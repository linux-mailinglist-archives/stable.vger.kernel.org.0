Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E189E202
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfH0HzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbfH0HzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:55:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE342173E;
        Tue, 27 Aug 2019 07:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892500;
        bh=ecQ2Mdgrnu91YiD8rxeRaTa4X/H3kDWc7NKlJgIbR8w=;
        h=From:To:Cc:Subject:Date:From;
        b=tJEW+2VGMnI3Eu5vqwmZzNFLqKy3gguh66pDz/M0NPLROL8a/a1MzJKAqC/7DPGMv
         Ek1gjMChccr/tL7SJziIDB/JcrbwmtNmZhYbOrE7EBFCaiA5x1Y8OfkZOM8UP9MF01
         4R1AbTXhCULvqVc3A+THwXhOi6+1GJTcbYNa5i3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/98] 4.19.69-stable review
Date:   Tue, 27 Aug 2019 09:49:39 +0200
Message-Id: <20190827072718.142728620@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.69-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.69-rc1
X-KernelTest-Deadline: 2019-08-29T07:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.69 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.69-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.69-rc1

David Howells <dhowells@redhat.com>
    rxrpc: Fix read-after-free in rxrpc_queue_local()

David Howells <dhowells@redhat.com>
    rxrpc: Fix local endpoint refcounting

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB

Dan Carpenter <dan.carpenter@oracle.com>
    dm zoned: fix potential NULL dereference in dmz_do_reclaim()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: always rejoin held resources during defer roll

Allison Henderson <allison.henderson@oracle.com>
    xfs: Add attibute remove and helper functions

Allison Henderson <allison.henderson@oracle.com>
    xfs: Add attibute set and helper functions

Allison Henderson <allison.henderson@oracle.com>
    xfs: Add helper function xfs_attr_try_sf_addname

Allison Henderson <allison.henderson@oracle.com>
    xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h

Brian Foster <bfoster@redhat.com>
    xfs: don't trip over uninitialized buffer on extent read of corrupted inode

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to EDQUOT

Henry Burns <henryburns@google.com>
    mm/zsmalloc.c: fix race condition in zs_destroy_pool

Henry Burns <henryburns@google.com>
    mm/zsmalloc.c: migration can leave pages in ZS_EMPTY indefinitely

Vlastimil Babka <vbabka@suse.cz>
    mm, page_owner: handle THP splits correctly

Michael Kelley <mikelley@microsoft.com>
    genirq: Properly pair kobject_del() with kobject_add()

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: properly handle backing device failure

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: improve error handling in i/o map code

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: improve error handling in reclaim

Mikulas Patocka <mpatocka@redhat.com>
    dm table: fix invalid memory accesses with too high sector number

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm space map metadata: fix missing store of apply_bops() return value

Wenwen Wang <wenwen@cs.uga.edu>
    dm raid: add missing cleanup in raid_ctr()

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a crash due to BUG_ON in __journal_read_write()

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm btree: fix order of block initialization in btree_split_beneath

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm kcopyd: always complete failed jobs

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Fix boot regression caused by bootparam sanitizing

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Save fields explicitly, zero out everything else

Tom Lendacky <thomas.lendacky@amd.com>
    x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Handle missing global clockevent gracefully

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Oleg Nesterov <oleg@redhat.com>
    userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: never report open-drain/source lines as 'input' to user-space

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't retry infinitely when receiving no data on i2c over AUX

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix PG split vs OSD (re)connect race

Jeff Layton <jlayton@kernel.org>
    ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Erqi Chen <chenerqi@gmail.com>
    ceph: clear page dirty before invalidate page

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: stratix10: fix rate caclulationg for cnt_clks

Mikulas Patocka <mpatocka@redhat.com>
    Revert "dm bufio: fix deadlock with loop device"

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct misreported EKR ring values

Naresh Kamboju <naresh.kamboju () linaro ! org>
    selftests: kvm: Adding config fragments

Marc Zyngier <maz@kernel.org>
    KVM: arm: Don't write junk to CP15 registers on reset

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't write junk to sysregs on reset

Jin Yao <yao.jin@linux.intel.com>
    perf pmu-events: Fix missing "cpu_clk_unhalted.core" event

He Zhe <zhe.he@windriver.com>
    perf cpumap: Fix writing to illegal memory in handling cpumap mask

He Zhe <zhe.he@windriver.com>
    perf ftrace: Fix failure to set cpumask when only one cpu is present

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: handle NULL return value by bfq_init_rq()

