Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9131B7A93
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgDXPtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:49:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56246 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbgDXPtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:49:39 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a8-0001hO-HO; Fri, 24 Apr 2020 16:49:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a7-00FNGM-Sz; Fri, 24 Apr 2020 16:49:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 24 Apr 2020 16:47:25 +0100
Message-ID: <lsq.1587743245.5555628@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/247] 3.16.83-rc2 review
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.83 release.
There are 247 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Apr 28 18:00:00 UTC 2020.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (2):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late
         [d0cb50185ae942b03c4327be322055d622dc79f6]
      vfs: fix do_last() regression
         [6404674acd596de41fd3ad5f267b4525494a891a]

Alan Cox (1):
      usb: dwc3: pci: Add PCI ID for Intel Braswell
         [7d643664ea559b36188cae264047ce3c9bfec3a2]

Alan Stern (1):
      HID: Fix slab-out-of-bounds read in hid_field_extract
         [8ec321e96e056de84022c032ffea253431a83c3c]

Alberto Aguirre (2):
      ALSA: usb-audio: add implicit fb quirk for Axe-Fx II
         [17f08b0d9aafccdb10038ab6dbd9ddb6433c13e2]
      ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk
         [103e9625647ad74d201e26fb74afcd8479142a37]

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types
         [927d780ee371d7e121cea4fc7812f6ef2cea461c]

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks
         [98ca480a8f22fdbd768e3dad07024c8d4856576c]

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry
         [4911ee401b7ceff8f38e0ac597cbf503d71e690c]

Arnd Bergmann (2):
      btrfs: tree-checker: use %zu format string for size_t
         [7cfad65297bfe0aa2996cd72d21c898aa84436d9]
      scsi: fnic: fix invalid stack access
         [42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf]

Avinash Patil (1):
      mwifiex: fix probable memory corruption while processing TDLS frame
         [3c99832d74777c9ec5545a92450fac5d37b0d0e1]

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()
         [65b1aae0d9d5962faccc06bdb8e91a2a0b09451c]

Cengiz Can (1):
      blktrace: fix dereference after null check
         [153031a301bb07194e9c37466cfce8eacb977621]

Chao Yu (1):
      quota: fix wrong condition in is_quota_modification()
         [6565c182094f69e4ffdece337d395eb7ec760efc]

Chen-Yu Tsai (1):
      net: stmmac: dwmac-sunxi: Allow all RGMII modes
         [52cc73e5404c7ba0cbfc50cb4c265108c84b3d5a]

Christian Brauner (1):
      taskstats: fix data-race
         [0b8d616fb5a8ffa307b1d3af37f55c15dae14f28]

Christophe Leroy (1):
      powerpc/irq: fix stack overflow verification
         [099bc4812f09155da77eeb960a983470249c9ce1]

Cong Wang (2):
      net_sched: fix datalen for ematch
         [61678d28d4a45ef376f5d02a839cc37509ae9281]
      netfilter: fix a use-after-free in mtype_destroy()
         [c120959387efa51479056fd01dc90adfba7a590c]

Dan Carpenter (1):
      scsi: iscsi: qla4xxx: fix double free in probe
         [fee92f25777789d73e1936b91472e9c4644457c8]

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between zones
         [63341ab03706e11a31e3dd8ccc0fbc9beaf723f0]

David Sterba (6):
      btrfs: add more checks to btrfs_read_sys_array
         [e3540eab29e1b2260bc4b9b3979a49a00e3e3af8]
      btrfs: cleanup, rename a few variables in btrfs_read_sys_array
         [1ffb22cf8c322bbfea6b35fe23d025841b49fede]
      btrfs: handle invalid num_stripes in sys_array
         [f5cdedd73fa71b74dcc42f2a11a5735d89ce7c4f]
      btrfs: kill extent_buffer_page helper
         [fb85fc9a675738ee2746b51c3aedde944b18ca02]
      btrfs: new define for the inline extent data start
         [7ec20afbcb7b257aec82ea5d66e6b0b7499abaca]
      btrfs: tree-check: reduce stack consumption in check_dir_item
         [e2683fc9d219430f5b78889b50cde7f40efeba7b]

Davidlohr Bueso (1):
      blktrace: re-write setting q->blk_trace
         [cdea01b2bf98affb7e9c44530108a4a28535eee8]

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function
         [30ca1aa536211f5ac3de0173513a7a99a98a97f3]

Dmitry Torokhov (5):
      HID: hid-input: clear unmapped usages
         [4f3882177240a1f55e45a3d241d3121341bead78]
      Input: add safety guards to input_set_keycode()
         [cb222aed03d798fc074be55e59d9a112338ee784]
      ptp: create "pins" together with the rest of attributes
         [85a66e55019583da1e0f18706b7a8281c9f6de5b]
      ptp: do not explicitly set drvdata in ptp_clock_register()
         [882f312dc0751c973db26478f07f082c584d16aa]
      ptp: use is_visible method to hide unused attributes
         [af59e717d5ff9c8dbf9bcc581c0dfb3b2a9c9030]

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function
         [1cd17f7f0def31e3695501c4f86cd3faf8489840]

