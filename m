Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137469DF2E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfH0Hv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbfH0Hv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3780206BA;
        Tue, 27 Aug 2019 07:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892318;
        bh=Y9ILVXIMzgjqrq+xarn3TVmEPLP02P6RuqmzV05ZWVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=14TJvuYSUY3TnuQWSHGxyJzzyto2JpyK0XMR64ECiY55EOczoaj5nLU+xZY8mxluT
         3LeWwaU/LfntbvHHFe3TzizYDSXLSQsq+4rdrLO5lPSSggpOd27BSajGEZPmLXMa4U
         AzBV/ESBcFAhLJfGAynGGuL2z9FxZwOR8rP/cMGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/62] 4.14.141-stable review
Date:   Tue, 27 Aug 2019 09:50:05 +0200
Message-Id: <20190827072659.803647352@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.141-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.141-rc1
X-KernelTest-Deadline: 2019-08-29T07:27+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.141 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.141-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.141-rc1

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB

Dan Carpenter <dan.carpenter@oracle.com>
    dm zoned: fix potential NULL dereference in dmz_do_reclaim()

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

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: never report open-drain/source lines as 'input' to user-space

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't retry infinitely when receiving no data on i2c over AUX

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix PG split vs OSD (re)connect race

Jeff Layton <jlayton@kernel.org>
    ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Mikulas Patocka <mpatocka@redhat.com>
    Revert "dm bufio: fix deadlock with loop device"

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Correct distance scale for 2nd-gen Intuos devices

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct misreported EKR ring values

Naresh Kamboju <naresh.kamboju () linaro ! org>
    selftests: kvm: Adding config fragments

Jin Yao <yao.jin@linux.intel.com>
    perf pmu-events: Fix missing "cpu_clk_unhalted.core" event

He Zhe <zhe.he@windriver.com>
    perf cpumap: Fix writing to illegal memory in handling cpumap mask

He Zhe <zhe.he@windriver.com>
    perf ftrace: Fix failure to set cpumask when only one cpu is present

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Sebastien Tisserant <stisserant@wallix.com>
    SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: input: fix a4tech horizontal wheel custom usage

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

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix rename concurrency with listing

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()

Michal Kalderon <michal.kalderon@marvell.com>
    qed: RDMA - Fix the hw_ver returned in device attributes

Bob Ham <bob.ham@puri.sm>
    net: usb: qmi_wwan: Add the BroadMobi BM818 card

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Navid Emamdoost <navid.emamdoost@gmail.com>
    st_nci_hci_connectivity_event_received: null check the allocation

Navid Emamdoost <navid.emamdoost@gmail.com>
    st21nfca_connectivity_event_received: null check the allocation

Ricard Wanderlof <ricard.wanderlof@axis.com>
    ASoC: Fail card instantiation if DAI format setup fails

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    can: dev: call netif_carrier_off() in register_candev()

Thomas Falcon <tlfalcon@linux.ibm.com>
    bonding: Force slave speed check after link state recovery for 802.3ad

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

 Documentation/admin-guide/kernel-parameters.txt    |  7 ++
 Makefile                                           |  4 +-
 arch/mips/kernel/cacheinfo.c                       |  2 +
 arch/mips/kernel/i8253.c                           |  3 +-
 arch/powerpc/kernel/misc_64.S                      |  4 +-
 arch/x86/include/asm/bootparam_utils.h             | 61 +++++++++++----
 arch/x86/include/asm/msr-index.h                   |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/kernel/apic/apic.c                        | 68 +++++++++++++----
 arch/x86/kernel/cpu/amd.c                          | 66 +++++++++++++++++
 arch/x86/lib/cpu.c                                 |  1 +
 arch/x86/power/cpu.c                               | 86 ++++++++++++++++++----
 drivers/ata/libata-scsi.c                          | 21 ++++++
 drivers/ata/libata-sff.c                           |  6 ++
 drivers/gpio/gpiolib.c                             |  6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      | 24 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |  4 +-
 drivers/hid/hid-a4tech.c                           | 30 +++++++-
 drivers/hid/hid-tmff.c                             | 12 +++
 drivers/hid/wacom_wac.c                            |  4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              | 13 +++-
 drivers/md/dm-bufio.c                              |  4 +-
 drivers/md/dm-kcopyd.c                             |  5 +-
 drivers/md/dm-table.c                              |  5 +-
 drivers/md/dm-zoned-metadata.c                     | 59 +++++++++++----
 drivers/md/dm-zoned-reclaim.c                      | 44 ++++++++---
 drivers/md/dm-zoned-target.c                       | 67 +++++++++++++++--
 drivers/md/dm-zoned.h                              | 10 +++
 drivers/md/persistent-data/dm-btree.c              | 31 ++++----
 drivers/md/persistent-data/dm-space-map-metadata.c |  2 +-
 drivers/net/bonding/bond_main.c                    |  9 +++
 drivers/net/can/dev.c                              |  2 +
 drivers/net/can/sja1000/peak_pcmcia.c              |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         | 28 ++++---
 drivers/net/ethernet/qlogic/qed/qed_int.c          |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |  2 +-
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/nfc/st-nci/se.c                            |  2 +
 drivers/nfc/st21nfca/se.c                          |  2 +
 fs/ceph/locks.c                                    |  3 +-
 fs/cifs/smb2ops.c                                  | 10 ++-
 fs/nfs/nfs4_fs.h                                   |  3 +-
 fs/nfs/nfs4client.c                                |  5 +-
 fs/nfs/nfs4state.c                                 | 27 +++++--
 fs/userfaultfd.c                                   | 25 ++++---
 fs/xfs/xfs_iops.c                                  |  1 +
 kernel/irq/irqdesc.c                               | 15 +++-
 mm/huge_memory.c                                   |  4 +
 mm/zsmalloc.c                                      | 78 ++++++++++++++++++--
 net/bridge/netfilter/ebtables.c                    |  4 +-
 net/ceph/osd_client.c                              |  9 +--
 net/netfilter/ipset/ip_set_core.c                  |  2 +-
 sound/soc/davinci/davinci-mcasp.c                  | 43 ++++++++---
 sound/soc/soc-core.c                               |  7 +-
 sound/soc/soc-dapm.c                               |  8 +-
 tools/perf/bench/numa.c                            |  6 +-
 tools/perf/builtin-ftrace.c                        |  2 +-
 tools/perf/pmu-events/jevents.c                    |  1 +
 tools/perf/util/cpumap.c                           |  5 +-
 tools/testing/selftests/kvm/config                 |  3 +
 62 files changed, 786 insertions(+), 184 deletions(-)


