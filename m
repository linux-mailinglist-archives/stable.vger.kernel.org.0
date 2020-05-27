Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF01E4956
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgE0QIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgE0QI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:08:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43002208DB;
        Wed, 27 May 2020 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590595708;
        bh=OcKfsr+UugltE0adv6KBLFflpabcSDMBwXXnAC7Ayrw=;
        h=From:To:Cc:Subject:Date:From;
        b=tLkN/8QEJ8/VS+n91w/EKaOZQJnQRLuvGdwb0H2WK9H/OC50StBKvSVPkHAdwWwn+
         H0wAvJmL7OUChI/cfw9/uJtUJIAj1AbkqXWmJX0jLt/1WVqTfv2YBwFcBL+XGRtF4i
         OqHsCWFyr+3iyho4+cZFUGbJpMo8aKZgDcl0qrWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.182
Date:   Wed, 27 May 2020 18:08:19 +0200
Message-Id: <1590595698236215@kroah.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.182 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/include/asm/futex.h                        |    9 
 arch/arm64/kernel/machine_kexec.c                   |    3 
 arch/powerpc/Kconfig                                |    4 
 arch/x86/kernel/apic/apic.c                         |   27 +-
 arch/x86/kernel/unwind_orc.c                        |    7 
 drivers/base/component.c                            |    8 
 drivers/dma/tegra210-adma.c                         |    2 
 drivers/hid/hid-ids.h                               |    1 
 drivers/hid/hid-multitouch.c                        |    3 
 drivers/i2c/i2c-dev.c                               |   48 ++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c               |    1 
 drivers/iio/accel/sca3000.c                         |    2 
 drivers/iio/adc/stm32-adc.c                         |   20 +
 drivers/iio/dac/vf610_dac.c                         |    1 
 drivers/iommu/amd_iommu_init.c                      |    9 
 drivers/media/platform/rcar_fdp1.c                  |    2 
 drivers/misc/mei/client.c                           |    2 
 drivers/mtd/ubi/debug.c                             |   12 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |   13 -
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c |    6 
 drivers/net/gtp.c                                   |    9 
 drivers/nvdimm/btt.c                                |   33 +-
 drivers/nvdimm/btt.h                                |    2 
 drivers/nvdimm/btt_devs.c                           |    8 
 drivers/platform/x86/asus-nb-wmi.c                  |   24 ++
 drivers/rapidio/devices/rio_mport_cdev.c            |    5 
 drivers/scsi/ibmvscsi/ibmvscsi.c                    |    4 
 drivers/scsi/qla2xxx/qla_mbx.c                      |    2 
 drivers/staging/greybus/uart.c                      |    4 
 drivers/staging/iio/resolver/ad2s1210.c             |   17 +
 drivers/usb/core/message.c                          |    4 
 drivers/vhost/vsock.c                               |   10 
 drivers/watchdog/watchdog_dev.c                     |   67 ++---
 fs/ceph/caps.c                                      |    1 
 fs/configfs/dir.c                                   |    1 
 fs/ext4/block_validity.c                            |    1 
 fs/file.c                                           |    2 
 fs/gfs2/glock.c                                     |    3 
 include/linux/padata.h                              |   13 -
 kernel/padata.c                                     |   71 ++---
 lib/Makefile                                        |    2 
 net/l2tp/l2tp_core.c                                |   21 -
 net/l2tp/l2tp_core.h                                |    3 
 net/l2tp/l2tp_eth.c                                 |   99 ++++++--
 net/l2tp/l2tp_ppp.c                                 |  238 ++++++++++++--------
 net/rxrpc/rxkad.c                                   |    3 
 scripts/gcc-plugins/Makefile                        |    1 
 scripts/gcc-plugins/gcc-common.h                    |    4 
 security/apparmor/apparmorfs.c                      |    3 
 security/integrity/evm/evm_crypto.c                 |    2 
 security/integrity/ima/ima_crypto.c                 |   12 -
 security/integrity/ima/ima_fs.c                     |    3 
 sound/core/pcm_lib.c                                |    1 
 sound/pci/ice1712/ice1712.c                         |    3 
 55 files changed, 528 insertions(+), 330 deletions(-)

