Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934D31C171B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgEAN5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728870AbgEANbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7460208C3;
        Fri,  1 May 2020 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339862;
        bh=PztrRb2Tz3DWVCFUVgUJFnupzhZqc22AOrD+w98cX9c=;
        h=From:To:Cc:Subject:Date:From;
        b=Qnt478GMLrdRhlnGPSnOOY8UgGFGhlWyyUhxDiw13Vgu+RndWmLRtPV+2Ju1SmlTl
         6kRJxnu3xwg4xiN221SW3e62yD0ZGVAKxlofFxZdIaZu6xQpTOCsJlzdlejMBr6Uw9
         koS0DbzwFpgLqCy2LFOKUmYfsnPyFLRBuz1CnmDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/117] 4.14.178-rc1 review
Date:   Fri,  1 May 2020 15:20:36 +0200
Message-Id: <20200501131544.291247695@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.178-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.178-rc1
X-KernelTest-Deadline: 2020-05-03T13:15+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.178 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.178-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.178-rc1

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: check for non-zero journal inum in ext4_calculate_overhead

Yuval Basson <ybason@marvell.com>
    qed: Fix use after free in qed_chain_free

Colin Ian King <colin.king@canonical.com>
    ext4: unsigned int compared against zero

Theodore Ts'o <tytso@mit.edu>
    ext4: fix block validity checks for journal inodes using indirect blocks

Theodore Ts'o <tytso@mit.edu>
    ext4: don't perform block validity checks on the journal inode

Theodore Ts'o <tytso@mit.edu>
    ext4: protect journal inode's blocks using block_validity

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid declaring fs inconsistent due to invalid file handles

Sascha Hauer <s.hauer@pengutronix.de>
    hwmon: (jc42) Fix name to have no illegal characters

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak on changeset destroy

Theodore Ts'o <tytso@mit.edu>
    ext4: convert BUG_ON's to WARN_ON's in mballoc.c

Theodore Ts'o <tytso@mit.edu>
    ext4: increase wait time needed before reuse of deleted inode numbers

yangerkun <yangerkun@huawei.com>
    ext4: use matching invalidatepage in ext4_writepage

Fangrui Song <maskray@google.com>
    arm64: Delete the space separator in __emit_inst

Juergen Gross <jgross@suse.com>
    xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant status

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support Clang non-section symbols in ORC dump

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: fix PR IN / READ FULL STATUS for FC

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

Olaf Hering <olaf@aepfle.de>
    x86: hyperv: report value of misc_features

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Yang Shi <yang.shi@linux.alibaba.com>
    mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path

Ian Rogers <irogers@google.com>
    perf/core: fix parent pid/tid in task exit events

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    ARM: dts: bcm283x: Disable dsi0 node

Jason Gunthorpe <jgg@mellanox.com>
    net/cxgb4: Check the return from t4_query_params properly

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: altera: use proper variable to hold errno

Vasily Averin <vvs@virtuozzo.com>
    nfsd: memory corruption in nfsd4_lock()

YueHaibing <yuehaibing@huawei.com>
    iio:ad7797: Use correct attribute_group

Nathan Chancellor <natechancellor@gmail.com>
    usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_complete

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Do link recovery for SS and SSP

Tyler Hicks <tyhicks@canonical.com>
    binder: take read mode of mmap_sem in binder_alloc_free_page()

Christian Borntraeger <borntraeger@de.ibm.com>
    include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

Liu Jian <liujian56@huawei.com>
    mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Clement Leger <cleger@kalray.eu>
    remoteproc: Fix wrong rvring index computation

kaixuxia <xiakaixu1987@gmail.com>
    xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: validate sb_logsunit is a multiple of the fs blocksize

Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
    serial: sh-sci: Make sure status register SCxSR is read in correct sequence

Udipto Goswami <ugoswami@codeaurora.org>
    usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_reset()

Oliver Neukum <oneukum@suse.com>
    UAS: fix deadlock in error handling and PM flushing work

Oliver Neukum <oneukum@suse.com>
    UAS: no use logging any details in case of ENODEV

Oliver Neukum <oneukum@suse.com>
    cdc-acm: introduce a cool down