Eric Dumazet (9):
      6pack,mkiss: fix possible deadlock
         [5c9934b6767b16ba60be22ec3cbd4379ad64170d]
      bonding: fix bond_neigh_init()
         [9e99bfefdbce2e23ef37487a3bcb4adf90a791d1]
      macvlan: do not assume mac_header is set in macvlan_broadcast()
         [96cc4b69581db68efc9749ef32e9cf8e0160c509]
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
         [1712b2fff8c682d145c7889d2290696647d82dab]
      neighbour: remove neigh_cleanup() method
         [f394722fb0d0f701119368959d7cd0ecbc46363a]
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
         [5604285839aaedfb23ebe297799c6e558939334d]
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
         [d9e15a2733067c9328fb56d98fe8e574fa19ec31]
      tcp: do not send empty skb from tcp_write_xmit()
         [1f85e6267caca44b30c54711652b0726fadbb131]
      vlan: vlan_changelink() should propagate errors
         [eb8ef2a3c50092bb018077c047b8dba1ce0e78e3]

Erkka Talvitie (1):
      USB: EHCI: Do not return -EPIPE when hub is disconnected
         [64cc3f12d1c7dd054a215bc1ff9cc2abcfe35832]

Eryu Guan (1):
      ext4: update c/mtime on truncate up
         [911af577de4e444622d46500c1f9a37ab4335d3a]

Eugenio Pérez (1):
      vhost: Check docket sk_family instead of call getname
         [42d84c8490f9f0931786f1623191fcab397c3d64]

Fabian Henneke (1):
      hidraw: Return EPOLLOUT from hidraw_poll
         [378b80370aa1fe50f9c48a3ac8af3e416e73b89f]

Felipe Balbi (3):
      usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices
         [dbb0569de852fb4576d6f62078d515f989a181ca]
      usb: dwc3: pci: add support for Comet Lake PCH ID
         [7ae622c978db6b2e28b4fced6ecd2a174492059d]
      usb: dwc3: pci: add support for TigerLake Devices
         [b3649dee5fbb0f6585010e6e9313dfcbb075b22b]

Filipe Manana (3):
      Btrfs: fix emptiness check for dirtied extent buffers at check_leaf()
         [f177d73949bf758542ca15a1c1945bd2e802cc65]
      Btrfs: fix infinite loop during nocow writeback due to race
         [de7999afedff02c6631feab3ea726a0e8f8c3d40]
      Btrfs: fix removal logic of the tree mod log that leads to use-after-free issues
         [6609fee8897ac475378388238456c84298bff802]

Finn Thain (4):
      net/sonic: Add mutual exclusion for accessing shared state
         [865ad2f2201dc18685ba2686f13217f8b3a9c52c]
      net/sonic: Fix receive buffer handling
         [9e311820f67e740f4fb8dcb82b4c4b5b05bdd1a5]
      net/sonic: Quiesce SONIC before re-initializing descriptor memory
         [3f4b7e6a2be982fd8820a2b54d46dd9c351db899]
      net/sonic: Use MMIO accessors
         [e3885f576196ddfc670b3d53e745de96ffcb49ab]

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode
         [2d77bd61a2927be8f4e00d9478fe6996c47e8d45]

Florian Westphal (6):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
         [1b789577f655060d98d20ed0c6f9fbd469d6ba63]
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct
         [212e7f56605ef9688d0846db60c6c6ec06544095]
      netfilter: ctnetlink: netns exit must wait for callbacks
         [18a110b022a5c02e7dc9f6109d0bd93e58ac6ebb]
      netfilter: ebtables: compat: reject all padding in matches/watchers
         [e608f631f0ba5f1fc5ee2e260a3a35d13107cbfe]
      netfilter: ebtables: convert BUG_ONs to WARN_ONs
         [fc6a5d0601c5ac1d02f283a46f60b87b2033e5ca]
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
         [22dad713b8a5ff488e07b821195270672f486eb2]

Geert Uytterhoeven (1):
      gpio: Fix error message on out-of-range GPIO in lookup table
         [d935bd50dd14a7714cbdba9a76435dbb56edb1ae]

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()
         [7690e25302dc7d0cd42b349e746fe44b44a94f2b]

Gu Jinxiang (1):
      btrfs: validate type when reading a chunk
         [315409b0098fb2651d86553f0436b70502b29bb2]

Hangbin Liu (1):
      vxlan: fix tos value before xmit
         [71130f29979c7c7956b040673e6b9d5643003176]

Hans de Goede (2):
      pinctrl: baytrail: Really serialize all register accesses
         [40ecab551232972a39cdd8b6f17ede54a3fdb296]
      platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes
         [133b2acee3871ae6bf123b8fe34be14464aa3d2c]

Heikki Krogerus (8):
      usb: dwc3: pci: add ID for one more Intel Broxton platform
         [1ffb4d5cc78a3a99109ff0808ce6915de07a0588]
      usb: dwc3: pci: add ID for the Intel Comet Lake -H variant
         [3c3caae4cd6e122472efcf64759ff6392fb6bce2]
      usb: dwc3: pci: add Intel Cannonlake PCI IDs
         [682179592e48fa66056fbad1a86604be4992f885]
      usb: dwc3: pci: add Intel Gemini Lake PCI ID
         [8f8983a5683623b62b339d159573f95a1fce44f3]
      usb: dwc3: pci: add Intel Kabylake PCI ID
         [4491ed5042f0419b22a4b08331adb54af31e2caa]
      usb: dwc3: pci: add support for Intel Broxton SOC
         [b4c580a43d520b7812c0fd064fbab929ce2f1da0]
      usb: dwc3: pci: add support for Intel IceLake
         [00908693c481f7298adf8cf4d2ff3dfbea8c375f]
      usb: dwc3: pci: add support for Intel Sunrise Point PCH
         [84a2b61b6eb94036093531cdabc448dddfbae45a]

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()
         [474e559567fa631dea8fb8407ab1b6090c903755]

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug
         [529244bd1afc102ab164429d338d310d5d65e60d]

