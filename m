Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E29C91CA
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfJBTIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35222 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728993AbfJBTII (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjym-000355-Va; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjym-0003Zp-OK; Wed, 02 Oct 2019 20:08:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 02 Oct 2019 20:06:50 +0100
Message-ID: <lsq.1570043210.379046399@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/87] 3.16.75-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.75 release.
There are 87 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Oct 04 19:06:50 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (1):
      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
         [a03ff54460817c76105f81f3aa8ef655759ccc9a]

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not
         [c1f7fec1eb6a2c86d01bc22afce772c743451d88]

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event
         [335726195e460cb6b3f795b695bfd31f0ea70ef0]

Andrea Arcangeli (1):
      coredump: fix race condition between collapse_huge_page() and core dumping
         [59ea6d06cfa9247b586a695c21f94afa7183af74]

Andrea Parri (1):
      sbitmap: fix improper use of smp_mb__before_atomic()
         [a0934fd2b1208458e55fc4b48f55889809fce666]

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD
         [7c7da40da1640ce6814dab1e8031b44e19e5a3f6]

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL
         [7aa1bb2ffd84d6b9b5f546b079bb15cd0ab6e76e]

Catalina Mocanu (1):
      staging: iio: cdc: Don't put an else right after a return
         [288903f6b91e759b0a813219acd376426cbb8f14]

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3
         [c5f81656a18b271976a86724dadd8344e54de74e]

Colin Ian King (3):
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
         [c3ea60c231446663afd6ea1054da6b7f830855ca]
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation
         [d0c0d902339249c75da85fd9257a86cbb98dfaa5]
      x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz
         [ea136a112d89bade596314a1ae49f748902f4727]

Coly Li (1):
      bcache: fix stack corruption by PRECEDING_KEY()
         [31b90956b124240aa8c63250243ae1a53585c5e2]

Dan Carpenter (1):
      genwqe: Prevent an integer overflow in the ioctl
         [110080cea0d0e4dfdb0b536e7f8a5633ead6a781]

Dave Martin (1):
      KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
         [df205b5c63281e4f32caac22adda18fd68795e80]

