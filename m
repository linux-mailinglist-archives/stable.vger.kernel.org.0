Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A8D6174E
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfGGTrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:47:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727436AbfGGTiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:00 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCyz-0006cs-Us; Sun, 07 Jul 2019 20:37:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCyy-0005WN-TJ; Sun, 07 Jul 2019 20:37:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sun, 07 Jul 2019 17:54:16 +0100
Message-ID: <lsq.1562518456.876074874@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/129] 3.16.70-rc1 review
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.70 release.
There are 129 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jul 09 20:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (1):
      mmc: omap: fix the maximum timeout setting
         [a6327b5e57fdc679c842588c3be046c0b39cc127]

Aditya Pakki (1):
      md: Fix failed allocation of md_register_thread
         [e406f12dde1a8375d77ea02d91f313fb1a9c6aec]

Alistair Strachan (1):
      media: uvcvideo: Fix 'type' check leading to overflow
         [47bb117911b051bbc90764a8bff96543cbd2005f]

Aneesh Kumar K.V (1):
      powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area topdown search
         [3b4d07d2674f6b4a9281031f99d1f7efd325b16d]

Ard Biesheuvel (1):
      crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
         [eaf46edf6ea89675bd36245369c8de5063a0272c]

Arnd Bergmann (1):
      cpufreq: pxa2xx: remove incorrect __init annotation
         [9505b98ccddc454008ca7efff90044e3e857c827]

Axel Lin (1):
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA
         [c25d47888f0fb3d836d68322d4aea2caf31a75a6]

Bart Van Assche (1):
      scsi: target/iscsi: Avoid iscsit_release_commands_from_conn() deadlock
         [32e36bfbcf31452a854263e7c7f32fbefc4b44d8]

Ben Hutchings (1):
      binder: Replace "%p" with "%pK" for stable
         [fdfb4a99b6ab8c393db19e3b92968b74ca2757b0,
          19c987241ca1216a51118b2bd0185b8bc5081783,
          7a4408c6bd3eb1dafba67986259191be081e3efb]

Buland Singh (1):
      hpet: Fix missing '=' character in the __setup() code of hpet_mmap_enable
         [24d48a61f2666630da130cc2ec2e526eacf229e3]

Christophe Leroy (4):
      powerpc/32: Clear on-stack exception marker upon exception return
         [9580b71b5a7863c24a9bd18bcd2ad759b86b1eff]
      powerpc/83xx: Also save/restore SPRG4-7 during suspend
         [36da5ff0bea2dc67298150ead8d8471575c54c7d]
      powerpc/irq: drop arch_early_irq_init()
         [607ea5090b3fb61fea1d0bc5278e6c1d40ab5bd6]
      powerpc/wii: properly disable use of BATs when requested.
         [6d183ca8baec983dc4208ca45ece3c36763df912]

Colin Ian King (4):
      rtc: 88pm80x: fix unintended sign extension
         [fb0b322537a831b5b0cb948c56f8f958ce493d3a]
      rtc: 88pm860x: fix unintended sign extension
         [dc9e47160626cdb58d5c39a4f43dcfdb27a5c004]
      rtc: ds1672: fix unintended sign extension
         [f0c04c276739ed8acbb41b4868e942a55b128dca]
      rtc: pm8xxx: fix unintended sign extension
         [e42280886018c6f77f0a90190f7cba344b0df3e0]

Dan Carpenter (1):
      xen, cpu_hotplug: Prevent an out of bounds access
         [201676095dda7e5b31a5e1d116d10fc22985075e]

Dan Robertson (1):
      btrfs: init csum_list before possible free
         [e49be14b8d80e23bb7c53d78c21717a474ade76b]

Daniel Axtens (1):
      bcache: never writeback a discard operation
         [9951379b0ca88c95876ad9778b9099e19a95d566]

Daniel Jordan (1):
      mm, swap: bounds check swap_info array accesses to avoid NULL derefs
         [c10d38cc8d3e43f946b6c2bf4602c86791587f30]

Doug Berger (1):
      irqchip/brcmstb-l2: Use _irqsave locking variants in non-interrupt code
         [33517881ede742107f416533b8c3e4abc56763da]