Jan Kara (7):
      blktrace: Protect q->blk_trace with RCU
         [c780e86dd48ef6467a1146cf7d0fe1e05a635039]
      ext4: check for directory entries too close to block end
         [109ba779d6cca2d519c5dd624a3276d03e21948e]
      ext4: fix races between buffered IO and collapse / insert range
         [32ebffd3bbb4162da5ff88f9a35dd32d0a28ea70]
      ext4: fix races between page faults and hole punching
         [ea3d7209ca01da209cda6f0dea8be9cc4b7a933b]
      ext4: fix races of writeback with punch hole and zero range
         [011278485ecc3cd2a3954b5d4c73101d919bf1fa]
      ext4: move unlocked dio protection from ext4_alloc_file_blocks()
         [17048e8a083fec7ad841d88ef0812707fbc7e39f]
      kobject: Export kobject_get_unless_zero()
         [c70c176ff8c3ff0ac6ef9a831cd591ea9a66bd1a]

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment
         [f5ae2ea6347a308cfe91f53b53682ce635497d0d]

Jeff Mahoney (2):
      btrfs: cleanup, stop casting for extent_map->lookup everywhere
         [95617d69326ce386c95e33db7aeb832b45ee9f8f]
      btrfs: struct-funcs, constify readers
         [1cbb1f454e5321e47fc1e6b233066c7ccc979d15]

Jerónimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx
         [260e41ac4dd3e5acb90be624c03ba7f019615b75]

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0
         [176a7fca81c5090a7240664e3002c106d296bf31]

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD
         [396d2e878f92ec108e4293f1c77ea3bc90b414ff]

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT
         [9e635c2851df6caee651e589fbf937b637973c91]

Jiri Slaby (4):
      vt: selection, close sel_buffer race
         [07e6124a1a46b4b5a9b3cacc0c306b50da87abf5]
      vt: selection, handle pending signals in paste_selection
         [687bff0cd08f790d540cfb7b2349f0d876cdddec]
      vt: selection, push console lock down
         [4b70dd57a15d2f4685ac6e38056bad93e81e982f]
      vt: selection, push sel_lock up
         [e8c75a30a23c6ba63f4ef6895cbf41fd42f21aa2]

Johan Hovold (29):
      ALSA: usb-audio: fix sync-ep altsetting sanity check
         [5d1b71226dc4d44b4b65766fa9d74492f9d4587b]
      Input: aiptek - fix endpoint sanity check
         [3111491fca4f01764e0c158c5e0f7ced808eef51]
      Input: gtco - fix endpoint sanity check
         [a8eeb74df5a6bdb214b2b581b14782c5f5a0cf83]
      Input: keyspan-remote - fix control-message timeouts
         [ba9a103f40fc4a3ec7558ec9b0b97d4f92034249]
      Input: sur40 - fix interface sanity checks
         [6b32391ed675827f8425a414abbc6fbd54ea54fe]
      USB: adutux: fix interface sanity check
         [3c11c4bed02b202e278c0f5c319ae435d7fb9815]
      USB: atm: ueagle-atm: add missing endpoint check
         [09068c1ad53fb077bdac288869dec2435420bdc4]
      USB: core: add endpoint-blacklist quirk
         [73f8bda9b5dc1c69df2bc55c0cbb24461a6391a9]
      USB: core: fix check for duplicate endpoints
         [3e4f8e21c4f27bcf30a48486b9dcc269512b79ff]
      USB: idmouse: fix interface sanity checks
         [59920635b89d74b9207ea803d5e91498d39e8b69]
      USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
         [bdd1b147b8026df0e4260b387026b251d888ed01]
      USB: serial: ch341: handle unbound port at reset_resume
         [4d5ef53f75c22d28f490bcc5c771fcc610a9afa4]
      USB: serial: io_edgeport: add missing active-port sanity check
         [1568c58d11a7c851bd09341aeefd6a1c308ac40d]
      USB: serial: io_edgeport: fix epic endpoint lookup
         [7c5a2df3367a2c4984f1300261345817d95b71f8]
      USB: serial: io_edgeport: handle unbound ports on URB completion
         [e37d1aeda737a20b1846a91a3da3f8b0f00cf690]
      USB: serial: keyspan: handle unbound ports
         [3018dd3fa114b13261e9599ddb5656ef97a1fa17]
      USB: serial: opticon: fix control-message timeouts
         [5e28055f340275a8616eee88ef19186631b4d136]
      USB: serial: quatech2: handle unbound ports
         [9715a43eea77e42678a1002623f2d9a78f5b81a1]
      USB: serial: suppress driver bind attributes
         [fdb838efa31e1ed9a13ae6ad0b64e30fdbd00570]
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting
         [2f361cd9474ab2c4ab9ac8db20faf81e66c6279b]
      media: ov519: add missing endpoint sanity checks
         [998912346c0da53a6dbb71fab3a138586b596b30]
      media: stv06xx: add missing descriptor sanity checks
         [485b06aadb933190f4bc44e006076bc27a23f205]
      media: xirlink_cit: add missing descriptor sanity checks
         [a246b4d547708f33ff4d4b9a7a5dbac741dc89d8]
      r8152: add missing endpoint sanity check
         [86f3f4cd53707ceeec079b83205c8d3c756eca93]
      staging: gigaset: add endpoint-type sanity check
         [ed9ed5a89acba51b82bdff61144d4e4a4245ec8a]
      staging: gigaset: fix general protection fault on probe
         [53f35a39c3860baac1e5ca80bf052751cfb24a99]
      staging: gigaset: fix illegal free on probe errors
         [84f60ca7b326ed8c08582417493982fe2573a9ad]
      staging: rtl8188eu: fix interface sanity check
         [74ca34118a0e05793935d804ccffcedd6eb56596]
      staging: rtl8712: fix interface sanity check
         [c724f776f048538ecfdf53a52b7a522309f5c504]

