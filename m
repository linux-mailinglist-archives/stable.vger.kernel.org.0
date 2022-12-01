Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02D963ECAB
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiLAJkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 04:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLAJkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 04:40:11 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF76A75E
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 01:40:10 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id n184so1095115yba.6
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 01:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9QLD+5uuDceL+/+s+viqs5DLeTzi4AwuSjjugeFiRVs=;
        b=ew98FRJGl8Kye3oV4cy7cci/JIlR4voaOzySnrmhSRElPwmOFo18U+emBFHDlVoVd/
         m+haqAEmiACZX4GxNr87JSxt83lZu6e7/WdFnnivdQ44CCMqGQrM1wgMPlZIDUzOuUWR
         HdoLDRQoYXH4nS1Xgst4DDILZZVfSWkwQNcxf4RfndJXqOAlDBSAwUysWSvjyi03T/iu
         TWDCIfYUegwBXZA+Pwz+9PhRX+Ryzd76ySAAf+dgNS0cgvRlMv1mmuauIQmeA4m1DJW0
         6e1Z+VvepJgECeZNuK5APEtYFSV6qL8a0NL6tzdh4Q7z4/P7qwHjHzxozNiRy/CCnqUY
         0EAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QLD+5uuDceL+/+s+viqs5DLeTzi4AwuSjjugeFiRVs=;
        b=zz/bKwH4JkfS+wxTBMlefG/CDTC9+L/0RxPAPyJEf0OX84PmXJw26XzGSNgmT4aMG4
         qRKenlDhX+bhJHqD2RnqFoV9lLMiTzsmQI/PCaNqV4jaQZkVHOZe2XXUndhpoTjOzxYB
         mVyY7uPMxGgPaQLuk8ek22fUGcqO13qjZ4suOwD9ySQyjBNtoRXKFBXk4tuWMzsBJBa7
         XNUbRIbRhRD6ft3fe41zdFrpEQjlLTeVPQdHeeD84ypZP+arwKPOm3yEgN/cfZz1dJLW
         LlrGvDyiSPJosYIj6AV9txuvuQaB8YKozirXl6jCe3q+dNeoJ8SKwi3/giVEvL1KZK+X
         SKHA==
X-Gm-Message-State: ANoB5plHk2x+dqgmZotPHZ+5F64g0P+2FL8IuzDJfT6nFsydqOg4TiTY
        H6yFF9aCVz0vpLRJ1sbeblV7X7/aJopRNFz0xEU0Bp00w0BhEw==
X-Google-Smtp-Source: AA0mqf4y7uu6OFUBayaBPcm0odN3ehbidXaGBhxwJLqfpZMWR2zjFpYIUGcAj+EDjJWev9ifXx2KhBXZHmYdFSgW2Vk=
X-Received: by 2002:a25:ed05:0:b0:6c4:8a9:e4d2 with SMTP id
 k5-20020a25ed05000000b006c408a9e4d2mr63398586ybh.164.1669887608496; Thu, 01
 Dec 2022 01:40:08 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 1 Dec 2022 15:09:57 +0530
