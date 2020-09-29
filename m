Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16927C33B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgI2LD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbgI2LD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:03:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56AA120C09;
        Tue, 29 Sep 2020 11:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377435;
        bh=+/vYeXi+jKi0J0jX5WnoOiPR+e5WyHyUbZzMFobPq2c=;
        h=From:To:Cc:Subject:Date:From;
        b=snzLyCiFyoD9QBqqLFAFVVHhbngwajzuAnF2BBcSBYzyizk1U4NW0fXTVoQcPXLGc
         PFljtdJp+BpXCJvraJIRjUqxd9/+9TGnH0ubegoTS7OmrSvbBrSzSt2RzCK1mjDup4
         QPcNrKGCmJC9tMVN7eZymKXRJiaM7RByZUIEwJJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/85] 4.4.238-rc1 review
Date:   Tue, 29 Sep 2020 12:59:27 +0200
Message-Id: <20200929105928.198942536@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.238-rc1
X-KernelTest-Deadline: 2020-10-01T10:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.238 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.238-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.238-rc1

Jiri Slaby <jslaby@suse.cz>
    ata: sata_mv, avoid trigerrable BUG_ON

Jiri Slaby <jslaby@suse.cz>
    ata: make qc_prep return ata_completion_errors

Jiri Slaby <jslaby@suse.cz>
    ata: define AC_ERR_OK

Nick Desaulniers <ndesaulniers@google.com>
    lib/string.c: implement stpcpy

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Jiri Slaby <jslaby@suse.cz>
    tty: vt, consw->con_scrolldelta cleanup

Wei Li <liwei391@huawei.com>
    MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Tom Rix <trix@redhat.com>
    ALSA: asihpi: fix iounmap in error handler

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast/TT: fix wrongly dropped or rerouted packets

Jing Xiangfeng <jingxiangfeng@huawei.com>
    atm: eni: fix the missed pci_disable_device() for eni_init_one()

Linus Lüssing <ll@simonwunderlich.de>
    batman-adv: bla: fix type misuse for backbone_gw hash indexing

Maximilian Luz <luzmaximilian@gmail.com>
    mwifiex: Increase AES key storage size to 256 bits

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/init: add missing __init annotations

Zeng Tao <prime.zeng@hisilicon.com>
    vfio/pci: fix racy on error and request eventfd ctx

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Clear error and request eventfd ctx after releasing

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline

Boris Brezillon <boris.brezillon@collabora.com>
    mtd: parser: cmdline: Support MTD names containing one or more colons

Jeff Layton <jlayton@kernel.org>
    ceph: fix potential race in ceph_check_caps

Dinghao Liu <dinghao.liu@zju.edu.cn>
    mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Fix module map when there are no modules loaded

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks of eventfd ctx

Shreyas Joshi <shreyas.joshi@biamp.com>
    printk: handle blank console arguments passed in.

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    e1000: Do not perform reset in reset_task if we are already down

Colin Ian King <colin.king@canonical.com>
    USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't check refcount after stealing page

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential race in unsol event handler

Jonathan Bakker <xc-racer2@live.ca>
    tty: serial: samsung: Correct clock selection logic

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Sonny Sasaka <sonnysasaka@chromium.org>
    Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Jonathan Bakker <xc-racer2@live.ca>
    phy: samsung: s5pv210-usb2: Add delay after reset

Cong Wang <xiyou.wangcong@gmail.com>
    atm: fix a memory leak of vcc->user_back

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: char: tlclk.c: Avoid data race between init and interrupt handler

Douglas Anderson <dianders@chromium.org>
    bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Steve Rutherford <srutherford@google.com>
    KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Jaewon Kim <jaewon31.kim@samsung.com>
    mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

Xianting Tian <xianting_tian@126.com>
    mm/filemap.c: clear page error before actual read

Andreas Steinmetz <ast@domdv.de>
    ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Liu Song <liu.song11@zte.com.cn>
    ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Peter Ujfalusi <peter.ujfalusi@ti.com>
    serial: 8250_omap: Fix sleeping function called from invalid context during probe

Nathan Chancellor <natechancellor@gmail.com>
    tracing: Use address-of operator on section symbols

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Wait for buffer to be set before proceeding

Colin Ian King <colin.king@canonical.com>
    media: tda10071: fix unsigned sign extension overflow

Howard Chung <howardchung@google.com>
    Bluetooth: L2CAP: handle l2cap config request during open state

John Clements <john.clements@amd.com>
    drm/amdgpu: increase atombios cmd timeout

Alain Michaud <alainm@chromium.org>
    Bluetooth: guard against controllers sending zero'd events

Takashi Iwai <tiwai@suse.de>
    media: go7007: Fix URB type for interrupt handling

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Wen Yang <wen.yang99@zte.com.cn>
    drm/omap: fix possible object reference leak

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix RQ buffer leakage when no IOCBs available

