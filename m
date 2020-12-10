Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D452D6097
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392026AbgLJPzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391161AbgLJOie (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:34 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 00/75] 5.9.14-rc1 review
Date:   Thu, 10 Dec 2020 15:26:25 +0100
Message-Id: <20201210142606.074509102@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.14-rc1
X-KernelTest-Deadline: 2020-12-12T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.14 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.14-rc1

Masami Hiramatsu <mhiramat@kernel.org>
    x86/insn-eval: Use new for_each_insn_prefix() macro to loop over prefixes bytes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables_offload: build mask based from the matching bytes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables_offload: set address type in control dissector

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid false-postive lockdep splat

Luo Meng <luomeng12@huawei.com>
    Input: i8042 - fix error return code in i8042_setup_aux()

Mike Snitzer <snitzer@redhat.com>
    dm writecache: remove BUG() and fail gracefully instead

Zhihao Cheng <chengzhihao1@huawei.com>
    i2c: qup: Fix error return code in qup_i2c_bam_schedule_desc()

Robert Foss <robert.foss@linaro.org>
    i2c: qcom: Fix IRQ error misassignement

Dan Carpenter <dan.carpenter@oracle.com>
    rtw88: debug: Fix uninitialized memory in debugfs code

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't freeze the file system during unmount

Alexander Aring <aahringo@redhat.com>
    gfs2: Fix deadlock dumping resource group glocks

Luo Meng <luomeng12@huawei.com>
    ASoC: wm_adsp: fix error return code in wm_adsp_load()

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix a deadlock when flushing scheduled work

Eric Dumazet <edumazet@google.com>
    netfilter: ipset: prevent uninit-value in hash_ip6_add

Bob Peterson <rpeterso@redhat.com>
    gfs2: check for empty rgrp tree in gfs2_ri_update

Oliver Hartkopp <socketcan@hartkopp.net>
    can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check

Willy Tarreau <w@1wt.eu>
    lib/syscall: fix syscall registers retrieval on 32-bit platforms

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: fix obj_cgroup_charge() return value handling

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs

Alex Deucher <alexdeucher@gmail.com>
    Revert "amd/amdgpu: Disable VCN DPG mode for Picasso"

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb_cgroup: fix offline of hugetlb cgroup with reservations

Qian Cai <qcai@redhat.com>
    mm/swapfile: do not sleep with a spin lock held

Yang Shi <shy828301@gmail.com>
    mm: list_lru: set shrinker map bit when child nr_items is not zero

Menglong Dong <dong.menglong@zte.com.cn>
    coredump: fix core_pattern parse error

Masami Hiramatsu <mhiramat@kernel.org>
    x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

Mike Snitzer <snitzer@redhat.com>
    dm: remove invalid sparse __acquires and __releases annotations

Mike Snitzer <snitzer@redhat.com>
    dm: fix double RCU unlock in dm_dax_zero_page_range() error path

Sergei Shtepa <sergei.shtepa@veeam.com>
    dm: fix bug with RCU locking in dm_blk_report_zones

Laurent Vivier <lvivier@redhat.com>
    powerpc/pseries: Pass MSI affinity to irq_create_mapping()

Laurent Vivier <lvivier@redhat.com>
    genirq/irqdomain: Add an irq_create_mapping_affinity() function

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/powernv: Fix memory corruption when saving SLB entries on MCE

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix the maximum number of arguments

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: advance the number of arguments when reporting max_age

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix recvmsg setup with compat buf-select

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix ioctl timeout

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Fix vCPU id sanity check

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Program mocs:63 for cache eviction on gen9

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Limit frequency drop to RPe on parking

Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>
    drm/i915/gt: Retain default context state across shrinking

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn3.0: remove old DPG workaround

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vcn3.0: stall DPG when WPTR/RPTR reset

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: sdi: fix bridge enable/disable

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix use-after-free in remove_unplugged_switch()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix userstacktrace option for instances

Christian Eggers <ceggers@arri.de>
    i2c: imx: Don't generate STOP condition if arbitration has been lost

Christian Eggers <ceggers@arri.de>
    i2c: imx: Check for I2SR_IAL after every byte

Christian Eggers <ceggers@arri.de>
    i2c: imx: Fix reset of I2SR_IAL flag

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/pci: fix CPU address in MSI for directed IRQ

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix deadlock between gfs2_{create_inode,inode_lookup} and delete_work_func

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Upgrade shared glocks for atime updates

Aurelien Aptel <aaptel@suse.com>
    cifs: add NULL check for ses->tcon_ipc

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: refactor create_sd_buf() and and avoid corrupting the buffer

Paulo Alcantara <pc@cjr.nz>
    cifs: fix potential use-after-free in cifs_echo_request()

Paulo Alcantara <pc@cjr.nz>
    cifs: allow syscalls to be restarted in __smb_send_rqst()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    ftrace: Fix DYNAMIC_FTRACE_WITH_DIRECT_CALLS dependency

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    ftrace: Fix updating FTRACE_FL_TRAMP

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Always check to put back before stamp when crossing pages

Andrea Righi <andrea.righi@canonical.com>
    ring-buffer: Set the right timestamp in the slow path of __rb_reserve_next()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Update write stamp with the correct ts

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/generic: Add option to enforce preferred_dacs pairs

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Dell AIO wrong sound tone

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC897

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset of ASUS UX482EG & B9400CEA with ALC294

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add mute LED quirk to yet another HP x360 model

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix bass speaker DAC assignment on Asus Zephyrus G14

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Reject setting the speakup line discipline outside of speakup

