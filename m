Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2421DB705
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgETO3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:29:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60902 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbgETOWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:20 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034t-29; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DNs-KK; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 20 May 2020 15:13:28 +0100
Message-ID: <lsq.1589984008.673931885@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/99] 3.16.84-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.84 release.
There are 99 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri May 22 20:00:00 UTC 2020.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock
         [b0d3869ce9eeacbb1bbd541909beeef4126426d5]

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: define clock rate range for tcb1
         [a7e0f3fc01df4b1b7077df777c37feae8c9e8b6d]
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
         [ee0aa926ddb0bd8ba59e33e3803b3b5804e3f5da]

Ard Biesheuvel (1):
      efi/x86: Map the entire EFI vendor string before copying it
         [ffc2760bcf2dba0dbef74013ed73eea8310cc52c]

Arnd Bergmann (2):
      sparc32: fix struct ipc64_perm type definition
         [34ca70ef7d3a9fa7e89151597db5e37ae1d429b4]
      x86: kvm: avoid unused variable warning
         [7288bde1f9df6c1475675419bdd7725ce84dec56]

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode
         [09ed259fac621634d51cd986aa8d65f035662658]

Bryan O'Donoghue (2):
      usb: gadget: f_ecm: Use atomic_t to track in-flight request
         [d710562e01c48d59be3f60d58b7a85958b39aeda]
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
         [5b24c28cfe136597dc3913e1c00b119307a20c7e]

Chen Yucong (1):
      kvm: x86: use macros to compute bank MSRs
         [81760dccf8d1fe5b128b58736fe3f56a566133cb]

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width
         [b6ae256afd32f96bec0117175b329d0dd617655e]

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error handling path
         [3c911fe799d1c338d94b78e7182ad452c37af897]

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill
         [7f8c36fe9be46862c4f3c5302f769378028a34fa]

Colin Ian King (2):
      iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop
         [c2f9a4e4a5abfc84c01b738496b3fd2d471e0b18]
      staging: wlan-ng: ensure error return is actually returned
         [4cc41cbce536876678b35e03c4a8a7bb72c78fa9]

Dan Carpenter (3):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
         [216b44000ada87a63891a8214c347e05a4aea8fe]
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
         [c7a91bc7c2e17e0a9c8b9745a2cb118891218fd1]
      power: supply: sbs-battery: Fix a signedness bug in sbs_get_battery_capacity()
         [eb368de6de32925c65a97c1e929a31cae2155aee]

Daniel Jordan (3):
      padata: always acquire cpu_hotplug_lock before pinst->lock
         [38228e8848cd7dd86ccb90406af32de0cad24be3]
      padata: initialize pd->cpu with effective cpumask
         [ec9c7d19336ee98ecba8de80128aa405c45feebb]
      padata: purge get_cpu and reorder_via_wq from padata_do_serial
         [065cf577135a4977931c7a1e1edf442bfd9773dd]

Daniel Kiper (1):
      efi: Use early_mem*() instead of early_io*()
         [abc93f8eb6e46a480485f19256bdbda36ec78a84]

Eric Dumazet (4):
      bonding/alb: properly access headers in bond_alb_xmit()
         [38f88c45404293bbc027b956def6c10cbd45c616]
      cls_rsvp: fix rsvp_policy
         [cb3c0e6bdf64d0d124e94ce43cbe4ccbb9b37f51]
      net_sched: ematch: reject invalid TCF_EM_SIMPLE
         [55cd9f67f1e45de8517cdaab985fb8e56c0bc1d8]
      tcp: clear tp->total_retrans in tcp_disconnect()
         [c13c48c00a6bc1febc73902505bdec0967bd7095]

Fabian Frederick (1):
      nfs: use kmap/kunmap directly
         [0795bf8357c1887e2a95e6e4f5b89d0896a0d929]

Filipe Manana (1):
      Btrfs: fix race between adding and putting tree mod seq elements and nodes
         [7227ff4de55d931bbdc156c8ef0ce4f100c78a5b]

Geert Uytterhoeven (1):
      nfs: NFS_SWAP should depend on SWAP
         [474c4f306eefbb21b67ebd1de802d005c7d7ecdc]

