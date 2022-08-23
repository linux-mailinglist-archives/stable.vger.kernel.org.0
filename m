Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B020659D370
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbiHWIHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240461AbiHWIGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FFC6B15D;
        Tue, 23 Aug 2022 01:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 514CE61219;
        Tue, 23 Aug 2022 08:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A36C433D7;
        Tue, 23 Aug 2022 08:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241873;
        bh=iExwPztNjg6VwHc1XhCygvt9vMAuw2FhAtfSzjqAUNY=;
        h=From:To:Cc:Subject:Date:From;
        b=bWJuN+qTsO3k1nKvZzJDXkSn8DXQjBh97MGsly98MGFsPMveG0/ZurfdI+mxTy1s2
         crMLgrrodXqDvL1MioiBq2x9nQ9imgGE08H+HmKej+EiawN0dUEEuj+hi6cw0RFHqp
         m53SYigjMak+/4yQ3Qb65zDkF2BThN2D2phL6N1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 000/101] 4.9.326-rc1 review
Date:   Tue, 23 Aug 2022 10:02:33 +0200
Message-Id: <20220823080034.579196046@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.326-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.326-rc1
X-KernelTest-Deadline: 2022-08-25T08:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.326 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.326-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.326-rc1

Nathan Chancellor <nathan@kernel.org>
    MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhouyi Zhou <zhouzhouyi@gmail.com>
    powerpc/64: Init jump labels before parse_early_param()

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add async signal helpers

Liang He <windhl@126.com>
    mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Schspa Shi <schspa@gmail.com>
    vfio: Clear the caps->buf to NULL after free

Liang He <windhl@126.com>
    tty: serial: Fix refcount leak bug in ucc_uart.c

Kiselev, Oleg <okiselev@amazon.com>
    ext4: avoid resizing to a partial cluster size

Ye Bin <yebin10@huawei.com>
    ext4: avoid remove directory when directory is corrupted

Wentao_Liang <Wentao_Liang_g@163.com>
    drivers:md:fix a potential use-after-free bug

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cxl: Fix a memory leak in an error handling path

Jozef Martiniak <jomajm@gmail.com>
    gadgetfs: ep_io - wait until IRQ finishes

Liang He <windhl@126.com>
    usb: host: ohci-ppc-of: Fix refcount leak bug

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    irqchip/tegra: Fix overflow implicit truncation warnings

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: clear LDFLAGS in the top Makefile

Csókás Bence <csokas.bence@prolan.hu>
    fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: really skip inactive sets when allocating name

Al Viro <viro@zeniv.linux.org.uk>
    nios2: add force_successful_syscall_return()

Al Viro <viro@zeniv.linux.org.uk>
    nios2: restarts apply only to the first sigframe we build...

Al Viro <viro@zeniv.linux.org.uk>
    nios2: fix syscall restart checks

Al Viro <viro@zeniv.linux.org.uk>
    nios2: traced syscall does need to check the syscall number

Al Viro <viro@zeniv.linux.org.uk>
    nios2: don't leave NULLs in sys_call_table[]

Al Viro <viro@zeniv.linux.org.uk>
    nios2: page fault et.al. are *not* restartable syscalls...

Duoming Zhou <duoming@zju.edu.cn>
    atm: idt77252: fix use-after-free bugs caused by tst_timer

Dan Carpenter <dan.carpenter@oracle.com>
    xen/xenbus: fix return type in xenbus_file_read()

Peilin Ye <peilin.ye@bytedance.com>
    vsock: Fix memory leak in vsock_connect()

Nikita Travkin <nikita@trvn.ru>
    pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Reinitialise the backchannel request buffers before reuse

Zhang Xianwei <zhang.xianwei8@zte.com.cn>
    NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: fix clang's -Wunaligned-access warning

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when looking up extended ref on log replay

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata-eh: Add missing command name

Mikulas Patocka <mpatocka@redhat.com>
    rds: add missing barrier to release_refill

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: info: Fix llseek return value when using callback

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: cls_route: disallow handle of 0

Tyler Hicks <tyhicks@linux.microsoft.com>
    net/9p: Initialize the iounit field during fid creation

Guenter Roeck <linux@roeck-us.net>
    nios2: time: Read timer in get_cycles only if initialized

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Jose Alonso <joalonsof@gmail.com>
    Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Tony Battersby <tonyb@cybernetics.com>
    scsi: sg: Allow waiting for commands to complete on removed device

Eric Dumazet <edumazet@google.com>
    tcp: fix over estimation in sk_forced_mem_schedule()

Qu Wenruo <wqu@suse.com>
    btrfs: reject log replay if there is unsupported RO compat flag

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    net_sched: cls_route: remove from list when handle is 0

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_status

Baokun Li <libaokun1@huawei.com>
    ext4: correct max_inline_xattr_value_size computing

Eric Whitney <enwlinux@gmail.com>
    ext4: fix extent status tree race in writeback error recovery path

Theodore Ts'o <tytso@mit.edu>
    ext4: update s_overhead_clusters in the superblock during an on-line resize

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_xattr_set_entry

