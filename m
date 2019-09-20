Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6B1B932F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfITOY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35608 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728943AbfITOY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqA-0004vZ-L5; Fri, 20 Sep 2019 15:24:54 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqA-0007oa-7C; Fri, 20 Sep 2019 15:24:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 20 Sep 2019 15:23:34 +0100
Message-ID: <lsq.1568989414.954567518@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/132] 3.16.74-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.74 release.
There are 132 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (3):
      media: usb: siano: Fix false-positive "uninitialized variable" warning
         [45457c01171fd1488a7000d1751c06ed8560ee38]
      media: usb: siano: Fix general protection fault in smsusb
         [31e0456de5be379b10fea0fa94a681057114a96e]
      p54usb: Fix race between disconnect and firmware loading
         [6e41e2257f1094acc37618bf6c856115374c6922]

Alexander Kochetkov (1):
      net: arc_emac: fix koops caused by sk_buff free
         [c278c253f3d992c6994d08aa0efb2b6806ca396f]

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines
         [5cbdae10bf11f96e30b4d14de7b08c8b490e903c]

Andy Lutomirski (2):
      x86/speculation/mds: Improve CPU buffer clear documentation
         [9d8d0294e78a164d407133dea05caf4b84247d6a]
      x86/speculation/mds: Revert CPU buffer clear on double fault exit
         [88640e1dcd089879530a49a8d212d1814678dfe7]

Arik Nemtsov (1):
      mac80211: add API to request TDLS operation from userspace
         [c887f0d3a03283cb6fe2c32aae62229bebd3fa32]

Arnd Bergmann (3):
      appletalk: Fix compile regression
         [27da0d2ef998e222a876c0cec72aa7829a626266]
      media: davinci-isif: avoid uninitialized variable use
         [0e633f97162c1c74c68e2eb20bbd9259dce87cd9]
      scsi: qla4xxx: avoid freeing unallocated dma memory
         [608f729c31d4caf52216ea00d20092a80959256d]

Bart Van Assche (1):
      scsi: qla2xxx: Unregister chrdev if module initialization fails
         [c794d24ec9eb6658909955772e70f34bef5b5b91]

Ben Hutchings (1):
      media: poseidon: Depend on PM_RUNTIME
         [not upstream; driver has been removed]

Bob Peterson (2):
      GFS2: Fix rgrp end rounding problem for bsize < page size
         [31dddd9eb9ebae9a2a9b502750e9e481d752180a]
      GFS2: don't set rgrp gl_object until it's inserted into rgrp tree
         [36e4ad0316c017d5b271378ed9a1c9a4b77fab5f]

Brian Masney (1):
      backlight: lm3630a: Return 0 on success in update_status functions
         [d3f48ec0954c6aac736ab21c34a35d7554409112]

Christian König (1):
      drm/radeon: prefer lower reference dividers
         [2e26ccb119bde03584be53406bbd22e711b0d6e6]

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()
         [6a54b2e002c9d00b398d35724c79f9fe0d9b38fb]

