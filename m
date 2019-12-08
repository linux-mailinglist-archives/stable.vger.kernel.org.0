Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23A6116259
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLHN7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:59:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59918 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbfLHNyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:38 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0007cx-KY; Sun, 08 Dec 2019 13:54:36 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002KM-5a; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sun, 08 Dec 2019 13:52:44 +0000
Message-ID: <lsq.1575813164.154362148@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/72] 3.16.79-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.79 release.
There are 72 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Dec 10 18:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (1):
      configfs: fix a deadlock in configfs_symlink()
         [351e5d869e5ac10cb40c78b5f2d7dfc816ad4587]

Alan Stern (4):
      HID: Fix assumption that devices have inputs
         [d9d4b1e46d9543a82c23f6df03f4ad697dab361b]
      HID: hidraw: Fix invalid read in hidraw_ioctl
         [416dacb819f59180e4d86a5550052033ebb6d72c]
      HID: prodikeys: Fix general protection fault during probe
         [98375b86c79137416e9fd354177b85e768c16e56]
      USB: usbcore: Fix slab-out-of-bounds bug during device reset
         [3dd550a2d36596a1b0ee7955da3b611c031d3873]

Arnd Bergmann (1):
      media: dib0700: fix link error for dibx000_i2c_set_speed
         [765bb8610d305ee488b35d07e2a04ae52fb2df9c]

Chris Brandt (1):
      i2c: riic: Clear NACK in tend isr
         [a71e2ac1f32097fbb2beab098687a7a95c84543e]

Colin Ian King (2):
      USB: adutux: remove redundant variable minor
         [8444efc4a052332d643ed5c8aebcca148c7de032]
      ext4: set error return correctly when ext4_htree_store_dirent fails
         [7a14826ede1d714f0bb56de8167c0e519041eeda]

David Howells (1):
      hypfs: Fix error number left in struct pointer member
         [b54c64f7adeb241423cd46598f458b5486b0375e]

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change
         [c1d3ad84eae35414b6b334790048406bd6301b12]

Douglas Anderson (1):
      video: of: display_timing: Add of_node_put() in of_get_display_timing()
         [4faba50edbcc1df467f8f308893edc3fdd95536e]

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock
         [e5bfad3d7acc5702f32aafeb388362994f4d7bd0]

Eric Dumazet (1):
      sch_netem: fix a divide by zero in tabledist()
         [b41d936b5ecfdb3a4abc525ce6402a6c49cffddc]

Filipe Manana (1):
      Btrfs: fix use-after-free when using the tree modification log
         [efad8a853ad2057f96664328a0d327a05ce39c76]

Grzegorz Halat (1):
      x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails
         [747d5a1bf293dcb33af755a6d285d41b8c1ea010]

Hans de Goede (1):
      media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
         [7e0bb5828311f811309bed5749528ca04992af2f]

Helge Deller (1):
      parisc: Disable HP HSC-PCI Cards to prevent kernel crash
         [5fa1659105fac63e0f3c199b476025c2e04111ce]

Herbert Xu (1):
      crypto: user - Fix crypto_alg_match race
         [016baaa1183bb0c5fb2a7de42413bba8a51c1bc8]

Hillf Danton (2):
      HID: hiddev: avoid opening a disconnected device
         [9c09b214f30e3c11f9b0b03f89442df03643794d]
      HID: hiddev: do cleanup in failure of opening a device
         [6d4472d7bec39917b54e4e80245784ea5d60ce49]

Ido Schimmel (1):
      thermal: Fix use-after-free when unregistering thermal zone device
         [1851799e1d2978f68eea5d9dff322e121dcf59c1]

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is set
         [3675f052b43ba51b99b85b073c7070e083f3e6fb]

Jean-Michel Hautbois (1):
      ASoC: sgtl5000: fix VAG power up timing
         [c803cc2dcd722e08020c1ba63bb5ceece4a19fdb]