Colin Ian King <colin.king@canonical.com>
    drm/vmwgfx: fix memory leak when too many retries have occurred

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    x86/lib/cpu: Address missing prototypes warning

Jens Axboe <axboe@kernel.dk>
    libata: add SG safety checks in SFF pio transfers

Jens Axboe <axboe@kernel.dk>
    libata: have ata_scsi_rw_xlat() fail invalid passthrough requests

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix dma_map_single failed on arm64

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: fix hip04-xmit never return TX_BUSY

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: make hip04_tx_reclaim non-reentrant

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: tc: Do not return a fragment entry

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Fix issues when number of Queues >= 4

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Vasily Gorbik <gor@linux.ibm.com>
    s390: put _stext and _etext into .text section

Sebastien Tisserant <stisserant@wallix.com>
    SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL

Pavel Shilovsky <pshilov@microsoft.com>
    SMB3: Fix potential memory leak when processing compound chain

Douglas Anderson <dianders@chromium.org>
    drm/rockchip: Suspend DP late

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: input: fix a4tech horizontal wheel custom usage

István Váradi <ivaradi@varadiistvan.hu>
    HID: quirks: Set the INCREMENT_USAGE_ON_DUPLICATE quirk on Saitek X52

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix regression whereby fscache errors are appearing on 'nofsc' mounts

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    net/ethernet/qlogic/qed: force the string buffer NULL-terminated

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: peak_usb: force the string buffer NULL-terminated

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: sja1000: force the string buffer NULL-terminated

Jiri Olsa <jolsa@kernel.org>
    perf bench numa: Fix cpu0 binding

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: phy: phy_led_triggers: Fix a possible null-pointer dereference in phy_led_trigger_change_speed()

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

David Howells <dhowells@redhat.com>
    rxrpc: Fix the lack of notification when sendmsg() fails on a DATA packet

David Howells <dhowells@redhat.com>
    rxrpc: Fix potential deadlock

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix rename concurrency with listing

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets

Stefano Brivio <sbrivio@redhat.com>
    netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too

Jia-Ju Bai <baijiaju1990@gmail.com>
    mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_radio_nl()

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()

Michal Kalderon <michal.kalderon@marvell.com>
    qed: RDMA - Fix the hw_ver returned in device attributes

Bob Ham <bob.ham@puri.sm>
    net: usb: qmi_wwan: Add the BroadMobi BM818 card

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Cheng-Yi Chiang <cychiang@chromium.org>
    ASoC: rockchip: Fix mono capture

Navid Emamdoost <navid.emamdoost@gmail.com>
    st_nci_hci_connectivity_event_received: null check the allocation

Navid Emamdoost <navid.emamdoost@gmail.com>
    st21nfca_connectivity_event_received: null check the allocation

Ricard Wanderlof <ricard.wanderlof@axis.com>
    ASoC: Fail card instantiation if DAI format setup fails

YueHaibing <yuehaibing@huawei.com>
    can: gw: Fix error path of cgw_module_init

Weitao Hou <houweitaoo@gmail.com>
    can: mcp251x: add error check when wq alloc failed

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    can: dev: call netif_carrier_off() in register_candev()

Ido Schimmel <idosch@mellanox.com>
    selftests: forwarding: gre_multipath: Fix flower filters

Ido Schimmel <idosch@mellanox.com>
    selftests: forwarding: gre_multipath: Enable IPv4 forwarding

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: Don't check for 3 consecutive Idle frames for 10G links

Thomas Falcon <tlfalcon@linux.ibm.com>
    bonding: Force slave speed check after link state recovery for 802.3ad

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: fix sendmsg6_prog on s390

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks

Wenwen Wang <wenwen@cs.uga.edu>
    netfilter: ebtables: fix a memory leak bug in compat

Vladimir Kondratiev <vladimir.kondratiev@linux.intel.com>
    mips: fix cacheinfo

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: kernel: only use i8253 clocksource with periodic clockevent

