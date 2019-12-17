Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801C212213A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfLQAva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34456 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbfLQAv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:29 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0003IM-GA; Tue, 17 Dec 2019 00:51:27 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15C-0005RH-MJ; Tue, 17 Dec 2019 00:51:26 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 17 Dec 2019 00:45:34 +0000
Message-ID: <lsq.1576543534.33060804@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/136] 3.16.80-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.80 release.
There are 136 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Dec 19 12:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (3):
      ceph: add missing check in d_revalidate snapdir handling
         [1f08529c84cfecaf1261ed9b7e17fab18541c58f]
      ecryptfs_lookup_interpose(): lower_dentry->d_inode is not stable
         [e72b9dd6a5f17d0fb51f16f8685f3004361e83d0]
      ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either
         [762c69685ff7ad5ad7fee0656671e20a0c9c864d]

Alan Stern (2):
      USB: gadget: Reject endpoints with 0 maxpacket value
         [54f83b8c8ea9b22082a496deadf90447a326954e]
      USB: yurex: Don't retry on unexpected errors
         [32a0721c6620b77504916dac0cea8ad497c4878a]

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue
         [2c409ba81be25516afe05ae27a4a15da01740b01]

Alexandre Belloni (1):
      clk: at91: avoid sleeping early
         [658fd65cf0b0d511de1718e48d9a28844c385ae0]

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU
         [5effc09c4907901f0e71e68e5f2e14211d9a203f]

Andreas Sandberg (1):
      tick: hrtimer-broadcast: Prevent endless restarting when broadcast device is unused
         [38d23a6cc16c02f7b0c920266053f340b5601735]

Andrey Ryabinin (1):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()
         [9a63236f1ad82d71a98aa80320b6cb618fb32f44]

Balasubramani Vivekanandan (1):
      tick: broadcast-hrtimer: Fix a race in bc_set_next
         [b9023b91dd020ad7e093baa5122b6968c48cc9e0]

Bart Van Assche (1):
      RDMA/iwcm: Fix a lock inversion issue
         [b66f31efbdad95ec274345721d99d1d835e6de01]

Bastien Nocera (1):
      USB: rio500: Remove Rio 500 kernel driver
         [015664d15270a112c2371d812f03f7c579b35a73]

Beni Mahler (1):
      USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20
         [357f16d9e0194cdbc36531ff88b453481560b76a]

Christophe JAILLET (1):
      memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'
         [28c9fac09ab0147158db0baeec630407a5e9b892]

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.
         [ba3a1a915c49cc3023e4ddfc88f21e7514e82aa4]

Dan Carpenter (3):
      USB: legousbtower: fix a signedness bug in tower_probe()
         [fd47a417e75e2506eb3672ae569b1c87e3774155]
      block: drbd: remove a stray unlock in __drbd_send_protocol()
         [8e9c523016cf9983b295e4bc659183d1fa6ef8e0]
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()
         [30b7244d79651460ff114ba8f7987ed94c86b99a]

Daniel Wagner (1):
      scsi: lpfc: Honor module parameter lpfc_use_adisc
         [0fd103ccfe6a06e40e2d9d8c91d96332cc9e1239]

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path
         [f67169fef8dbcc1ac6a6a109ecaad0d3b259002c]

Denis Efremov (1):
      staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()
         [22d67a01d8d89552b989c9651419824bb4111200]

Doug Berger (2):
      net: bcmgenet: reset 40nm EPHY on energy detect
         [25382b991d252aed961cd434176240f9de6bb15f]
      net: phy: bcm7xxx: define soft_reset for 40nm EPHY
         [fe586b823372a9f43f90e2c6aa0573992ce7ccb7]

Eric Biggers (1):
      llc: fix sk_buff leak in llc_sap_state_process()
         [c6ee11c39fcc1fb55130748990a8f199e76263b4]

