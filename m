Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA5C1E2DD4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391599AbgEZTHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391565AbgEZTHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A900E20776;
        Tue, 26 May 2020 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520041;
        bh=dFTeMeVxxttxMIYLdz9gcZJ/yOJKCMkEr7Rh7mnAgB4=;
        h=From:To:Cc:Subject:Date:From;
        b=dS3dXlbNG3rqdblnXEHffo/7UR605wAz7FCMFFFqb9bYkV5884M11j2sCmR7W140V
         zgh5C0sOjDw2oUvYHuVk18UzKytDo0ziGVyoM+7fmp6PYXRZB5LC7xKPrYMAnvXh2w
         qk0uTRWV3ykIpyoGQN+XKNKgZmYLzqHK7sXI8wXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/111] 5.4.43-rc1 review
Date:   Tue, 26 May 2020 20:52:18 +0200
Message-Id: <20200526183932.245016380@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.43-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.43-rc1
X-KernelTest-Deadline: 2020-05-28T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.43 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.43-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.43-rc1

Phil Auld <pauld@redhat.com>
    sched/fair: Fix enqueue_task_fair() warning some more

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix reordering of enqueue/dequeue_task_fair()

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Reorder enqueue/dequeue_task_fair path

Loïc Yhuel <loic.yhuel@gmail.com>
    tpm: check event log version before reading final events

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

Jakub Sitnicki <jakub@cloudflare.com>
    flow_dissector: Drop BPF flow dissector prog ref on netns cleanup

Philipp Rudo <prudo@linux.ibm.com>
    s390/kexec_file: fix initrd location for kdump kernel

Qiushi Wu <wu000273@umn.edu>
    rxrpc: Fix a memory leak in rxkad_verify_response()

David Howells <dhowells@redhat.com>
    rxrpc: Fix the excessive initial retransmission timeout

Marco Elver <elver@google.com>
    kasan: disable branch tracing for core runtime

John Hubbard <jhubbard@nvidia.com>
    rapidio: fix an error in get_user_pages_fast() error handling

David Hildenbrand <david@redhat.com>
    device-dax: don't leak kernel memory to user space after unloading kmem

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/kaslr: add support for R_390_JMP_SLOT relocation type

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix s390_mmio_read/write with MIO

Wei Yongjun <weiyongjun1@huawei.com>
    ipack: tpci200: fix error return code in tpci200_register()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: release me_cl object reference

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    tty: serial: add missing spin_lock_init for SiFive serial console

Klaus Doth <kdlnx@doth.eu>
    misc: rtsx: Add short delay after exit from ASPM

Gregory CLEMENT <gregory.clement@bootlin.com>
    iio: adc: ti-ads8344: Fix channel selection

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: sca3000: Remove an erroneous 'get_device()'

Oscar Carter <oscar.carter@gmx.com>
    staging: greybus: Fix uninitialized scalar variable

Wei Yongjun <weiyongjun1@huawei.com>
    staging: kpc2000: fix error return code in kp2000_pcie_probe()

Dragos Bogdan <dragos.bogdan@analog.com>
    staging: iio: ad2s1210: Fix SPI reading

Geert Uytterhoeven <geert+renesas@glider.be>
    media: fdp1: Fix R-Car M3-N naming in debug message

Bob Peterson <rpeterso@redhat.com>
    Revert "gfs2: Don't demote a glock until its revokes are written"

Kees Cook <keescook@chromium.org>
    kbuild: Remove debug info from kallsyms linking

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Avoid setting bpf insns pages read-only when prog is jited

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Disable STRICT_KERNEL_RWX

Russell Currey <ruscur@russell.cc>
    powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Propagate error from completed fences

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Init DPLL/DDI vreg for virtual display instead of inheritance.

Ilya Dryomov <idryomov@gmail.com>
    vsprintf: don't obfuscate NULL and error pointers

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    dmaengine: owl: Use correct lock in owl_dma_get_pchan()

Vladimir Murzin <vladimir.murzin@arm.com>
    dmaengine: dmatest: Restore default for channel

Dan Carpenter <dan.carpenter@oracle.com>
    drm/etnaviv: Fix a leak in submit_pin_objects()

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

Keno Fischer <keno@juliacomputing.com>
    arm64: Fix PTRACE_SYSEMU semantics

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: Put lun_ref at end of tmr processing

Ewan D. Milne <emilne@redhat.com>
    scsi: qla2xxx: Do not log message when reading port speed via sysfs

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek - Add more fixup entries for Clevo machines

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Xtreme

Brent Lu <brent.lu@intel.com>
    ALSA: pcm: fix incorrect hw_base increase

Scott Bahling <sbahling@suse.com>
    ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option

Babu Moger <babu.moger@amd.com>
    KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek: Enable headset mic of ASUS UX581LV with ALC295

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable headset mic of ASUS UX550GE with ALC295

Chris Chiu <chiu@endlessm.com>
    ALSA: hda/realtek - Enable headset mic of ASUS GL503VM with ALC295