Oliver Neukum <oneukum@suse.com>
    cdc-acm: close race betrween suspend() and acm_softint

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Power save stop wake_up_count wrap around.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix pairwise key entry save.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix drivers TBTT timing counter.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix calling conditions of vnt_set_bss_mode

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.

Nicolas Pitre <nico@fluxnic.net>
    vt: don't hardcode the mem allocation upper bound

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: comedi: Fix comedi_device refcnt leak in comedi_open

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt2815: fix writing hi byte of analog output

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/setup_64: Set cache-line-size based on cache-block-size

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: actually release queue memory in TVQM

Gyeongtaek Lee <gt82.lee@samsung.com>
    ASoC: dapm: fixup dapm kcontrol widget

Paul Moore <paul@paul-moore.com>
    audit: check the length of userspace generated audit records

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add unusual_devs entry for JMicron JMS566

Jiri Slaby <jslaby@suse.cz>
    tty: rocket, avoid OOB access

Andrew Melnychenko <andrew@daynix.com>
    tty: hvc: fix buffer overflow during hvc_alloc().

Uros Bizjak <ubizjak@gmail.com>
    KVM: VMX: Enable machine check support for 32bit targets

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check validity of resolved slot when searching memslots

George Wilson <gcwilson@linux.ibm.com>
    tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm/tpm_tis: Free IRQ if probing fails

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Filter out unsupported sample rates on Focusrite devices

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC245

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix potential NULL dereference

Lucas Stach <l.stach@pengutronix.de>
    tools/vm: fix cross-compile build

Muchun Song <songmuchun@bytedance.com>
    mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

Longpeng <longpeng2@huawei.com>
    mm/hugetlb: fix a addressing exception caused by huge_pte_offset

Jann Horn <jannh@google.com>
    vmalloc: fix remap_vmalloc_range() bounds checks

Jason Gunthorpe <jgg@mellanox.com>
    overflow.h: Add arithmetic shift helper

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Fix handling of connect changes during sleep

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix free-while-in-use bug in the USB S-Glibrary

Jann Horn <jannh@google.com>
    USB: early: Handle AMD's spec-compliant identifiers, too

Jonathan Cox <jonathan@jdcox.net>
    USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsair K70 RGB RAPIDFIRE

Changming Liu <liu.changm@northeastern.edu>
    USB: sisusbvga: Change port variable from signed to unsigned

Piotr Krysiuk <piotras@gmail.com>
    fs/namespace.c: fix mountpoint reference counter race

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix sequencer configuration for aux channels in simultaneous mode

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix clearing interrupt when enabling trigger

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix ADC-B powerdown

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-adc: fix sleep in atomic context

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Remove ASUS ROG Zenith from the blacklist

Waiman Long <longman@redhat.com>
    KEYS: Avoid false positive ENOMEM error on key read

David Ahern <dsahern@gmail.com>
    vrf: Check skb for XFRM_TRANSFORMED flag

David Ahern <dsahern@gmail.com>
    xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Fix ARL register definitions

Taehee Yoo <ap420073@gmail.com>
    team: fix hang in team_mode_get()

Eric Dumazet <edumazet@google.com>
    tcp: cache line align MAX_TCP_HEADER

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/x25: Fix x25_neigh refcnt leak when receiving frame

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: correct per TX/RX ring statistics

Taehee Yoo <ap420073@gmail.com>
    macvlan: fix null dereference in macvlan_device_event()

Taehee Yoo <ap420073@gmail.com>
    macsec: avoid to set wrong mtu

John Haxby <john.haxby@oracle.com>
    ipv6: fix restrict IPV6_ADDRFORM operation

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix large delays in PTP synchronization

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: restore the original intention of prefetch_freepointer()

Heiner Kallweit <hkallweit1@gmail.com>
    PCI/ASPM: Allow re-enabling Clock PM

Jiri Olsa <jolsa@kernel.org>
    perf/core: Disable page faults when getting phys address

Florian Fainelli <f.fainelli@gmail.com>
    pwm: bcm2835: Dynamically allocate base

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: renesas-tpu: Fix late Runtime PM enablement

Cornelia Huck <cohuck@redhat.com>
    s390/cio: avoid duplicated 'ADD' uevents

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() should increase position index

Eric Biggers <ebiggers@google.com>
    selftests: kmod: fix handling test numbers above 9