Vasily Averin <vvs@virtuozzo.com>
    selinux: sel_avc_get_stat_idx should increase position index

Steve Grubb <sgrubb@redhat.com>
    audit: CONFIG_CHANGE don't log internal bookkeeping as an event

Qian Cai <cai@lca.pw>
    skbuff: fix a data race in skb_queue_len()

Hillf Danton <hdanton@sina.com>
    Bluetooth: prefetch channel before killing sock

Steven Price <steven.price@arm.com>
    mm: pagewalk: fix termination condition in walk_pte_range()

Manish Mandlik <mmandlik@google.com>
    Bluetooth: Fix refcount use-after-free issue

Mert Dirik <mertdirik@gmail.com>
    ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Josef Bacik <jbacik@fb.com>
    tracing: Set kernel_stack's caller size properly

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Reference count query handlers under lock

Marco Elver <elver@google.com>
    seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Vasily Averin <vvs@virtuozzo.com>
    rt_cpu_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    neigh_stat_seq_next() should increase position index

Joe Perches <joe@perches.com>
    kernel/sys.c: avoid copying possible padding bytes in copy_to_user

Brian Foster <bfoster@redhat.com>
    xfs: fix attr leaf header freemap.size underflow

Guoju Fang <fangguoju@gmail.com>
    bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Divya Indi <divya.indi@oracle.com>
    tracing: Adding NULL checks for trace_array descriptor pointer

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Protect against NULL call-back function pointer

Hou Tao <houtao1@huawei.com>
    mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix IRQ error handling

Kangjie Lu <kjlu@umn.edu>
    gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Fuqian Huang <huangfq.daxian@gmail.com>
    m68k: q40: Fix info-leak in rtc_ioctl

Balsundar P <balsundar.p@microsemi.com>
    scsi: aacraid: fix illegal IO beyond last LBA

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Avoid error message on reprobe

Wei Wang <weiwan@google.com>
    ip: fix tos reflection in ack and reset packets

Eric Dumazet <edumazet@google.com>
    net: add __must_check to skb_put_padto()

Xin Long <lucien.xin@gmail.com>
    tipc: use skb_unshare() instead in tipc_buf_append()

Dan Carpenter <dan.carpenter@oracle.com>
    hdlc_ppp: add range checks in ppp_cp_parse_cr()

Ben Hutchings <ben@decadent.org.uk>
    mtd: Fix comparison in map_word_andequal()

Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
    RDMA/ucma: ucma_context reference leak in error path

Chengming Zhou <zhouchengming@bytedance.com>
    ftrace: Setup correct FTRACE_FL_REGS flags for module

Muchun Song <songmuchun@bytedance.com>
    kprobes: fix kill kprobe which has been marked as gone

Rustam Kovhaev <rkovhaev@gmail.com>
    KVM: fix memory leak in kvm_io_bus_unregister_dev()

Mark Salyzyn <salyzyn@android.com>
    af_key: pfkey_dump needs parameter validation


-------------