Dmitry Korotin (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.
         [0b24cae4d535045f4c9e177aa228d4e97bad212c]

Eiichi Tsukata (1):
      tracing/snapshot: Resize spare buffer if size changed
         [46cc0b44428d0f0e81f11ea98217fc0edfbeab07]

Eric Biggers (2):
      cfg80211: fix memory leak of wiphy device name
         [4f488fbca2a86cc7714a128952eead92cac279ab]
      crypto: user - prevent operating on larval algorithms
         [21d4120ec6f5b5992b01b96ac484701163917b63]

Eric Dumazet (6):
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
         [3580d04aa674383c42de7b635d28e52a1e5bc72c]
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
         [903869bd10e6719b9df6718e785be7ec725df59f]
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
         [65a3c497c0e965a552008db8bc2653f62bc925a1]
      llc: fix skb leak in llc_build_and_send_ui_pkt()
         [8fb44d60d4142cd2a440620cd291d346e23c131e]
      neigh: fix use-after-free read in pneigh_get_next
         [f3e92cb8e2eb8c27d109e6fd73d3a69a8c09e288]
      net-gro: fix use-after-free read in napi_gro_frags()
         [a4270d6795b0580287453ea55974d948393e66ef]

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO
         [f6e2aa91a46d2bc79fce9b93a988dbe7655c90c0]

Filipe Manana (2):
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges
         [0c713cbab6200b0ab6473b50435e450a6e1de85d]
      Btrfs: fix race between readahead and device replace/removal
         [ce7791ffee1e1ee9f97193b817c7dd1fa6746aad]

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations= parameter
         [1bf72720281770162c87990697eae1ba2f1d917a]

George G. Davis (1):
      serial: sh-sci: disable DMA for uart_console
         [099506cbbc79c0bd52b19cb6b930f256dabc3950]

Hans de Goede (1):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
         [31f6264e225fb92cf6f4b63031424f20797c297d]

Harald Freudenberger (1):
      s390/crypto: fix possible sleep during spinlock aquired
         [1c2c7029c008922d4d48902cc386250502e73d51]

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm
         [c8ea9fce2baf7b643384f36f29e4194fa40d33a6]

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing
         [718f4a2537089ea41903bf357071306163bc7c04]

Jakub Kicinski (1):
      net: netem: fix backlog accounting for corrupted GSO frames
         [177b8007463c4f36c9a2c7ce7aa9875a4cad9bd5]

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
         [240b4cc8fd5db138b675297d4226ec46594d9b3b]

Jan Stancek (1):
      powerpc/perf: add missing put_cpu_var in power_pmu_event_init
         [68de8867ea5d99127e836c23f6bccf4d44859623]

Jann Horn (2):
      apparmor: enforce nullbyte at end of tag string
         [8404d7a674c49278607d19726e0acc0cae299357]
      ptrace: restore smp_rmb() in __ptrace_may_access()
         [f6581f5b55141a95657ef5742cf6a6bfa20a109f]

Jisheng Zhang (1):
      net: stmmac: fix reset gpio free missing
         [49ce881c0d4c4a7a35358d9dccd5f26d0e56fc61]

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate
         [247e5356a709eb49a0d95ff2a7f07dac05c8252c]

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup
         [5d24f455c182d5116dd5db8e1dc501115ecc9c2c]

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coherence index of I/O pdirs
         [63923d2c3800919774f5c651d503d1dd2adaddd5]

Julian Wiedmann (2):
      net/af_iucv: always register net_device notifier
         [06996c1d4088a0d5f3e7789d7f96b4653cc947cc]
      net/af_iucv: remove GFP_DMA restriction for HiperTransport
         [fdbf6326912d578a31ac4ca0933c919eadf1d54c]

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek
         [1a6dd3fea131276a4fc44ae77b0f471b0b473577]

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()
         [3e66b7cc50ef921121babc91487e1fb98af1ba6e]

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording audio.
         [bd21f0222adab64974b7d1b4b8c7ce6b23e9ea4d]

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter
         [ea261113385ac0a71c2838185f39e8452d54b152]

Melissa Wen (1):
      staging:iio:ad7150: fix threshold mode config bit
         [df4d737ee4d7205aaa6275158aeebff87fd14488]

Naohiro Aota (1):
      btrfs: start readahead also in seed devices
         [c4e0540d0ad49c8ceab06cceed1de27c4fe29f6e]

Oliver Neukum (1):
      USB: rio500: fix memory leak in close after disconnect
         [e0feb73428b69322dd5caae90b0207de369b5575]

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.
         [720f1de4021f09898b8c8443f3b3e995991b6e3a]

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels
         [7c420636860a719049fae9403e2c87804f53bdde]

Peter Zijlstra (2):
      perf/core: Fix perf_sample_regs_user() mm check
         [085ebfe937d7a7a5df1729f35a12d6d655fea68c]
      perf/ring_buffer: Add ordering to rb->nest increment
         [3f9fbe9bd86c534eba2faf5d840fd44c6049f50e]

Petr Oros (1):
      be2net: fix link failure after ethtool offline test
         [2e5db6eb3c23e5dc8171eb8f6af7a97ef9fcf3a9]

Randy Dunlap (1):
      gpio: fix gpio-adp5588 build errors
         [e9646f0f5bb62b7d43f0968f39d536cfe7123b53]

Ravi Bangoria (2):
      perf/ioctl: Add check for the sample_period value
         [913a90bc5a3a06b1f04c337320e9aeee2328dd77]
      powerpc/perf: Fix MMCRA corruption by bhrb_filter
         [3202e35ec1c8fc19cea24253ff83edf702a60a02]

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages
         [4a60570dce658e3f8885bbcf852430b99f65aca5]

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM
         [31fad7d41e73731f05b8053d17078638cf850fa6]

Roman Bolshakov (1):
      scsi: target/iblock: Fix overrun in WRITE SAME emulation
         [5676234f20fef02f6ca9bd66c63a8860fce62645]

Ronnie Sahlberg (1):
      cifs: add spinlock for the openFileList to cifsInodeInfo
         [487317c99477d00f22370625d53be3239febabbe]

Russell King (1):
      i2c: acorn: fix i2c warning
         [ca21f851cc9643af049226d57fabc3c883ea648e]

S.j. Wang (1):
      ASoC: cs42xx8: Add regcache mask dirty
         [ad6eecbfc01c987e0253371f274c3872042e4350]

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry
         [f6122ed2a4f9c9c1c073ddf6308d1b2ac10e0781]

Shuah Khan (2):
      usbip: usbip_host: fix BUG: sleeping function called from invalid context
         [0c9e8b3cad654bfc499c10b652fbf8f0b890af8f]
      usbip: usbip_host: fix stub_dev lock context imbalance regression
         [3ea3091f1bd8586125848c62be295910e9802af0]

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever
         [24e2e7a19f7e4b83d0d5189040d997bce3596473]

Steffen Maier (2):
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove
         [d27e5e07f9c49bf2a6a4ef254ce531c1b4fb5a38]
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)
         [ef4021fe5fd77ced0323cede27979d80a56211ca]