Johan Hovold (3):
      USB: adutux: fix use-after-free on disconnect
         [44efc269db7929f6275a1fa927ef082e533ecde0]
      USB: iowarrior: fix use-after-free on disconnect
         [edc4746f253d907d048de680a621e121517f484b]
      can: peak_usb: fix slab info leak
         [f7a1337f0d29b98733c8824e165fca3371d7d4fd]

Johannes Berg (3):
      ALSA: aoa: onyx: always initialize register read value
         [f474808acb3c4b30552d9c59b181244e0300d218]
      cfg80211: add and use strongly typed element iteration macros
         [0f3b07f027f87a38ebe5c436490095df762819be]
      nl80211: validate beacon head
         [f88eb7c0d002a67ef31aeb7850b42ff69abc46dc]

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()
         [78887832e76541f77169a24ac238fccb51059b63]

Luis Araneda (1):
      ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
         [b7005d4ef4f3aa2dc24019ffba03a322557ac43d]

Marc Kleine-Budde (1):
      can: mcp251x: mcp251x_hw_reset(): allow more time after a reset
         [d84ea2123f8d27144e3f4d58cd88c9c6ddc799de]

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset
         [dd9782834dd9dde3624ff1acea8859f3d3e792d4]

Martijn Coenen (1):
      ANDROID: binder: remove waitqueue when thread exits.
         [f5cb779ba16334b45ba8946d6bfa6d9834d1527f]

Murphy Zhou (1):
      CIFS: fix max ea value size
         [63d37fb4ce5ae7bf1e58f906d1bf25f036fe79b2]

Nathan Lynch (2):
      powerpc/pseries: correctly track irq state in default idle
         [92c94dfb69e350471473fd3075c74bc68150879e]
      powerpc/rtas: use device model APIs and serialization during LPM
         [a6717c01ddc259f6f73364779df058e2c67309f8]

Navid Emamdoost (7):
      can: gs_usb: gs_can_open(): prevent memory leak
         [fb5be6a7b4863ecc44963bb80ca614584b6c7817]
      crypto: user - fix memory leak in crypto_report
         [ffdde5932042600c6807d46c1550b28b0db6a3bc]
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
         [db8fd2cde93227e566a412cf53173ffa227998bc]
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring
         [d10dcb615c8e29d403a24d35f8310a7a53e3050c]
      scsi: bfa: release allocated memory in case of error
         [0e62395da2bd5166d7c9e14cbc7503b256a34cb0]
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
         [6f3ef5c25cc762687a7341c18cbea5af54461407]
      wimax: i2400: fix memory leak
         [2507e6ab7a9a440773be476141a255934468c5ef]

Nick Stoughton (1):
      leds: leds-lp5562 allow firmware files up to the maximum length
         [ed2abfebb041473092b41527903f93390d38afa7]

Nikolay Borisov (1):
      btrfs: Relinquish CPUs in btrfs_compare_trees
         [6af112b11a4bc1b560f60a618ac9c1dcefe9836e]

Oleksandr Suvorov (2):
      ASoC: Define a set of DAPM pre/post-up events
         [cfc8f568aada98f9608a0a62511ca18d647613e2]
      ASoC: sgtl5000: Improve VAG power and mute control
         [b1f373a11d25fc9a5f7679c9b85799fe09b0dc4a]

Oliver Neukum (3):
      Input: ff-memless - kill timer in destroy()
         [fa3a5a1880c91bb92594ad42dfe9eedad7996b86]
      media: b2c2-flexcop-usb: add sanity checking
         [1b976fc6d684e3282914cdbe7a8d68fdce19095c]
      usb: iowarrior: fix deadlock on disconnect
         [c468a8aa790e0dfe0a7f8a39db282d39c2c00b46]

Paolo Bonzini (1):
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)
         [433f4ba1904100da65a311033f17a9bf586b287e]

