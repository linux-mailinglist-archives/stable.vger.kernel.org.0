Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EE99D78
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbfHVRXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391567AbfHVRXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:36 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFDA823400;
        Thu, 22 Aug 2019 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494614;
        bh=CjN5f7NIKT1lH4U8zykvs46rOrqhcPorNx2sQK/kIsI=;
        h=From:To:Cc:Subject:Date:From;
        b=FpGtxe5+mS1xodr1IKJ9cL5vwxytJooDCeEHufiPQT+r+MzNI1504Mz0GHATObVc7
         4k8Lwe0AlAY9RTLHwzj02EwrhoB2jAgE/scA992f6KOv+zrRKVb6S8D4opsSnX3NuF
         ZP7fPhF/IsQw1+tw6JEDpzlvdzk1KgCQaRWwFzc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/103] 4.9.190-stable review
Date:   Thu, 22 Aug 2019 10:17:48 -0700
Message-Id: <20190822171728.445189830@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.190-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.190-rc1
X-KernelTest-Deadline: 2019-08-24T17:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.190 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 24 Aug 2019 05:15:44 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.190-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.190-rc1

YueHaibing <yuehaibing@huawei.com>
    bonding: Add vlan tx offload to hw_enc_features

YueHaibing <yuehaibing@huawei.com>
    team: Add vlan tx offload to hw_enc_features

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Use flow keys dissector to parse packets for ARFS

Huy Nguyen <huyn@mellanox.com>
    net/mlx5e: Only support tx/rx pause setting for port owner

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/netback: Reset nr_frags before freeing skb

Xin Long <lucien.xin@gmail.com>
    sctp: fix the transport error_count check

Eric Dumazet <edumazet@google.com>
    net/packet: fix race in tpacket_snd()

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix VF's VLAN reconfiguration in reload.

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Move iommu_init_pci() to .init section

YueHaibing <yuehaibing@huawei.com>
    Input: psmouse - fix build error of multiple definition

Dirk Morris <dmorris@metaloft.com>
    netfilter: conntrack: Use consistent ct id hash calculation

Will Deacon <will@kernel.org>
    arm64: compat: Allow single-byte watchpoints on all addresses

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K

Qian Cai <cai@lca.pw>
    asm-generic: fix -Wtype-limits compiler warnings

Tony Lindgren <tony@atomide.com>
    USB: serial: option: Add Motorola modem UARTs

Bob Ham <bob.ham@puri.sm>
    USB: serial: option: add the BroadMobi BM818 card

Yoshiaki Okamoto <yokamoto@allied-telesis.co.jp>
    USB: serial: option: Add support for ZTE MF871A

Rogan Dawes <rogan@dawes.za.net>
    USB: serial: option: add D-Link DWM-222 device ID

Oliver Neukum <oneukum@suse.com>
    USB: CDC: fix sanity checks in CDC union parser

Oliver Neukum <oneukum@suse.com>
    usb: cdc-acm: make sure a refcount is taken early enough

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix races in character device registration and deregistraion

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt3000: Fix rounding up of timer divisor

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt3000: Fix signed integer overflow 'divider * base'

YueHaibing <yuehaibing@huawei.com>
    ocfs2: remove set but not used variable 'last_hash'

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mad: Fix use-after-free in ib mad completion handling

Tony Luck <tony.luck@intel.com>
    IB/core: Add mitigation for Spectre V1

Qian Cai <cai@lca.pw>
    arm64/mm: fix variable 'pud' set but not used

Qian Cai <cai@lca.pw>
    arm64/efi: fix variable 'si' set but not used

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Miquel Raynal <miquel.raynal@bootlin.com>
    ata: libahci: do not complain in case of deferred probe

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct scsi command status issue after reset

Kees Cook <keescook@chromium.org>
    libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Numfor Mbiziwo-Tiapo <nums@google.com>
    perf header: Fix use of unitialized value warning

