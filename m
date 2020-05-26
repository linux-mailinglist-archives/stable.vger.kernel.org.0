Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797221E2B3A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390582AbgEZTDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391165AbgEZTDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:03:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C9B20849;
        Tue, 26 May 2020 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519787;
        bh=y2aP+HajdiZgK5V+KYc0YmXT4h9Ake5rut0Sk3S+HvI=;
        h=From:To:Cc:Subject:Date:From;
        b=0lPQGr7PPNepyITwXri5/I7YcOQeBUVWgx0aLQKCx1UGxQPGyUt1gC6KFHb0FFzgc
         rsY7V0/LNmoJh4re0NV5f++uBFLNCZvt3KQU9gIYskoiFcTW2mgcDYxLC9WcsI/qfq
         01jWpj32kBNnd+hutdUF6b+10I2yI1pReSSSuLZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/81] 4.19.125-rc1 review
Date:   Tue, 26 May 2020 20:52:35 +0200
Message-Id: <20200526183923.108515292@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.125-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.125-rc1
X-KernelTest-Deadline: 2020-05-28T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.125 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.125-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.125-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    make 'user_access_begin()' do 'access_ok()'

David Howells <dhowells@redhat.com>
    rxrpc: Fix ack discard

David Howells <dhowells@redhat.com>
    rxrpc: Trace discarded ACKs

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-dfsdm: fix device used to request dma

Peter Ujfalusi <peter.ujfalusi@ti.com>
    iio: adc: stm32-dfsdm: Use dma_request_chan() instead dma_request_slave_channel()

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

Wei Yongjun <weiyongjun1@huawei.com>
    ipack: tpci200: fix error return code in tpci200_register()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: release me_cl object reference

Klaus Doth <kdlnx@doth.eu>
    misc: rtsx: Add short delay after exit from ASPM

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

Guenter Roeck <linux@roeck-us.net>
    brcmfmac: abort and release host after error

Matthias Kaehlcke <mka@chromium.org>
    tty: serial: qcom_geni_serial: Fix wrap around of TX buffer

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4: free mac_hlist properly

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: abort suspend on error

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: code movement

Juliet Kim <julietk@linux.vnet.ibm.com>
    Revert "net/ibmvnic: Fix EOI when running in XIVE mode"

Geert Uytterhoeven <geert+renesas@glider.be>
    media: fdp1: Fix R-Car M3-N naming in debug message

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Drop duplicated get_switch_at_route()

Gustavo A. R. Silva <gustavo@embeddedor.com>
    staging: most: core: replace strcpy() by strscpy()

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Fix LBA masking during 'free list' population

Vishal Verma <vishal.l.verma@intel.com>
    libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Dexuan Cui <decui@microsoft.com>
    nfit: Add Hyper-V NVDIMM DSM command set to white list

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Disable STRICT_KERNEL_RWX

Russell Currey <ruscur@russell.cc>
    powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Init DPLL/DDI vreg for virtual display instead of inheritance.

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    dmaengine: owl: Use correct lock in owl_dma_get_pchan()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    apparmor: Fix aa_label refcnt leak in policy_update

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    apparmor: fix potential label refcnt leak in aa_change_profile

Navid Emamdoost <navid.emamdoost@gmail.com>
    apparmor: Fix use-after-free in aa_audit_rule_init

Christian Gmeiner <christian.gmeiner@gmail.com>
    drm/etnaviv: fix perfmon domain interation

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek - Add more fixup entries for Clevo machines

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Xtreme

Brent Lu <brent.lu@intel.com>
    ALSA: pcm: fix incorrect hw_base increase

Scott Bahling <sbahling@suse.com>
    ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: purge get_cpu and reorder_via_wq from padata_do_serial

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: initialize pd->cpu with effective cpumask

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Replace delayed timer with immediate workqueue in padata_reorder

Thomas Gleixner <tglx@linutronix.de>
    ARM: futex: Address build warning

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix misleading driver bug report

Maxim Petrov <mmrmaximuzz@gmail.com>
    stmmac: fix pointer check after utilization in stmmac_interrupt

Wu Bo <wubo40@huawei.com>
    ceph: fix double unlock in handle_cap_export()

Hans de Goede <hdegoede@redhat.com>
    HID: quirks: Add HID_QUIRK_NO_INIT_REPORTS quirk for Dell K12A keyboard-dock

Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
    gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Move TSC deadline timer debug printk

Daniel Playfair Cal <daniel.playfair.cal@gmail.com>
    HID: i2c-hid: reset Synaptics SYNA2393 on resume

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Fix WARN_ON during event pool release

James Hilliard <james.hilliard1@gmail.com>
    component: Silence bind error on -EPROBE_DEFER

Richard Clark <richard.xnu.clark@gmail.com>
    aquantia: Fix the media type of AQC100 ethernet controller in the driver

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix packet delivery order to monitoring devices

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    configfs: fix config_item refcnt leak in configfs_rmdir()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Delete all sessions before unregister local nvme port

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV

Jiri Kosina <jkosina@suse.cz>
    HID: alps: ALPS_1657 is too specific; use U1_UNICORN_LEGACY instead