Guenter Roeck (1):
      brcmfmac: abort and release host after error
         [863844ee3bd38219c88e82966d1df36a77716f3e]

Herbert Xu (7):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
         [37f96694cf73ba116993a9d2d99ad6a75fa7fdb0]
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
         [7db3b61b6bba4310f454588c2ca6faf2958ad79f]
      crypto: api - Fix race condition in crypto_spawn_alg
         [73669cc556462f4e50376538d77ee312142e8a8a]
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
         [e8d998264bffade3cfe0536559f712ab9058d654]
      crypto: pcrypt - Fix user-after-free on module unload
         [07bfd9bdf568a38d9440c607b72342036011f727]
      padata: Remove broken queue flushing
         [07928d9bfc81640bab36f5190e8725894d93b659]
      padata: Replace delayed timer with immediate workqueue in padata_reorder
         [6fc4dbcf0276279d488c5fbbfabe94734134f4fa]

Jan Kara (2):
      reiserfs: Fix memory leak of journal device string
         [5474ca7da6f34fa95e82edc747d5faa19cbdfb5c]
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
         [4d5c1adaf893b8aa52525d2b81995e949bcb3239]

Jason A. Donenfeld (2):
      padata: avoid race in reordering
         [de5540d088fe97ad583cc7d396586437b32149a5]
      padata: get_next is never NULL
         [69b348449bda0f9588737539cfe135774c9939a7]

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use
         [4feaef830de7ffdd8352e1fe14ad3bf13c9688f8]

Johan Hovold (10):
      USB: serial: ir-usb: add missing endpoint sanity check
         [2988a8ae7476fe9535ab620320790d1714bdad1d]
      USB: serial: ir-usb: fix IrLAP framing
         [38c0d5bdf4973f9f5a888166e9d3e9ed0d32057a]
      USB: serial: ir-usb: fix link-speed handling
         [17a0184ca17e288decdca8b2841531e34d49285f]
      ath9k: fix storage endpoint lookup
         [0ef332951e856efa89507cdd13ba8f4fb8d4db12]
      brcmfmac: fix interface sanity check
         [3428fbcd6e6c0850b1a8b2a12082b7b2aabb3da3]
      media: iguanair: fix endpoint sanity check
         [1b257870a78b0a9ce98fdfb052c58542022ffb5b]
      orinoco_usb: fix interface sanity check
         [b73e05aa543cf8db4f4927e36952360d71291d41]
      rsi: fix use-after-free on failed probe and unbind
         [e93cd35101b61e4c79149be2cfc927c4b28dc60c]
      rsi_91x_usb: fix interface sanity check
         [3139b180906af43bc09bd3373fc2338a8271d9d9]
      zd1211rw: fix storage endpoint lookup
         [2d68bb2687abb747558b933e80845ff31570a49c]

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers
         [3c7470b6f68434acae459482ab920d1e3fabd1c7]

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal
         [a09decff5c32060639a685581c380f51b14e1fc2]

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer
         [febac332a819f0e764aa4da62757ba21d18c182b]

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it
         [af3ed119329cf9690598c5a562d95dfd128e91d6]

Logan Gunthorpe (1):
      PCI: Don't disable bridge BARs when assigning bus resources
         [9db8dc6d0785225c42a37be7b44d1b07b31b8957]

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths
         [afccc00f75bbbee4e4ae833a96c2d29a7259c693]

Marios Pomonis (7):
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks
         [ea740059ecb37807ba47b84b33d1447435a8d868]
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c
         [6ec4c5eee1750d5d17951c4e1960d953376a0dda]
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
         [8c86405f606ca8508b8d9280680166ca26723695]
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
         [670564559ca35b439c8d8861fc399451ddf95137]
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
         [4bf79cb089f6b1c6c632492c0271054ce52ad766]
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
         [3c9053a2cae7ba2ba73766a34cea41baa70f57f7]
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
         [14e32321f3606e4b0970200b6e5e47ee6f1e6410]

Masahiro Yamada (1):
      kconfig: fix broken dependency in randconfig-generated .config
         [c8fb7d7e48d11520ad24808cfce7afb7b9c9f798]

