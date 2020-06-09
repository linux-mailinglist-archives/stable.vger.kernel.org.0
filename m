Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616641F4515
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgFISF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:05:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41194 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730284AbgFISFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-0001oG-I5; Tue, 09 Jun 2020 19:05:52 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006VuT-1M; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 09 Jun 2020 19:03:51 +0100
Message-ID: <lsq.1591725831.850867383@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/61] 3.16.85-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.85 release.
There are 61 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 11 18:03:51 UTC 2020.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Akinobu Mita (1):
      sg: prevent integer overflow when converting from sectors to bytes
         [46f69e6a6bbbf3858617c8729e31895846c15a79]

Alan Stern (1):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
         [056ad39ee9253873522f6469c3364964a322912b]

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()
         [1d605416fb7175e1adf094251466caa52093b413]

Ben Hutchings (2):
      scsi: sg: Change next_cmd_len handling to mirror upstream
         [65c26a0f39695ba01d9693754f27ca76cc8a3ab5,
          bf33f87dd04c371ea33feb821b60d63d754e3124]
      scsi: sg: Re-fix off by one in sg_fill_request_table()
         [587c3c9f286cee5c9cac38d28c8ae1875f4ec85b]

Colin Ian King (1):
      ext4: unsigned int compared against zero
         [fbbbbd2f28aec991f3fbc248df211550fbdfd58c]

Dan Carpenter (3):
      scsi: mptfusion: Add bounds check in mptctl_hp_targetinfo()
         [a7043e9529f3c367cc4d82997e00be034cbe57ca]
      scsi: mptfusion: Fix double fetch bug in ioctl
         [28d76df18f0ad5bcf5fa48510b225f0ed262a99b]
      scsi: sg: off by one in sg_ioctl()
         [bd46fc406b30d1db1aff8dabaff8d18bb423fdcf]

David Mosberger (2):
      drivers: usb: core: Don't disable irqs in usb_sg_wait() during URB submit.
         [98b74b0ee57af1bcb6e8b2e76e707a71c5ef8ec9]
      drivers: usb: core: Minimize irq disabling in usb_sg_cancel()
         [5f2e5fb873e269fcb806165715d237f0de4ecf1d]

Douglas Gilbert (1):
      sg: O_EXCL and other lock handling
         [cc833acbee9db5ca8c6162b015b4c93863c6f821]

Eric Dumazet (1):
      net-sysfs: fix netdev_queue_add_kobject() breakage
         [48a322b6f9965b2f1e4ce81af972f0e287b07ed0]

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits
         [d1e7fd6462ca9fc76650fbe6ca800e35b24267da]

Hannes Reinecke (8):
      scsi: sg: close race condition in sg_remove_sfp_usercontext()
         [97d27b0dd015e980ade63fda111fd1353276e28b]
      scsi: sg: disable SET_FORCE_LOW_DMA
         [745dfa0d8ec26b24f3304459ff6e9eacc5c8351b]
      scsi: sg: factor out sg_fill_request_table()
         [4759df905a474d245752c9dc94288e779b8734dd]
      scsi: sg: fixup infoleak when using SG_GET_REQUEST_TABLE
         [3e0097499839e0fe3af380410eababe5a47c4cf9]
      scsi: sg: protect accesses to 'reserved' page array
         [1bc0eb0446158cc76562176b80623aa119afee5b]
      scsi: sg: remove 'save_scat_len'
         [136e57bf43dc4babbfb8783abbf707d483cacbe3]
      scsi: sg: reset 'res_in_use' after unlinking reserved array
         [e791ce27c3f6a1d3c746fd6a8f8e36c9540ec6f9]
      scsi: sg: use standard lists for sg_requests
         [109bade9c625c89bb5ea753aaa1a0a97e6fbb548]

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}
         [69efea712f5b0489e67d07565aad5c94e09a3e52]

Jia Zhang (1):
      x86/cpu: Rename cpu_data.x86_mask to cpu_data.x86_stepping
         [b399151cb48db30ad1e0e93dd40d68c6d007b637]