Eric Dumazet (8):
      dccp: do not leak jiffies on the wire
         [3d1e5039f5f87a8731202ceca08764ee7cb010d3]
      inet: stop leaking jiffies on the wire
         [a904a0693c189691eeee64f6c6b188bd7dc244e9]
      ipv6: drop incoming packets having a v4mapped source address
         [6af1799aaf3f1bc8defedddfa00df3192445bbf3]
      ipvs: move old_secure_tcp into struct netns_ipvs
         [c24b75e0f9239e78105f81c5f03a751641eb07ef]
      net: avoid potential infinite loop in tc_ctl_action()
         [39f13ea2f61b439ebe0060393e9c39925c9ee28c]
      nfc: fix memory leak in llcp_sock_bind()
         [a0c2dc1fe63e2869b74c1c7f6a81d1745c8a695d]
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
         [e9789c7cc182484fc031fd88097eb14cb26c4596]
      sch_dsmark: fix potential NULL deref in dsmark_init()
         [474f0813a3002cb299bb73a5a93aa1f537a80ca8]

Filipe Manana (1):
      Btrfs: check for the full sync flag while holding the inode lock during fsync
         [ba0b084ac309283db6e329785c1dc4f45fdbd379]

Florian Fainelli (1):
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
         [efb86fede98cdc70b674692ff617b1162f642c49]

Gustavo A. R. Silva (1):
      usb: udc: lpc32xx: fix bad bit shift operation
         [b987b66ac3a2bc2f7b03a0ba48a07dc553100c07]

Helge Deller (1):
      parisc: Fix vmap memory leak in ioremap()/iounmap()
         [513f7f747e1cba81f28a436911fba0b485878ebd]

Henry Lin (1):
      ALSA: usb-audio: not submit urb for stopped endpoint
         [528699317dd6dc722dccc11b68800cf945109390]

Jacky.Cao@sony.com (1):
      USB: dummy-hcd: fix power budget for SuperSpeed mode
         [2636d49b64671d3d90ecc4daf971b58df3956519]

Jakub Kicinski (1):
      net: netem: correct the parent's backlog when corrupted packet was dropped
         [e0ad032e144731a5928f2d75e91c2064ba1a764c]

Jan Schmidt (1):
      xhci: Check all endpoints for LPM timeout
         [d500c63f80f2ea08ee300e57da5f2af1c13875f5]

Jeff Layton (1):
      ceph: just skip unrecognized info in ceph_reply_info_extra
         [1d3f87233e26362fc3d4e59f0f31a71b570f90b9]

Jiri Olsa (1):
      perf tools: Fix time sorting
         [722ddfde366fd46205456a9c5ff9b3359dc9a75e]

Johan Hovold (30):
      USB: adutux: fix NULL-derefs on disconnect
         [b2fa7baee744fde746c17bc1860b9c6f5c2eebb7]
      USB: adutux: fix use-after-free on release
         [123a0f125fa3d2104043697baa62899d9e549272]
      USB: iowarrior: fix use-after-free after driver unbind
         [b5f8d46867ca233d773408ffbe691a8062ed718f]
      USB: iowarrior: fix use-after-free on release
         [80cd5479b525093a56ef768553045741af61b250]
      USB: ldusb: fix NULL-derefs on driver unbind
         [58ecf131e74620305175a7aa103f81350bb37570]
      USB: ldusb: fix control-message timeout
         [52403cfbc635d28195167618690595013776ebde]
      USB: ldusb: fix memleak on disconnect
         [b14a39048c1156cfee76228bf449852da2f14df8]
      USB: ldusb: fix read info leaks
         [7a6f22d7479b7a0b68eadd308a997dd64dda7dae]
      USB: ldusb: fix ring-buffer locking
         [d98ee2a19c3334e9343df3ce254b496f1fc428eb]
      USB: legousbtower: fix deadlock on disconnect
         [33a7813219f208f4952ece60ee255fd983272dec]
      USB: legousbtower: fix memleak on disconnect
         [b6c03e5f7b463efcafd1ce141bd5a8fc4e583ae2]
      USB: legousbtower: fix open after failed reset request
         [0b074f6986751361ff442bc1127c1648567aa8d6]
      USB: legousbtower: fix potential NULL-deref on disconnect
         [cd81e6fa8e033e7bcd59415b4a65672b4780030b]
      USB: legousbtower: fix slab info leak at probe
         [1d427be4a39defadda6dd8f4659bc17f7591740f]
      USB: legousbtower: fix use-after-free on release
         [726b55d0e22ca72c69c947af87785c830289ddbc]
      USB: microtek: fix info-leak at probe
         [177238c3d47d54b2ed8f0da7a4290db492f4a057]
      USB: serial: fix runtime PM after driver unbind
         [d51bdb93ca7e71d7fb30a572c7b47ed0194bf3fe]
      USB: serial: keyspan: fix NULL-derefs on open() and write()
         [7d7e21fafdbc7fcf0854b877bd0975b487ed2717]
      USB: serial: ti_usb_3410_5052: fix port-close races
         [6f1d1dc8d540a9aa6e39b9cb86d3a67bbc1c8d8d]
      USB: serial: whiteheat: fix line-speed endianness
         [84968291d7924261c6a0624b9a72f952398e258b]
      USB: serial: whiteheat: fix potential slab corruption
         [1251dab9e0a2c4d0d2d48370ba5baa095a5e8774]
      USB: usb-skeleton: fix NULL-deref on disconnect
         [bed5ef230943863b9abf5eae226a20fad9a8ff71]
      USB: usb-skeleton: fix runtime PM after driver unbind
         [5c290a5e42c3387e82de86965784d30e6c5270fd]
      USB: usblcd: fix I/O after disconnect
         [eb7f5a490c5edfe8126f64bc58b9ba2edef0a425]
      USB: usblp: fix runtime PM after driver unbind
         [9a31535859bfd8d1c3ed391f5e9247cd87bb7909]
      USB: usblp: fix use-after-free on disconnect
         [7a759197974894213621aa65f0571b51904733d6]
      USB: yurex: fix NULL-derefs on disconnect
         [aafb00a977cf7d81821f7c9d12e04c558c22dc3c]
      can: usb_8dev: fix use-after-free on disconnect
         [3759739426186a924675651b388d1c3963c5710e]
      hso: fix NULL-deref on tty open
         [8353da9fa69722b54cba82b2ec740afd3d438748]
      media: stkwebcam: fix runtime PM after driver unbind
         [30045f2174aab7fb4db7a9cf902d0aa6c75856a7]

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays
         [e4f5cb1a9b27c0f94ef4f5a0178a3fde2d3d0e9e]

