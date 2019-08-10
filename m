Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B4F88E77
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJUzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:55:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53724 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbfHJUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052o-F0; Sat, 10 Aug 2019 21:43:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003XT-8w; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.188083258@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/157] 3.16.72-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.72 release.
There are 157 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Aug 13 12:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Aditya Pakki (1):
      serial: max310x: Fix to avoid potential NULL pointer dereference
         [3a10e3dd52e80b9a97a3346020024d17b2c272d6]

Al Viro (1):
      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour
         [4e9036042fedaffcd868d7f7aa948756c48c637d]

Alan Stern (4):
      USB: core: Fix bug caused by duplicate interface PM usage counter
         [c2b71462d294cf517a0bc6e4fd6424d7cee5596f]
      USB: core: Fix unterminated string returned by usb_string()
         [c01c348ecdc66085e44912c97368809612231520]
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
         [c114944d7d67f24e71562fcfc18d550ab787e4d4]
      USB: yurex: Fix protection fault after device removal
         [ef61eb43ada6c1d6b94668f0f514e4c268093ff3]

Anand Jain (1):
      btrfs: prop: fix vanished compression property after failed set
         [272e5326c7837697882ce3162029ba893059b616]

Andre Przywara (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9170 SATA controller
         [9cde402a59770a0669d895399c13407f63d7d209]

Andy Lutomirski (2):
      x86/asm/entry/64: Disentangle error_entry/exit gsbase/ebx/usermode code
         [539f5113650068ba221197f190267ab727296ef5]
      x86/entry/64: Really create an error-entry-from-usermode code path
         [cb6f64ed5a04036eef07e70b57dd5dd78f2fbcef]

Arnd Bergmann (1):
      3c515: fix integer overflow warning
         [fb6fafbc7de4a813bb5364358bbe27f71e62b24a]

Aurelien Aptel (1):
      CIFS: keep FileInfo handle live during oplock break
         [b98749cac4a695f084a5ff076f4510b23e353ecd]

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load
         [79b4a9cf0e2ea8203ce777c8d5cfa86c71eae86e]

Axel Lin (1):
      gpio: adnp: Fix testing wrong value in adnp_gpio_direction_input
         [c5bc6e526d3f217ed2cc3681d256dc4a2af4cc2b]

Ben Gardon (1):
      kvm: mmu: Fix overflow on kvm mmu page limit calculation
         [bc8a3d8925a8fa09fa550e0da115d95851ce33c6]

Ben Hutchings (2):
      Revert "inet: update the IP ID generation algorithm to higher standards."
         [not upstream; reverted commit was not upstream either]
      x86: cpufeatures: Renumber feature word 7
         [not upstream; this updates earlier backports to align with 4.4/4.9]

Changbin Du (1):
      perf tests: Fix a memory leak in test__perf_evsel__tp_sched_test()
         [d982b33133284fa7efa0e52ae06b88f9be3ea764]

Chen Jie (1):
      futex: Ensure that futex address is aligned in handle_futex_death()
         [5a07168d8d89b00fe1760120714378175b3ef992]

Christophe Leroy (1):
      powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64
         [dd9a994fc68d196a052b73747e3366c57d14a09e]

Colin Ian King (1):
      vxge: fix return of a free'd memblock on a failed dma mapping
         [0a2c34f18c94b596562bf3d019fceab998b8b584]

Dan Carpenter (2):
      staging: rtl8712: uninitialized memory in read_bbreg_hdl()
         [22c971db7dd4b0ad8dd88e99c407f7a1f4231a2e]
      xen: Prevent buffer overflow in privcmd ioctl
         [42d8644bd77dd2d747e004e367cb0c895a606f39]

David Howells (1):
      afs: Fix StoreData op marshalling
         [8c7ae38d1ce12a0eaeba655df8562552b3596c7f]

Denis Efremov (4):
      floppy: fix div-by-zero in setup_format_params
         [f3554aeb991214cbfafd17d55e2bfddb50282e32]
      floppy: fix invalid pointer dereference in drive_name
         [9b04609b784027968348796a18f601aed9db3789]
      floppy: fix out-of-bounds read in copy_buffer
         [da99466ac243f15fbba65bd261bfc75ffa1532b6]
      floppy: fix out-of-bounds read in next_valid_format
         [5635f897ed83fd539df78e98ba69ee91592f9bb8]

Dragos Bogdan (1):
      iio: ad_sigma_delta: select channel when reading register
         [fccfb9ce70ed4ea7a145f77b86de62e38178517f]

Eric Dumazet (7):
      dccp: do not use ipv6 header for ipv4 flow
         [e0aa67709f89d08c8d8e5bdd9e0b649df61d0090]
      inet: switch IP ID generator to siphash
         [df453700e8d81b1bdafdf684365ee2b9431fb702]
      ipv6/flowlabel: wait rcu grace period before put_pid()
         [6c0afef5fb0c27758f4d52b2210c61b6bd8b4470]
      l2ip: fix possible use-after-free
         [a622b40035d16196bf19b2b33b854862595245fc]
      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()
         [c1c477217882c610a2ba0268f5faf36c9c092528]
      net/rose: fix unbound loop in rose_loopback_timer()
         [0453c682459583910d611a96de928f4442205493]
      tcp: do not use ipv6 header for ipv4 flow
         [89e4130939a20304f4059ab72179da81f5347528]

Erik Schmauss (1):
      ACPICA: Namespace: remove address node from global list after method termination
         [c5781ffbbd4f742a58263458145fe7f0ac01d9e0]

Fabrice Gasnier (1):
      iio: core: fix a possible circular locking dependency
         [7f75591fc5a123929a29636834d1bcb8b5c9fee3]

Finn Thain (1):
      mac8390: Fix mmio access size probe
         [bb9e5c5bcd76f4474eac3baf643d7a39f7bac7bb]

Florian Westphal (2):
      netfilter: ctnetlink: don't use conntrack/expect object addresses as id
         [3c79107631db1f7fd32cf3f7368e4672004a3010]
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
         [7caa56f006e9d712b44f27b32520c66420d5cbc6]

Frank Sorenson (1):
      cifs: do not attempt cifs operation on smb2+ rename error
         [652727bbe1b17993636346716ae5867627793647]

Frederic Weisbecker (1):
      locking/lockdep: Add IRQs disabled/enabled assertion APIs: lockdep_assert_irqs_enabled()/disabled()
         [f54bb2ec02c839f6bfe3e8d438cd93d30b4809dd]

Geert Uytterhoeven (1):
      net: mac8390: Use standard memcpy_{from,to}io()
         [4042cd756e193f49469d31a23d5b85c4dca2a3b6]

Georg Ottinger (1):
      iio: adc: at91: disable adc channel interrupt in timeout case
         [09c6bdee51183a575bf7546890c8c137a75a2b44]

George McCollister (1):
      USB: serial: ftdi_sio: add additional NovaTech products
         [422c2537ba9d42320f8ab6573940269f87095320]

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level
         [2a017fd82c5402b3c8df5e3d6e5165d9e6147dc1]

Greg Kroah-Hartman (1):
      USB: serial: cp210x: add new device id
         [a595ecdd5f60b2d93863cebb07eec7f935839b54]

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup
         [47b16820c490149c2923e8474048f2c6e7557cab]

Gustavo A. R. Silva (2):
      ALSA: rawmidi: Fix potential Spectre v1 vulnerability
         [2b1d9c8f87235f593826b9cf46ec10247741fff9]
      ALSA: seq: oss: Fix Spectre v1 vulnerability
         [c709f14f0616482b67f9fbcb965e1493a03ff30b]

Haibinzhang (1):
      vhost-net: set packet weight of tx polling to 2 * vq size
         [a2ac99905f1ea8b15997a6ec39af69aa28a3653b]

Hangbin Liu (1):
      team: fix possible recursive locking when add slaves
         [925b0c841e066b488cc3a60272472b2c56300704]

Hannes Frederic Sowa (3):
      ipv4: hash net ptr into fragmentation bucket selection
         [b6a7719aedd7e5c0f2df7641aa47386111682df4]
      ipv4: ip_tunnel: use net namespace from rtable not socket
         [926a882f6916fd76b6f8ee858d45a2241c5e7999]
      ipv6: hash net ptr into fragmentation bucket selection
         [5a352dd0a3aac03b443c94828dfd7144261c8636]

Heiner Kallweit (1):
      net: phy: don't clear BMCR in genphy_soft_reset
         [d29f5aa0bc0c321e1b9e4658a2a7e08e885da52a]

Hoan Nguyen An (1):
      serial: sh-sci: Fix setting SCSCR_TIE while transferring data
         [93bcefd4c6bad4c69dbc4edcd3fbf774b24d930d]

Ian Abbott (2):
      staging: comedi: vmk80xx: Fix possible double-free of ->usb_rx_buf
         [663d294b4768bfd89e529e069bffa544a830b5bf]
      staging: comedi: vmk80xx: Fix use of uninitialized semaphore
         [08b7c2f9208f0e2a32159e4e7a4831b7adb10a3e]

Igor Redko (1):
      mm/page_alloc.c: calculate 'available' memory in a separate function
         [d02bd27bd33dd7e8d22594cd568b81be0cb584cd]

Ilya Dryomov (1):
      dm table: propagate BDI_CAP_STABLE_WRITES to fix sporadic checksum errors
         [eb40c0acdc342b815d4d03ae6abb09e80c0f2988]

Jack Morgenstein (1):
      IB/mlx4: Fix race condition between catas error reset and aliasguid flows
         [587443e7773e150ae29e643ee8f41a1eed226565]

Jan Kara (1):
      udf: Fix crash on IO error during truncate
         [d3ca4651d05c0ff7259d087d8c949bcf3e14fb46]

Jann Horn (1):
      device_cgroup: fix RCU imbalance in error case
         [0fcc4c8c044e117ac126ab6df4138ea9a67fa2a9]

Jason A. Donenfeld (1):
      siphash: add cryptographically secure PRF
         [2c956a60778cbb6a27e0c7a8a52a91378c90e1d1]

Jason Wang (4):
      vhost: introduce vhost_exceeds_weight()
         [e82b9b0727ff6d665fff2d326162b460dded554d]
      vhost: scsi: add weight support
         [c1ea02f15ab5efb3e93fc3144d895410bf79fcf2]
      vhost_net: fix possible infinite loop
         [e2412c07f8f3040593dfb88207865a3cd58680c0]
      vhost_net: introduce vhost_exceeds_weight()
         [272f35cba53d088085e5952fd81d7a133ab90789]

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout
         [b90cd6f2b905905fb42671009dc0e27c310a16ae]

Jean-Francois Dagenais (1):
      iio: dac: mcp4725: add missing powerdown bits in store eeprom
         [06003531502d06bc89d32528f6ec96bf978790f9]

Jeff Layton (1):
      ceph: ensure d_name stability in ceph_dentry_hash()
         [76a495d666e5043ffc315695f8241f5e94a98849]

Jie Liu (1):
      tipc: set sysctl_tipc_rmem and named_timeout right range
         [4bcd4ec1017205644a2697bccbc3b5143f522f5f]

Jim Mattson (1):
      kvm: x86: IA32_ARCH_CAPABILITIES is always supported
         [1eaafe91a0df4157521b6417b3dd8430bf5f52f0]

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly
         [3c677d206210f53a4be972211066c0f1cd47fe12]

Johannes Berg (1):
      mac80211: don't attempt to rename ERR_PTR() debugfs dirs
         [517879147493a5e1df6b89a50f708f1133fcaddb]

Johannes Thumshirn (1):
      btrfs: correctly validate compression type
         [aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e]

Johannes Weiner (1):
      proc: meminfo: estimate available memory more conservatively
         [84ad5802a33a4964a49b8f7d24d80a214a096b19]

Josh Poimboeuf (3):
      x86/entry/64: Use JMP instead of JMPQ
         [64dbc122b20f75183d8822618c24f85144a5a94d]
      x86/speculation: Enable Spectre v1 swapgs mitigations
         [a2059825986a1c8143fd6698774fa9d83733bb11]
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
         [18ec54fdd6d18d92025af097cd042a75cf0ea24c]

Juergen Gross (1):
      xen: let alloc_xenballooned_pages() fail if not enough memory free
         [a1078e821b605813b63bf6bca414a85f804d5c66]

Jérôme Glisse (1):
      block: do not leak memory in bio_copy_user_iov()
         [a3761c3c91209b58b6f33bf69dd8bb8ec0c9d925]

Kangjie Lu (2):
      tty: atmel_serial: fix a potential NULL pointer dereference
         [c85be041065c0be8bc48eda4c45e0319caf1d0e5]
      tty: mxs-auart: fix a potential NULL pointer dereference
         [6734330654dac550f12e932996b868c6d0dcb421]

Kohji Okuno (1):
      ARM: imx6q: cpuidle: fix bug that CPU might not wake up at expected time
         [91740fc8242b4f260cfa4d4536d8551804777fae]

Konstantin Khlebnikov (1):
      mm/vmstat.c: fix /proc/vmstat format for CONFIG_DEBUG_TLBFLUSH=y CONFIG_SMP=n
         [e8277b3b52240ec1caad8e6df278863e4bf42eac]

Lars-Peter Clausen (1):
      iio: Fix scan mask selection
         [20ea39ef9f2f911bd01c69519e7d69cfec79fde3]

Leonard Pollak (1):
      Staging: iio: meter: fixed typo
         [0a8a29be499cbb67df79370aaf5109085509feb8]

Lin Yi (1):
      USB: serial: mos7720: fix mos_parport refcount imbalance on error path
         [2908b076f5198d231de62713cb2b633a3a4b95ac]

Linus Torvalds (1):
      slip: make slhc_free() silently accept an error pointer
         [baf76f0c58aec435a3a864075b8f6d8ee5d1f17e]

Liu Jian (1):
      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer
         [d9b8a67b3b95a5c5aae6422b8113adc1c2485f2b]

Lu Baolu (1):
      iommu/vt-d: Check capability before disabling protected memory
         [5bb71fc790a88d063507dc5d445ab8b14e845591]

Lukas Czerner (2):
      ext4: add missing brelse() in add_new_gdb_meta_bg()
         [d64264d6218e6892edd832dc3a5a5857c2856c53]
      ext4: fix data corruption caused by unaligned direct AIO
         [372a03e01853f860560eade508794dd274e9b390]

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe
         [c409ca3be3c6ff3a1eeb303b191184e80d412862]

Marco Felsch (1):
      ARM: dts: pfla02: increase phy reset duration
         [032f85c9360fb1a08385c584c2c4ed114b33c260]

Markus Elfring (1):
      iio: Use kmalloc_array() in iio_scan_mask_set()
         [057ac1acdfc4743f066fcefe359385cad00549eb]

Masami Hiramatsu (3):
      kprobes: Mark ftrace mcount handler functions nokprobe
         [fabe38ab6b2bd9418350284c63825f13b8a6abba]
      x86/kprobes: Avoid kretprobe recursion bug
         [b191fa96ea6dc00d331dcc28c1f7db5e075693a0]
      x86/kprobes: Verify stack frame on kretprobe
         [3ff9c075cc767b3060bdac12da72fc94dd7da1b8]

Mathias Nyman (1):
      xhci: Don't let USB3 ports stuck in polling state prevent suspend
         [d92f2c59cc2cbca6bfb2cc54882b58ba76b15fd4]

Max Filippov (1):
      xtensa: fix return_address
         [ada770b1e74a77fff2d5f539bf6c42c25f4784db]

Mel Gorman (1):
      sched/fair: Do not re-read ->h_load_next during hierarchical load calculation
         [0e9f02450da07fc7b1346c8c32c771555173e397]

Michael Ellerman (1):
      powerpc/vdso64: Fix CLOCK_MONOTONIC inconsistencies across Y2038
         [b5b4453e7912f056da1ca7572574cada32ecb60c]

Michael Neuling (1):
      powerpc/tm: Fix oops on sigreturn on systems without TM
         [f16d80b75a096c52354c6e0a574993f3b0dfbdfe]

Mike Snitzer (1):
      dm: disable DISCARD if the underlying storage no longer supports it
         [bcb44433bba5eaff293888ef22ffa07f1f0347d6]

NeilBrown (2):
      NFS: fix mount/umount race in nlmclnt.
         [4a9be28c45bf02fa0436808bb6c0baeba30e120e]
      sunrpc: don't mark uninitialised items as VALID.
         [d58431eacb226222430940134d97bfd72f292fcd]

Nick Desaulniers (1):
      lib/string.c: implement a basic bcmp
         [5f074f3e192f10c9fade898b9b3b8812e3d83342]

Nikolay Aleksandrov (1):
      net: bridge: multicast: use rcu to access port list from br_multicast_start_querier
         [c5b493ce192bd7a4e7bd073b5685aad121eeef82]

Paolo Abeni (1):
      vhost_net: use packet weight for rx handler, too
         [db688c24eada63b1efe6d0d7d835e5c3bdd71fd3]

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse
         [d6097c9e4454adf1f8f2c9547c2fa6060d55d952]

Phil Auld (1):
      sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup
         [2e8e19226398db8265a8e675fcc0118b9e80c9e8]

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp
         [f32c2877bcb068a718bb70094cd59ccc29d4d082]

Ronnie Sahlberg (1):
      cifs: fix handle leak in smb2_query_symlink()
         [e6d0fb7b34f264f72c33053558a360a6a734905e]

Sabrina Dubroca (1):
      ipv6: call ipv6_proxy_select_ident instead of ipv6_select_ident in udp6_ufo_fragment
         [8e199dfd82ee097b522b00344af6448715d8ee0c]

Samuel Thibault (1):
      staging: speakup_soft: Fix alternate speech with other synths
         [45ac7b31bc6c4af885cc5b5d6c534c15bcbe7643]

Sean Christopherson (2):
      KVM: Reject device ioctls from processes other than the VM's creator
         [ddba91801aeb5c160b660caed1800eb3aef403f8]
      KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts
         [0cf9135b773bf32fba9dd8e6699c1b331ee4b749]

Steffen Klassert (3):
      xfrm4: Fix header checks in _decode_session4.
         [1a14f1e5550a341f76e5c8f596e9b5f8a886dfbc]
      xfrm4: Fix uninitialized memory read in _decode_session4
         [8742dc86d0c7a9628117a989c11f04a9b6b898f3]
      xfrm4: Reload skb header pointers after calling pskb_may_pull.
         [ea673a4d3a337184f3c314dcc6300bf02f39e077]

Steffen Maier (2):
      scsi: zfcp: fix rport unblock if deleted SCSI devices on Scsi_Host
         [fe67888fc007a76b81e37da23ce5bd8fb95890b0]
      scsi: zfcp: fix scsi_eh host reset with port_forced ERP for non-NPIV FCP devices
         [242ec1455151267fe35a0834aa9038e4c4670884]

Stephane Eranian (1):
      perf/core: Restore mmap record type correctly
         [d9c1bb2f6a2157b38e8eb63af437cb22701d31ee]

Su Yanjun (1):
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module
         [6ee02a54ef990a71bf542b6f0a4e3321de9d9c66]

Sven Eckelmann (3):
      batman-adv: Reduce claim hash refcnt only for removed entry
         [4ba104f468bbfc27362c393815d03aa18fb7a20f]
      batman-adv: Reduce tt_global hash refcnt only for removed entry
         [f131a56880d10932931e74773fb8702894a94a75]
      batman-adv: Reduce tt_local hash refcnt only for removed entry
         [3d65b9accab4a7ed5038f6df403fbd5e298398c7]

Takashi Iwai (3):
      ALSA: core: Fix card races between register and disconnect
         [2a3f7221acddfe1caa9ff09b3a8158c39b2fdeac]
      ALSA: pcm: Don't suspend stream in unrecoverable PCM state
         [113ce08109f8e3b091399e7cc32486df1cff48e7]
      ALSA: pcm: Fix possible OOB access in PCM oss plugins
         [ca0214ee2802dd47239a4e39fb21c5b00ef61b22]

Thomas Gleixner (2):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS
         [f36cf386e3fec258a341d446915862eded3e13d8]
      x86/speculation: Prevent deadlock on ssb_state::lock
         [2f5fb19341883bb6e37da351bc3700489d8506a7]

Vijayakumar Durai (1):
      rt2x00: do not increment sequence number while re-transmitting
         [746ba11f170603bf1eaade817553a6c2e9135bbe]

Vlad Yasevich (4):
      Revert "drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets"
         [72f6510745592c87f612f62ae4f16bb002934df4]
      ipv6: Fix fragment id assignment on LE arches.
         [51f30770e50eb787200f30a79105e2615b379334]
      ipv6: Make __ipv6_select_ident static
         [8381eacf5c3b35cf7755f4bc521c4d56d24c1cd9]
      ipv6: Select fragment id during UFO segmentation if not set.
         [0508c07f5e0c94f38afd5434e8b2a55b84553077]

Vladis Dronov (1):
      Bluetooth: hci_uart: check for missing tty operations
         [b36a1552d7319bbfd5cf7f08726c23c5c66d4f73]

Wanpeng Li (1):
      x86/entry/64: Fix context tracking state warning when load_gs_index fails
         [2fa5f04f85730d0c4f49f984b7efeb4f8d5bd1fc]

Willem de Bruijn (3):
      ipv6: invert flowlabel sharing check in process and user mode
         [95c169251bf734aa555a1e8043e4d88ec97a04ec]
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll
         [b2cf86e1563e33a14a1c69b3e508d15dc12f804c]
      packet: validate msg_namelen in send directly
         [486efdc8f6ce802b27e15921d2353cc740c55451]

Xie XiuQi (1):
      sched/numa: Fix a possible divide-by-zero
         [a860fa7b96e1a1c974556327aa1aee852d434c21]

Xin Long (3):
      ipv6: check sk sk_type and protocol early in ip_mroute_set/getsockopt
         [99253eb750fda6a644d5188fb26c43bad8d5a745]
      netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING
         [e166e4fdaced850bee3d5ee12a5740258fb30587]
      sctp: get sctphdr by offset in sctp_compute_cksum
         [273160ffc6b993c7c91627f5a84799c66dfe4dee]

YueHaibing (5):
      dccp: Fix memleak in __feat_register_sp
         [1d3ff0950e2b40dc861b1739029649d03f591820]
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
         [89189557b47b35683a27c80ee78aef18248eefb4]
      fs/proc/proc_sysctl.c: fix NULL pointer dereference in put_links
         [23da9588037ecdd4901db76a5b79a42b529c4ec3]
      net-sysfs: call dev_hold if kobject_init_and_add success
         [a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e]
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink
         [b805d78d300bcf2c83d6df7da0c818b0fee41427]

Zhangyi (1):
      ext4: brelse all indirect buffer in ext4_ind_remove_space()
         [674a2b27234d1b7afcb0a9162e81b2e53aeef217]

Zubin Mithra (1):
      ALSA: seq: Fix OOB-reads from strlcpy
         [212ac181c158c09038c474ba68068be49caecebb]

 Documentation/kernel-parameters.txt              |   5 +
 Documentation/siphash.txt                        | 100 ++++++++++
 Documentation/usb/power-management.txt           |  14 +-
 Documentation/virtual/kvm/api.txt                |  16 +-
 MAINTAINERS                                      |   7 +
 Makefile                                         |   4 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi     |   1 +
 arch/arm/mach-imx/cpuidle-imx6q.c                |  27 +--
 arch/mips/kernel/scall64-o32.S                   |   2 +-
 arch/powerpc/include/asm/vdso_datapage.h         |   8 +-
 arch/powerpc/kernel/signal_32.c                  |   3 +
 arch/powerpc/kernel/signal_64.c                  |   5 +
 arch/powerpc/kernel/vdso32/gettimeofday.S        |   2 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S        |   2 +-
 arch/x86/include/asm/calling.h                   |  18 ++
 arch/x86/include/asm/cpufeatures.h               |  41 ++--
 arch/x86/include/asm/kvm_host.h                  |  13 +-
 arch/x86/include/asm/xen/hypercall.h             |   3 +
 arch/x86/kernel/cpu/bugs.c                       | 105 +++++++++-
 arch/x86/kernel/cpu/common.c                     |  42 ++--
 arch/x86/kernel/entry_64.S                       |  73 +++++--
 arch/x86/kernel/kprobes/core.c                   |  48 ++++-
 arch/x86/kernel/process.c                        |   8 +-
 arch/x86/kvm/cpuid.c                             |   5 +
 arch/x86/kvm/mmu.c                               |  13 +-
 arch/x86/kvm/mmu.h                               |   2 +-
 arch/x86/kvm/vmx.c                               |  15 --
 arch/x86/kvm/x86.c                               |  18 +-
 arch/xtensa/kernel/stacktrace.c                  |   6 +-
 block/bio.c                                      |   5 +-
 drivers/acpi/acpica/nsobject.c                   |   4 +
 drivers/block/floppy.c                           |  32 +++-
 drivers/block/xsysace.c                          |   2 +
 drivers/bluetooth/hci_ath.c                      |   3 +
 drivers/bluetooth/hci_ldisc.c                    |   9 +
 drivers/bluetooth/hci_uart.h                     |   1 +
 drivers/gpio/gpio-adnp.c                         |   6 +-
 drivers/iio/adc/ad_sigma_delta.c                 |   1 +
 drivers/iio/adc/at91_adc.c                       |  28 +--
 drivers/iio/dac/mcp4725.c                        |   1 +
 drivers/iio/industrialio-buffer.c                |   6 +-
 drivers/iio/industrialio-core.c                  |   4 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c          |   2 +-
 drivers/input/tablet/gtco.c                      |  20 +-
 drivers/iommu/amd_iommu_init.c                   |   2 +-
 drivers/iommu/intel-iommu.c                      |   3 +
 drivers/md/dm-table.c                            |  39 ++++
 drivers/md/dm.c                                  |  31 ++-
 drivers/media/usb/tlg2300/pd-common.h            |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c              |   6 +-
 drivers/net/ethernet/3com/3c515.c                |   2 +-
 drivers/net/ethernet/8390/mac8390.c              |  37 ++--
 drivers/net/ethernet/neterion/vxge/vxge-config.c |   1 +
 drivers/net/macvtap.c                            |   3 -
 drivers/net/phy/phy_device.c                     |   5 +-
 drivers/net/ppp/pptp.c                           |   2 +-
 drivers/net/slip/slhc.c                          |   2 +-
 drivers/net/team/team.c                          |   6 +
 drivers/net/tun.c                                |   6 +-
 drivers/net/wireless/rt2x00/rt2x00.h             |   1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c          |  10 -
 drivers/net/wireless/rt2x00/rt2x00queue.c        |  15 +-
 drivers/pci/quirks.c                             |   2 +
 drivers/s390/scsi/zfcp_erp.c                     |  17 ++
 drivers/s390/scsi/zfcp_ext.h                     |   2 +
 drivers/s390/scsi/zfcp_scsi.c                    |   4 +
 drivers/scsi/libsas/sas_expander.c               |   9 +-
 drivers/staging/comedi/drivers/vmk80xx.c         |   8 +-
 drivers/staging/iio/meter/ade7854.c              |   2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c            |  10 +-
 drivers/staging/rtl8712/rtl8712_cmd.h            |   2 +-
 drivers/staging/speakup/speakup_soft.c           |  12 +-
 drivers/staging/speakup/spk_priv.h               |   1 +
 drivers/staging/speakup/synth.c                  |   6 +
 drivers/staging/usbip/stub_rx.c                  |  12 +-
 drivers/staging/usbip/usbip_common.h             |   7 +
 drivers/tty/serial/atmel_serial.c                |   4 +
 drivers/tty/serial/max310x.c                     |   2 +
 drivers/tty/serial/mxs-auart.c                   |   4 +
 drivers/tty/serial/sh-sci.c                      |  12 +-
 drivers/usb/core/driver.c                        |  13 --
 drivers/usb/core/message.c                       |   4 +-
 drivers/usb/host/xhci-hub.c                      |  19 +-
 drivers/usb/host/xhci.h                          |   8 +
 drivers/usb/misc/yurex.c                         |   1 +
 drivers/usb/serial/cp210x.c                      |   1 +
 drivers/usb/serial/ftdi_sio.c                    |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                |   4 +-
 drivers/usb/serial/mos7720.c                     |   4 +-
 drivers/usb/storage/realtek_cr.c                 |  13 +-
 drivers/vhost/net.c                              |  31 +--
 drivers/vhost/scsi.c                             |  15 +-
 drivers/vhost/vhost.c                            |  20 +-
 drivers/vhost/vhost.h                            |   6 +-
 drivers/w1/masters/ds2490.c                      |   6 +-
 drivers/xen/balloon.c                            |  16 +-
 fs/afs/fsclient.c                                |   6 +-
 fs/btrfs/compression.c                           |  18 ++
 fs/btrfs/compression.h                           |   1 +
 fs/btrfs/props.c                                 |   5 +-
 fs/ceph/dir.c                                    |   6 +-
 fs/cifs/cifsglob.h                               |   2 +
 fs/cifs/file.c                                   |  30 ++-
 fs/cifs/inode.c                                  |   4 +
 fs/cifs/misc.c                                   |  25 ++-
 fs/cifs/smb2misc.c                               |   6 +-
 fs/cifs/smb2ops.c                                |   2 +
 fs/ext4/file.c                                   |   2 +-
 fs/ext4/indirect.c                               |  12 +-
 fs/ext4/resize.c                                 |  11 +-
 fs/lockd/host.c                                  |   3 +-
 fs/proc/meminfo.c                                |  34 +---
 fs/proc/proc_sysctl.c                            |   7 +-
 fs/udf/truncate.c                                |   3 +
 fs/ufs/util.h                                    |   2 +-
 include/linux/kprobes.h                          |   1 +
 include/linux/lockdep.h                          |  15 ++
 include/linux/mm.h                               |   1 +
 include/linux/siphash.h                          |  90 +++++++++
 include/linux/string.h                           |   3 +
 include/linux/usb.h                              |   2 -
 include/net/ip.h                                 |  12 +-
 include/net/ipv6.h                               |   4 +-
 include/net/netfilter/nf_conntrack.h             |   2 +
 include/net/netns/ipv4.h                         |   2 +
 include/net/sctp/checksum.h                      |   2 +-
 kernel/events/core.c                             |   2 +
 kernel/futex.c                                   |   4 +
 kernel/sched/fair.c                              |  35 +++-
 kernel/trace/ftrace.c                            |   5 +-
 kernel/trace/ring_buffer.c                       |   2 +-
 lib/Kconfig.debug                                |  10 +
 lib/Makefile                                     |   3 +-
 lib/siphash.c                                    | 232 +++++++++++++++++++++++
 lib/string.c                                     |  20 ++
 lib/test_siphash.c                               | 131 +++++++++++++
 mm/page_alloc.c                                  |  43 +++++
 mm/vmstat.c                                      |   5 -
 net/batman-adv/bridge_loop_avoidance.c           |  16 +-
 net/batman-adv/translation-table.c               |  32 +++-
 net/bridge/br_multicast.c                        |   4 +-
 net/bridge/br_netfilter.c                        |   3 +
 net/bridge/netfilter/ebtables.c                  |   3 +-
 net/core/net-sysfs.c                             |   6 +-
 net/dccp/feat.c                                  |   7 +-
 net/dccp/ipv6.c                                  |   4 +-
 net/ipv4/igmp.c                                  |   4 +-
 net/ipv4/ip_output.c                             |   7 +-
 net/ipv4/ip_tunnel_core.c                        |   3 +-
 net/ipv4/ipmr.c                                  |   7 +-
 net/ipv4/raw.c                                   |   2 +-
 net/ipv4/route.c                                 |  16 +-
 net/ipv4/xfrm4_mode_tunnel.c                     |   2 +-
 net/ipv4/xfrm4_policy.c                          |  60 ++++--
 net/ipv6/ip6_flowlabel.c                         |  24 ++-
 net/ipv6/ip6_output.c                            |  23 +--
 net/ipv6/ip6mr.c                                 |  11 +-
 net/ipv6/output_core.c                           |  53 +++++-
 net/ipv6/tcp_ipv6.c                              |   8 +-
 net/ipv6/udp_offload.c                           |   6 +
 net/ipv6/xfrm6_tunnel.c                          |   4 +
 net/l2tp/l2tp_core.c                             |  10 +-
 net/mac80211/debugfs_netdev.c                    |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                  |   5 +-
 net/netfilter/nf_conntrack_core.c                |  36 ++++
 net/netfilter/nf_conntrack_netlink.c             |  34 +++-
 net/packet/af_packet.c                           |  37 ++--
 net/rose/rose_loopback.c                         |  34 ++--
 net/sunrpc/cache.c                               |   3 +
 net/tipc/sysctl.c                                |   4 +-
 net/xfrm/xfrm_user.c                             |   2 +-
 security/device_cgroup.c                         |   2 +-
 sound/core/init.c                                |  18 +-
 sound/core/oss/pcm_oss.c                         |  43 +++--
 sound/core/pcm_native.c                          |   9 +-
 sound/core/rawmidi.c                             |   2 +
 sound/core/seq/oss/seq_oss_synth.c               |   7 +-
 sound/core/seq/seq_clientmgr.c                   |   6 +-
 tools/lib/traceevent/event-parse.c               |   2 +-
 tools/perf/tests/evsel-tp-sched.c                |   1 +
 virt/kvm/kvm_main.c                              |   3 +
 181 files changed, 1982 insertions(+), 570 deletions(-)

-- 
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

