Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FA1E2E6B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbgEZTBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390929AbgEZTBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149202086A;
        Tue, 26 May 2020 19:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519681;
        bh=rDwR7cS7zx+L/0ixbyjNImgKK+dklmfHfcl2V7rAX1s=;
        h=From:To:Cc:Subject:Date:From;
        b=rw9ZWWA+xu0ZCxxzbs/7he/edYQqxfxl873Ifrf4ZxCcSMCav4az693b0rYE98CwL
         S1ENsR+EkHQLEZIwIM5CG0QB7Qj/Hx+ym9VCyL3UN+tt3D9dmApvFTo6oKMFCf937n
         Z69acZF+6bSzIzptH56rdpJrofeGHkuqXn65ytoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/59] 4.14.182-rc1 review
Date:   Tue, 26 May 2020 20:52:45 +0200
Message-Id: <20200526183907.123822792@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.182-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.182-rc1
X-KernelTest-Deadline: 2020-05-28T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.182 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.182-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.182-rc1

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix device used to request dma

Peter Ujfalusi <peter.ujfalusi@ti.com>
    iio: adc: stm32-adc: Use dma_request_chan() instead dma_request_slave_channel()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix unwind_get_return_address_ptr() for inactive tasks

Qiushi Wu <wu000273@umn.edu>
    rxrpc: Fix a memory leak in rxkad_verify_response()

John Hubbard <jhubbard@nvidia.com>
    rapidio: fix an error in get_user_pages_fast() error handling

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: release me_cl object reference

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: sca3000: Remove an erroneous 'get_device()'

Oscar Carter <oscar.carter@gmx.com>
    staging: greybus: Fix uninitialized scalar variable

Dragos Bogdan <dragos.bogdan@analog.com>
    staging: iio: ad2s1210: Fix SPI reading

Bob Peterson <rpeterso@redhat.com>
    Revert "gfs2: Don't demote a glock until its revokes are written"

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4: free mac_hlist properly

Geert Uytterhoeven <geert+renesas@glider.be>
    media: fdp1: Fix R-Car M3-N naming in debug message

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Fix LBA masking during 'free list' population

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Arnd Bergmann <arnd@arndb.de>
    ubsan: build ubsan.c more conservatively

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, ubsan: Fix UBSAN vs. SMAP

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Disable STRICT_KERNEL_RWX

Russell Currey <ruscur@russell.cc>
    powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc: restore alphabetic order in Kconfig

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    apparmor: Fix aa_label refcnt leak in policy_update

Brent Lu <brent.lu@intel.com>
    ALSA: pcm: fix incorrect hw_base increase

Scott Bahling <sbahling@suse.com>
    ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: initialise PPP sessions before registering them

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: protect sock pointer of struct pppol2tp_session with RCU

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: initialise l2tp_eth sessions before registering them

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: don't register sessions in l2tp_session_create()

Christoph Hellwig <hch@lst.de>
    arm64: fix the flush_icache_range arguments in machine_kexec

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: purge get_cpu and reorder_via_wq from padata_do_serial

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: initialize pd->cpu with effective cpumask

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Replace delayed timer with immediate workqueue in padata_reorder

Mathias Krause <minipli@googlemail.com>
    padata: set cpu_index of unused CPUs to -1

Thomas Gleixner <tglx@linutronix.de>
    ARM: futex: Address build warning

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix misleading driver bug report

Wu Bo <wubo40@huawei.com>
    ceph: fix double unlock in handle_cap_export()

Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
    gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Move TSC deadline timer debug printk

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Fix WARN_ON during event pool release

James Hilliard <james.hilliard1@gmail.com>
    component: Silence bind error on -EPROBE_DEFER

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix packet delivery order to monitoring devices

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    configfs: fix config_item refcnt leak in configfs_rmdir()

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Sebastian Reichel <sebastian.reichel@collabora.com>
    HID: multitouch: add eGalaxTouch P80H84 support

Frédéric Pierret (fepitre) <frederic.pierret@qubes-os.org>
    gcc-common.h: Update for GCC 10

Richard Weinberger <richard@nod.at>
    ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'

Alexander Monakov <amonakov@ispras.ru>
    iommu/amd: Fix over-read of ACPI UID from IVRS table

Al Viro <viro@zeniv.linux.org.uk>
    fix multiplication overflow in copy_fdtable()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Fix return value of ima_write_policy()

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check also if *tfm is an error pointer in init_desc()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()

Mathias Krause <minipli@googlemail.com>
    padata: ensure padata_do_serial() runs on the correct CPU

Mathias Krause <minipli@googlemail.com>
    padata: ensure the reorder timer callback runs on the correct CPU

Kevin Hao <haokexin@gmail.com>
    i2c: dev: Fix the race between the release of i2c_dev and cdev

Kevin Hao <haokexin@gmail.com>
    watchdog: Fix the race between the release of watchdog_core_data and cdev

Shijie Luo <luoshijie1@huawei.com>
    ext4: add cond_resched() to ext4_protect_reserved_inode


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/futex.h                       |   9 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 +-
 arch/powerpc/Kconfig                               |   4 +-
 arch/x86/kernel/apic/apic.c                        |  27 +--
 arch/x86/kernel/unwind_orc.c                       |   7 +
 drivers/base/component.c                           |   8 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-multitouch.c                       |   3 +
 drivers/i2c/i2c-dev.c                              |  48 +++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/accel/sca3000.c                        |   2 +-
 drivers/iio/adc/stm32-adc.c                        |  20 +-
 drivers/iio/dac/vf610_dac.c                        |   1 +
 drivers/iommu/amd_iommu_init.c                     |   9 +-
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/misc/mei/client.c                          |   2 +
 drivers/mtd/ubi/debug.c                            |  12 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  13 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   6 +-
 drivers/net/gtp.c                                  |   9 +-
 drivers/nvdimm/btt.c                               |  33 +--
 drivers/nvdimm/btt.h                               |   2 +
 drivers/nvdimm/btt_devs.c                          |   8 +
 drivers/platform/x86/asus-nb-wmi.c                 |  24 +++
 drivers/rapidio/devices/rio_mport_cdev.c           |   5 +
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   4 -
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/staging/greybus/uart.c                     |   4 +-
 drivers/staging/iio/resolver/ad2s1210.c            |  17 +-
 drivers/usb/core/message.c                         |   4 +-
 drivers/vhost/vsock.c                              |  10 +-
 drivers/watchdog/watchdog_dev.c                    |  67 +++---
 fs/ceph/caps.c                                     |   1 +
 fs/configfs/dir.c                                  |   1 +
 fs/ext4/block_validity.c                           |   1 +
 fs/file.c                                          |   2 +-
 fs/gfs2/glock.c                                    |   3 -
 include/linux/padata.h                             |  13 +-
 kernel/padata.c                                    |  71 +++---
 lib/Makefile                                       |   2 +
 net/l2tp/l2tp_core.c                               |  21 +-
 net/l2tp/l2tp_core.h                               |   3 +
 net/l2tp/l2tp_eth.c                                |  99 +++++++--
 net/l2tp/l2tp_ppp.c                                | 238 +++++++++++++--------
 net/rxrpc/rxkad.c                                  |   3 +-
 scripts/gcc-plugins/Makefile                       |   1 +
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/apparmor/apparmorfs.c                     |   3 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima_crypto.c                |  12 +-
 security/integrity/ima/ima_fs.c                    |   3 +-
 sound/core/pcm_lib.c                               |   1 +
 sound/pci/ice1712/ice1712.c                        |   3 +-
 55 files changed, 529 insertions(+), 331 deletions(-)