Jose Abreu (1):
      net: stmmac: Correctly take timestamp for PTPv2
         [14f347334bf232074616e29e29103dd0c7c54dec]

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()
         [3d5c1a037d37392a6859afbde49be5ba6a70a6b3]

Kai-Heng Feng (1):
      x86/quirks: Disable HPET on Intel Coffe Lake platforms
         [fc5db58539b49351e76f19817ed1102bf7c712d0]

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock
         [5cbf2fff3bba8d3c6a4d47c1754de1cf57e2b01f]

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity
         [317b96bb14303c7998dbcd5bc606bd8038fdd4b4]
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family (10h)
         [e431e79b60603079d269e0c2a5177943b95fa4b6]

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ
         [3cb3eaac52c0f145d895f4b6c22834d5f02b8569]

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed
         [d791cfcbf98191122af70b053a21075cb450d119]

Lorenzo Bianconi (1):
      net: ipv4: use a dedicated counter for icmp_v4 redirect packets
         [c09551c6ff7fe16a79a42133bcecba5fc2fc3291]

Luis Henriques (1):
      ceph: fix use-after-free in __ceph_remove_cap()
         [ea60ed6fcf29eebc78f2ce91491e6309ee005a01]

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit
         [250367c59e6ba0d79d702a059712d66edacd4a1a]

Marek Szyprowski (1):
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume
         [e9323b664ce29547d996195e8a6129a351c39108]

Markus Pargmann (1):
      batman-adv: iv_ogm_iface_enable, direct return values
         [42d9f2cbd42e1ba137584da8305cf6f68b84f39d]

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop
         [1fab1b89e2e8f01204a9c05a39fd0b6411a48593]

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists
         [723eb53690041740a13ac78efeaf6804f5d684c9]

Mathias Nyman (1):
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too long
         [cd9d9491e835a845c1a98b8471f88d26285e0bb9]

Max Filippov (1):
      xtensa: drop EXPORT_SYMBOL for outs*/ins*
         [8b39da985194aac2998dd9e3a22d00b596cebf1e]

Michal Hocko (1):
      mm, vmstat: hide /proc/pagetypeinfo from normal users
         [abaed0112c1db08be15a784a2c5c8a8b3063cdd3]

