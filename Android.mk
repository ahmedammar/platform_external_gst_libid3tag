# This file is the top android makefile for all sub-modules.

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

id3tag_TOP := $(LOCAL_PATH)

ID3TAG_BUILT_SOURCES := 		\
	libid3tag-Android.mk

ID3TAG_BUILT_SOURCES := $(patsubst %, $(abspath $(id3tag_TOP))/%, $(ID3TAG_BUILT_SOURCES))

ifeq ($(NDK_BUILD),true)
LIB := $(SYSROOT)/usr/lib
else
LIB := $(TARGET_OUT_SHARED_LIBRARIES)
endif

.PHONY: libid3tag-configure
libid3tag-configure: $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(LIB)/libc.so $(LIB)/libz.so
	cd $(id3tag_TOP) ; \
	touch NEWS AUTHORS ChangeLog ; \
	autoreconf -i && \
	CC="$(CONFIGURE_CC)" \
	CFLAGS="$(CONFIGURE_CFLAGS)" \
	LD=$(TARGET_LD) \
	LDFLAGS="$(CONFIGURE_LDFLAGS)" \
	CPP=$(CONFIGURE_CPP) \
	CPPFLAGS="$(CONFIGURE_CPPFLAGS)" \
	PKG_CONFIG_LIBDIR=$(CONFIGURE_PKG_CONFIG_PATH) \
	PKG_CONFIG_TOP_BUILD_DIR=/ \
	$(abspath $(id3tag_TOP))/configure --host=arm-linux-androideabi \
	--prefix=/system && \
	for file in $(ID3TAG_BUILT_SOURCES); do \
		rm -f $$file && \
		make -C $$(dirname $$file) $$(basename $$file) ; \
	done

CONFIGURE_TARGETS += libid3tag-configure

-include $(id3tag_TOP)/libid3tag-Android.mk