Eric Biggers (5):
      crypto: ahash - fix another early termination in hash walk
         [77568e535af7c4f97eaef1e555bf0af83772456c]
      crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
         [ba7d7433a0e998c902132bd47330e355a1eaa894]
      crypto: pcbc - remove bogus memcpy()s with src == dest
         [251b7aea34ba3c4d4fdfa9447695642eb8b8b098]
      crypto: testmgr - skip crc32c context test for ahash algorithms
         [eb5e6730db98fcc4b51148b4a819fa4bf864ae54]
      crypto: tgr192 - fix unaligned memory access
         [f990f7fb58ac8ac9a43316f09a48cff1a49dda42]

Eric Dumazet (6):
      gro_cells: make sure device is up in gro_cells_receive()
         [2a5ff07a0eb945f291e361aa6f6becca8340ba46]
      l2tp: fix infoleak in l2tp_ip6_recvmsg()
         [163d1c3d6f17556ed3c340d3789ea93be95d6c28]
      net/hsr: fix possible crash in add_timer()
         [1e027960edfaa6a43f9ca31081729b716598112b]
      netns: provide pure entropy for net_hash_mix()
         [355b98553789b646ed97ad801a619ff898471b92]
      tcp: refine memory limit test in tcp_fragment()
         [b6653b3629e5b88202be3c9abc44713973f5c4b4]
      vxlan: test dev->flags & IFF_UP before calling gro_cells_receive()
         [59cbf56fcd98ba2a715b6e97c4e43f773f956393]

Eric W. Biederman (1):
      fs/nfs: Fix nfs_parse_devname to not modify it's argument
         [40cc394be1aa18848b8757e03bd8ed23281f572e]

Felipe Franciosi (1):
      scsi: virtio_scsi: don't send sc payload with tmfs
         [3722e6a52174d7c3a00e6f5efd006ca093f346c1]

Filipe Manana (1):
      Btrfs: fix corruption reading shared and compressed extents after hole punching
         [8e928218780e2f1cf2f5891c7575e8f0b284fcce]

Finn Thain (1):
      m68k: Add -ffreestanding to CFLAGS
         [28713169d879b67be2ef2f84dcf54905de238294]

Gal Pressman (2):
      IB/usnic: Fix out of bounds index check in query pkey
         [4959d5da5737dd804255c75b8cea0a2929ce279a]
      RDMA/ocrdma: Fix out of bounds index check in query pkey
         [b188940796c7be31c1b8c25a9a0e0842c2e7a49e]

Geert Uytterhoeven (3):
      pinctrl: sh-pfc: r8a7778: Fix HSPI pin numbers and names
         [8e32e881947be98abaa917157fefc4a3319e90af]
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
         [a4b0350047f1b10207e25e72d7cd3f7826e93769]
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups
         [0e6e448bdcf896d001a289a6112a704542d51516]

Gustavo A. R. Silva (4):
      ARM: s3c24xx: Fix boolean expressions in osiris_dvs_notify
         [e2477233145f2156434afb799583bccd878f3e9f]
      applicom: Fix potential Spectre v1 vulnerabilities
         [d7ac3c6ef5d8ce14b6381d52eb7adafdd6c8bb3c]
      drm/radeon/evergreen_cs: fix missing break in switch statement
         [cc5034a5d293dd620484d1d836aa16c6764a1c8c]
      iscsi_ibft: Fix missing break in switch statement
         [df997abeebadaa4824271009e2d2b526a70a11cb]

Halil Pasic (1):
      s390/virtio: handle find on invalid queue gracefully
         [3438b2c039b4bf26881786a1f3450f016d66ad11]

Hou Tao (1):
      9p: use inode->i_lock to protect i_size_write() under 32-bit
         [5e3cc1ee1405a7eb3487ed24f786dec01b4cbe1f]

Hugh Dickins (1):
      mm: fix potential data race in SyS_swapon
         [6f179af88f60b32c2855e7f3e16ea8e336a7043f]

Ido Schimmel (1):
      ip6mr: Do not call __IP6_INC_STATS() from preemptible context
         [87c11f1ddbbad38ad8bad47af133a8208985fbdf]

Ivan Mironov (1):
      USB: serial: cp210x: add ID for Ingenico 3070
         [dd9d3d86b08d6a106830364879c42c78db85389c]

Jack Morgenstein (2):
      net/mlx4_core: Fix locking in SRIOV mode when switching between events and polling
         [c07d27927f2f2e96fcd27bb9fb330c9ea65612d0]
      net/mlx4_core: Fix qp mtt size calculation
         [8511a653e9250ef36b95803c375a7be0e2edb628]

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values
         [61da76beef1e4f0b6ba7be4f8d0cf0dac7ce1f55]