Johannes Thumshirn (5):
      scsi: sg: check for valid direction before starting the request
         [28676d869bbb5257b5f14c0c95ad3af3a7019dd5]
      scsi: sg: don't return bogus Sg_requests
         [48ae8484e9fc324b4968d33c585e54bc98e44d61]
      scsi: sg: fix SG_DXFER_FROM_DEV transfers
         [68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47]
      scsi: sg: fix static checker warning in sg_is_valid_dxfer
         [14074aba4bcda3764c9a702b276308b89901d5b6]
      scsi: sg: only check for dxfer_len greater than 256M
         [f930c7043663188429cd9b254e9d761edfc101ce]

Josh Poimboeuf (1):
      x86/speculation: Add Ivy Bridge to affected list
         [3798cc4d106e91382bfe016caa2edada27c2bb3f]

Jouni Hogander (7):
      can: slcan: Fix use-after-free Read in slcan_open
         [9ebd796e24008f33f06ebea5a5e6aceb68b51794]
      net-sysfs: Call dev_hold always in netdev_queue_add_kobject
         [e0b60903b434a7ee21ba8d8659f207ed84101e89]
      net-sysfs: Call dev_hold always in rx_queue_add_kobject
         [ddd9b5e3e765d8ed5a35786a6cb00111713fe161]
      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
         [b8eb718348b8fb30b5a7d0a8fce26fb3f4ac741b]
      slcan: Fix memory leak in error path
         [ed50e1600b4483c049ce76e6bd3b665a6a9300ed]
      slip: Fix memory leak in slip_open error path
         [3b5a39979dafea9d0cd69c7ae06088f7a84cdafa]
      slip: Fix use-after-free Read in slip_open
         [e58c1912418980f57ba2060017583067f5f71e52]

Kyungtae Kim (1):
      USB: gadget: fix illegal array access in binding with UDC
         [15753588bcd4bbffae1cca33c8ced5722477fe1f]

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write
         [849f8583e955dbe3a1806e03ecacd5e71cce0a08]

Marek Milkovic (1):
      selinux: Print 'sclass' as string when unrecognized netlink message occurs
         [cded3fffbeab777e6ad2ec05d4a3b62c5caca0f3]

Mark Gross (4):
      x86/cpu: Add 'table' argument to cpu_matches()
         [93920f61c2ad7edb01e63323832585796af75fc9]
      x86/cpu: Add a steppings field to struct x86_cpu_id
         [e9d7144597b10ff13ff2264c059f7d4a7fbc89ac]
      x86/speculation: Add SRBDS vulnerability and mitigation documentation
         [7222a1b5b87417f22265c92deea76a6aecd0fb0f]
      x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
         [7e5b3c267d256822407a22fdce6afdf9cd13f9fb]

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open
         [2091a3d42b4f339eaeed11228e0cbe9d4f92f558]

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()
         [fb73974172ffaaf57a7c42f35424d9aece1a5af6]

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()
         [b70261a288ea4d2f4ac7cd04be08a9f0f2de4f4d]
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
         [3a9b153c5591548612c3955c9600a98150c81875]

Richard Guy Briggs (2):
      selinux: cleanup error reporting in selinux_nlmsg_perm()
         [e173fb2646a832b424c80904c306b816760ce477]
      selinux: convert WARN_ONCE() to printk() in selinux_nlmsg_perm()
         [d950f84c1c6658faec2ecbf5b09f7e7191953394]

Shijie Luo (1):
      ext4: add cond_resched() to ext4_protect_reserved_inode
         [af133ade9a40794a37104ecbcc2827c0ea373a3c]

Tahsin Erdogan (1):
      ext4: Make checks for metadata_csum feature safer
         [dec214d00e0d78a08b947d7dccdfdb84407a9f4d]

Theodore Ts'o (3):
      ext4: don't perform block validity checks on the journal inode
         [0a944e8a6c66ca04c7afbaa17e22bf208a8b37f0]
      ext4: fix block validity checks for journal inodes using indirect blocks
         [170417c8c7bb2cbbdd949bf5c443c0c8f24a203b]
      ext4: protect journal inode's blocks using block_validity
         [345c0dbf3a30872d9b204db96b5857cd00808cae]