Mike Pozulp <pozulp.kernel@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Notebook

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add HP new mute led supported for ALC236

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add supported new mute Led for HP

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Manage concurrent reg access more properly

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: patch_realtek: fix empty macro usage in if block

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ALSA: hda - constify and cleanup static NodeID tables

Aymeric Agon-Rambosson <aymeric.agon@yandex.com>
    scripts/gdb: repair rb_first() and rb_last()

Thomas Gleixner <tglx@linutronix.de>
    ARM: futex: Address build warning

Peter Xu <peterx@redhat.com>
    KVM: selftests: Fix build for evmcs.h

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Prevent dpcd reads with passive dongles

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Call domain_flush_complete() in update_domain()

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

Alan Maguire <alan.maguire@oracle.com>
    ftrace/selftest: make unresolved cases cause failure if --fail-unresolved set

Juliet Kim <julietk@linux.vnet.ibm.com>
    ibmvnic: Skip fatal error reset after passive init

Rick Edgecombe <rick.p.edgecombe@intel.com>
    x86/mm/cpa: Flush direct map alias during cpa

Daniel Playfair Cal <daniel.playfair.cal@gmail.com>
    HID: i2c-hid: reset Synaptics SYNA2393 on resume

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Fix WARN_ON during event pool release

Gavin Shan <gshan@redhat.com>
    net/ena: Fix build warning in ena_xdp_set()

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

Masahiro Yamada <masahiroy@kernel.org>
    net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: avoid concurrency issue in parallel building dtbs and dtbs_check

Ricardo Ribalda Delgado <ribalda@kernel.org>
    mtd: Fix mtd not registered due to nvmem name collision

David Howells <dhowells@redhat.com>
    afs: Don't unlock fetched data pages until the op completes successfully

Richard Weinberger <richard@nod.at>
    ubi: Fix seq_file usage in detailed_erase_block_info debugfs file

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'

Dan Carpenter <dan.carpenter@oracle.com>
    evm: Fix a small race in init_desc()

Alexander Monakov <amonakov@ispras.ru>
    iommu/amd: Fix over-read of ACPI UID from IVRS table

Alain Volmat <alain.volmat@st.com>
    i2c: fix missing pm_runtime_put_sync in i2c_device_probe

Christoph Hellwig <hch@lst.de>
    ubifs: remove broken lazytime support

Al Viro <viro@zeniv.linux.org.uk>
    fix multiplication overflow in copy_fdtable()

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: Propagate ECC information to the MTD structure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive

Eric Biggers <ebiggers@google.com>
    ubifs: fix wrong use of crypto_shash_descsize()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Fix return value of ima_write_policy()

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check also if *tfm is an error pointer in init_desc()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()

Miaohe Lin <linmiaohe@huawei.com>
    KVM: SVM: Fix potential memory leak in svm_cpu_init()

Kevin Hao <haokexin@gmail.com>
    i2c: dev: Fix the race between the release of i2c_dev and cdev


-------------