Message-ID: <CA+G9fYuNirzmuQvYpH6gYiAr_fqh9g-+RP83FW3oLbty9iKbyw@mail.gmail.com>
Subject: stable-rc-5.10: arm64: allmodconfig: (.hyp.text+0x1a4c): undefined
 reference to `__kvm_nvhe_memset'
To:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[please ignore if it is already reported]

The stable-rc 5.10 arm64 allmodconfig builds failed with gcc-12.
List of build warnings and errors with gcc-12 are listed below.

aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function
`__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
(.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'

steps to reproduce:
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12
--kconfig allmodconfig CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

build log:
---------
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build
CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc' allmodconfig

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build
CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/builds/linux/drivers/acpi/acpica/utdebug.c: In function
'acpi_ut_init_stack_ptr_trace':
/builds/linux/drivers/acpi/acpica/utdebug.c:40:38: warning: storing
the address of local variable 'current_sp' in
'acpi_gbl_entry_stack_pointer' [-Wdangling-pointer=]
   40 |         acpi_gbl_entry_stack_pointer = &current_sp;
      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
/builds/linux/drivers/acpi/acpica/utdebug.c:38:19: note: 'current_sp'
declared here
   38 |         acpi_size current_sp;
      |                   ^~~~~~~~~~
In file included from /builds/linux/include/acpi/acpi.h:31,
                 from /builds/linux/drivers/acpi/acpica/utdebug.c:12:
/builds/linux/drivers/acpi/acpica/acglobal.h:196:26: note:
'acpi_gbl_entry_stack_pointer' declared here
  196 | ACPI_GLOBAL(acpi_size *, acpi_gbl_entry_stack_pointer);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
/builds/linux/include/acpi/acpixf.h:45:21: note: in definition of
macro 'ACPI_GLOBAL'
   45 |         extern type name
      |                     ^~~~
/builds/linux/fs/xfs/libxfs/xfs_attr_remote.c: In function
'__xfs_attr3_rmt_read_verify':
/builds/linux/fs/xfs/libxfs/xfs_attr_remote.c:140:35: warning: storing
the address of local variable '__here' in '*failaddr'
[-Wdangling-pointer=]
  140 |                         *failaddr = __this_address;
In file included from /builds/linux/fs/xfs/xfs.h:22,
                 from /builds/linux/fs/xfs/libxfs/xfs_attr_remote.c:7:
/builds/linux/fs/xfs/xfs_linux.h:133:46: note: '__here' declared here
  133 | #define __this_address  ({ __label__ __here; __here:
barrier(); &&__here; })
      |                                              ^~~~~~
/builds/linux/fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in
expansion of macro '__this_address'
  140 |                         *failaddr = __this_address;
      |                                     ^~~~~~~~~~~~~~
/builds/linux/fs/xfs/xfs_linux.h:133:46: note: 'failaddr' declared here
  133 | #define __this_address  ({ __label__ __here; __here:
barrier(); &&__here; })
      |                                              ^~~~~~
/builds/linux/fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in
expansion of macro '__this_address'
  140 |                         *failaddr = __this_address;
      |                                     ^~~~~~~~~~~~~~
/builds/linux/drivers/acpi/thermal.c: In function 'acpi_thermal_resume':
/builds/linux/drivers/acpi/thermal.c:1123:21: warning: the comparison
will always evaluate as 'true' for the address of 'active' will never
be NULL [-Waddress]
 1123 |                 if (!(&tz->trips.active[i]))
      |                     ^
/builds/linux/drivers/acpi/thermal.c:154:36: note: 'active' declared here
  154 |         struct acpi_thermal_active active[ACPI_THERMAL_MAX_ACTIVE];
      |                                    ^~~~~~
In file included from /builds/linux/include/linux/preempt.h:11,
                 from /builds/linux/include/linux/percpu.h:6,
                 from /builds/linux/include/linux/context_tracking_state.h:5,
                 from /builds/linux/include/linux/hardirq.h:5,
                 from /builds/linux/include/linux/interrupt.h:11,
                 from /builds/linux/drivers/scsi/lpfc/lpfc_bsg.c:23:
In function '__list_add',
    inlined from 'list_add_tail' at /builds/linux/include/linux/list.h:100:2,
    inlined from 'diag_cmd_data_free.isra' at
/builds/linux/drivers/scsi/lpfc/lpfc_bsg.c:891:2:
/builds/linux/include/linux/list.h:70:20: warning: storing the address
of local variable 'head' in '*&mlist_1(D)->dma.list.prev'
[-Wdangling-pointer=]
   70 |         next->prev = new;
      |         ~~~~~~~~~~~^~~~~
/builds/linux/drivers/scsi/lpfc/lpfc_bsg.c: In function
'diag_cmd_data_free.isra':
/builds/linux/drivers/scsi/lpfc/lpfc_bsg.c:883:26: note: 'head' declared here
  883 |         struct list_head head, *curr, *next;
      |                          ^~~~