Lukas Czerner <lczerner@redhat.com>
    ext4: make sure ext4_append() always allocates new block

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h

David Collins <quic_collinsd@quicinc.com>
    spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

Alexander Lobakin <alexandr.lobakin@intel.com>
    x86/olpc: fix 'logical not is only applied to the left hand side'

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix missing auto port scan and thus missing target ports

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix null deref due to zeroed list head

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: HCD: Fix URB giveback issue in tasklet function

Huacai Chen <chenhuacai@loongson.cn>
    MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Avoid crashing if rng is NULL

Pali Rohár <pali@kernel.org>
    powerpc/fsl-pci: Fix Class Code of PCIe Root Port

Pali Rohár <pali@kernel.org>
    PCI: Add defines for normal and subtractive PCI bridges

Alexander Lobakin <alexandr.lobakin@intel.com>
    ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()

Mikulas Patocka <mpatocka@redhat.com>
    md-raid10: fix KASAN warning

Miklos Szeredi <mszeredi@redhat.com>
    fuse: limit nsec

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix overflow in prog accounting

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix another off-by-one in nvbios_addr

Helge Deller <deller@gmx.de>
    parisc: Fix device names in /proc/iomem

Lukas Wunner <lukas@wunner.de>
    usbnet: Fix linkwatch use-after-free on disconnect

David Howells <dhowells@redhat.com>
    vfs: Check the truncate maximum size in inode_newsize_ok()

Allen Ballway <ballway@chromium.org>
    ALSA: hda/cirrus - support for iMac 12,1 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Sean Christopherson <seanjc@google.com>
    KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Mikulas Patocka <mpatocka@redhat.com>
    add barriers to buffer_uptodate and set_buffer_uptodate

Zheyu Ma <zheyuma97@gmail.com>
    ALSA: bcd2000: Fix a UAF bug on the error path of probing

Nick Desaulniers <ndesaulniers@google.com>
    x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nick Desaulniers <ndesaulniers@google.com>
    Makefile: link with -z noexecstack --no-warn-rwx-segments

Ning Qiang <sohu0106@126.com>
    macintosh/adb: fix oob read in do_adb_query() function

Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
    random: only call boot_init_stack_canary() once

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for some TongFang devices

Daniel Micay <danielmicay@gmail.com>
    init/main.c: extract early boot entropy from the passed cmdline

Laura Abbott <lauraa@codeaurora.org>
    init: move stack canary initialization after setup_arch

Viresh Kumar <viresh.kumar@linaro.org>
    init/main: properly align the multi-line comment

Viresh Kumar <viresh.kumar@linaro.org>
    init/main: Fix double "the" in comment

Christian Borntraeger <borntraeger@de.ibm.com>
    include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

Paul Moore <paul@paul-moore.com>
    selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Tianyue Ren <rentianyue@kylinos.cn>
    selinux: fix error initialization in inode_doinit_with_dentry()

Andreas Gruenbacher <agruenba@redhat.com>
    selinux: Convert isec->lock into a spinlock

Andreas Gruenbacher <agruenba@redhat.com>
    selinux: Clean up initialization of isec->sclass

Andreas Gruenbacher <agruenba@redhat.com>
    proc: Pass file mode to proc_pid_make_inode

Andreas Gruenbacher <agruenba@redhat.com>
    selinux: Minor cleanups

Nathan Chancellor <nathan@kernel.org>
    ion: Make user_ion_handle_put_nolock() a void function

Wei Mingzhi <whistler@member.fsf.org>
    mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ARM: crypto: comment out gcc warning that breaks clang builds

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: do not allow packet truncation below transport header offset

Liang He <windhl@126.com>
    net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: ping6: Fix memleak in ipv6_renew_options().

Liang He <windhl@126.com>
    scsi: ufs: host: Hold reference returned by of_parse_phandle()

ChenXiaoSong <chenxiaosong2@huawei.com>
    ntfs: fix use-after-free in ntfs_ucsncmp()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put


-------------