Christoph Vogtländer (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs
         [b00ef53053191d3025c15e8041699f8c9d132daf]

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring
         [ee0df19305d9fabd9479b785918966f6e25b733b]

Colin Ian King (2):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure
         [a6d2a5a92e67d151c98886babdc86d530d27111c]
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer
         [98e2630284ab741804bd0713e932e725466f2f84]

Coly Li (1):
      bcache: never set KEY_PTRS of journal key to 0 in journal_reclaim()
         [1bee2addc0c8470c8aaa65ef0599eeae96dd88bc]

Dan Carpenter (11):
      ath6kl: add some bounds checking
         [5d6751eaff672ea77642e74e92e6c0ac7f9709ab]
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
         [c8ea3663f7a8e6996d44500ee818c9330ac4fd88]
      kdb: do a sanity check on the cpu in kdb_per_cpu()
         [b586627e10f57ee3aa8f0cfab0d6f7dc4ae63760]
      media: cx18: update *pos correctly in cx18_read_pos()
         [7afb0df554292dca7568446f619965fb8153085d]
      media: davinci/vpbe: array underflow in vpbe_enum_outputs()
         [b72845ee5577b227131b1fef23f9d9a296621d7b]
      media: ivtv: update *pos correctly in ivtv_read_pos()
         [f8e579f3ca0973daef263f513da5edff520a6c0d]
      media: omap_vout: potential buffer overflow in vidioc_dqbuf()
         [dd6e2a981bfe83aa4a493143fd8cf1edcda6c091]
      media: pvrusb2: Prevent a buffer overflow
         [c1ced46c7b49ad7bc064e68d966e0ad303f917fb]
      media: wl128x: Fix an error code in fm_download_firmware()
         [ef4bb63dc1f7213c08e13f6943c69cd27f69e4a3]
      media: wl128x: prevent two potential buffer overflows
         [9c2ccc324b3a6cbc865ab8b3e1a09e93d3c8ade9]
      platform/x86: alienware-wmi: printing the wrong error code
         [6d1f8b3d75419a8659ac916a1e9543bb3513a882]

Dave Chinner (1):
      xfs: clear sb->s_fs_info on mount failure
         [c9fbd7bbc23dbdd73364be4d045e5d3612cf6e82]

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic
         [19e4e768064a87b073a4b4c138b55db70e0cfb9f]

Dmitry Osipenko (1):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divider
         [40db569d6769ffa3864fd1b89616b1a7323568a8]

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file
         [cbe08bcbbe787315c425dde284dcb715cfbf3f39]

Eric Biggers (4):
      crypto: arm/aes-neonbs - don't access already-freed walk.iv
         [767f015ea0b7ab9d60432ff6cd06b664fd71f50f]
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
         [307508d1072979f4435416f87936f87eaeb82054]
      crypto: salsa20 - don't access already-freed walk.iv
         [edaf28e996af69222b2cb40455dbb5459c2b875a]
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
         [dec3d0b1071a0f3194e66a83d26ecf4aa8c5910e]

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule
         [680f6af5337c98d116e4f127cea7845339dba8da]

Geert Uytterhoeven (2):
      spi: rspi: Fix register initialization while runtime-suspended
         [42bdaaece121b3bb50fd4d1203d6d0170279f9fa]
      spi: rspi: Fix sequencer reset during initialization
         [26843bb128590edd7eba1ad7ce22e4b9f1066ce3]

Guenter Roeck (6):
      hwmon: (f71805f) Use request_muxed_region for Super-IO accesses
         [73e6ff71a7ea924fb7121d576a2d41e3be3fc6b5]
      hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
         [755a9b0f8aaa5639ba5671ca50080852babb89ce]
      hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
         [8c0826756744c0ac1df600a5e4cca1a341b13101]
      hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
         [d6410408ad2a798c4cc685252c1baa713be0ad69]
      hwmon: (vt1211) Use request_muxed_region for Super-IO accesses
         [14b97ba5c20056102b3dd22696bf17b057e60976]
      hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
         [e95fd518d05bfc087da6fcdea4900a57cfb083bd]

Gustavo A. R. Silva (2):
      cxgb3/l2t: Fix undefined behaviour
         [76497732932f15e7323dc805e8ea8dc11bb587cf]
      platform/x86: sony-laptop: Fix unintentional fall-through
         [1cbd7a64959d33e7a2a1fa2bf36a62b350a9fcbd]

Hui Peng (2):
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
         [19bce474c45be69a284ecee660aa12d8f1e88f18]
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit
         [daac07156b330b18eb5071aec4b3ddca1c377f2c]

Hui Wang (1):
      ALSA: hda/hdmi - Read the pin sense from register when repolling
         [8c2e6728c2bf95765b724e07d0278ae97cd1ee0d]

Ian Abbott (1):
      staging: comedi: dt282x: fix a null  pointer deref on interrupt
         [b8336be66dec06bef518030a0df9847122053ec5]

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset
         [6afb7e26978da5e86e57e540fdce65c8b04f398a]

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe
         [933c1320847f5ed6b61a7d10f0a948aa98ccd7b0]

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode
         [a9b8a2b39ce65df45687cf9ef648885c2a99fe75]

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed
         [3b0541791453fbe7f42867e310e0c9eb6295364d]

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount
         [00abf69dd24f4444d185982379c5cc3bb7b6d1fc]

Jiri Slaby (1):
      TTY: serial_core, add ->install
         [4cdd17ba1dff20ffc99fdbd2e6f0201fc7fe67df]

Jiufei Xue (1):
      jbd2: check superblock mapped prior to committing
         [742b06b5628f2cd23cb51a034cb54dc33c6162c5]

Johan Hovold (3):
      USB: cdc-acm: fix unthrottle races
         [764478f41130f1b8d8057575b89e69980a0f600d]
      USB: serial: fix initial-termios handling
         [579bebe5dd522580019e7b10b07daaf500f9fb1e]
      USB: serial: fix unthrottle races
         [3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab]

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA
         [588f7d39b3592a36fb7702ae3b8bdd9be4621e2f]

Jon Hunter (1):
      ASoC: max98090: Fix restore of DAPM Muxes
         [ecb2795c08bc825ebd604997e5be440b060c5b18]

Julia Lawall (1):
      powerpc/83xx: Add missing of_node_put() after of_device_is_available()
         [4df2cb633b5b22ba152511f1a55e718efca6c0d9]

Kailang Yang (1):
      ALSA: hda/realtek - EAPD turn on later
         [607ca3bd220f4022e6f5356026b19dafc363863a]

Karthik D A (1):
      mwifiex: vendor_ie length check for parse WMM IEs
         [113630b581d6d423998d2113a8e892ed6e6af6f9]

Kees Cook (1):
      selftests/ipc: Fix msgque compiler warnings
         [a147faa96f832f76e772b1e448e94ea84c774081]

Kefeng Wang (1):
      Bluetooth: hci_ldisc: Postpone HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
         [56897b217a1d0a91c9920cb418d6b3fe922f590a]

Kirill Tkhai (1):
      ext4: actually request zeroing of inode table after grow
         [310a997fd74de778b9a4848a64be9cda9f18764a]

Ladislav Michl (2):
      cdc-acm: handle read pipe errors
         [1aba579f3cf51fd0fe0b4d46cc13823fd1200acb]
      cdc-acm: store in and out pipes in acm structure
         [74bccc9b71dc41d37e73fcdbcbec85310a670751]

Laurentiu Tudor (1):
      powerpc/booke64: set RI in default MSR
         [5266e58d6cd90ac85c187d673093ad9cb649e16d]

Liang Chen (1):
      bcache: fix a race between cache register and cacheset unregister
         [a4b732a248d12cbdb46999daf0bf288c011335eb]

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate
         [0cbade024ba501313da3b7e5dd2a188a6bc491b5]

Loic Poulain (1):
      Bluetooth: hci_ldisc: Fix null pointer derefence in case of early data
         [84cb3df02aea4b00405521e67c4c67c2d525c364]

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly
         [cf1ec4539a50bdfe688caad4615ca47646884316]

Lukas Czerner (1):
      ext4: fix data corruption caused by overlapping unaligned and aligned IO
         [57a0da28ced8707cb9f79f071a016b9d005caf5a]

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc
         [c666355e60ddb4748ead3bdd983e3f7f2224aaf0]

Lyude Paul (1):
      PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary
         [e0547c81bfcfad01cbbfa93a5e66bb98ab932f80]

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connections
         [d5bb334a8e171b262e48f378bd2096c0ea458265]
      Bluetooth: Fix regression with minimum encryption key size alignment
         [693cd8ce3f882524a5d06f7800dd8492411877b3]

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check
         [eca94432934fe5f141d084f2e36ee2c0e614cc04]

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking
         [b60fe990c6b07ef6d4df67bc0530c7c90a62623a]

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment
         [a47686636d84eaec5c9c6e84bd5f96bed34d526d]

Miklos Szeredi (2):
      fuse: fallocate: fix return with locked inode
         [35d6fcbb7c3e296a52136347346a698a35af3fda]
      fuse: fix writepages on 32bit
         [9de5be06d0a89ca97b5ab902694d42dfd2bb77d2]

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero
         [fdc6bae940ee9eb869e493990540098b8c0fd6ab]

Noralf Trønnes (1):
      drm/fb-helper: dpms_legacy(): Only set on connectors in use
         [65a102f68005891d7f39354cfd79099908df6d51]

Oliver Neukum (5):
      USB: rio500: refuse more than one device at a time
         [3864d33943b4a76c6e64616280e98d2410b1190f]
      USB: serial: use variable for status
         [3161da970d38cd6ed2ba8cadec93874d1d06e11e]
      USB: sisusbvga: fix oops in error path of sisusb_probe
         [9a5729f68d3a82786aea110b1bfe610be318f80a]
      cdc-acm: fix race between callback and unthrottle
         [36e59e0d70d6150e7a2155c54612ea875e88ce8d]
      media: cpia2_usb: first wake up, then free in disconnect
         [eff73de2b1600ad8230692f00bc0ab49b166512a]

Pan Bian (1):
      p54: drop device reference count if fails to enable device
         [8149069db81853570a665f5e5648c0e526dc0e43]

Peter Zijlstra (1):
      x86/uaccess: Dont leak the AC flag into __put_user() argument evaluation
         [6ae865615fc43d014da2fd1f1bba7e81ee622d1b]

Petr Štetiar (1):
      mwl8k: Fix rate_idx underflow
         [6b583201fa219b7b1b6aebd8966c8fd9357ef9f4]

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device
         [347ab9480313737c0f1aaa08e8f2e1a791235535]

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()
         [440868661f36071886ed360d91de83bd67c73b4f]

Romain Izard (1):
      usb: cdc-acm: fix race during wakeup blocking TX traffic
         [93e1c8a638308980309e009cc40b5a57ef87caf1]

S.j. Wang (1):
      ASoC: fsl_esai: Fix missing break in switch statement
         [903c220b1ece12f17c868e43f2243b8f81ff2d4c]

Sanjay Konduri (1):
      rsi: add fix for crash during assertions
         [abd39c6ded9db53aa44c2540092bdd5fb6590fa8]

Sebastian Andrzej Siewior (1):
      smpboot: Place the __percpu annotation correctly
         [d4645d30b50d1691c26ff0f8fa4e718b08f8d3bb]

Sergei Trofimovich (1):
      tty/vt: fix write/write race in ioctl(KDSKBSENT) handler
         [46ca3f735f345c9d87383dd3a09fa5d43870770e]

Shuning Zhang (1):
      ocfs2: fix ocfs2 read inode data panic in ocfs2_iget
         [e091eab028f9253eac5c04f9141bbc9d170acab3]

Slava Pestov (1):
      bcache: fix memory corruption in init error path
         [c9a78332b42cbdcdd386a95192a716b67d1711a4]

Stefan Mätje (2):
      PCI: Factor out pcie_retrain_link() function
         [86fa6a344209d9414ea962b1f1ac6ade9dd7563a]
      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum
         [4ec73791a64bab25cabf16a6067ee478692e506d]

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop
         [38c73529de13e1e10914de7030b659a2f8b01c3b]

Steve Twiss (1):
      mfd: da9063: Fix OTP control register names to match datasheets for DA9063/63L
         [6b4814a9451add06d457e198be418bf6a3e6a990]

Stuart Menefy (1):
      ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260
         [b7ed69d67ff0788d8463e599dd5dd1b45c701a7e]

Takashi Iwai (3):
      ALSA: hda/realtek - Fix overridden device-specific initialization
         [89781d0806c2c4f29072d3f00cb2dd4274aabc3d]
      ALSA: line6: Fix write on zero-sized buffer
         [3450121997ce872eb7f1248417225827ea249710]
      ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()
         [328e9f6973be2ee67862cb17bf6c0c5c5918cd72]

Tetsuo Handa (1):
      kobject: Don't trigger kobject_uevent(KOBJ_REMOVE) twice.
         [c03a0fd0b609e2f5c669c2b7f27c8e1928e9196e]

Tony Lindgren (1):
      ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()
         [7f0d078667a494466991aa7133f49594f32ff6a2]

Vincenzo Frascino (1):
      arm64: compat: Reduce address limit
         [d263119387de9975d2acba1dfd3392f7c5979c18]

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings
         [7caac62ed598a196d6ddf8d9c121e12e082cac3a]

Wenwen Wang (1):
      ALSA: usb-audio: Fix a memory leak bug
         [cb5173594d50c72b7bfa14113dfc5084b4d2f726]

Wolfram Sang (1):
      rtc: don't reference bogus function pointer in kdoc
         [c48cadf5bf4becefcd0751b97995d2350aa9bb57]

Yongduan (1):
      vhost: make sure log_num < in_num
         [060423bfdee3f8bc6e2c1bac97de24d5415e2bc4]

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer
         [79c92ca42b5a3e0ea172ea2ce8df8e125af237da]

YueHaibing (4):
      ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"
         [9ee8578d953023cc57e7e736ae48502c707c0210]
      appletalk: Fix use-after-free in atalk_proc_exit
         [6377f787aeb945cae7abbb6474798de129e1f3ac]
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
         [09ac2694b0475f96be895848687ebcbba97eeecf]
      ehea: Fix a copy-paste err in ehea_init_port_res
         [c8f191282f819ab4e9b47b22a65c6c29734cefce]

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount
         [f02f3755dbd14fb935d24b14650fff9ba92243b8]

 Documentation/x86/mds.rst                         |  44 ++-------
 Makefile                                          |   4 +-
 arch/arm/boot/dts/exynos5260.dtsi                 |   2 +-
 arch/arm/crypto/aesbs-glue.c                      |   4 +
 arch/arm/mach-omap2/omap_hwmod.c                  |   2 +-
 arch/arm/plat-pxa/ssp.c                           |   6 --
 arch/arm64/include/asm/memory.h                   |   8 ++
 arch/powerpc/include/asm/reg_booke.h              |   2 +-
 arch/powerpc/platforms/83xx/usb.c                 |   4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c           |  13 +--
 arch/x86/include/asm/uaccess.h                    |   7 +-
 arch/x86/kernel/traps.c                           |   8 --
 crypto/crct10dif_generic.c                        |  11 +--
 crypto/salsa20_generic.c                          |   2 +-
 drivers/bluetooth/hci_ldisc.c                     |  10 +-
 drivers/bluetooth/hci_uart.h                      |   1 +
 drivers/clk/tegra/clk-pll.c                       |   4 +-
 drivers/gpu/drm/drm_fb_helper.c                   |  11 +--
 drivers/gpu/drm/radeon/radeon_display.c           |   4 +-
 drivers/hwmon/f71805f.c                           |  15 ++-
 drivers/hwmon/pc87427.c                           |  14 ++-
 drivers/hwmon/smsc47b397.c                        |  13 ++-
 drivers/hwmon/smsc47m1.c                          |  28 ++++--
 drivers/hwmon/vt1211.c                            |  15 ++-
 drivers/hwmon/w83627hf.c                          |  42 +++++++-
 drivers/infiniband/hw/cxgb4/cm.c                  |   2 +
 drivers/iommu/intel-iommu.c                       |   7 +-
 drivers/md/bcache/journal.c                       |  11 ++-
 drivers/md/bcache/super.c                         |  13 ++-
 drivers/media/i2c/soc_camera/ov6650.c             |   2 +
 drivers/media/pci/cx18/cx18-fileops.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c             |   2 +-
 drivers/media/platform/davinci/isif.c             |   9 --
 drivers/media/platform/davinci/vpbe.c             |   2 +-
 drivers/media/platform/omap/omap_vout.c           |  15 ++-
 drivers/media/radio/radio-raremono.c              |  30 ++++--
 drivers/media/radio/wl128x/fmdrv_common.c         |  13 ++-
 drivers/media/usb/cpia2/cpia2_usb.c               |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c           |   2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h           |   1 +
 drivers/media/usb/siano/smsusb.c                  |  33 ++++---
 drivers/media/usb/tlg2300/Kconfig                 |   1 +
 drivers/net/bonding/bond_options.c                |   7 --
 drivers/net/ethernet/arc/emac_main.c              |   9 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h          |   2 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c |   8 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |   2 +-
 drivers/net/wireless/at76c50x-usb.c               |   4 +-
 drivers/net/wireless/ath/ath6kl/wmi.c             |  10 +-
 drivers/net/wireless/mwifiex/ie.c                 |   3 +
 drivers/net/wireless/mwifiex/uap_cmd.c            |  17 +++-
 drivers/net/wireless/mwl8k.c                      |  13 ++-
 drivers/net/wireless/p54/p54pci.c                 |   3 +-
 drivers/net/wireless/p54/p54usb.c                 |  43 ++++----
 drivers/net/wireless/rsi/rsi_91x_mac80211.c       |   1 +
 drivers/pci/pcie/aspm.c                           |  49 +++++++---
 drivers/pci/quirks.c                              |  76 +++++++++++++++
 drivers/platform/x86/alienware-wmi.c              |  19 ++--
 drivers/platform/x86/sony-laptop.c                |   8 +-
 drivers/pwm/core.c                                |  10 +-
 drivers/pwm/pwm-tiehrpwm.c                        |   2 +
 drivers/pwm/sysfs.c                               |  14 +--
 drivers/rtc/interface.c                           |   7 +-
 drivers/scsi/libsas/sas_expander.c                |   2 +
 drivers/scsi/qla2xxx/qla_attr.c                   |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  34 ++++---
 drivers/scsi/qla4xxx/ql4_os.c                     |   2 +-
 drivers/spi/spi-rspi.c                            |  48 +++++----
 drivers/staging/comedi/drivers/dt282x.c           |   3 +-
 drivers/staging/line6/pcm.c                       |   5 +
 drivers/tty/serial/serial_core.c                  |  15 ++-
 drivers/tty/vt/keyboard.c                         |  33 +++++--
 drivers/usb/class/cdc-acm.c                       | 113 +++++++++++++++++-----
 drivers/usb/class/cdc-acm.h                       |   4 +
 drivers/usb/misc/rio500.c                         |  24 +++--
 drivers/usb/misc/sisusbvga/sisusb.c               |  15 +--
 drivers/usb/serial/generic.c                      |  57 ++++++++---
 drivers/usb/serial/usb-serial.c                   |  11 ++-
 drivers/vhost/vhost.c                             |   4 +-
 drivers/video/backlight/lm3630a_bl.c              |   4 +-
 drivers/virt/fsl_hypervisor.c                     |  26 ++---
 fs/ceph/super.c                                   |   7 ++
 fs/cifs/smb2ops.c                                 |  14 +--
 fs/ext4/file.c                                    |   7 ++
 fs/ext4/ioctl.c                                   |   2 +-
 fs/fuse/file.c                                    |   9 +-
 fs/gfs2/rgrp.c                                    |  12 ++-
 fs/jbd2/journal.c                                 |   4 +
 fs/nfs/nfs4state.c                                |   4 +
 fs/ocfs2/export.c                                 |  30 +++++-
 fs/xfs/xfs_super.c                                |  10 ++
 include/linux/atalk.h                             |  20 +++-
 include/linux/ieee80211.h                         |   3 +
 include/linux/mfd/da9063/registers.h              |   6 +-
 include/linux/of.h                                |   4 +-
 include/linux/pci.h                               |   2 +
 include/linux/pwm.h                               |   5 -
 include/linux/smpboot.h                           |   2 +-
 include/media/davinci/vpbe.h                      |   2 +-
 include/net/bluetooth/hci_core.h                  |   3 +
 include/net/mac80211.h                            |  13 +++
 kernel/debug/kdb/kdb_main.c                       |   2 +-
 kernel/time/ntp.c                                 |   2 +-
 kernel/trace/trace_events.c                       |   3 -
 lib/kobject_uevent.c                              |   9 +-
 net/appletalk/atalk_proc.c                        |   2 +-
 net/appletalk/ddp.c                               |  37 +++++--
 net/appletalk/sysctl_net_atalk.c                  |   5 +-
 net/bluetooth/hci_conn.c                          |  10 +-
 net/bluetooth/l2cap_core.c                        |  34 +++++--
 net/bridge/netfilter/ebtables.c                   |   4 +-
 net/ipv4/raw.c                                    |   6 +-
 net/mac80211/ieee80211_i.h                        |   3 +
 net/mac80211/mlme.c                               |  16 ++-
 net/mac80211/rx.c                                 |   2 +
 net/mac80211/tdls.c                               |  40 ++++++++
 sound/pci/hda/hda_generic.c                       |   3 +-
 sound/pci/hda/hda_generic.h                       |   1 +
 sound/pci/hda/patch_hdmi.c                        |   6 ++
 sound/pci/hda/patch_realtek.c                     |   5 +-
 sound/soc/codecs/max98090.c                       |  12 +--
 sound/soc/fsl/fsl_esai.c                          |   1 +
 sound/usb/mixer.c                                 |  36 +++++--
 tools/testing/selftests/ipc/msgque.c              |  11 ++-
 virt/kvm/coalesced_mmio.c                         |  17 ++--
 125 files changed, 1070 insertions(+), 489 deletions(-)

-- 
Ben Hutchings
Nothing is ever a complete failure;
it can always serve as a bad example.