Vince Weaver <vincent.weaver@maine.edu>
    perf header: Fix divide by zero error if f_header.attr_size==0

Lucas Stach <l.stach@pengutronix.de>
    irqchip/irq-imx-gpcv2: Forward irq type to parent

YueHaibing <yuehaibing@huawei.com>
    xen/pciback: remove set but not used variable 'old_state'

Denis Kirjanov <kda@linux-powerpc.org>
    net: usb: pegasus: fix improper read if get_registers() fail

Oliver Neukum <oneukum@suse.com>
    Input: iforce - add sanity checks

Oliver Neukum <oneukum@suse.com>
    Input: kbtab - sanity check for endpoint type

Hillf Danton <hdanton@sina.com>
    HID: hiddev: do cleanup in failure of opening a device

Hillf Danton <hdanton@sina.com>
    HID: hiddev: avoid opening a disconnected device

Oliver Neukum <oneukum@suse.com>
    HID: holtek: test for sanity of intfdata

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Let all conexant codec enter D3 when rebooting

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add a generic reboot_notify

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: hda - Fix a memory leak bug

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add missing isync to the cpu_reset TLB code

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: don't use conntrack/expect object addresses as id

Eric Dumazet <edumazet@google.com>
    inet: switch IP ID generator to siphash

Jason A. Donenfeld <Jason@zx2c4.com>
    siphash: implement HalfSipHash1-3 for hash tables

Jason A. Donenfeld <Jason@zx2c4.com>
    siphash: add cryptographically secure PRF

Jason Wang <jasowang@redhat.com>
    vhost: scsi: add weight support

Jason Wang <jasowang@redhat.com>
    vhost_net: fix possible infinite loop

Jason Wang <jasowang@redhat.com>
    vhost: introduce vhost_exceeds_weight()

Jason Wang <jasowang@redhat.com>
    vhost_net: introduce vhost_exceeds_weight()

Paolo Abeni <pabeni@redhat.com>
    vhost_net: use packet weight for rx handler, too

haibinzhang(张海斌) <haibinzhang@tencent.com>
    vhost-net: set packet weight of tx polling to 2 * vq size

Daniel Borkmann <daniel@iogearbox.net>
    bpf: add bpf_jit_limit knob to restrict unpriv allocations

Daniel Borkmann <daniel@iogearbox.net>
    bpf: restrict access to core bpf sysctls

Daniel Borkmann <daniel@iogearbox.net>
    bpf: get rid of pure_initcall dependency to enable jits

Miles Chen <miles.chen@mediatek.com>
    mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Isaac J. Manjarres <isaacm@codeaurora.org>
    mm/usercopy: use memory range to be accessed for wraparound check

Gustavo A. R. Silva <gustavo@embeddedor.com>
    sh: kernel: hw_breakpoint: Fix missing break in switch statement

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't unmap as page memory that was mapped as single

Brian Norris <briannorris@chromium.org>
    mwifiex: fix 802.11n/WPA detection

Steve French <stfrench@microsoft.com>
    smb3: send CAP_DFS capability during session setup

Pavel Shilovsky <pshilov@microsoft.com>
    SMB3: Fix deadlock in validate negotiate hits reconnect

Brian Norris <briannorris@chromium.org>
    mac80211: don't WARN on short WMM parameters from AP

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't override global PCM hw info flag

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: firewire: fix a memory leak bug

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct7802) Fix wrong detection of in4 presence

Tomas Bortoli <tomasbortoli@gmail.com>
    can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices

Tomas Bortoli <tomasbortoli@gmail.com>
    can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices

Leonard Crestez <leonard.crestez@nxp.com>
    perf/core: Fix creating kernel counters for PMUs that override event->cpu

Peter Zijlstra <peterz@infradead.org>
    tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    scsi: ibmvfc: fix WARN_ON during event pool release

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: megaraid_sas: fix panic on loading firmware crashdump