/builds/linux/drivers/scsi/lpfc/lpfc_bsg.c:883:26: note: 'mlist' declared here
In file included from /builds/linux/include/linux/smp.h:12,
                 from /builds/linux/arch/arm64/include/asm/arch_timer.h:18,
                 from /builds/linux/arch/arm64/include/asm/timex.h:8,
                 from /builds/linux/include/linux/timex.h:67,
                 from /builds/linux/include/linux/time32.h:13,
                 from /builds/linux/include/linux/time.h:73,
                 from /builds/linux/include/linux/skbuff.h:15,
                 from /builds/linux/include/linux/if_ether.h:19,
                 from /builds/linux/include/linux/etherdevice.h:20,
                 from /builds/linux/drivers/net/wireless/ath/ath6kl/core.h:21,
                 from
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:18:
In function '__list_add',
    inlined from 'list_add' at /builds/linux/include/linux/list.h:86:2,
    inlined from 'ath6kl_htc_mbox_tx' at
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:1142:3:
/builds/linux/include/linux/list.h:72:19: warning: storing the address
of local variable 'queue' in '*&packet_15(D)->list.prev'
[-Wdangling-pointer=]
   72 |         new->prev = prev;
      |         ~~~~~~~~~~^~~~~~
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c: In function
'ath6kl_htc_mbox_tx':
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:1125:26:
note: 'queue' declared here
 1125 |         struct list_head queue;
      |                          ^~~~~
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:1125:26:
note: 'packet' declared here
In function '__list_add',
    inlined from 'list_add_tail' at /builds/linux/include/linux/list.h:100:2,
    inlined from 'htc_tx_comp_handler' at
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:462:2:
/builds/linux/include/linux/list.h:72:19: warning: storing the address
of local variable 'container' in '*&packet_5(D)->list.prev'
[-Wdangling-pointer=]
   72 |         new->prev = prev;
      |         ~~~~~~~~~~^~~~~~
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c: In function
'htc_tx_comp_handler':
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:455:26: note:
'container' declared here
  455 |         struct list_head container;
      |                          ^~~~~~~~~
/builds/linux/drivers/net/wireless/ath/ath6kl/htc_mbox.c:455:26: note:
'packet' declared here
/builds/linux/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c: In
function 'rtl92d_phy_reload_iqk_setting':
/builds/linux/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:2389:39:
warning: the comparison will always evaluate as 'true' for the address
of 'value' will never be NULL [-Waddress]
 2389 |                              value[0] != NULL)
      |                                       ^~
In file included from
/builds/linux/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:4:
/builds/linux/drivers/net/wireless/realtek/rtlwifi/rtl8192de/../wifi.h:1293:14:
note: 'value' declared here
 1293 |         long value[1][IQK_MATRIX_REG_NUM];
      |              ^~~~~
/builds/linux/drivers/net/ethernet/sun/cassini.c: In function 'cas_init_rx_dma':
/builds/linux/drivers/net/ethernet/sun/cassini.c:1328:29: warning:
comparison between two arrays [-Warray-compare]
 1328 |         if (CAS_HP_FIRMWARE == cas_prog_null)
      |                             ^~
/builds/linux/drivers/net/ethernet/sun/cassini.c:1328:29: note: use
'&cas_prog_workaroundtab[0] == &cas_prog_null[0]' to compare the
addresses
/builds/linux/drivers/net/ethernet/sun/cassini.c: In function 'cas_reset':
/builds/linux/drivers/net/ethernet/sun/cassini.c:3796:34: warning:
comparison between two arrays [-Warray-compare]
 3796 |             (CAS_HP_ALT_FIRMWARE == cas_prog_null)) {
      |                                  ^~
/builds/linux/drivers/net/ethernet/sun/cassini.c:3796:34: note: use
'&cas_prog_null[0] == &cas_prog_null[0]' to compare the addresses
aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function
`__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
(.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function
`__kvm_nvhe___kvm_tlb_flush_vmid':
(.hyp.text+0x1b20): undefined reference to `__kvm_nvhe_memset'
aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function
`__kvm_nvhe___kvm_flush_cpu_context':
(.hyp.text+0x1b80): undefined reference to `__kvm_nvhe_memset'
make[1]: *** [/builds/linux/Makefile:1194: vmlinux] Error 1

Build link,
  - https://builds.tuxbuild.com/2IHivEkKmuryHjt6Xv8xUn9RLy5/

Build comparison link,
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y-sanity/build/v5.10.155-312-g97b8f00e4c81/testrun/13335963/suite/build/test/gcc-12-allmodconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