Johannes Thumshirn (1):
      btrfs: ensure that a DUP or RAID1 block group has exactly two stripes
         [349ae63f40638a28c6fce52e8447c2d14b84cc0c]

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
         [8605131747e7e1fd8f6c9f97a00287aae2b2c640]
      net: stmmac: Enable 16KB buffer size
         [b2f3a481c4cd62f78391b836b64c0a6e72b503d2]

Josef Bacik (9):
      Btrfs: fix em leak in find_first_block_group
         [187ee58c62c1d0d238d3dc4835869d33e1869906]
      btrfs: abort transaction after failed inode updates in create_subvol
         [c7e54b5102bf3614cadb9ca32d7be73bad6cecf0]
      btrfs: check rw_devices, not num_devices for balance
         [b35cf1f0bf1f2b0b193093338414b9bd63b29015]
      btrfs: do not call synchronize_srcu() in inode_tree_del
         [f72ff01df9cf5db25c76674cac16605992d15467]
      btrfs: do not delete mismatched root refs
         [423a716cd7be16fb08690760691befe3be97d3fc]
      btrfs: do not leak reloc root if we fail to read the fs root
         [ca1aa2818a53875cfdd175fb5e9a2984e997cce9]
      btrfs: handle ENOENT in btrfs_uuid_tree_iterate
         [714cd3e8cba6841220dce9063a7388a81de03825]
      btrfs: skip log replay on orphaned roots
         [9bc574de590510eff899c3ca8dbaf013566b5efe]
      ext4: only call ext4_truncate when size <= isize
         [3da40c7b089810ac9cf2bb1e59633f619f3a7312]

Jouni Malinen (1):
      mac80211: Do not send Layer 2 Update frame before authorization
         [3e493173b7841259a08c5c8e5cbe90adb349da7e]

Kaitao Cheng (1):
      kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail
         [50f9ad607ea891a9308e67b81f774c71736d1098]

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup
         [9c06ac4c83df6d6fbdbf7488fbad822b4002ba19]

Kenneth Klette Jonassen (1):
      pkt_sched: fq: avoid hang when quantum 0
         [3725a269815ba6dbb415feddc47da5af7d1fac58]

Lars Möllendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest element
         [883f616530692d81cb70f8a32d85c0d2afc05f69]

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops
         [0e4f7f920a5c6bfe5e851e989f27b35a0cc7fb7e]

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it
         [2e90ca68b0d2f5548804f22f0dd61145516171e3]

Liu Bo (9):
      Btrfs: add validadtion checks for chunk loading
         [e06cd3dd7cea50e87663a88acdfdb7ac1c53a5ca]
      Btrfs: check btree node's nritems
         [053ab70f0604224c7893b43f9d9d5efa283580d6]
      Btrfs: check inconsistence between chunk and block group
         [6fb37b756acce6d6e045f79c3764206033f617b4]
      Btrfs: detect corruption when non-root leaf has zero item
         [1ba98d086fe3a14d6a31f2f66dbab70c45d00f63]
      Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
         [ef85b25e982b5bba1530b936e283ef129f02ab9d]
      Btrfs: improve check_node to avoid reading corrupted nodes
         [6b722c1747d533ac6d4df110dc8233db46918b65]
      Btrfs: kill BUG_ON in run_delayed_tree_ref
         [02794222c4132ac003e7281fb71f4ec1645ffc87]
      Btrfs: memset to avoid stale content in btree leaf
         [851cd173f06045816528176001cf82948282029c]
      Btrfs: memset to avoid stale content in btree node block
         [3eb548ee3a8042d95ad81be254e67a5222c24e03]

Logan Gunthorpe (1):
      chardev: add helper function to register char devs with a struct device
         [233ed09d7fdacf592ee91e6c97ce5f4364fbe7c0]

Lu Fengqi (1):
      btrfs: Remove redundant btrfs_release_path from btrfs_unlink_subvol
         [5b7d687ad5913a56b6a8788435d7a53990b4176d]

Lukas Czerner (1):
      ext4: wait for existing dio workers in ext4_alloc_file_blocks()
         [0d306dcf86e8f065dff42a4a934ae9d99af35ba5]

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input
         [cf3ca1877574a306c0207cbf7fdf25419d9229df]

Mao Wenan (2):
      af_packet: set defaule value for tmo
         [b43d1f9f7067c6759b1051e8ecb84e82cef569fe]
      net: sonic: return NETDEV_TX_OK if failed to map buffer
         [6e1cdedcf0362fed3aedfe051d46bd7ee2a85fe1]

Marcel Holtmann (2):
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll
         [9f3b61dc1dd7b81e99e7ed23776bb64a35f39e1a]
      HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
         [be54e7461ffdc5809b67d2aeefc1ddc9a91470c7]

Mathias Nyman (2):
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.
         [7ff11162808cc2ec66353fc012c58bb449c892c3]
      xhci: make sure interrupts are restored to correct state
         [bd82873f23c9a6ad834348f8b83f3b6a5bca2c65]

Mauro Carvalho Chehab (3):
      [media] media-device: dynamically allocate struct media_devnode
         [a087ce704b802becbb4b0f2a20f2cb3f6911802e]
      [media] media-devnode: fix namespace mess
         [163f1e93e995048b894c5fc86a6034d16beed740]
      [media] media-devnode: just return 0 instead of using a var
         [8b37c6455fc8f43e0e95db2847284e618db6a4f8]