Diffstat:

 Makefile                                        |   8 +-
 arch/arm/lib/xor-neon.c                         |   3 +-
 arch/ia64/include/asm/processor.h               |   2 +-
 arch/mips/cavium-octeon/octeon-platform.c       |   3 +-
 arch/mips/kernel/proc.c                         |   2 +-
 arch/mips/mm/tlbex.c                            |   4 +-
 arch/nios2/include/asm/entry.h                  |   3 +-
 arch/nios2/include/asm/ptrace.h                 |   2 +
 arch/nios2/kernel/entry.S                       |  22 +++--
 arch/nios2/kernel/signal.c                      |   3 +-
 arch/nios2/kernel/syscall_table.c               |   1 +
 arch/nios2/kernel/time.c                        |   5 +-
 arch/parisc/kernel/drivers.c                    |   9 +-
 arch/powerpc/kernel/prom.c                      |   7 ++
 arch/powerpc/platforms/powernv/rng.c            |   2 +
 arch/powerpc/sysdev/fsl_pci.c                   |   8 ++
 arch/powerpc/sysdev/fsl_pci.h                   |   1 +
 arch/x86/boot/Makefile                          |   2 +-
 arch/x86/boot/compressed/Makefile               |   4 +
 arch/x86/entry/vdso/Makefile                    |   2 +-
 arch/x86/kvm/emulate.c                          |  19 ++--
 arch/x86/kvm/svm.c                              |   2 -
 arch/x86/platform/olpc/olpc-xo1-sci.c           |   2 +-
 drivers/acpi/video_detect.c                     |  55 +++++++----
 drivers/ata/libata-eh.c                         |   1 +
 drivers/atm/idt77252.c                          |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |   2 +-
 drivers/irqchip/irq-tegra.c                     |  10 +-
 drivers/macintosh/adb.c                         |   2 +-
 drivers/md/dm-raid.c                            |   2 +-
 drivers/md/raid10.c                             |   5 +-
 drivers/md/raid5.c                              |   2 +-
 drivers/misc/cxl/irq.c                          |   1 +
 drivers/net/can/usb/ems_usb.c                   |   2 +-
 drivers/net/ethernet/freescale/fec_ptp.c        |   6 +-
 drivers/net/sungem_phy.c                        |   1 +
 drivers/net/usb/ax88179_178a.c                  |  14 +--
 drivers/net/usb/usbnet.c                        |   8 +-
 drivers/net/wireless/mediatek/mt7601u/usb.c     |   1 +
 drivers/pinctrl/nomadik/pinctrl-nomadik.c       |   4 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c          |   4 +-
 drivers/s390/scsi/zfcp_fc.c                     |  29 ++++--
 drivers/s390/scsi/zfcp_fc.h                     |   6 +-
 drivers/s390/scsi/zfcp_fsf.c                    |   4 +-
 drivers/scsi/sg.c                               |  57 ++++++-----
 drivers/scsi/ufs/ufshcd-pltfrm.c                |  15 ++-
 drivers/staging/android/ion/ion-ioctl.c         |   8 +-
 drivers/tty/serial/ucc_uart.c                   |   2 +
 drivers/usb/core/hcd.c                          |  26 ++---
 drivers/usb/gadget/legacy/inode.c               |   1 +
 drivers/usb/host/ohci-ppc-of.c                  |   1 +
 drivers/vfio/vfio.c                             |   1 +
 drivers/video/fbdev/i740fb.c                    |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c        |   4 +-
 fs/attr.c                                       |   2 +
 fs/btrfs/disk-io.c                              |  14 +++
 fs/btrfs/tree-log.c                             |   4 +-
 fs/ext4/inline.c                                |   3 +
 fs/ext4/inode.c                                 |   7 ++
 fs/ext4/namei.c                                 |  23 ++++-
 fs/ext4/resize.c                                |  11 +++
 fs/ext4/xattr.c                                 |   6 +-
 fs/ext4/xattr.h                                 |  13 +++
 fs/fuse/inode.c                                 |   6 ++
 fs/nfs/nfs4proc.c                               |   3 +
 fs/ntfs/attrib.c                                |   8 +-
 fs/proc/base.c                                  |  23 ++---
 fs/proc/fd.c                                    |   6 +-
 fs/proc/internal.h                              |   2 +-
 fs/proc/namespaces.c                            |   3 +-
 include/linux/bpf.h                             |  11 +++
 include/linux/buffer_head.h                     |  25 ++++-
 include/linux/pci_ids.h                         |   2 +
 include/linux/usb/hcd.h                         |   1 +
 include/net/bluetooth/l2cap.h                   |   1 +
 include/sound/core.h                            |   8 ++
 include/trace/events/spmi.h                     |  12 +--
 include/uapi/linux/swab.h                       |   4 +-
 init/main.c                                     |  14 +--
 kernel/bpf/core.c                               |  16 ++-
 kernel/bpf/syscall.c                            |  36 +++++--
 net/9p/client.c                                 |   4 +-
 net/bluetooth/l2cap_core.c                      |  68 +++++++++----
 net/ipv4/tcp_output.c                           |   7 +-
 net/ipv6/ping.c                                 |   6 ++
 net/netfilter/nf_tables_api.c                   |   3 +-
 net/netfilter/nfnetlink_queue.c                 |   7 +-
 net/rds/ib_recv.c                               |   1 +
 net/sched/cls_route.c                           |   8 +-
 net/sunrpc/backchannel_rqst.c                   |  14 +++
 net/vmw_vsock/af_vsock.c                        |   9 +-
 security/selinux/hooks.c                        | 123 +++++++++++++++---------
 security/selinux/include/objsec.h               |   5 +-
 security/selinux/selinuxfs.c                    |   4 +-
 sound/core/info.c                               |   6 +-
 sound/core/misc.c                               |  94 ++++++++++++++++++
 sound/core/timer.c                              |  11 ++-
 sound/pci/hda/patch_cirrus.c                    |   1 +
 sound/pci/hda/patch_conexant.c                  |  11 ++-
 sound/usb/bcd2000/bcd2000.c                     |   3 +-
 100 files changed, 753 insertions(+), 296 deletions(-)