Michał Mirosław (1):
      HID: fix error message in hid_open_report()
         [b3a81c777dcb093020680490ab970d85e2f6f04f]

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
         [b24e7598db62386a95a3c8b9c75630c5d56fe077]
      fuse: truncate pending writes on O_TRUNC
         [e4648309b85a78f8c787457832269a8712a8673e]

Nakajima Akira (1):
      Fix to check Unique id and FileType when client refer file directly.
         [7196ac113a4f38b7ca1a3282fd9edf328bd22287]

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path
         [d3566abb1a1e7772116e4d50fb6a58d19c9802e5]

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization
         [21e3d6c81179bbdfa279efc8de456c34b814cfd2]

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage
         [b406472b5ad79ede8d10077f0c8f05505ace8b6d]

Paul Burton (1):
      MIPS: tlbex: Fix build_restore_pagemask KScratch restore
         [b42aa3fd5957e4daf4b69129e5ce752a2a53e7d6]

Pavel Shilovsky (3):
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set
         [0b3d0ef9840f7be202393ca9116b857f6f793715]
      CIFS: Force revalidate inode when dentry is stale
         [c82e5ac7fe3570a269c0929bf7899f62048e7dbc]
      CIFS: Gracefully handle QueryInfo errors during open
         [30573a82fb179420b8aac30a3a3595aa96a93156]

Qian Cai (1):
      mm/slub: fix a deadlock in show_slab_objects()
         [e4f8e513c3d353c134ad4eef9fd0bba12406c7c8]

Rafael J. Wysocki (1):
      PCI: PM: Fix pci_power_up()
         [45144d42f299455911cc29366656c7324a3a7c97]

Randy Dunlap (1):
      serial: uartlite: fix exit path null pointer
         [a553add0846f355a28ed4e81134012e4a1e280c2]

Rick Tseng (1):
      usb: xhci: wait for CNR controller not ready bit in xhci resume
         [a70bcbc322837eda1ab5994d12db941dc9733a7d]

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF
         [03d9a9fe3f3aec508e485dd3dcfa1e99933b4bdb]

Roman Gushchin (2):
      mm: hugetlb: switch to css_tryget() in hugetlb_cgroup_charge_cgroup()
         [0362f326d86c645b5e96b7dbc3ee515986ed019d]
      mm: memcg: switch to css_tryget() in get_mem_cgroup_from_mm()
         [00d484f354d85845991b40141d40ba9e5eb60faf]

Ross Lagerwall (1):
      cifs: Check uniqueid for SMB2+ and return -ESTALE if necessary
         [a108471b5730b52017e73b58c9f486319d2ac308]

Russell King (2):
      ARM: mm: fix alignment handler faults under memory pressure
         [67e15fa5b487adb9b78a92789eeff2d6ec8f5cee]
      ASoC: kirkwood: fix external clock probe defer
         [4523817d51bc3b2ef38da768d004fda2c8bc41de]

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification
         [2190168aaea42c31bff7b9a967e7b045f07df095]

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets
         [de280f403f2996679e2607384980703710576fed]

Steven Rostedt (1):
      tracing: Get trace_array reference for available_tracers files
         [194c2c74f5532e62c218adeb8e2b683119503907]

Sven Eckelmann (1):
      batman-adv: Avoid free/alloc race when handling OGM buffer
         [40e220b4218bb3d278e5e8cc04ccdfd1c7ff8307]

Taehee Yoo (1):
      bonding: fix unexpected IFF_BONDING bit unset
         [65de65d9033750d2cf1b336c9d6e9da3a8b5cc6e]

Takashi Iwai (4):
      ALSA: timer: Fix incorrectly assigned timer instance
         [e7af6307a8a54f0b873960b32b6a644f2d0fbd97]
      ALSA: timer: Fix mutex deadlock at releasing card
         [a39331867335d4a94b6165e306265c9e24aca073]
      ALSA: timer: Simplify error path in snd_timer_open()
         [41672c0c24a62699d20aab53b98d843b16483053]
      ALSA: usb-audio: Fix missing error check at mixer resolution test
         [167beb1756791e0806365a3f86a0da10d7a327ee]