Max Kellermann (2):
      [media] drivers/media/media-devnode: clear private_data before put_device()
         [bf244f665d76d20312c80524689b32a752888838]
      [media] media-devnode: add missing mutex lock in error handler
         [88336e174645948da269e1812f138f727cd2896b]

Michael Straube (1):
      staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21
         [58dcc5bf4030cab548d5c98cd4cd3632a5444d5a]

Michał Mirosław (1):
      mmc: sdhci: fix minimum clock rate for v3 controller
         [2a187d03352086e300daa2044051db00044cd171]

Mika Westerberg (4):
      pinctrl: baytrail: Clear interrupt triggering from pins that are in GPIO mode
         [95f0972c7e4cbf3fc68160131c5ac2f033481d00]
      pinctrl: baytrail: Relax GPIO request rules
         [f8323b6bb2cc7d26941d4838dd4375952980a88a]
      pinctrl: baytrail: Rework interrupt handling
         [31e4329f99062a06dca5a493bb4495a63b2dc6ba]
      pinctrl: baytrail: Serialize all register access
         [39ce8150a079e3ae6ed9abf26d7918a558ef7c19]

Mike Snitzer (1):
      dm flakey: fix reads to be issued if drop_writes configured
         [299f6230bc6d0ccd5f95bb0fb865d80a9c7d5ccc]

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size
         [ad6bf88a6c19a39fb3b0045d78ea880325dfcf15]

Moni Shoua (1):
      IB/mlx4: Avoid executing gid task when device is being removed
         [4bf9715f184969dc703bde7be94919995024a6a9]

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
         [c7bf1fb7ddca331780b9a733ae308737b39f1ad4]
      libertas: make lbs_ibss_join_existing() return error code on rates overflow
         [1754c4f60aaf1e17d886afefee97e94d7f27b4cb]

Nikos Tsironis (1):
      dm thin metadata: Add support for a pre-commit callback
         [ecda7c0280e6b3398459dc589b9a41c1adb45529]

Pablo Neira Ayuso (2):
      netfilter: nf_tables: missing sanitization in data from userspace
         [71df14b0ce094be46d105b5a3ededd83b8e779a0]
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
         [0d2c96af797ba149e559c5875c0151384ab6dd14]

Paolo Bonzini (1):
      KVM: nVMX: Don't emulate instructions in guest mode
         [07721feee46b4b248402133228235318199b05ec]

Parav Pandit (1):
      IB/mlx4: Follow mirror sequence of device add during device removal
         [89f988d93c62384758b19323c886db917a80c371]

Paul Cercueil (1):
      usb: musb: dma: Correct parameter passed to IRQ handler
         [c80d0f4426c7fdc7efd6ae8d8b021dcfc89b4254]

Pavel Tatashin (1):
      x86/pti/efi: broken conversion from efi to kernel page table
         [not upstream; fixes a bug specific to KAISER]

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
         [c9655008e7845bcfdaac10a1ed8554ec167aea88]

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read
         [19e6317d24c25ee737c65d1ffb7483bdda4bb54a]

Peter Hurley (1):
      tty: vt: Fix !TASK_RUNNING diagnostic warning from paste_selection()
         [61e86cc90af49cecef9c54ccea1f572fbcb695ac]

Peter Zijlstra (1):
      futex: Fix inode life-time issue
         [8019ad13ef7f64be44d4f892af9c840179009254]

Qize Wang (1):
      mwifiex: Fix heap overflow in mmwifiex_process_tdls_action_frame()
         [1e58252e334dc3f3756f424a157d1b7484464c40]

Qu Wenruo (14):
      btrfs: Add checker for EXTENT_CSUM
         [4b865cab96fe2a30ed512cf667b354bd291b3b0a]
      btrfs: Add sanity check for EXTENT_DATA when reading out leaf
         [40c3c40947324d9f40bf47830c92c59a9bbadf4a]
      btrfs: Check if item pointer overlaps with the item itself
         [7f43d4affb2a254d421ab20b0cf65ac2569909fb]
      btrfs: Check that each block group has corresponding chunk at mount time
         [514c7dca85a0bf40be984dab0b477403a6db901f]
      btrfs: Enhance chunk validation check
         [f04b772bfc17f502703794f4d100d12155c1a1a9]
      btrfs: Move leaf and node validation checker to tree-checker.c
         [557ea5dd003d371536f6b4e8f7c8209a2b6fd4e3]
      btrfs: Refactor check_leaf function for later expansion
         [c3267bbaa9cae09b62960eafe33ad19196803285]
      btrfs: Verify that every chunk has corresponding block group at mount time
         [7ef49515fa6727cb4b6f2f5b0ffbc5fc20a9f8c6]
      btrfs: tree-checker: Add checker for dir item
         [ad7b0368f33cffe67fecd302028915926e50ef7e]
      btrfs: tree-checker: Check level for leaves and nodes
         [f556faa46eb4e96d0d0772e74ecf66781e132f72]
      btrfs: tree-checker: Detect invalid and empty essential trees
         [ba480dd4db9f1798541eb2d1c423fc95feee8d36]
      btrfs: tree-checker: Enhance btrfs_check_node output
         [bba4f29896c986c4cec17bc0f19f2ce644fceae1]
      btrfs: tree-checker: Fix false panic for sanity test
         [69fc6cbbac542c349b3d350d10f6e394c253c81d]
      btrfs: tree-checker: Verify block_group_item
         [fce466eab7ac6baa9d2dcd88abcf945be3d4a089]

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list
         [aa604651d523b1493988d0bf6710339f3ee60272]

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices
         [b9ea0bae260f6aae546db224daa6ac1bd9d94b91]

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED
         [aa9f7d5172fac9bf1f09e678c35e287a40a7b7dd]