Jan Kara (2):
      ext2: Fix underflow in ext2_max_size()
         [1c2d14212b15a60300a2d4f6364753e87394c521]
      ext4: fix crash during online resizing
         [f96c3ac8dfc24b4e38fc4c2eba5fea2107b929d1]

Jann Horn (1):
      splice: don't merge into linked buffers
         [a0ce2f0aa6ad97c3d4927bf2ca54bcebdf062d55]

Jarkko Sakkinen (1):
      tpm/tpm_i2c_atmel: Return -E2BIG when the transfer is incomplete
         [442601e87a4769a8daba4976ec3afa5222ca211d]

Jay Dolan (2):
      serial: 8250_pci: Fix number of ports for ACCES serial cards
         [b896b03bc7fce43a07012cc6bf5e2ab2fddf3364]
      serial: 8250_pci: Have ACCES cards that use the four port Pericom PI7C9X7954 chip use the pci_pericom_setup()
         [78d3820b9bd39028727c6aab7297b63c093db343]

Jeremy Fertic (7):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
         [10bfe7cc1739c22f0aa296b39e53f61e9e3f4d99]
      staging: iio: adt7316: fix dac_bits assignment
         [e9de475723de5bf207a5b7b88bdca863393e42c8]
      staging: iio: adt7316: fix handling of dac high resolution option
         [76b7fe8d6c4daf4db672eb953c892c6f6572a282]
      staging: iio: adt7316: fix register and bit definitions
         [53a6f022b4fe8645468adaffca901dbf8c3c547e]
      staging: iio: adt7316: fix the dac read calculation
         [45130fb030aec26ac28b4bb23344901df3ec3b7f]
      staging: iio: adt7316: fix the dac write calculation
         [78accaea117c1ae878774974fab91ac4a0b0e2b0]
      staging: iio: adt7316: invert the logic of the check for an ldac pin
         [85a1c11913312132d0800ca2c1c42a011f96ea92]

Jia Zhang (1):
      tpm: Fix off-by-one when reading binary_bios_measurements
         [64494d39ff630a63b5308042b20132b491e3706b]

Jiri Olsa (1):
      perf header: Fix wrong node write in NUMA_TOPOLOGY feature
         [b00ccb27f97367d89e2d7b419ed198b0985be55d]

Jordan Niethe (1):
      powerpc/powernv: Make opal log only readable by root
         [7b62f9bd2246b7d3d086e571397c14ba52645ef1]

Jun Zhang (1):
      rcu: Do RCU GP kthread self-wakeup from softirq and interrupt
         [1d1f898df6586c5ea9aeaf349f13089c6fa37903]

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode
         [035a14e71f27eefa50087963b94cbdb3580d08bf]

Kirill Smelkov (2):
      fs: stream_open - opener for stream-like files so  that read and write can run simultaneously without deadlock
         [10dce8af34226d90fa56746a934f8da5dcdba3df]
      fuse: Add FOPEN_STREAM to use stream_open()
         [bbd84f33652f852ce5992d65db4d020aba21f882]

Lubomir Rintel (2):
      libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer
         [607076a904c435f2677fadaadd4af546279db68b]
      serial: 8250_of: assume reg-shift of 2 for mrvl,mmp-uart
         [f4817843e39ce78aace0195a57d4e8500a65a898]

Mans Rullgard (1):
      USB: serial: ftdi_sio: add ID for Hjelmslund Electronics USB485
         [8d7fa3d4ea3f0ca69554215e87411494e6346fdc]

Marek Szyprowski (1):
      clocksource/drivers/exynos_mct: Fix error path in timer resources initialization
         [b9307420196009cdf18bad55e762ac49fb9a80f4]

Michal Kazior (1):
      leds: lp55xx: fix null deref on firmware load failure
         [5ddb0869bfc1bca6cfc592c74c64a026f936638c]

NeilBrown (2):
      nfsd: fix memory corruption caused by readdir
         [b602345da6cbb135ba68cf042df8ec9a73da7981]
      security/selinux: pass 'flags' arg to avc_audit() and avc_has_perm_flags()
         [7b20ea2579238f5e0da4bc93276c1b63c960c9ef]

Pavel Shilovsky (2):
      CIFS: Do not reset lease state to NONE on lease break
         [7b9b9edb49ad377b1e06abf14354c227e9ac4b06]
      CIFS: Fix read after write for files with read caching
         [6dfbd84684700cb58b34e8602c01c12f3d2595c8]