Steve French (1):
      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write
         [8d526d62db907e786fd88948c75d1833d82bd80e]

WANG Cong (2):
      igmp: acquire pmc lock for ip_mc_clear_src()
         [c38b7d327aafd1e3ad7ff53eefac990673b65667]
      igmp: add a missing spin_lock_init()
         [b4846fc3c8559649277e3e4e6b5cec5348a8d208]

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()
         [be99ca2716972a712cde46092c54dee5e6192bf8]

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct
         [fd704bd5ee749d560e86c4f1fd2ef486d8abf7cf]

Xin Long (1):
      sctp: change to hold sk after auth shkey is created successfully
         [25bff6d5478b2a02368097015b7d8eb727c87e16]

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head
         [1b038c6e05ff70a1e66e3e571c2e6106bdb75f53]

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr
         [a0692f0eef91354b62c2b4c94954536536be5425]

YueHaibing (4):
      bonding: Add vlan tx offload to hw_enc_features
         [d595b03de2cb0bdf9bcdf35ff27840cc3a37158f]
      bonding: Always enable vlan tx offload
         [30d8177e8ac776d89d387fad547af6a0f599210e]
      can: af_can: Fix error path of can_init()
         [c5a3aed1cd3152429348ee1fe5cdcca65fe901ce]
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master
         [5caaf29af5ca82d5da8bc1d0ad07d9e664ccf1d8]

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print
         [00f9fec48157f3734e52130a119846e67a12314b]

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit
         [98af37d624ed8c83f1953b1b6b2f6866011fc064]

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool
         [85cb928787eab6a2f4ca9d2a798b6f3bed53ced1]

 Makefile                                          |  4 +-
 arch/arm64/kvm/guest.c                            | 49 ++++++++++++---
 arch/mips/mm/tlbex.c                              | 29 ++++++---
 arch/powerpc/perf/core-book3s.c                   |  8 ++-
 arch/powerpc/perf/power8-pmu.c                    |  3 +
 arch/s390/crypto/aes_s390.c                       | 10 +--
 arch/s390/crypto/des_s390.c                       |  9 +--
 arch/x86/kernel/apic/apic.c                       |  3 +-
 arch/x86/kernel/cpu/bugs.c                        | 11 +++-
 block/blk-mq-tag.c                                |  2 +-
 crypto/crypto_user.c                              |  3 +
 drivers/ata/libata-core.c                         |  9 ++-
 drivers/gpio/Kconfig                              |  1 +
 drivers/gpu/drm/gma500/cdv_intel_lvds.c           |  3 +
 drivers/gpu/drm/gma500/intel_bios.c               |  3 +
 drivers/gpu/drm/gma500/psb_drv.h                  |  1 +
 drivers/hwmon/pmbus/pmbus_core.c                  | 34 ++++++++--
 drivers/i2c/busses/i2c-acorn.c                    |  1 +
 drivers/i2c/i2c-dev.c                             |  1 +
 drivers/input/misc/uinput.c                       | 22 ++++++-
 drivers/md/bcache/bset.c                          | 16 ++++-
 drivers/md/bcache/bset.h                          | 34 +++++-----
 drivers/misc/genwqe/card_dev.c                    |  2 +
 drivers/misc/genwqe/card_utils.c                  |  4 ++
 drivers/net/bonding/bond_main.c                   |  6 +-
 drivers/net/can/flexcan.c                         |  2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c            |  1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c    | 30 ++++++---
 drivers/net/ethernet/mellanox/mlx4/mcg.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |  3 +-
 drivers/parisc/ccio-dma.c                         |  4 +-
 drivers/parisc/sba_iommu.c                        |  3 +-
 drivers/s390/net/qeth_l2_main.c                   |  2 +-
 drivers/s390/scsi/zfcp_ext.h                      |  1 +
 drivers/s390/scsi/zfcp_scsi.c                     |  9 +++
 drivers/s390/scsi/zfcp_sysfs.c                    | 55 +++++++++++++++--
 drivers/s390/scsi/zfcp_unit.c                     |  8 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                  |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                  | 11 ++--
 drivers/scsi/vmw_pvscsi.c                         |  6 +-
 drivers/spi/spi-bitbang.c                         |  2 +-
 drivers/staging/iio/cdc/ad7150.c                  | 23 ++++---
 drivers/staging/usbip/stub_dev.c                  | 75 ++++++++++++++++-------
 drivers/target/target_core_iblock.c               |  2 +-
 drivers/tty/serial/max310x.c                      |  2 +-
 drivers/tty/serial/sh-sci.c                       |  7 +++
 drivers/usb/core/config.c                         |  4 +-
 drivers/usb/core/quirks.c                         |  6 ++
 drivers/usb/host/xhci.c                           |  2 +-
 drivers/usb/misc/rio500.c                         | 17 ++++-
 drivers/usb/serial/pl2303.c                       |  1 +
 drivers/usb/serial/pl2303.h                       |  3 +
 drivers/usb/storage/unusual_realtek.h             |  5 ++
 fs/btrfs/file.c                                   | 12 ++++
 fs/btrfs/reada.c                                  |  7 +++
 fs/cifs/cifsfs.c                                  |  1 +
 fs/cifs/cifsglob.h                                |  5 ++
 fs/cifs/file.c                                    | 12 +++-
 fs/cifs/smb2maperror.c                            |  2 +-
 fs/configfs/dir.c                                 | 14 ++---
 fs/ocfs2/dcache.c                                 | 12 ++++
 include/linux/sched.h                             |  4 ++
 kernel/cpu.c                                      |  3 +
 kernel/cred.c                                     |  9 +++
 kernel/events/core.c                              |  5 +-
 kernel/events/ring_buffer.c                       | 33 ++++++++--
 kernel/ptrace.c                                   | 20 +++++-
 kernel/signal.c                                   |  2 +
 kernel/trace/trace.c                              | 10 +--
 lib/mpi/mpi-pow.c                                 |  6 +-
 mm/huge_memory.c                                  |  2 +
 net/can/af_can.c                                  | 24 +++++++-
 net/core/dev.c                                    |  2 +-
 net/core/neighbour.c                              |  7 +++
 net/core/pktgen.c                                 | 11 ++++
 net/ipv4/igmp.c                                   | 53 +++++++++++-----
 net/ipv6/ip6_flowlabel.c                          |  7 ++-
 net/iucv/af_iucv.c                                | 33 +++++++---
 net/llc/llc_output.c                              |  2 +
 net/rds/ib_rdma.c                                 | 10 +--
 net/sched/sch_netem.c                             | 13 ++--
 net/sctp/endpointola.c                            |  8 +--
 net/wireless/core.c                               |  2 +-
 security/apparmor/policy_unpack.c                 |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c                |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                   |  2 +-
 sound/soc/codecs/cs42xx8.c                        |  1 +
 87 files changed, 683 insertions(+), 211 deletions(-)

-- 
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