Richard Palethorpe (2):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU
         [0ace17d56824165c7f4c68785d6b58971db954dd]
      slcan: Don't transmit uninitialized stack data in padding
         [b9258a2cece4ec1f020715fe3554bc2e360f6264]

Russell King (2):
      gpiolib: fix up emulated open drain outputs
         [256efaea1fdc4e38970489197409a26125ee0aaa]
      mod_devicetable: fix PHY module format
         [d2ed49cf6c13e379c5819aa5ac20e1f9674ebc89]

Sabrina Dubroca (1):
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup
         [6c8991f41546c3c472503dff1ea9daaddf9331c2]

Salvatore Mesoraca (1):
      namei: allow restricted O_CREAT of FIFOs and regular files
         [30aba6656f61ed44cba445a3c0d38b296fa9e8f5]

Shaokun Zhang (1):
      btrfs: tree-checker: Fix misleading group system information
         [761333f2f50ccc887aa9957ae829300262c0d15b]

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value
         [556672d75ff486e0b6786056da624131679e0576]

Shuah Khan (3):
      [media] media: Fix media_open() to clear filp->private_data in error leg
         [d40ec6fdb0b03b7be4c7923a3da0e46bf943740a]
      [media] media: fix media devnode ioctl/syscall and unregister race
         [6f0dd24a084a17f9984dd49dffbf7055bf123993]
      [media] media: fix use-after-free in cdev_put() when app exits after driver unbind
         [5b28dde51d0ccc54cee70756e1800d70bed7114a]

Steven Rostedt (1):
      tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined
         [b8299d362d0837ae39e87e9019ebe6b736e0f035]

Sudip Mukherjee (2):
      tty: always relink the port
         [273f632912f1b24b642ba5b7eb5022e43a72f3b5]
      tty: link tty and port before configuring it as console
         [fb2b90014d782d80d7ebf663e50f96d8c507a73c]

Suren Baghdasaryan (1):
      staging: android: ashmem: Disallow ashmem memory from being remapped
         [6d67b0290b4b84c477e6a2fc6e005e174d3c7786]

Suwan Kim (1):
      usbip: Fix error path of vhci_recv_ret_submit()
         [aabb5b833872524eaf28f52187e5987984982264]

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems
         [4cc4a1708903f404d2ca0dfde30e71e052c6cbc9]

Takashi Iwai (4):
      ALSA: hda/ca0132 - Avoid endless loop
         [cb04fc3b6b076f67d228a0b7d096c69ad486c09c]
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
         [0aec96f5897ac16ad9945f531b4bef9a2edd2ebd]
      ALSA: pcm: Avoid possible info leaks from PCM stream buffers
         [add9d56d7b3781532208afbff5509d7382fb6efe]
      ALSA: seq: Fix racy access for queue timer in proc read
         [60adcfde92fa40fcb2dbf7cc52f9b096e0cd109a]

Thomas Gleixner (1):
      futex: Unbreak futex hashing
         [8d67743653dce5a0e7aa500fcccb237cde7ad88e]

Tom Lendacky (1):
      x86/microcode/AMD: Add support for fam17h microcode loading
         [f4e9b7af0cd58dd039a0fb2cd67d57cea4889abf]

Vivek Goyal (1):
      dm: do not override error code returned from dm_get_device()
         [e80d1c805a3b2f0ad2081369be5dc5deedd5ee59]

Vladis Dronov (2):
      ptp: fix the race between the release of ptp_clock and cdev
         [a33121e5487b424339636b25c35d3a180eaa5f5e]
      ptp: free ptp device pin descriptors properly
         [75718584cb3c64e6269109d4d54f888ac5a5fd15]

Wang Shilong (1):
      Btrfs: fix wrong max inline data size limit
         [c01a5c074c0f6f85a3b02e39432b9e5576ab51de]

Wei Yongjun (1):
      dm flakey: return -EINVAL on interval bounds error in flakey_ctr()
         [bff7e067ee518f9ed7e1cbc63e4c9e01670d0b71]

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor
         [e5e884b42639c74b5b57dc277909915c0aefc8bb]

Wen Yang (1):
      ftrace: Avoid potential division by zero in function profiler
         [e31f7939c1c27faa5d0e3f14519eaf7c89e8a69d]

Will Deacon (1):
      chardev: Avoid potential use-after-free in 'chrdev_open()'
         [68faa679b8be1a74e6663c21c3a9d25d32f1c079]

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI
         [465f4edaecc6c37f81349233e84d46246bcac11a]

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY
         [be7a7729207797476b6666f046d765bdf9630407]