Todd Poynor (2):
      scsi: sg: protect against races between mmap() and SG_SET_RESERVED_SIZE
         [6a8dadcca81fceff9976e8828cceb072873b7bd5]
      scsi: sg: recheck MMAP_IO request length with lock held
         [8d26f491116feaa0b16de370b6a7ba40a40fa0b4]

Tony Battersby (1):
      scsi: sg: fix minor memory leak in error path
         [c170e5a8d222537e98aa8d4fddb667ff7a2ee114]

Vladis Dronov (1):
      selinux: rate-limit netlink message warnings in selinux_nlmsg_perm()
         [76319946f321e30872dd72af7de867cb26e7a373]

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write
         [83c6f2390040f188cc25b270b4befeb5628c1aee]

Yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open
         [f596c87005f7b1baeb7d62d9a9e25d68c3dfae10]

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 .../special-register-buffer-data-sampling.rst      | 149 ++++
 Documentation/kernel-parameters.txt                |  20 +
 Makefile                                           |   4 +-
 arch/x86/include/asm/acpi.h                        |   2 +-
 arch/x86/include/asm/cpu_device_id.h               |  27 +
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/include/uapi/asm/msr-index.h              |   4 +
 arch/x86/kernel/amd_nb.c                           |   2 +-
 arch/x86/kernel/asm-offsets_32.c                   |   2 +-
 arch/x86/kernel/cpu/amd.c                          |  28 +-
 arch/x86/kernel/cpu/bugs.c                         | 106 +++
 arch/x86/kernel/cpu/centaur.c                      |   4 +-
 arch/x86/kernel/cpu/common.c                       |  62 +-
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/cyrix.c                        |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  18 +-
 arch/x86/kernel/cpu/match.c                        |   7 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   4 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   2 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |   2 +-
 arch/x86/kernel/cpu/proc.c                         |   4 +-
 arch/x86/kernel/head_32.S                          |   4 +-
 arch/x86/kernel/mpparse.c                          |   2 +-
 drivers/base/cpu.c                                 |   8 +
 drivers/char/hw_random/via-rng.c                   |   2 +-
 drivers/char/random.c                              |   3 -
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/longhaul.c                         |   6 +-
 drivers/cpufreq/p4-clockmod.c                      |   2 +-
 drivers/cpufreq/powernow-k7.c                      |   2 +-
 drivers/cpufreq/speedstep-centrino.c               |   4 +-
 drivers/cpufreq/speedstep-lib.c                    |   6 +-
 drivers/crypto/padlock-aes.c                       |   2 +-
 drivers/edac/amd64_edac.c                          |   2 +-
 drivers/edac/mce_amd.c                             |   2 +-
 drivers/hwmon/coretemp.c                           |   6 +-
 drivers/hwmon/hwmon-vid.c                          |   2 +-
 drivers/hwmon/k10temp.c                            |   2 +-
 drivers/hwmon/k8temp.c                             |   2 +-
 drivers/message/fusion/mptctl.c                    | 215 ++----
 drivers/net/can/slcan.c                            |   4 +
 drivers/net/slip/slip.c                            |   4 +
 drivers/net/wireless/mwifiex/scan.c                |   7 +
 drivers/net/wireless/mwifiex/wmm.c                 |   4 +
 drivers/scsi/sg.c                                  | 758 +++++++++++----------
 drivers/usb/core/message.c                         |  53 +-
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/video/fbdev/geode/video_gx.c               |   2 +-
 fs/binfmt_elf.c                                    |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/block_validity.c                           |  57 ++
 fs/ext4/ext4.h                                     |  19 +-
 fs/ext4/extents.c                                  |  13 +-
 fs/ext4/inode.c                                    |   5 +
 include/linux/mod_devicetable.h                    |   6 +
 include/linux/sched.h                              |   4 +-
 include/scsi/sg.h                                  |   1 -
 kernel/signal.c                                    |   2 +-
 net/core/net-sysfs.c                               |  39 +-
 security/selinux/hooks.c                           |  70 +-
 65 files changed, 1103 insertions(+), 689 deletions(-)

-- 
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