Mathias Krause (2):
      padata: ensure padata_do_serial() runs on the correct CPU
         [350ef88e7e922354f82a931897ad4a4ce6c686ff]
      padata: ensure the reorder timer callback runs on the correct CPU
         [cf5868c8a22dc2854b96e9569064bb92365549ca]

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of #PF
         [a4d956b9390418623ae5d07933e2679c68b6f83c]

Michael Ellerman (1):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc
         [dabf6b36b83a18d57e3d4b9d50544ed040d86255]

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit
         [4282dc057d750c6a7dd92953564b15c26b54c22c]

Oliver Neukum (1):
      media: iguanair: add sanity checks
         [ab1cbdf159beba7395a13ab70bc71180929ca064]

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid
         [f236a2a2ebabad0848ad0995af7ad1dc7029e895]

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR
         [5efc6fa9044c3356d6046c6e1da6d02572dbed6b]

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race
         [2763d11912317a12318135ca03e592bb6df65624]

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure
         [641e0efddcbde52461e017136acd3ce7f2ef0c14]

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval
         [3d96208c30f84d6edf9ab4fac813306ac0d20c10]

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out
         [b0dd940e582b6a60296b9847a54012a4b080dc72]

Sean Christopherson (6):
      KVM: Check for a bad hva before dropping into the ghc slow path
         [fcfbc617547fc6d9552cb6c1c563b6a90ee98085]
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
         [1a978d9d3e72ddfa40ac60d26301b154247ee0bc]
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
         [cb10bf9194f4d2c5d830eddca861f7ca0fecdbb4]
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
         [e30a7d623dccdb3f880fbcad980b0cb589a1da45]
      KVM: x86: Don't let userspace set host-reserved cr4 bits
         [b11306b53b2540c6ba068c4deddb6a17d9f8d95b]
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
         [16be9ddea268ad841457a59109963fff8c9de38d]

Stephen Warren (2):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1
         [1a3388d506bf5b45bb283e6a4c4706cfb4897333]
      clk: tegra: Mark fuse clock as critical
         [bf83b96f87ae2abb1e535306ea53608e8de5dfbb]

Steven Rostedt (1):
      tracing: Fix very unlikely race of registering two stat tracers
         [dfb6cd1e654315168e36d947471bd2a0ccd834ae]

Takashi Iwai (2):
      ALSA: dummy: Fix PCM format loop in proc output
         [2acf25f13ebe8beb40e97a1bbe76f36277c64f1e]
      ALSA: sh: Fix compile warning wrt const
         [f1dd4795b1523fbca7ab4344dd5a8bb439cc770d]

Tobias Klauser (1):
      padata: Remove unused but set variables
         [119a0798dc42ed4c4f96d39b8b676efcea73aec6]

Trond Myklebust (2):
      NFS: Directory page cache pages need to be locked when read
         [114de38225d9b300f027e2aec9afbb6e0def154b]
      NFS: Fix memory leaks and corruption in readdir
         [4b310319c6a8ce708f1033d57145e2aa027a883c]

Vincent Whitchurch (1):
      CIFS: Fix task struct use-after-free on reconnect
         [f1f27ad74557e39f67a8331a808b860f89254f2d]

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver
         [c26a2c2ddc0115eb088873f5c309cf46b982f522]

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors
         [68035c80e129c4cfec659aac4180354530b26527]

Wuxu.Wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls
         [19b61392c5a852b4e8a0bf35aecb969983c5932d]