Diffstat:

 Makefile                                           |  12 +-
 arch/arm/include/asm/futex.h                       |   9 +-
 arch/arm64/kernel/ptrace.c                         |   7 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/s390/include/asm/pci_io.h                     |  10 +-
 arch/s390/kernel/machine_kexec_file.c              |   2 +-
 arch/s390/kernel/machine_kexec_reloc.c             |   1 +
 arch/s390/pci/pci_mmio.c                           | 213 ++++++++++++++++++-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/apic/apic.c                        |  27 +--
 arch/x86/kernel/unwind_orc.c                       |   7 +
 arch/x86/kvm/svm.c                                 |  13 +-
 arch/x86/kvm/vmx/vmx.c                             |  18 --
 arch/x86/kvm/x86.c                                 |  17 ++
 arch/x86/mm/pageattr.c                             |  12 +-
 drivers/acpi/ec.c                                  |   6 +-
 drivers/acpi/sleep.c                               |  15 +-
 drivers/base/component.c                           |   8 +-
 drivers/dax/kmem.c                                 |  14 +-
 drivers/dma/dmatest.c                              |   9 +-
 drivers/dma/owl-dma.c                              |   8 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/firmware/efi/libstub/tpm.c                 |   5 +-
 drivers/firmware/efi/tpm.c                         |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  17 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   4 +-
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c          |   2 +-
 drivers/gpu/drm/i915/gvt/display.c                 |  49 ++++-
 drivers/gpu/drm/i915/i915_request.c                |   4 +-
 drivers/hid/hid-alps.c                             |   1 +
 drivers/hid/hid-ids.h                              |   7 +-
 drivers/hid/hid-multitouch.c                       |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   2 +
 drivers/i2c/i2c-core-base.c                        |  22 +-
 drivers/i2c/i2c-dev.c                              |  48 +++--
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/accel/sca3000.c                        |   2 +-
 drivers/iio/adc/stm32-adc.c                        |  20 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |  36 +++-
 drivers/iio/adc/ti-ads8344.c                       |   8 +-
 drivers/iio/dac/vf610_dac.c                        |   1 +
 drivers/iommu/amd_iommu.c                          |   1 +
 drivers/iommu/amd_iommu_init.c                     |   9 +-
 drivers/ipack/carriers/tpci200.c                   |   1 +
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   3 +
 drivers/misc/mei/client.c                          |   2 +
 drivers/mtd/mtdcore.c                              |   2 +-
 drivers/mtd/nand/spi/core.c                        |   4 +
 drivers/mtd/ubi/debug.c                            |  12 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/gtp.c                                  |   9 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  24 +++
 drivers/rapidio/devices/rio_mport_cdev.c           |   5 +
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   4 -
 drivers/scsi/qla2xxx/qla_attr.c                    |   5 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/staging/greybus/uart.c                     |   4 +-
 drivers/staging/iio/resolver/ad2s1210.c            |  17 +-
 drivers/staging/kpc2000/kpc2000/core.c             |   9 +-
 drivers/target/target_core_transport.c             |   1 +
 drivers/tty/serial/sifive.c                        |   1 +
 drivers/usb/core/message.c                         |   4 +-
 drivers/vhost/vsock.c                              |  10 +-
 fs/afs/fs_probe.c                                  |  18 +-
 fs/afs/fsclient.c                                  |   8 +-
 fs/afs/vl_probe.c                                  |  18 +-
 fs/afs/yfsclient.c                                 |   8 +-
 fs/ceph/caps.c                                     |   1 +
 fs/configfs/dir.c                                  |   1 +
 fs/file.c                                          |   2 +-
 fs/gfs2/glock.c                                    |   3 -
 fs/ubifs/auth.c                                    |  17 +-
 fs/ubifs/file.c                                    |   6 +-
 fs/ubifs/replay.c                                  |  13 +-
 include/linux/filter.h                             |   8 +-
 include/net/af_rxrpc.h                             |   2 +-
 include/net/drop_monitor.h                         |   2 +-
 include/sound/hda_regmap.h                         |   3 +
 include/sound/hdaudio.h                            |   1 +
 include/trace/events/rxrpc.h                       |  52 ++++-
 kernel/sched/fair.c                                |  50 +++--
 lib/test_printf.c                                  |  19 +-
 lib/vsprintf.c                                     |   7 +
 mm/kasan/Makefile                                  |   8 +-
 mm/kasan/generic.c                                 |   1 -
 mm/kasan/tags.c                                    |   1 -
 net/core/flow_dissector.c                          |  26 ++-
 net/rxrpc/Makefile                                 |   1 +
 net/rxrpc/ar-internal.h                            |  25 ++-
 net/rxrpc/call_accept.c                            |   2 +-
 net/rxrpc/call_event.c                             |  22 +-
 net/rxrpc/input.c                                  |  44 +++-
 net/rxrpc/misc.c                                   |   5 -
 net/rxrpc/output.c                                 |   9 +-
 net/rxrpc/peer_event.c                             |  46 ----
 net/rxrpc/peer_object.c                            |  12 +-
 net/rxrpc/proc.c                                   |   8 +-
 net/rxrpc/rtt.c                                    | 195 +++++++++++++++++
 net/rxrpc/rxkad.c                                  |   3 +-
 net/rxrpc/sendmsg.c                                |  26 +--
 net/rxrpc/sysctl.c                                 |   9 -
 scripts/gcc-plugins/Makefile                       |   1 +
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 scripts/gdb/linux/rbtree.py                        |   4 +-
 scripts/link-vmlinux.sh                            |  28 ++-
 security/apparmor/apparmorfs.c                     |   3 +-
 security/apparmor/audit.c                          |   3 +-
 security/apparmor/domain.c                         |   3 +-
 security/integrity/evm/evm_crypto.c                |  44 ++--
 security/integrity/ima/ima_crypto.c                |  12 +-
 security/integrity/ima/ima_fs.c                    |   3 +-
 sound/core/pcm_lib.c                               |   1 +
 sound/hda/hdac_device.c                            |   1 +
 sound/hda/hdac_regmap.c                            | 142 +++++++++----
 sound/pci/hda/hda_codec.c                          |  30 +--
 sound/pci/hda/hda_generic.c                        |   6 +-
 sound/pci/hda/hda_local.h                          |   2 +
 sound/pci/hda/patch_analog.c                       |   6 +-
 sound/pci/hda/patch_ca0132.c                       |  12 +-
 sound/pci/hda/patch_conexant.c                     |   6 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +-
 sound/pci/hda/patch_realtek.c                      | 232 +++++++++++++++++----
 sound/pci/hda/patch_sigmatel.c                     |   4 +-
 sound/pci/hda/patch_via.c                          |   6 +-
 sound/pci/ice1712/ice1712.c                        |   3 +-
 tools/testing/selftests/ftrace/ftracetest          |   8 +-
 tools/testing/selftests/kvm/include/evmcs.h        |   4 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   3 +
 133 files changed, 1451 insertions(+), 600 deletions(-)