Ilya Trukhanov <lahvuun@gmail.com>
    HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 Makefile                                           |   4 +-
 arch/arm/kvm/coproc.c                              |  23 +-
 arch/arm64/kvm/sys_regs.c                          |  32 +--
 arch/mips/kernel/cacheinfo.c                       |   2 +
 arch/mips/kernel/i8253.c                           |   3 +-
 arch/powerpc/kernel/misc_64.S                      |   4 +-
 arch/s390/kernel/vmlinux.lds.S                     |  10 +-
 arch/x86/include/asm/bootparam_utils.h             |  61 ++++--
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/nospec-branch.h               |   2 +-
 arch/x86/kernel/apic/apic.c                        |  68 ++++--
 arch/x86/kernel/cpu/amd.c                          |  66 ++++++
 arch/x86/lib/cpu.c                                 |   1 +
 arch/x86/power/cpu.c                               |  86 ++++++--
 block/bfq-iosched.c                                |  14 +-
 drivers/ata/libata-scsi.c                          |  21 ++
 drivers/ata/libata-sff.c                           |   6 +
 drivers/clk/socfpga/clk-periph-s10.c               |   2 +-
 drivers/gpio/gpiolib.c                             |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  24 ++-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   4 +-
 drivers/hid/hid-a4tech.c                           |  30 ++-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-tmff.c                             |  12 ++
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hv/channel.c                               |   2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  13 +-
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-integrity.c                          |  15 ++
 drivers/md/dm-kcopyd.c                             |   5 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/md/dm-zoned-metadata.c                     |  59 ++++--
 drivers/md/dm-zoned-reclaim.c                      |  44 +++-
 drivers/md/dm-zoned-target.c                       |  67 +++++-
 drivers/md/dm-zoned.h                              |  10 +
 drivers/md/persistent-data/dm-btree.c              |  31 +--
 drivers/md/persistent-data/dm-space-map-metadata.c |   2 +-
 drivers/net/bonding/bond_main.c                    |   9 +
 drivers/net/can/dev.c                              |   2 +
 drivers/net/can/sja1000/peak_pcmcia.c              |   2 +-
 drivers/net/can/spi/mcp251x.c                      |  49 ++---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  28 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 +-
 drivers/net/phy/phy_led_triggers.c                 |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/mac80211_hwsim.c              |   8 +-
 drivers/nfc/st-nci/se.c                            |   2 +
 drivers/nfc/st21nfca/se.c                          |   2 +
 fs/ceph/addr.c                                     |   5 +-
 fs/ceph/locks.c                                    |   3 +-
 fs/cifs/smb2ops.c                                  |  39 ++--
 fs/nfs/fscache.c                                   |   7 +-
 fs/nfs/fscache.h                                   |   2 +-
 fs/nfs/nfs4_fs.h                                   |   3 +-
 fs/nfs/nfs4client.c                                |   5 +-
 fs/nfs/nfs4state.c                                 |  27 ++-
 fs/nfs/super.c                                     |   1 +
 fs/userfaultfd.c                                   |  25 +--
 fs/xfs/libxfs/xfs_attr.c                           | 231 ++++++++++++---------
 fs/xfs/{ => libxfs}/xfs_attr.h                     |   2 +
 fs/xfs/libxfs/xfs_bmap.c                           |  54 +++--
 fs/xfs/libxfs/xfs_bmap.h                           |   1 +
 fs/xfs/libxfs/xfs_defer.c                          |  14 +-
 fs/xfs/xfs_dquot.c                                 |  17 +-
 fs/xfs/xfs_iops.c                                  |   1 +
 include/trace/events/rxrpc.h                       |   6 +-
 kernel/irq/irqdesc.c                               |  15 +-
 mm/huge_memory.c                                   |   4 +
 mm/zsmalloc.c                                      |  78 ++++++-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/can/gw.c                                       |  48 +++--
 net/ceph/osd_client.c                              |   9 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c            |   6 +-
 net/rxrpc/af_rxrpc.c                               |   4 +-
 net/rxrpc/ar-internal.h                            |   6 +-
 net/rxrpc/input.c                                  |  16 +-
 net/rxrpc/local_object.c                           | 101 +++++----
 net/rxrpc/peer_event.c                             |   2 +-
 net/rxrpc/peer_object.c                            |  18 ++
 net/rxrpc/sendmsg.c                                |   1 +
 sound/soc/davinci/davinci-mcasp.c                  |  43 +++-
 sound/soc/rockchip/rockchip_i2s.c                  |   5 +-
 sound/soc/soc-core.c                               |   7 +-
 sound/soc/soc-dapm.c                               |   8 +-
 tools/perf/bench/numa.c                            |   6 +-
 tools/perf/builtin-ftrace.c                        |   2 +-
 tools/perf/pmu-events/jevents.c                    |   1 +
 tools/perf/util/cpumap.c                           |   5 +-
 tools/testing/selftests/bpf/sendmsg6_prog.c        |   3 +-
 tools/testing/selftests/kvm/config                 |   3 +
 .../selftests/net/forwarding/gre_multipath.sh      |  28 +--
 104 files changed, 1265 insertions(+), 494 deletions(-)