Pavel Shilovsky (1):
      CIFS: Fix oplock handling for SMB 2.1+ protocols
         [a016e2794fc3a245a91946038dd8f34d65e53cc3]

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function
         [e47488b2df7f9cb405789c7f5d4c27909fc597ae]

Prabhakar Lad (1):
      fbdev: ssd1307fb: return proper error code if write command fails
         [5b72ae9a901cbfbe632570f278486142b037fe51]

Rakesh Pandit (1):
      ext4: fix warning inside ext4_convert_unwritten_extents_endio
         [e3d550c2c4f2f3dba469bc3c4b83d9332b4e99e1]

Sean Christopherson (1):
      KVM: x86: Manually calculate reserved bits when loading PDPTRS
         [16cfacc8085782dab8e365979356ce1ca87fd6cc]

Sean Young (1):
      media: tm6000: double free if usb disconnect while streaming
         [699bf94114151aae4dceb2d9dbf1a6312839dcae]

Shih-Yuan Lee (1):
      ALSA: hda - Add laptop imic fixup for ASUS M9V laptop
         [7b485d175631be676424aedb8cd2f66d0c93da78]

Tetsuo Handa (1):
      /dev/mem: Bail out upon SIGKILL.
         [8619e5bdeee8b2c685d686281f2d2a6017c4bc15]

Tiejun Chen (1):
      KVM: mmio: cleanup kvm_set_mmio_spte_mask
         [d143148383d0395539073dd6c2f25ddf6656bdcc]

Tokunori Ikegami (1):
      mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()
         [37c673ade35c707d50583b5b25091ff8ebdeafd7]

Tomas Bortoli (1):
      media: ttusb-dec: Fix info-leak in ttusb_dec_send_command()
         [a10feaf8c464c3f9cfdd3a8a7ce17e1c0d498da1]

Vasily Averin (1):
      fuse: fix missing unlock_page in fuse_writepage()
         [d5880c7a8620290a6c90ced7a0e8bd0ad9419601]

Vasily Gorbik (3):
      s390/cio: avoid calling strlen on null pointer
         [ea298e6ee8b34b3ed4366be7eb799d0650ebe555]
      s390/cio: exclude subchannels with no parent from pseudo check
         [ab5758848039de9a4b249d46e4ab591197eebaf2]
      s390/topology: avoid firing events before kobjs are created
         [f3122a79a1b0a113d3aea748e0ec26f2cb2889de]

Xiaofei Tan (1):
      efi: cper: print AER info of PCIe fatal error
         [b194a77fcc4001dc40aecdd15d249648e8a436d1]