Pawe? Chmiel (2):
      media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration
         [49710c32cd9d6626a77c9f5f978a5f58cb536b35]
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL
         [19c624c6b29e244c418f8b44a711cbf5e82e3cd4]

QiaoChong (1):
      parport_pc: fix find_superio io compare code, should use equal test.
         [21698fd57984cd28207d841dbdaa026d6061bceb]

Richard Weinberger (2):
      mtd: docg3: Don't leak docg3->bbt in error path
         [45c2ebd702a468d5037cf16aa4f8ea8d67776f6a]
      mtd: docg3: Fix kasprintf() usage
         [0eb8618bd07533f423fed47399a0d6387bfe7cac]

Roman Penyaev (1):
      mm/vmalloc: fix size check for remap_vmalloc_range_partial()
         [401592d2e095947344e10ec0623adbcd58934dd4]

S.j. Wang (1):
      ASoC: fsl_esai: fix register setting issue in RIGHT_J mode
         [cc29ea007347f39f4c5a4d27b0b555955a0277f9]

Sakari Ailus (1):
      media: uvcvideo: Avoid NULL pointer dereference at the end of streaming
         [9dd0627d8d62a7ddb001a75f63942d92b5336561]

Sean Christopherson (1):
      KVM: x86/mmu: Do not cache MMIO accesses while memslots are in flux
         [ddfd1730fd829743e41213e32ccc8b4aa6dc8325]

Sergei Shtylyov (1):
      devres: always use dev_name() in devm_ioremap_resource()
         [8d84b18f5678d3adfdb9375dfb0d968da2dc753d]

Stanislaw Gruszka (1):
      lib/div64.c: off by one in shift
         [cdc94a37493135e355dfc0b0e086d84e3eadb50d]

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails
         [d9866572486802bc598a3e8576a5231378d190de]

Stephen Smalley (1):
      selinux: avoid silent denials in permissive mode under RCU walk
         [3a28cff3bd4bf43f02be0c4e7933aebf3dc8197e]

Takashi Iwai (4):
      ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
         [2757970f6d0d0a112247600b23d38c0c728ceeb3]
      mwifiex: Abort at too short BSS descriptor element
         [685c9b7750bfacd6fc1db50d86579980593b7869]
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
         [69ae4f6aac1578575126319d3f55550e7e440449]
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
         [13ec7f10b87f5fc04c4ccbd491c94c7980236a74]

Takashi Sakamoto (1):
      ALSA: bebob: use more identical mod_alias for Saffire Pro 10 I/O against Liquid Saffire 56
         [7dc661bd8d3261053b69e4e2d0050cd1ee540fc1]

Tang Junhui (1):
      bcache: treat stale && dirty keys as bad keys
         [58ac323084ebf44f8470eeb8b82660f9d0ee3689]

Tetsuo Handa (1):
      staging: android: ashmem: Avoid range_alloc() allocation with ashmem_mutex held.
         [ecd182cbf4e107928077866399100228d2359c60]

Tony Jones (1):
      tools lib traceevent: Fix buffer overflow in arg_eval
         [7c5b019e3a638a5a290b0ec020f6ca83d2ec2aaa]

Trond Myklebust (1):
      NFSv4.1: Reinitialise sequence results before retransmitting a request
         [c1dffe0bf7f9c3d57d9f237a7cb2a81e62babd2b]

Xiao Ni (1):
      It's wrong to add len to sector_nr in raid10 reshape twice
         [b761dcf1217760a42f7897c31dcb649f59b2333e]

Xin Long (2):
      pptp: dst_release sk_dst_cache in pptp_sock_destruct
         [9417d81f4f8adfe20a12dd1fadf73a618cbd945d]
      route: set the deleted fnhe fnhe_daddr to 0 in ip_del_fnhe to fix a race
         [ee60ad219f5c7c4fb2f047f88037770063ef785f]

Yangerkun (3):
      ext4: add mask of ext4 flags to swap
         [abdc644e8cbac2e9b19763680e5a7cf9bab2bee7]
      ext4: fix check of inode in swap_inode_boot_loader
         [67a11611e1a5211f6569044fbf8150875764d1d0]
      ext4: update quota information while swapping boot loader inode
         [aa507b5faf38784defe49f5e64605ac3c4425e26]