Zhangyi (2):
      ext4, jbd2: ensure panic when aborting with zero errno
         [51f57b01e4a3c7d7bdceffd84de35144e8c538e7]
      jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
         [d0a186e0d3e7ac05cc77da7c157dae5aa59f95d9]

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage
         [f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2]

 Makefile                                           |   4 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |  26 ++--
 arch/arm/boot/dts/sama5d3_can.dtsi                 |   4 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |   1 +
 arch/arm/boot/dts/sama5d3_uart.dtsi                |   4 +-
 arch/arm/include/asm/kvm_emulate.h                 |   5 +
 arch/arm/include/asm/kvm_mmio.h                    |   2 +
 arch/arm/kvm/mmio.c                                |   6 +
 arch/arm/mach-tegra/sleep-tegra30.S                |  11 ++
 arch/arm64/include/asm/kvm_emulate.h               |   5 +
 arch/arm64/include/asm/kvm_mmio.h                  |   6 +-
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/book3s_pr.c                       |   4 +-
 arch/sparc/include/uapi/asm/ipcbuf.h               |  22 ++--
 arch/x86/kernel/cpu/tsx.c                          |  13 +-
 arch/x86/kvm/emulate.c                             |  12 +-
 arch/x86/kvm/i8259.c                               |   4 +-
 arch/x86/kvm/lapic.c                               |  14 ++-
 arch/x86/kvm/vmx.c                                 |   4 +-
 arch/x86/kvm/x86.c                                 |  57 +++++++--
 arch/x86/platform/efi/efi.c                        |  37 +++---
 crypto/af_alg.c                                    |   6 +-
 crypto/algapi.c                                    |  22 ++--
 crypto/api.c                                       |   3 +-
 crypto/internal.h                                  |   1 -
 crypto/pcrypt.c                                    |   4 +-
 drivers/clk/tegra/clk-tegra-periph.c               |   6 +-
 drivers/crypto/picoxcell_crypto.c                  |  15 ++-
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  27 ++++
 drivers/md/persistent-data/dm-space-map-common.h   |   2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   5 +-
 drivers/media/rc/iguanair.c                        |  15 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |  12 ++
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   5 +-
 drivers/mmc/host/mmc_spi.c                         |  11 +-
 drivers/net/bonding/bond_alb.c                     |  44 +++++--
 drivers/net/ethernet/freescale/gianfar.c           |  10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   3 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   3 +-
 drivers/net/wireless/iwlegacy/common.c             |   2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  12 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |   2 +-
 drivers/of/Kconfig                                 |   4 +
 drivers/of/address.c                               |   6 +-
 drivers/pci/setup-bus.c                            |  20 ++-
 drivers/power/sbs-battery.c                        |   2 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/spi/spi-dw.c                               |  14 ++-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/gadget/f_ecm.c                         |  16 ++-
 drivers/usb/gadget/f_ncm.c                         |  17 ++-
 drivers/usb/serial/ir-usb.c                        | 136 ++++++++++++++++-----
 drivers/video/fbdev/pxa168fb.c                     |   6 +-
 fs/btrfs/ctree.c                                   |   8 +-
 fs/btrfs/ctree.h                                   |   6 +-
 fs/btrfs/delayed-ref.c                             |   8 +-
 fs/btrfs/disk-io.c                                 |   1 -
 fs/btrfs/tests/btrfs-tests.c                       |   1 -
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/smb2pdu.c                                  |  10 +-
 fs/cifs/smb2transport.c                            |   2 +
 fs/cifs/transport.c                                |   4 +
 fs/jbd2/checkpoint.c                               |   2 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/jbd2/journal.c                                  |  21 ++--
 fs/namespace.c                                     |   2 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/dir.c                                       | 104 +++++++---------
 fs/pnode.c                                         |   9 +-
 fs/reiserfs/super.c                                |   4 +-
 fs/ubifs/file.c                                    |   5 +-
 include/linux/padata.h                             |  13 +-
 include/linux/usb/irda.h                           |  13 +-
 kernel/padata.c                                    | 134 +++++++-------------
 kernel/time/clocksource.c                          |  11 +-
 kernel/trace/trace_stat.c                          |  31 ++---
 mm/mempolicy.c                                     |   6 +-
 net/ipv4/tcp.c                                     |   1 +
 net/sched/cls_rsvp.h                               |   6 +-
 net/sched/ematch.c                                 |   3 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |   4 +
 scripts/kconfig/confdata.c                         |   2 +-
 sound/drivers/dummy.c                              |   2 +-
 sound/sh/aica.c                                    |   4 +-
 virt/kvm/ioapic.c                                  |  15 ++-
 virt/kvm/kvm_main.c                                |  12 +-
 94 files changed, 711 insertions(+), 444 deletions(-)

-- 
Ben Hutchings
All the simple programs have been written, and all the good names taken