YueHaibing (3):
      appletalk: Fix potential NULL pointer dereference in unregister_snap_client
         [9804501fa1228048857910a6bf23e085aade37cc]
      appletalk: Set error code if register_snap_client failed
         [c93ad1337ad06a718890a89cdd85188ff9a5a5cc]
      libertas_tf: Use correct channel range in lbtf_geo_init
         [2ec4ad49b98e4a14147d04f914717135eca7c8b1]

 Makefile                                     |   4 +-
 arch/arm/mach-zynq/platsmp.c                 |   2 +-
 arch/powerpc/kernel/rtas.c                   |  11 +-
 arch/powerpc/platforms/pseries/setup.c       |   3 +
 arch/s390/hypfs/inode.c                      |   9 +-
 arch/s390/kernel/topology.c                  |   3 +-
 arch/x86/kernel/smp.c                        |  46 +++---
 arch/x86/kvm/cpuid.c                         |   5 +-
 arch/x86/kvm/mmu.c                           |   5 -
 arch/x86/kvm/mmu.h                           |   5 +
 arch/x86/kvm/x86.c                           |  12 +-
 crypto/crypto_user.c                         |  43 ++++--
 drivers/char/hw_random/core.c                |   2 +-
 drivers/char/mem.c                           |  21 +++
 drivers/firmware/efi/cper.c                  |  15 ++
 drivers/hid/hid-axff.c                       |  11 +-
 drivers/hid/hid-dr.c                         |  12 +-
 drivers/hid/hid-emsff.c                      |  12 +-
 drivers/hid/hid-gaff.c                       |  12 +-
 drivers/hid/hid-holtekff.c                   |  12 +-
 drivers/hid/hid-lg2ff.c                      |  12 +-
 drivers/hid/hid-lg3ff.c                      |  11 +-
 drivers/hid/hid-lg4ff.c                      |  11 +-
 drivers/hid/hid-lgff.c                       |  11 +-
 drivers/hid/hid-prodikeys.c                  |  12 +-
 drivers/hid/hid-sony.c                       |  12 +-
 drivers/hid/hid-tmff.c                       |  12 +-
 drivers/hid/hid-zpff.c                       |  12 +-
 drivers/hid/hidraw.c                         |   2 +-
 drivers/hid/usbhid/hiddev.c                  |  12 ++
 drivers/i2c/busses/i2c-riic.c                |   1 +
 drivers/input/ff-memless.c                   |   9 ++
 drivers/leds/leds-lp5562.c                   |   6 +-
 drivers/media/usb/b2c2/flexcop-usb.c         |   3 +
 drivers/media/usb/dvb-usb/dib0700_devices.c  |   8 +
 drivers/media/usb/gspca/sn9c20x.c            |   7 +
 drivers/media/usb/tm6000/tm6000-dvb.c        |   3 +
 drivers/media/usb/ttusb-dec/ttusb_dec.c      |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c          |  19 ++-
 drivers/net/can/spi/mcp251x.c                |  19 ++-
 drivers/net/can/usb/gs_usb.c                 |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |   2 +-
 drivers/net/phy/national.c                   |   9 +-
 drivers/net/wimax/i2400m/op-rfkill.c         |   1 +
 drivers/net/wireless/libertas_tf/cmd.c       |   2 +-
 drivers/net/wireless/mwifiex/pcie.c          |   9 +-
 drivers/parisc/dino.c                        |  24 +++
 drivers/s390/cio/ccwgroup.c                  |   2 +-
 drivers/s390/cio/css.c                       |   2 +
 drivers/scsi/bfa/bfad_attr.c                 |   4 +-
 drivers/staging/android/binder.c             |  17 ++-
 drivers/thermal/thermal_core.c               |   2 +-
 drivers/usb/core/config.c                    |  12 +-
 drivers/usb/misc/adutux.c                    |   9 +-
 drivers/usb/misc/iowarrior.c                 |   8 +-
 drivers/video/fbdev/ssd1307fb.c              |  67 +++++++--
 drivers/video/of_display_timing.c            |   7 +-
 fs/btrfs/ctree.c                             |   5 +-
 fs/cifs/smb2ops.c                            |   5 +
 fs/cifs/xattr.c                              |   2 +-
 fs/configfs/symlink.c                        |  33 +++-
 fs/ext4/extents.c                            |   4 +-
 fs/ext4/inline.c                             |   2 +-
 fs/fuse/file.c                               |   1 +
 include/linux/atalk.h                        |   2 +-
 include/linux/ieee80211.h                    |  53 +++++++
 include/sound/soc-dapm.h                     |   2 +
 net/appletalk/aarp.c                         |  15 +-
 net/appletalk/ddp.c                          |  21 ++-
 net/sched/sch_netem.c                        |   2 +-
 net/wireless/nl80211.c                       |  35 +++++
 net/wireless/util.c                          |   1 +
 security/smack/smack_access.c                |   4 +-
 security/smack/smack_lsm.c                   |   5 +-
 sound/aoa/codecs/onyx.c                      |   4 +-
 sound/pci/hda/patch_analog.c                 |   1 +
 sound/soc/codecs/sgtl5000.c                  | 216 +++++++++++++++++++++++----
 77 files changed, 830 insertions(+), 190 deletions(-)

-- 
Ben Hutchings
Never attribute to conspiracy what can adequately be explained
by stupidity.