Arnd Bergmann <arnd@arndb.de>
    ARM: davinci: fix sleep.S build error on ARMv4

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()

Arnd Bergmann <arnd@arndb.de>
    drbd: dynamically allocate shash descriptor

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Avoid calling freeing routine multiple times for same pointer

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Be more restrictive about when a drain is allowed

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Don't allow paritial drain operations on capture streams

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Prevent bypasses of set_params

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Fix regression on compressed capture streams

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: add sanity checks to the fast-requeue path

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()

Björn Gerhart <gerhart@posteo.de>
    hwmon: (nct6775) Fix register address and added missed tolerance for nct6106

Brian Norris <briannorris@chromium.org>
    mac80211: don't warn about CW params when not using them

Thomas Tai <thomas.tai@oracle.com>
    iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink: avoid deadlock due to synchronous request_module

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix potential double kfree_skb()

Suzuki K Poulose <suzuki.poulose@arm.com>
    usb: yurex: Fix use-after-free in yurex_delete

Thomas Richter <tmricht@linux.ibm.com>
    perf record: Fix module size on s390

Adrian Hunter <adrian.hunter@intel.com>
    perf db-export: Fix thread__exec_comm()

Thomas Richter <tmricht@linux.vnet.ibm.com>
    perf record: Fix wrong size in perf_record_mmap for last kernel module

Joerg Roedel <jroedel@suse.de>
    mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()

Joerg Roedel <jroedel@suse.de>
    x86/mm: Sync also unmappings in vmalloc_sync_all()

Joerg Roedel <jroedel@suse.de>
    x86/mm: Check for pfn instead of page in vmalloc_sync_one()

Wenwen Wang <wenwen@cs.uga.edu>
    sound: fix a memory leak bug

Oliver Neukum <oneukum@suse.com>
    usb: iowarrior: fix deadlock on disconnect

Gavin Li <git@thegavinli.com>
    usb: usbfs: fix double-free of usb memory upon submiturb error


-------------