YueHaibing (1):
      ptp: Fix pass zero to ERR_PTR() in ptp_clock_register
         [aea0a897af9e44c258e8ab9296fad417f1bc063a]

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region
         [513dc792d6060d5ef572e43852683097a8420f56]

 Documentation/sysctl/fs.txt                       |  36 ++
 Makefile                                          |   4 +-
 arch/powerpc/kernel/irq.c                         |   4 +-
 arch/x86/boot/compressed/head_64.S                |   5 +
 arch/x86/include/asm/kaiser.h                     |  10 +
 arch/x86/kernel/cpu/microcode/amd.c               |   4 +
 arch/x86/kvm/cpuid.c                              |   3 +-
 arch/x86/kvm/vmx.c                                |   2 +-
 arch/x86/realmode/init.c                          |   4 +-
 arch/x86/realmode/rm/trampoline_64.S              |   3 +-
 block/blk-settings.c                              |   2 +-
 drivers/acpi/device_pm.c                          |  12 +-
 drivers/block/floppy.c                            |   7 +-
 drivers/gpio/gpiolib.c                            |  13 +-
 drivers/hid/hid-core.c                            |   6 +
 drivers/hid/hid-input.c                           |  16 +-
 drivers/hid/hidraw.c                              |   7 +-
 drivers/hid/uhid.c                                |   5 +-
 drivers/hwmon/adt7475.c                           |   5 +-
 drivers/iio/industrialio-buffer.c                 |   6 +-
 drivers/infiniband/hw/mlx4/main.c                 |  16 +-
 drivers/input/input.c                             |  26 +-
 drivers/input/misc/keyspan_remote.c               |   9 +-
 drivers/input/tablet/aiptek.c                     |   6 +-
 drivers/input/tablet/gtco.c                       |  10 +-
 drivers/input/touchscreen/sur40.c                 |   2 +-
 drivers/isdn/gigaset/usb-gigaset.c                |  23 +-
 drivers/md/dm-crypt.c                             |   4 +-
 drivers/md/dm-delay.c                             |  16 +-
 drivers/md/dm-flakey.c                            |  40 +-
 drivers/md/dm-linear.c                            |   7 +-
 drivers/md/dm-raid1.c                             |   8 +-
 drivers/md/dm-snap-persistent.c                   |   2 +-
 drivers/md/dm-stripe.c                            |   8 +-
 drivers/md/dm-thin-metadata.c                     |  29 +
 drivers/md/dm-thin-metadata.h                     |   7 +
 drivers/md/persistent-data/dm-btree-remove.c      |   8 +-
 drivers/md/raid0.c                                |   2 +-
 drivers/media/media-device.c                      |  43 +-
 drivers/media/media-devnode.c                     | 171 +++---
 drivers/media/usb/gspca/ov519.c                   |  10 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c         |  19 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c  |   4 +
 drivers/media/usb/gspca/xirlink_cit.c             |  18 +-
 drivers/media/usb/uvc/uvc_driver.c                |   2 +-
 drivers/misc/enclosure.c                          |   3 +-
 drivers/mmc/host/sdhci.c                          |  10 +-
 drivers/net/bonding/bond_main.c                   |  40 +-
 drivers/net/can/mscan/mscan.c                     |  21 +-
 drivers/net/can/slcan.c                           |  16 +-
 drivers/net/can/usb/gs_usb.c                      |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   5 -
 drivers/net/ethernet/natsemi/sonic.c              | 113 +++-
 drivers/net/ethernet/natsemi/sonic.h              |  25 +-
 drivers/net/ethernet/stmicro/stmmac/common.h      |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 drivers/net/hamradio/6pack.c                      |   4 +-
 drivers/net/hamradio/mkiss.c                      |   4 +-
 drivers/net/macvlan.c                             |   3 +-
 drivers/net/slip/slip.c                           |  12 +-
 drivers/net/usb/r8152.c                           |   3 +
 drivers/net/vxlan.c                               |   5 +-
 drivers/net/wireless/libertas/cfg.c               |  18 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c          |   1 +
 drivers/net/wireless/mwifiex/tdls.c               |  74 ++-
 drivers/pinctrl/pinctrl-baytrail.c                | 212 ++++---
 drivers/platform/x86/asus-wmi.c                   |   8 +-
 drivers/platform/x86/hp-wmi.c                     |   2 +-
 drivers/ptp/ptp_clock.c                           |  42 +-
 drivers/ptp/ptp_private.h                         |   9 +-
 drivers/ptp/ptp_sysfs.c                           | 162 +++---
 drivers/scsi/fnic/vnic_dev.c                      |  20 +-
 drivers/scsi/qla4xxx/ql4_os.c                     |   1 -
 drivers/scsi/sd.c                                 |   4 +-
 drivers/staging/android/ashmem.c                  |  28 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |   3 +-
 drivers/staging/rtl8712/usb_intf.c                |   2 +-
 drivers/staging/usbip/vhci_rx.c                   |  13 +-
 drivers/tty/serial/msm_serial.c                   |  13 +-
 drivers/tty/serial/serial_core.c                  |   1 +
 drivers/tty/vt/selection.c                        |  34 +-
 drivers/tty/vt/vt.c                               |   2 -
 drivers/usb/atm/ueagle-atm.c                      |  18 +-
 drivers/usb/core/config.c                         |  77 ++-
 drivers/usb/core/hub.c                            |   1 +
 drivers/usb/core/quirks.c                         |  37 ++
 drivers/usb/core/urb.c                            |   1 +
 drivers/usb/core/usb.h                            |   3 +
 drivers/usb/dwc3/dwc3-pci.c                       |  30 +
 drivers/usb/host/ehci-q.c                         |  13 +-
 drivers/usb/host/xhci-hub.c                       |   8 +-
 drivers/usb/host/xhci-ring.c                      |   3 +-
 drivers/usb/misc/adutux.c                         |   2 +-
 drivers/usb/misc/idmouse.c                        |   2 +-
 drivers/usb/mon/mon_bin.c                         |  32 +-
 drivers/usb/musb/musbhsdma.c                      |   2 +-
 drivers/usb/serial/ch341.c                        |   6 +-
 drivers/usb/serial/io_edgeport.c                  |  26 +-
 drivers/usb/serial/keyspan.c                      |   4 +
 drivers/usb/serial/opticon.c                      |   2 +-
 drivers/usb/serial/quatech2.c                     |   6 +
 drivers/usb/serial/usb-serial-simple.c            |   2 +
 drivers/usb/serial/usb-serial.c                   |   3 +
 drivers/vhost/net.c                               |  13 +-
 drivers/video/console/vgacon.c                    |   3 +
 drivers/virtio/virtio_balloon.c                   |  10 +
 firmware/Makefile                                 |   2 +-
 fs/btrfs/Makefile                                 |   2 +-
 fs/btrfs/ctree.c                                  |  19 +-
 fs/btrfs/ctree.h                                  | 157 +++---
 fs/btrfs/dev-replace.c                            |   2 +-
 fs/btrfs/disk-io.c                                |  80 +--
 fs/btrfs/extent-tree.c                            | 110 +++-
 fs/btrfs/extent_io.c                              |  98 ++--
 fs/btrfs/extent_io.h                              |  25 +-
 fs/btrfs/extent_map.c                             |   2 +-
 fs/btrfs/extent_map.h                             |  10 +-
 fs/btrfs/inode.c                                  |   8 +-
 fs/btrfs/ioctl.c                                  |  10 +-
 fs/btrfs/relocation.c                             |   1 +
 fs/btrfs/root-tree.c                              |  10 +-
 fs/btrfs/scrub.c                                  |   2 +-
 fs/btrfs/struct-funcs.c                           |   9 +-
 fs/btrfs/tree-checker.c                           | 649 ++++++++++++++++++++++
 fs/btrfs/tree-checker.h                           |  38 ++
 fs/btrfs/tree-log.c                               |  24 +-
 fs/btrfs/uuid-tree.c                              |   2 +
 fs/btrfs/volumes.c                                | 206 +++++--
 fs/btrfs/volumes.h                                |   2 +
 fs/char_dev.c                                     |  88 ++-
 fs/ext4/dir.c                                     |   5 +
 fs/ext4/ext4.h                                    |  13 +
 fs/ext4/extents.c                                 |  89 +--
 fs/ext4/file.c                                    |   2 +-
 fs/ext4/inode.c                                   | 117 +++-
 fs/ext4/super.c                                   |   1 +
 fs/ext4/truncate.h                                |   2 +
 fs/inode.c                                        |   1 +
 fs/locks.c                                        |   2 +-
 fs/namei.c                                        |  56 +-
 include/linux/blkdev.h                            |  10 +-
 include/linux/blktrace_api.h                      |   6 +-
 include/linux/cdev.h                              |   5 +
 include/linux/fs.h                                |   3 +
 include/linux/futex.h                             |  17 +-
 include/linux/if_ether.h                          |   8 +
 include/linux/kobject.h                           |   2 +
 include/linux/mod_devicetable.h                   |   4 +-
 include/linux/netfilter_arp/arp_tables.h          |   2 +-
 include/linux/posix-clock.h                       |  19 +-
 include/linux/quotaops.h                          |   2 +-
 include/linux/usb/quirks.h                        |   3 +
 include/media/media-device.h                      |   5 +-
 include/media/media-devnode.h                     |  32 +-
 include/net/addrconf.h                            |   5 +-
 include/net/cfg80211.h                            |  11 +
 include/net/neighbour.h                           |   1 -
 kernel/futex.c                                    |  93 ++--
 kernel/sysctl.c                                   |  18 +
 kernel/taskstats.c                                |  30 +-
 kernel/time/posix-clock.c                         |  31 +-
 kernel/trace/blktrace.c                           | 129 +++--
 kernel/trace/ftrace.c                             |   6 +-
 kernel/trace/trace_sched_wakeup.c                 |   4 +-
 kernel/trace/trace_stack.c                        |   5 +
 lib/kobject.c                                     |   5 +-
 mm/mempolicy.c                                    |   6 +-
 net/8021q/vlan_netlink.c                          |  10 +-
 net/batman-adv/distributed-arp-table.c            |   4 +-
 net/bridge/br_netfilter.c                         |   3 +
 net/bridge/netfilter/ebtables.c                   |  58 +-
 net/core/neighbour.c                              |   3 -
 net/ipv4/netfilter/arp_tables.c                   |  42 +-
 net/ipv4/netfilter/arptable_filter.c              |   2 +-
 net/ipv4/tcp_input.c                              |   5 +-
 net/ipv4/tcp_output.c                             |   8 +
 net/ipv6/af_inet6.c                               |   2 +-
 net/mac80211/cfg.c                                |  55 +-
 net/mac80211/sta_info.c                           |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h           |   2 +-
 net/netfilter/ipset/ip_set_core.c                 |   3 +-
 net/netfilter/nf_conntrack_netlink.c              |   3 +
 net/netfilter/nft_bitwise.c                       |  19 +-
 net/netfilter/nft_cmp.c                           |  18 +-
 net/packet/af_packet.c                            |   3 +-
 net/sched/ematch.c                                |   2 +-
 net/sched/sch_fq.c                                |  10 +-
 net/sctp/sm_sideeffect.c                          |  28 +-
 net/wireless/util.c                               |  45 ++
 scripts/recordmcount.c                            |  17 +
 sound/core/pcm_native.c                           |   4 +
 sound/core/seq/seq_timer.c                        |  14 +-
 sound/pci/hda/patch_ca0132.c                      |   5 +-
 sound/pci/ice1712/ice1724.c                       |   9 +-
 sound/soc/codecs/wm8962.c                         |   4 +-
 sound/usb/pcm.c                                   |  44 +-
 197 files changed, 3378 insertions(+), 1230 deletions(-)

-- 
Ben Hutchings
Knowledge is power.  France is bacon.