Yangtao Li (10):
      clk: armada-370: fix refcount leak in a370_clk_init()
         [a3c24050bdf70c958a8d98c2823b66ea761e6a31]
      clk: armada-xp: fix refcount leak in axp_clk_init()
         [db20a90a4b6745dad62753f8bd2f66afdd5abc84]
      clk: dove: fix refcount leak in dove_clk_init()
         [8d726c5128298386b907963033be93407b0c4275]
      clk: highbank: fix refcount leak in hb_clk_init()
         [5eb8ba90958de1285120dae5d3a5d2b1a360b3b4]
      clk: imx6q: fix refcount leak in imx6q_clocks_init()
         [c9ec1d8fef31b5fc9e90e99f9bd685db5caa7c5e]
      clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
         [1731e14fb30212dd8c1e9f8fc1af061e56498c55]
      clk: kirkwood: fix refcount leak in kirkwood_clk_init()
         [e7beeab9c61591cd0e690d8733d534c3f4278ff8]
      clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
         [cee82eb9532090cd1dc953e845d71f9b1445c84e]
      clk: socfpga: fix refcount leak
         [7f9705beeb3759e69165e7aff588f6488ff6c1ac]
      clk: vf610: fix refcount leak in vf610_clocks_init()
         [567177024e0313e4f0dcba7ba10c0732e50e655d]

YueHaibing (5):
      cdc-wdm: pass return value of recover_from_urb_loss
         [0742a338f5b3446a26de551ad8273fb41b2787f2]
      drm: Fix error handling in drm_legacy_addctx
         [c39191feed4540fed98badeb484833dcf659bb96]
      mtd: docg3: Fix passing zero to 'PTR_ERR' warning in doc_probe_device
         [32937a82f36c7bbe08db4052de94bc7ade4e3c51]
      net-sysfs: Fix mem leak in netdev_register_kobject
         [895a5e96dbd6386c8e78e5b78e067dcc67b7f0ab]
      tty: ipwireless: Fix potential NULL pointer dereference
         [7dd50e205b3348dc7784efbdf85723551de64a25]

Zev Weiss (1):
      kernel/sysctl.c: add missing range check in do_proc_dointvec_minmax_conv
         [8cf7630b29701d364f8df4a50e4f1f5e752b2778]