Takashi Sakamoto (2):
      ALSA: bebob: Fix prototype of helper function to return negative value
         [f2bbdbcb075f3977a53da3bdcb7cd460bc8ae5f2]
      ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series
         [706ad6746a66546daf96d4e4a95e46faf6cf689a]

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim
         [20eb4f29b60286e0d6dc01d9c260b4bd383c58fb]

Thomas Gleixner (1):
      tick: broadcast-hrtimer: Remove overly clever return value abuse
         [b8a62f1ff0ccb18fdc25c6150d1cd394610f4753]

Tomi Valkeinen (1):
      drm/omap: fix max fclk divider for omap36xx
         [e2c4ed148cf3ec8669a1d90dc66966028e5fad70]

Viresh Kumar (1):
      hrtimer: Store cpu-number in struct hrtimer_cpu_base
         [cddd02489f52ccf635ed65931214729a23b93cd6]

Will Deacon (2):
      mac80211: Reject malformed SSID elements
         [4152561f5da3fca92af7179dd538ea89e248f9d0]
      panic: ensure preemption is disabled during panic()
         [20bb759a66be52cf4a9ddd17fddaf509e11490cd]

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision
         [4929a4e6faa0f13289a67cae98139e727f0d4a97]

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()
         [b8e51a6a9db94bc1fb18ae831b3dab106b5a4b5f]

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt,wedge}()
         [1aae1394294cb71c6aa0bc904a94a7f2f1e75936]
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior
         [4d599cd3a097a85a5c68a2c82b9a48cddf9953ec]

Yufen Yu (1):
      scsi: core: try to get module before removing device
         [77c301287ebae86cc71d03eb3806f271cb14da79]