Jann Horn <jannh@google.com>
    tty: Fix ->session locking

Jann Horn <jannh@google.com>
    tty: Fix ->pgrp locking in tiocspgrp()

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: fix Quectel BG96 matching

Giacinto Cifelli <gciofono@gmail.com>
    USB: serial: option: add support for Thales Cinterion EXS82

Vincent Palatin <vpalatin@chromium.org>
    USB: serial: option: add Fibocom NL668 variants

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: sort device-id entries

Jan-Niklas Burfeind <kernel@aiyionpri.me>
    USB: serial: ch341: add new Product ID for CH341A

Johan Hovold <johan@kernel.org>
    USB: serial: kl5kusb105: fix memleak on open

Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
    usb: gadget: f_fs: Use local copy of descriptors for userspace copy


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/powerpc/kvm/book3s_xive.c             |  7 +--
 arch/powerpc/platforms/powernv/setup.c     |  9 +++-
 arch/powerpc/platforms/pseries/msi.c       |  3 +-
 arch/s390/pci/pci_irq.c                    | 14 ++++--
 arch/x86/include/asm/insn.h                | 15 +++++++
 arch/x86/kernel/uprobes.c                  | 10 +++--
 arch/x86/lib/insn-eval.c                   |  5 ++-
 drivers/accessibility/speakup/spk_ttyio.c  | 37 +++++++++------
 drivers/gpu/drm/amd/amdgpu/soc15.c         |  3 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c      | 25 ++++++++---
 drivers/gpu/drm/i915/gt/intel_mocs.c       | 14 +++++-
 drivers/gpu/drm/i915/gt/intel_rps.c        |  4 ++
 drivers/gpu/drm/i915/gt/shmem_utils.c      |  7 ++-
 drivers/gpu/drm/omapdrm/dss/sdi.c          | 10 ++---
 drivers/i2c/busses/i2c-imx.c               | 44 ++++++++++++++----
 drivers/i2c/busses/i2c-qcom-cci.c          |  4 +-
 drivers/i2c/busses/i2c-qup.c               |  3 +-
 drivers/input/serio/i8042.c                |  3 +-
 drivers/iommu/amd/amd_iommu_types.h        |  2 +-
 drivers/md/dm-writecache.c                 |  6 ++-
 drivers/md/dm.c                            | 10 ++---
 drivers/net/wireless/realtek/rtw88/debug.c |  2 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c         |  2 +-
 drivers/thunderbolt/icm.c                  | 10 +++--
 drivers/tty/tty_io.c                       |  7 ++-
 drivers/tty/tty_jobctrl.c                  | 44 ++++++++++++------
 drivers/usb/gadget/function/f_fs.c         |  6 ++-
 drivers/usb/serial/ch341.c                 |  5 ++-
 drivers/usb/serial/kl5kusb105.c            | 10 ++---
 drivers/usb/serial/option.c                | 10 +++--
 fs/cifs/connect.c                          |  5 ++-
 fs/cifs/smb2pdu.c                          | 71 +++++++++++++++--------------
 fs/cifs/smb2pdu.h                          |  2 -
 fs/cifs/transport.c                        |  4 +-
 fs/coredump.c                              |  3 +-
 fs/gfs2/glops.c                            |  5 ++-
 fs/gfs2/inode.c                            | 42 ++++++++++++-----
 fs/gfs2/rgrp.c                             |  4 ++
 fs/io_uring.c                              |  3 +-
 include/linux/irqdomain.h                  | 12 ++++-
 include/linux/tty.h                        |  4 ++
 include/net/netfilter/nf_tables_offload.h  |  7 +++
 kernel/irq/irqdomain.c                     | 13 +++---
 kernel/trace/Kconfig                       |  2 +-
 kernel/trace/ftrace.c                      | 22 ++++++++-
 kernel/trace/ring_buffer.c                 | 20 ++++-----
 kernel/trace/trace.c                       | 13 +++---
 lib/syscall.c                              | 11 ++++-
 mm/hugetlb_cgroup.c                        |  8 ++--
 mm/list_lru.c                              | 10 ++---
 mm/slab.h                                  | 42 ++++++++++-------
 mm/swapfile.c                              |  4 +-
 net/can/af_can.c                           |  7 ++-
 net/netfilter/ipset/ip_set_core.c          |  3 +-
 net/netfilter/nf_tables_api.c              |  3 +-
 net/netfilter/nf_tables_offload.c          | 17 +++++++
 net/netfilter/nft_cmp.c                    |  8 ++--
 net/netfilter/nft_meta.c                   | 16 +++----
 net/netfilter/nft_payload.c                | 70 ++++++++++++++++++++++-------
 net/tipc/core.c                            |  9 ++--
 net/tipc/core.h                            |  8 ++++
 net/tipc/net.c                             | 20 +++------
 net/tipc/net.h                             |  1 +
 sound/pci/hda/hda_generic.c                | 12 +++--
 sound/pci/hda/hda_generic.h                |  1 +
 sound/pci/hda/patch_realtek.c              | 72 +++++++++++++++++++++++++++---
 sound/soc/codecs/wm_adsp.c                 |  1 +
 tools/arch/x86/include/asm/insn.h          | 15 +++++++
 69 files changed, 633 insertions(+), 272 deletions(-)