Al Viro (1):
      fix multiplication overflow in copy_fdtable()

Alan Stern (1):
      USB: core: Fix misleading driver bug report

Alexander Monakov (1):
      iommu/amd: Fix over-read of ACPI UID from IVRS table

Alexander Usyskin (1):
      mei: release me_cl object reference

Arjun Vynipadath (2):
      cxgb4: free mac_hlist properly
      cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arnd Bergmann (1):
      ubsan: build ubsan.c more conservatively

Arun Easi (1):
      scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Bob Peterson (1):
      Revert "gfs2: Don't demote a glock until its revokes are written"

Brent Lu (1):
      ALSA: pcm: fix incorrect hw_base increase

Christoph Hellwig (1):
      arm64: fix the flush_icache_range arguments in machine_kexec

Christophe JAILLET (4):
      i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'
      dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'
      iio: sca3000: Remove an erroneous 'get_device()'
      iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

Christophe Leroy (1):
      powerpc: restore alphabetic order in Kconfig

Daniel Jordan (2):
      padata: initialize pd->cpu with effective cpumask
      padata: purge get_cpu and reorder_via_wq from padata_do_serial

Dragos Bogdan (1):
      staging: iio: ad2s1210: Fix SPI reading

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix device used to request dma

Frédéric Pierret (fepitre) (1):
      gcc-common.h: Update for GCC 10

Geert Uytterhoeven (1):
      media: fdp1: Fix R-Car M3-N naming in debug message

Greg Kroah-Hartman (1):
      Linux 4.14.182

Guillaume Nault (4):
      l2tp: don't register sessions in l2tp_session_create()
      l2tp: initialise l2tp_eth sessions before registering them
      l2tp: protect sock pointer of struct pppol2tp_session with RCU
      l2tp: initialise PPP sessions before registering them

Hans de Goede (1):
      platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Herbert Xu (1):
      padata: Replace delayed timer with immediate workqueue in padata_reorder

James Hilliard (1):
      component: Silence bind error on -EPROBE_DEFER

John Hubbard (1):
      rapidio: fix an error in get_user_pages_fast() error handling

Josh Poimboeuf (1):
      x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks

Kevin Hao (2):
      watchdog: Fix the race between the release of watchdog_core_data and cdev
      i2c: dev: Fix the race between the release of i2c_dev and cdev

Mathias Krause (3):
      padata: ensure the reorder timer callback runs on the correct CPU
      padata: ensure padata_do_serial() runs on the correct CPU
      padata: set cpu_index of unused CPUs to -1

Michael Ellerman (1):
      powerpc/64s: Disable STRICT_KERNEL_RWX

Oscar Carter (1):
      staging: greybus: Fix uninitialized scalar variable

Peter Ujfalusi (1):
      iio: adc: stm32-adc: Use dma_request_chan() instead dma_request_slave_channel()

Peter Zijlstra (1):
      x86/uaccess, ubsan: Fix UBSAN vs. SMAP

Qiushi Wu (1):
      rxrpc: Fix a memory leak in rxkad_verify_response()

Richard Weinberger (1):
      ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Roberto Sassu (3):
      ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
      evm: Check also if *tfm is an error pointer in init_desc()
      ima: Fix return value of ima_write_policy()

Russell Currey (1):
      powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Scott Bahling (1):
      ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode

Stefano Garzarella (1):
      vhost/vsock: fix packet delivery order to monitoring devices

Thomas Gleixner (2):
      x86/apic: Move TSC deadline timer debug printk
      ARM: futex: Address build warning

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix WARN_ON during event pool release

Vishal Verma (2):
      libnvdimm/btt: Remove unnecessary code in btt_freelist_init
      libnvdimm/btt: Fix LBA masking during 'free list' population

Wu Bo (1):
      ceph: fix double unlock in handle_cap_export()

Xiyu Yang (2):
      configfs: fix config_item refcnt leak in configfs_rmdir()
      apparmor: Fix aa_label refcnt leak in policy_update

Yoshiyuki Kurauchi (1):
      gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