Artem Borisov <dedsa2002@gmail.com>
    HID: alps: Add AUI1657 device ID

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

Christoph Hellwig <hch@lst.de>
    ubifs: remove broken lazytime support

Al Viro <viro@zeniv.linux.org.uk>
    fix multiplication overflow in copy_fdtable()

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: Propagate ECC information to the MTD structure

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Fix return value of ima_write_policy()

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check also if *tfm is an error pointer in init_desc()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()

Vincent Chen <vincent.chen@sifive.com>
    riscv: set max_pfn to the PFN of the last page

Miaohe Lin <linmiaohe@huawei.com>
    KVM: SVM: Fix potential memory leak in svm_cpu_init()

Kevin Hao <haokexin@gmail.com>
    i2c: dev: Fix the race between the release of i2c_dev and cdev

Arnd Bergmann <arnd@arndb.de>
    ubsan: build ubsan.c more conservatively

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, ubsan: Fix UBSAN vs. SMAP


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/futex.h                       |   9 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/riscv/kernel/setup.c                          |   2 +
 arch/x86/include/asm/uaccess.h                     |  11 +-
 arch/x86/kernel/apic/apic.c                        |  27 ++---
 arch/x86/kernel/unwind_orc.c                       |   7 ++
 arch/x86/kvm/svm.c                                 |  13 ++-
 drivers/acpi/nfit/core.c                           |  17 ++-
 drivers/acpi/nfit/nfit.h                           |   6 +-
 drivers/base/component.c                           |   8 +-
 drivers/dma/owl-dma.c                              |   8 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c          |   2 +-
 drivers/gpu/drm/i915/gvt/display.c                 |  49 ++++++++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  15 ++-
 drivers/hid/hid-alps.c                             |   1 +
 drivers/hid/hid-ids.h                              |   7 +-
 drivers/hid/hid-multitouch.c                       |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   2 +
 drivers/i2c/i2c-dev.c                              |  48 +++++----
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/accel/sca3000.c                        |   2 +-
 drivers/iio/adc/stm32-adc.c                        |  20 +++-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |  23 +++--
 drivers/iio/dac/vf610_dac.c                        |   1 +
 drivers/iommu/amd_iommu_init.c                     |   9 +-
 drivers/ipack/carriers/tpci200.c                   |   1 +
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   3 +
 drivers/misc/mei/client.c                          |   2 +
 drivers/mtd/nand/spi/core.c                        |   4 +
 drivers/mtd/ubi/debug.c                            |  12 +--
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  63 ++++++------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   6 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  13 ++-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/gtp.c                                  |   9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   2 +
 drivers/nvdimm/btt.c                               |  33 +++---
 drivers/nvdimm/btt.h                               |   2 +
 drivers/nvdimm/btt_devs.c                          |   8 ++
 drivers/platform/x86/asus-nb-wmi.c                 |  24 +++++
 drivers/rapidio/devices/rio_mport_cdev.c           |   5 +
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   4 -
 drivers/scsi/qla2xxx/qla_attr.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/staging/greybus/uart.c                     |   4 +-
 drivers/staging/iio/resolver/ad2s1210.c            |  17 ++-
 drivers/staging/most/core.c                        |   2 +-
 drivers/thunderbolt/icm.c                          |  12 ++-
 drivers/thunderbolt/switch.c                       |  18 ----
 drivers/thunderbolt/tb.c                           |   9 +-
 drivers/thunderbolt/tb.h                           |   1 -
 drivers/tty/serial/qcom_geni_serial.c              |  12 ++-
 drivers/usb/core/message.c                         |   4 +-
 drivers/vhost/vsock.c                              |  10 +-
 fs/ceph/caps.c                                     |   1 +
 fs/configfs/dir.c                                  |   1 +
 fs/file.c                                          |   2 +-
 fs/gfs2/glock.c                                    |   3 -
 fs/ubifs/file.c                                    |   6 +-
 include/linux/padata.h                             |  13 +--
 include/linux/uaccess.h                            |   2 +-
 include/trace/events/rxrpc.h                       |  35 +++++++
 include/uapi/linux/ndctl.h                         |   1 +
 kernel/compat.c                                    |   6 +-
 kernel/exit.c                                      |   6 +-
 kernel/padata.c                                    | 114 ++++-----------------
 lib/Makefile                                       |   2 +
 lib/strncpy_from_user.c                            |   9 +-
 lib/strnlen_user.c                                 |   9 +-
 net/rxrpc/input.c                                  |  38 ++++++-
 net/rxrpc/rxkad.c                                  |   3 +-
 scripts/gcc-plugins/Makefile                       |   1 +
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/apparmor/apparmorfs.c                     |   3 +-
 security/apparmor/audit.c                          |   3 +-
 security/apparmor/domain.c                         |   3 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima_crypto.c                |  12 +--
 security/integrity/ima/ima_fs.c                    |   3 +-
 sound/core/pcm_lib.c                               |   1 +
 sound/pci/hda/patch_realtek.c                      |   4 +
 sound/pci/ice1712/ice1712.c                        |   3 +-
 89 files changed, 537 insertions(+), 362 deletions(-)