Zhangyi (1):
      fs/dcache: move  security_d_instantiate() behind attaching dentry to inode
         [not upstream; fixes stable-specific regression]

 Documentation/usb/rio.txt                          | 138 -----
 MAINTAINERS                                        |   7 -
 Makefile                                           |   4 +-
 arch/arc/kernel/perf_event.c                       |   4 +-
 arch/arm/configs/badge4_defconfig                  |   1 -
 arch/arm/configs/corgi_defconfig                   |   1 -
 arch/arm/configs/s3c2410_defconfig                 |   1 -
 arch/arm/configs/spitz_defconfig                   |   1 -
 arch/arm/mm/alignment.c                            |  44 +-
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/configs/mtx1_defconfig                   |   1 -
 arch/mips/configs/rm200_defconfig                  |   1 -
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 arch/mips/mm/tlbex.c                               |  23 +-
 arch/parisc/mm/ioremap.c                           |  12 +-
 arch/powerpc/configs/c2k_defconfig                 |   1 -
 arch/s390/mm/cmm.c                                 |  12 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |   5 +-
 arch/x86/kernel/early-quirks.c                     |   2 +
 arch/xtensa/kernel/xtensa_ksyms.c                  |   7 -
 drivers/block/drbd/drbd_main.c                     |   1 -
 drivers/char/virtio_console.c                      |  28 +-
 drivers/clk/at91/clk-main.c                        |   5 +-
 drivers/clk/at91/clk-slow.c                        |  15 +-
 drivers/clk/samsung/clk-exynos5420.c               |   6 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   1 +
 drivers/hid/hid-core.c                             |   7 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   3 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/net/bonding/bond_main.c                    |   6 +-
 drivers/net/can/c_can/c_can.c                      |  25 +-
 drivers/net/can/c_can/c_can.h                      |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  17 +-
 drivers/net/can/usb/usb_8dev.c                     |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  15 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   6 +-
 drivers/net/ethernet/sfc/ptp.c                     |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/phy/bcm7xxx.c                          |   1 +
 drivers/net/usb/hso.c                              |  12 +-
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/pci/pci.c                                  |  24 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/scsi/sd.c                                  |   3 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |   2 +-
 drivers/tty/serial/uartlite.c                      |   3 +-
 drivers/usb/class/usblp.c                          |  12 +-
 drivers/usb/gadget/atmel_usba_udc.c                |   6 +-
 drivers/usb/gadget/dummy_hcd.c                     |   3 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |   6 +-
 drivers/usb/host/xhci.c                            |  30 +-
 drivers/usb/image/microtek.c                       |   4 +
 drivers/usb/misc/Kconfig                           |  10 -
 drivers/usb/misc/Makefile                          |   1 -
 drivers/usb/misc/adutux.c                          |  19 +-
 drivers/usb/misc/iowarrior.c                       |   9 +-
 drivers/usb/misc/ldusb.c                           |  50 +-
 drivers/usb/misc/legousbtower.c                    |  63 +--
 drivers/usb/misc/rio500.c                          | 578 ---------------------
 drivers/usb/misc/rio500_usb.h                      |  37 --
 drivers/usb/misc/usblcd.c                          |  33 +-
 drivers/usb/misc/yurex.c                           |  18 +-
 drivers/usb/renesas_usbhs/common.h                 |   1 +
 drivers/usb/renesas_usbhs/fifo.c                   |   2 +-
 drivers/usb/renesas_usbhs/fifo.h                   |   1 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |  18 +-
 drivers/usb/renesas_usbhs/pipe.c                   |  15 +
 drivers/usb/renesas_usbhs/pipe.h                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   9 +
 drivers/usb/serial/keyspan.c                       |   4 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 drivers/usb/serial/usb-serial.c                    |   5 +-
 drivers/usb/serial/whiteheat.c                     |  13 +-
 drivers/usb/serial/whiteheat.h                     |   2 +-
 drivers/usb/usb-skeleton.c                         |  15 +-
 drivers/video/fbdev/omap2/dss/dss.c                |   2 +-
 fs/btrfs/file.c                                    |  36 +-
 fs/ceph/caps.c                                     |  10 +-
 fs/ceph/inode.c                                    |   1 +
 fs/ceph/mds_client.c                               |  21 +-
 fs/cifs/dir.c                                      |   8 +-
 fs/cifs/file.c                                     |   6 +
 fs/cifs/inode.c                                    |  53 +-
 fs/cifs/smb1ops.c                                  |   3 +
 fs/dcache.c                                        |   2 +-
 fs/ecryptfs/inode.c                                |  19 +-
 fs/fuse/dir.c                                      |  13 +
 fs/fuse/file.c                                     |  10 +-
 include/linux/gfp.h                                |  22 +
 include/linux/hrtimer.h                            |   2 +
 include/linux/usb/gadget.h                         |  10 +
 include/net/inetpeer.h                             |   1 +
 include/net/ip_vs.h                                |   1 +
 include/net/netfilter/nf_tables.h                  |   3 +-
 include/net/sock.h                                 |  11 +-
 kernel/hrtimer.c                                   |   1 +
 kernel/panic.c                                     |   1 +
 kernel/sched/fair.c                                |  36 +-
 kernel/time/tick-broadcast-hrtimer.c               |  57 +-
 kernel/trace/trace.c                               |  17 +-
 lib/dump_stack.c                                   |   7 +-
 mm/hugetlb_cgroup.c                                |   2 +-
 mm/ksm.c                                           |  14 +-
 mm/memcontrol.c                                    |   2 +-
 mm/slub.c                                          |  13 +-
 mm/vmstat.c                                        |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |  61 ++-
 net/batman-adv/hard-interface.c                    |   2 +
 net/batman-adv/types.h                             |   3 +
 net/dccp/ipv4.c                                    |   4 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/inetpeer.c                                |   1 +
 net/ipv4/route.c                                   |  12 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/ip6_input.c                               |  10 +
 net/llc/llc_s_ac.c                                 |  12 +-
 net/llc/llc_sap.c                                  |  23 +-
 net/mac80211/mlme.c                                |   5 +-
 net/netfilter/ipset/ip_set_core.c                  |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  15 +-
 net/nfc/llcp_sock.c                                |   7 +-
 net/sched/act_api.c                                |  12 +-
 net/sched/act_pedit.c                              |   4 +-
 net/sched/sch_cbq.c                                |  31 +-
 net/sched/sch_dsmark.c                             |   2 +
 net/sched/sch_netem.c                              |   2 +
 net/sctp/socket.c                                  |   2 +-
 net/wireless/nl80211.c                             |   3 +-
 sound/core/timer.c                                 |  67 ++-
 sound/firewire/bebob/bebob_focusrite.c             |   3 +
 sound/firewire/bebob/bebob_stream.c                |   3 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |   8 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/mixer.c                                  |   4 +-
 tools/perf/util/hist.c                             |   2 +-
 142 files changed, 958 insertions(+), 1236 deletions(-)

-- 
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.