Vasily Averin <vvs@virtuozzo.com>
    kernel/gcov/fs.c: gcov_seq_next() should increase position index

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_slot_map()

Wu Bo <wubo40@huawei.com>
    scsi: iscsi: Report unbind session event when the target has been removed

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: rcar: Fix late Runtime PM enablement

Yan, Zheng <zyan@redhat.com>
    ceph: don't skip updating wanted caps when cap is stale

Qiujun Huang <hqjagain@gmail.com>
    ceph: return ceph_mdsc_do_request() errors from __get_parent()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Tero Kristo <t-kristo@ti.com>
    watchdog: reset last_hw_keepalive time at start

Jeremy Sowden <jeremy@azazel.net>
    vti4: removed duplicate log message.

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static

Rob Clark <robdclark@chromium.org>
    drm/msm: Use the correct dma_sync calls harder

David Howells <dhowells@redhat.com>
    keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h

Arnd Bergmann <arnd@arndb.de>
    net: ipv4: avoid unused variable warning for sysctl

Nicolai Stange <nstange@suse.de>
    net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()

Dmitry Monakhov <dmonakhov@gmail.com>
    ext4: fix extent_status fragmentation for plain files


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                    |   1 +
 arch/arm/mach-imx/Makefile                        |   2 +
 arch/arm64/include/asm/sysreg.h                   |   4 +-
 arch/powerpc/kernel/setup_64.c                    |   2 +
 arch/x86/kernel/cpu/mshyperv.c                    |   4 +-
 arch/x86/kvm/vmx.c                                |   2 +-
 arch/x86/net/bpf_jit_comp.c                       |  18 ++-
 drivers/android/binder_alloc.c                    |   8 +-
 drivers/char/tpm/tpm_ibmvtpm.c                    | 136 ++++++++++++----------
 drivers/char/tpm/tpm_tis_core.c                   |   8 +-
 drivers/crypto/mxs-dcp.c                          |   4 +-
 drivers/gpu/drm/msm/msm_gem.c                     |   4 +-
 drivers/hwmon/jc42.c                              |   2 +-
 drivers/i2c/busses/i2c-altera.c                   |   9 +-
 drivers/iio/adc/ad7793.c                          |   2 +-
 drivers/iio/adc/stm32-adc.c                       |  31 ++++-
 drivers/iio/adc/xilinx-xadc-core.c                |  17 ++-
 drivers/mtd/chips/cfi_cmdset_0002.c               |   6 +-
 drivers/net/dsa/b53/b53_regs.h                    |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    |  27 +----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c        |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h      |   3 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c         |  38 +++---
 drivers/net/macsec.c                              |  12 +-
 drivers/net/macvlan.c                             |   2 +-
 drivers/net/team/team.c                           |   4 +
 drivers/net/vrf.c                                 |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   3 +
 drivers/of/unittest.c                             |   4 +
 drivers/pci/pcie/aspm.c                           |  18 +--
 drivers/pwm/pwm-bcm2835.c                         |   1 +
 drivers/pwm/pwm-rcar.c                            |  10 +-
 drivers/pwm/pwm-renesas-tpu.c                     |   9 +-
 drivers/remoteproc/remoteproc_core.c              |   2 +-
 drivers/s390/cio/device.c                         |  13 ++-
 drivers/scsi/lpfc/lpfc_sli.c                      |   2 +
 drivers/scsi/scsi_transport_iscsi.c               |   4 +-
 drivers/staging/comedi/comedi_fops.c              |   4 +-
 drivers/staging/comedi/drivers/dt2815.c           |   3 +
 drivers/staging/vt6656/int.c                      |   3 +-
 drivers/staging/vt6656/key.c                      |  14 +--
 drivers/staging/vt6656/main_usb.c                 |  31 ++---
 drivers/target/target_core_fabric_lib.c           |   2 +-
 drivers/tty/hvc/hvc_console.c                     |  23 ++--
 drivers/tty/rocket.c                              |  25 ++--
 drivers/tty/serial/sh-sci.c                       |  13 ++-
 drivers/tty/vt/vt.c                               |   2 +-
 drivers/usb/class/cdc-acm.c                       |  36 +++++-
 drivers/usb/class/cdc-acm.h                       |   5 +-
 drivers/usb/core/hub.c                            |  14 +++
 drivers/usb/core/message.c                        |   9 +-
 drivers/usb/core/quirks.c                         |   4 +
 drivers/usb/dwc3/gadget.c                         |   8 +-
 drivers/usb/early/xhci-dbc.c                      |   8 +-
 drivers/usb/early/xhci-dbc.h                      |  18 ++-
 drivers/usb/gadget/function/f_fs.c                |   4 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c               |   2 +-
 drivers/usb/misc/sisusbvga/sisusb.c               |  20 ++--
 drivers/usb/misc/sisusbvga/sisusb_init.h          |  14 +--
 drivers/usb/storage/uas.c                         |  46 +++++++-
 drivers/usb/storage/unusual_devs.h                |   7 ++
 drivers/watchdog/watchdog_dev.c                   |   1 +
 drivers/xen/xenbus/xenbus_client.c                |   9 +-
 fs/ceph/caps.c                                    |   8 +-
 fs/ceph/export.c                                  |   5 +
 fs/ext4/block_validity.c                          |  54 +++++++++
 fs/ext4/ext4.h                                    |  15 ++-
 fs/ext4/extents.c                                 |  59 ++++++----
 fs/ext4/ialloc.c                                  |   4 +-
 fs/ext4/inode.c                                   |  55 ++++++---
 fs/ext4/ioctl.c                                   |   2 +-
 fs/ext4/mballoc.c                                 |   6 +-
 fs/ext4/namei.c                                   |   4 +-
 fs/ext4/resize.c                                  |   5 +-
 fs/ext4/super.c                                   |  22 ++--
 fs/ext4/xattr.c                                   |   5 +-
 fs/namespace.c                                    |   2 +-
 fs/nfsd/nfs4state.c                               |   2 +
 fs/proc/vmcore.c                                  |   2 +-
 fs/xfs/xfs_inode.c                                |  85 +++++++-------
 fs/xfs/xfs_log.c                                  |  14 ++-
 fs/xfs/xfs_reflink.c                              |   1 +
 include/linux/kvm_host.h                          |   2 +-
 include/linux/overflow.h                          |  31 +++++
 include/linux/qed/qed_chain.h                     |  24 ++--
 include/linux/vmalloc.h                           |   2 +-
 include/net/tcp.h                                 |   2 +-
 include/uapi/linux/keyctl.h                       |   7 +-
 include/uapi/linux/swab.h                         |   4 +-
 ipc/util.c                                        |   2 +-
 kernel/audit.c                                    |   3 +
 kernel/events/core.c                              |  22 +++-
 kernel/gcov/fs.c                                  |   2 +-
 mm/hugetlb.c                                      |  14 ++-
 mm/ksm.c                                          |  12 +-
 mm/shmem.c                                        |   4 +-
 mm/slub.c                                         |   3 +-
 mm/vmalloc.c                                      |  16 ++-
 net/ipv4/ip_vti.c                                 |   4 +-
 net/ipv4/raw.c                                    |   4 +-
 net/ipv4/route.c                                  |   3 +-
 net/ipv4/xfrm4_output.c                           |   2 -
 net/ipv6/ipv6_sockglue.c                          |  13 +--
 net/ipv6/xfrm6_output.c                           |   2 -
 net/netrom/nr_route.c                             |   1 +
 net/x25/x25_dev.c                                 |   4 +-
 security/keys/internal.h                          |  12 ++
 security/keys/keyctl.c                            |  58 ++++++---
 sound/pci/hda/hda_intel.c                         |   1 -
 sound/pci/hda/patch_realtek.c                     |   3 +
 sound/soc/intel/atom/sst-atom-controls.c          |   2 +
 sound/soc/soc-dapm.c                              |  20 +++-
 sound/usb/format.c                                |  52 +++++++++
 sound/usb/mixer_quirks.c                          |  12 +-
 sound/usb/usx2y/usbusx2yaudio.c                   |   2 +
 tools/objtool/check.c                             |  17 ++-
 tools/objtool/orc_dump.c                          |  44 ++++---
 tools/testing/selftests/kmod/kmod.sh              |  13 ++-
 tools/vm/Makefile                                 |   2 +
 121 files changed, 1047 insertions(+), 480 deletions(-)