Diffstat:

 Documentation/DocBook/libata.tmpl                  |  2 +-
 Documentation/devicetree/bindings/sound/wm8994.txt | 18 ++++++++----
 Makefile                                           |  4 +--
 arch/m68k/q40/config.c                             |  1 +
 arch/mips/include/asm/cpu-type.h                   |  1 +
 arch/s390/kernel/setup.c                           |  6 ++--
 arch/x86/include/asm/nospec-branch.h               |  4 +--
 arch/x86/kvm/x86.c                                 | 10 +++++--
 drivers/acpi/ec.c                                  | 16 +++-------
 drivers/ata/acard-ahci.c                           |  6 ++--
 drivers/ata/libahci.c                              |  6 ++--
 drivers/ata/libata-core.c                          |  9 ++++--
 drivers/ata/libata-sff.c                           | 12 +++++---
 drivers/ata/pata_macio.c                           |  6 ++--
 drivers/ata/pata_pxa.c                             |  8 +++--
 drivers/ata/pdc_adma.c                             |  7 +++--
 drivers/ata/sata_fsl.c                             |  4 ++-
 drivers/ata/sata_inic162x.c                        |  4 ++-
 drivers/ata/sata_mv.c                              | 34 ++++++++++++----------
 drivers/ata/sata_nv.c                              | 18 +++++++-----
 drivers/ata/sata_promise.c                         |  6 ++--
 drivers/ata/sata_qstor.c                           |  8 +++--
 drivers/ata/sata_rcar.c                            |  6 ++--
 drivers/ata/sata_sil.c                             |  8 +++--
 drivers/ata/sata_sil24.c                           |  6 ++--
 drivers/ata/sata_sx4.c                             |  6 ++--
 drivers/atm/eni.c                                  |  2 +-
 drivers/char/tlclk.c                               | 17 ++++++-----
 drivers/char/tpm/tpm_ibmvtpm.c                     |  9 ++++++
 drivers/char/tpm/tpm_ibmvtpm.h                     |  1 +
 drivers/devfreq/tegra-devfreq.c                    |  4 ++-
 drivers/dma/tegra20-apb-dma.c                      |  3 +-
 drivers/gpu/drm/amd/amdgpu/atom.c                  |  4 +--
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  2 ++
 drivers/infiniband/core/ucma.c                     |  6 ++--
 drivers/md/bcache/bcache.h                         |  1 +
 drivers/md/bcache/btree.c                          | 12 +++++---
 drivers/md/bcache/super.c                          |  1 +
 drivers/media/dvb-frontends/tda10071.c             |  9 +++---
 drivers/media/usb/go7007/go7007-usb.c              |  4 ++-
 drivers/mfd/mfd-core.c                             | 10 +++++++
 drivers/mtd/chips/cfi_cmdset_0002.c                |  1 -
 drivers/mtd/cmdlinepart.c                          | 23 +++++++++++++--
 drivers/mtd/nand/omap_elm.c                        |  1 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      | 18 +++++++++---
 drivers/net/wan/hdlc_ppp.c                         | 16 ++++++----
 drivers/net/wireless/ath/ar5523/ar5523.c           |  2 ++
 drivers/net/wireless/mwifiex/fw.h                  |  2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |  4 +--
 drivers/phy/phy-s5pv210-usb2.c                     |  4 +++
 drivers/scsi/aacraid/aachba.c                      |  8 ++---
 drivers/scsi/lpfc/lpfc_sli.c                       |  4 +++
 drivers/tty/serial/8250/8250_core.c                | 11 +++++--
 drivers/tty/serial/8250/8250_omap.c                |  2 +-
 drivers/tty/serial/samsung.c                       |  8 ++---
 drivers/tty/vt/vt.c                                |  2 +-
 drivers/usb/host/ehci-mv.c                         |  8 ++---
 drivers/vfio/pci/vfio_pci.c                        | 13 +++++++++
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c  |  4 ++-
 fs/block_dev.c                                     | 10 +++++++
 fs/ceph/caps.c                                     | 14 ++++++++-
 fs/fuse/dev.c                                      |  1 -
 fs/ubifs/io.c                                      | 16 ++++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  4 ++-
 include/linux/libata.h                             | 13 +++++----
 include/linux/mtd/map.h                            |  2 +-
 include/linux/seqlock.h                            | 11 +++++--
 include/linux/skbuff.h                             | 16 ++++++++--
 kernel/audit_watch.c                               |  2 --
 kernel/kprobes.c                                   | 14 +++++++--
 kernel/printk/printk.c                             |  3 ++
 kernel/sys.c                                       |  4 ++-
 kernel/trace/ftrace.c                              |  9 ++++--
 kernel/trace/trace.c                               |  5 +++-
 kernel/trace/trace_entries.h                       |  2 +-
 kernel/trace/trace_events.c                        |  2 ++
 lib/string.c                                       | 24 +++++++++++++++
 mm/filemap.c                                       |  8 +++++
 mm/mmap.c                                          |  2 ++
 mm/pagewalk.c                                      |  4 +--
 net/atm/lec.c                                      |  6 ++++
 net/batman-adv/bridge_loop_avoidance.c             |  7 +++--
 net/batman-adv/routing.c                           |  4 +++
 net/bluetooth/hci_event.c                          | 25 ++++++++++++++--
 net/bluetooth/l2cap_core.c                         | 29 ++++++++++--------
 net/bluetooth/l2cap_sock.c                         | 18 ++++++++++--
 net/core/neighbour.c                               |  1 +
 net/ipv4/ip_output.c                               |  3 +-
 net/ipv4/route.c                                   |  1 +
 net/key/af_key.c                                   |  7 +++++
 net/sunrpc/svc_xprt.c                              | 19 ++++++++----
 net/tipc/msg.c                                     |  3 +-
 net/unix/af_unix.c                                 | 11 +++++--
 security/selinux/selinuxfs.c                       |  1 +
 sound/hda/hdac_bus.c                               |  4 +++
 sound/pci/asihpi/hpioctl.c                         |  4 +--
 sound/soc/kirkwood/kirkwood-dma.c                  |  2 +-
 sound/usb/midi.c                                   | 29 ++++++++++++++----
 tools/perf/util/symbol-elf.c                       |  7 +++++
 virt/kvm/kvm_main.c                                | 21 +++++++------
 100 files changed, 581 insertions(+), 219 deletions(-)