Zhangyi (1):
      jbd2: clear dirty flag when revoking a buffer from an older transaction
         [904cdbd41d749a476863a0ca41f6f396774f26e4]

 Makefile                                           |   4 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   1 +
 arch/arm/mach-imx/clk-imx6sx.c                     |   1 +
 arch/arm/mach-imx/clk-vf610.c                      |   1 +
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   8 +-
 arch/arm64/crypto/aes-ce-ccm-core.S                |   5 +-
 arch/m68k/Makefile                                 |   5 +-
 arch/powerpc/kernel/entry_32.S                     |   9 +
 arch/powerpc/kernel/irq.c                          |   5 -
 arch/powerpc/mm/slice.c                            |  10 +-
 arch/powerpc/platforms/83xx/suspend-asm.S          |  34 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |   4 +
 arch/powerpc/platforms/powernv/opal-msglog.c       |   2 +-
 arch/x86/kvm/x86.h                                 |   7 +-
 crypto/ahash.c                                     |  42 ++-
 crypto/pcbc.c                                      |  14 +-
 crypto/shash.c                                     |  18 +-
 crypto/testmgr.c                                   |  14 +-
 crypto/tgr192.c                                    |   6 +-
 drivers/char/applicom.c                            |  35 +-
 drivers/char/hpet.c                                |   2 +-
 drivers/char/tpm/tpm_eventlog.c                    |  10 +-
 drivers/char/tpm/tpm_i2c_atmel.c                   |   9 +-
 drivers/clk/clk-highbank.c                         |   1 +
 drivers/clk/mvebu/armada-370.c                     |   4 +-
 drivers/clk/mvebu/armada-xp.c                      |   4 +-
 drivers/clk/mvebu/dove.c                           |   4 +-
 drivers/clk/mvebu/kirkwood.c                       |   5 +-
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/clk/socfpga/clk-pll.c                      |   1 +
 drivers/clocksource/exynos_mct.c                   |  14 +-
 drivers/cpufreq/pxa2xx-cpufreq.c                   |   4 +-
 drivers/firmware/iscsi_ibft.c                      |   1 +
 drivers/gpu/drm/drm_context.c                      |  15 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |  10 +-
 drivers/leds/leds-lp55xx-common.c                  |   4 +-
 drivers/md/bcache/extents.c                        |  13 +-
 drivers/md/bcache/writeback.h                      |   3 +
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  21 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  14 +-
 drivers/media/usb/uvc/uvc_video.c                  |   8 +
 drivers/mmc/host/omap.c                            |   2 +-
 drivers/mtd/devices/docg3.c                        |  18 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   8 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   6 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   6 +-
 drivers/net/ppp/pptp.c                             |   1 +
 drivers/net/vxlan.c                                |  10 +
 drivers/net/wireless/libertas_tf/if_usb.c          |   2 -
 drivers/net/wireless/mwifiex/ie.c                  |  30 +-
 drivers/net/wireless/mwifiex/scan.c                |  19 ++
 drivers/parport/parport_pc.c                       |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |   6 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   3 +-
 drivers/regulator/wm831x-dcdc.c                    |   4 +-
 drivers/rtc/rtc-88pm80x.c                          |  21 +-
 drivers/rtc/rtc-88pm860x.c                         |  21 +-
 drivers/rtc/rtc-ds1672.c                           |   3 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/s390/kvm/virtio_ccw.c                      |   4 +-
 drivers/scsi/virtio_scsi.c                         |   2 -
 drivers/staging/android/ashmem.c                   |  42 ++-
 drivers/staging/android/binder.c                   |  28 +-
 drivers/staging/iio/addac/adt7316.c                |  55 ++--
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/tty/ipwireless/hardware.c                  |   2 +
 drivers/tty/serial/8250/8250_pci.c                 | 141 +++++++-
 drivers/tty/serial/of_serial.c                     |   4 +
 drivers/usb/class/cdc-wdm.c                        |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/xen/cpu_hotplug.c                          |   2 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 fs/9p/v9fs_vfs.h                                   |  23 +-
 fs/9p/vfs_file.c                                   |   6 +-
 fs/9p/vfs_inode.c                                  |  23 +-
 fs/9p/vfs_inode_dotl.c                             |  27 +-
 fs/9p/vfs_super.c                                  |   4 +-
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/scrub.c                                   |   2 +-
 fs/cifs/file.c                                     |  12 +-
 fs/cifs/smb2misc.c                                 |  17 +-
 fs/cifs/smb2ops.c                                  |  13 +-
 fs/ext2/super.c                                    |  39 ++-
 fs/ext4/ext4.h                                     |   3 +
 fs/ext4/ioctl.c                                    |  84 +++--
 fs/ext4/resize.c                                   |   3 +-
 fs/fuse/file.c                                     |   4 +-
 fs/jbd2/transaction.c                              |  17 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfs/super.c                                     |   2 +-
 fs/nfsd/nfs3proc.c                                 |  16 +-
 fs/nfsd/nfs3xdr.c                                  |   1 +
 fs/open.c                                          |  18 +
 fs/pipe.c                                          |  14 +
 fs/read_write.c                                    |   5 +-
 fs/splice.c                                        |   4 +
 include/linux/fs.h                                 |   4 +
 include/linux/pipe_fs_i.h                          |   1 +
 include/linux/swap.h                               |   1 +
 include/net/gro_cells.h                            |  12 +-
 include/net/net_namespace.h                        |   2 +
 include/net/netns/hash.h                           |  17 +-
 include/uapi/linux/fuse.h                          |   2 +
 kernel/rcu/tree.c                                  |  20 +-
 kernel/sysctl.c                                    |  11 +-
 lib/devres.c                                       |   4 +-
 lib/div64.c                                        |   4 +-
 mm/swapfile.c                                      |  83 ++---
 mm/vmalloc.c                                       |   2 +-
 net/core/net-sysfs.c                               |   3 +
 net/core/net_namespace.c                           |   1 +
 net/hsr/hsr_device.c                               |  14 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/ip6mr.c                                   |   8 +-
 net/l2tp/l2tp_ip6.c                                |   4 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++++++
 security/selinux/avc.c                             |  44 ++-
 security/selinux/hooks.c                           |   6 +-
 security/selinux/include/avc.h                     |  10 +-
 sound/firewire/bebob/bebob.c                       |  14 +-
 sound/soc/fsl/fsl_esai.c                           |   7 +-
 sound/soc/fsl/fsl_ssi.c                            |   5 +-
 sound/soc/fsl/imx-sgtl5000.c                       |   3 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/perf/util/header.c                           |   2 +-
 135 files changed, 1418 insertions(+), 459 deletions(-)

-- 
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