Diffstat:

 Documentation/siphash.txt                          | 175 +++++++
 Documentation/sysctl/net.txt                       |   8 +
 MAINTAINERS                                        |   7 +
 Makefile                                           |   4 +-
 arch/arm/mach-davinci/sleep.S                      |   1 +
 arch/arm/net/bpf_jit_32.c                          |   2 -
 arch/arm64/include/asm/efi.h                       |   6 +-
 arch/arm64/include/asm/pgtable.h                   |   4 +-
 arch/arm64/kernel/hw_breakpoint.c                  |   7 +-
 arch/arm64/net/bpf_jit_comp.c                      |   2 -
 arch/mips/net/bpf_jit.c                            |   2 -
 arch/powerpc/net/bpf_jit_comp.c                    |   2 -
 arch/powerpc/net/bpf_jit_comp64.c                  |   2 -
 arch/s390/net/bpf_jit_comp.c                       |   2 -
 arch/sh/kernel/hw_breakpoint.c                     |   1 +
 arch/sparc/net/bpf_jit_comp.c                      |   2 -
 arch/x86/mm/fault.c                                |  15 +-
 arch/x86/net/bpf_jit_comp.c                        |   2 -
 arch/xtensa/kernel/setup.c                         |   1 +
 drivers/acpi/arm64/iort.c                          |   4 +-
 drivers/ata/libahci_platform.c                     |   3 +
 drivers/ata/libata-zpodd.c                         |   2 +-
 drivers/block/drbd/drbd_receiver.c                 |  14 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |  23 +-
 drivers/firmware/Kconfig                           |   5 +-
 drivers/firmware/iscsi_ibft.c                      |   4 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/usbhid/hiddev.c                        |  12 +
 drivers/hwmon/nct6775.c                            |   3 +-
 drivers/hwmon/nct7802.c                            |   6 +-
 drivers/infiniband/core/mad.c                      |  20 +-
 drivers/infiniband/core/user_mad.c                 |   6 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   5 +
 drivers/input/mouse/trackpoint.h                   |   3 +-
 drivers/input/tablet/kbtab.c                       |   6 +-
 drivers/iommu/amd_iommu_init.c                     |   2 +-
 drivers/irqchip/irq-imx-gpcv2.c                    |   1 +
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  97 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   3 +
 drivers/net/team/team.c                            |   4 +-
 drivers/net/usb/pegasus.c                          |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |   3 +-
 drivers/net/xen-netback/netback.c                  |   2 +
 drivers/s390/cio/qdio_main.c                       |  12 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   7 +-
 drivers/scsi/hpsa.c                                |  12 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  12 +-
 drivers/staging/comedi/drivers/dt3000.c            |   8 +-
 drivers/tty/tty_ldsem.c                            |   5 +-
 drivers/usb/class/cdc-acm.c                        |  12 +-
 drivers/usb/core/devio.c                           |   2 -
 drivers/usb/core/file.c                            |  10 +-
 drivers/usb/core/message.c                         |   4 +-
 drivers/usb/misc/iowarrior.c                       |   7 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/serial/option.c                        |  10 +
 drivers/vhost/net.c                                |  34 +-
 drivers/vhost/scsi.c                               |  15 +-
 drivers/vhost/vhost.c                              |  20 +-
 drivers/vhost/vhost.h                              |   6 +-
 drivers/vhost/vsock.c                              |  12 +-
 drivers/xen/xen-pciback/conf_space_capability.c    |   3 +-
 fs/cifs/smb2pdu.c                                  |   7 +-
 fs/ocfs2/xattr.c                                   |   3 -
 include/asm-generic/getorder.h                     |  50 +-
 include/linux/filter.h                             |   1 +
 include/linux/siphash.h                            | 145 ++++++
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/netns/ipv4.h                           |   2 +
 include/sound/compress_driver.h                    |   5 +-
 kernel/bpf/core.c                                  |  73 ++-
 kernel/events/core.c                               |   2 +-
 lib/Kconfig.debug                                  |   6 +-
 lib/Makefile                                       |   5 +-
 lib/siphash.c                                      | 551 +++++++++++++++++++++
 lib/test_siphash.c                                 | 223 +++++++++
 mm/memcontrol.c                                    |  39 +-
 mm/usercopy.c                                      |   2 +-
 mm/vmalloc.c                                       |   9 +
 net/core/sysctl_net_core.c                         |  71 ++-
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/output_core.c                             |  30 +-
 net/mac80211/driver-ops.c                          |  13 +-
 net/mac80211/mlme.c                                |  10 +
 net/netfilter/nf_conntrack_core.c                  |  35 ++
 net/netfilter/nf_conntrack_netlink.c               |  34 +-
 net/netfilter/nfnetlink.c                          |   2 +-
 net/packet/af_packet.c                             |   7 +
 net/sctp/sm_sideeffect.c                           |   2 +-
 net/socket.c                                       |   9 -
 scripts/Makefile.modpost                           |   2 +-
 sound/core/compress_offload.c                      |  60 ++-
 sound/firewire/packets-buffer.c                    |   2 +-
 sound/pci/hda/hda_controller.c                     |   6 +-
 sound/pci/hda/hda_generic.c                        |  21 +-
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/patch_conexant.c                     |  15 +-
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/sound_core.c                                 |   3 +-
 tools/perf/arch/s390/util/machine.c                |  14 +-
 tools/perf/builtin-probe.c                         |  10 +
 tools/perf/util/header.c                           |   9 +-
 tools/perf/util/machine.c                          |   7 +-
 tools/perf/util/machine.h                          |   2 +-
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/perf/util/symbol.c                           |  21 +-
 tools/perf/util/symbol.h                           |   2 +-
 tools/perf/util/thread.c                           |  12 +-
 119 files changed, 1894 insertions(+), 383 deletions(-)


