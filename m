Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249CC2A5A8
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfEYRBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 13:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfEYRBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 13:01:03 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B3B21707;
        Sat, 25 May 2019 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558803661;
        bh=N+9Np/PnvfSMz+KO9ReLU6Sq0wMYMQ5P67Pr4gFoXAM=;
        h=Date:From:To:Cc:Subject:From;
        b=fgfFj+rr6wnaIo0flXGqosGkvrbn4c3pJDTt9lyJfoK7vys49v++epWPi74+nf3k1
         5B3yJKfNl0rUvYjhfqpzqMUIIhCTGEQJWpvbQ2S2PYdAtA3tTVfPWJnJdHzBibfjsq
         yUfNsHlpmxGWwzS8ZsVOMLHcr2SI47dpiYigX/us=
Date:   Sat, 25 May 2019 19:00:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.122
Message-ID: <20190525170059.GA7545@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.122 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/parisc/boot/compressed/head.S                  |    6=20
 arch/parisc/include/asm/assembly.h                  |    6=20
 arch/parisc/kernel/head.S                           |    4=20
 arch/parisc/kernel/process.c                        |    1=20
 arch/parisc/kernel/syscall.S                        |    2=20
 arch/x86/entry/entry_64.S                           |   18 +
 arch/x86/include/asm/text-patching.h                |   28 ++
 arch/x86/kernel/ftrace.c                            |   32 ++
 arch/x86/lib/Makefile                               |   12=20
 drivers/base/dd.c                                   |    5=20
 drivers/clk/hisilicon/clk-hi3660.c                  |    6=20
 drivers/clk/rockchip/clk-rk3328.c                   |   18 -
 drivers/clk/tegra/clk-pll.c                         |    4=20
 drivers/hwtracing/intel_th/msu.c                    |   35 ++
 drivers/hwtracing/stm/core.c                        |    2=20
 drivers/iommu/tegra-smmu.c                          |   25 +-
 drivers/md/dm-cache-metadata.c                      |    9=20
 drivers/md/dm-delay.c                               |    3=20
 drivers/md/dm-zoned-metadata.c                      |    5=20
 drivers/md/md.c                                     |    6=20
 drivers/md/raid5.c                                  |   29 +-
 drivers/media/i2c/ov6650.c                          |    2=20
 drivers/memory/tegra/mc.c                           |    2=20
 drivers/net/Makefile                                |    2=20
 drivers/net/ethernet/mellanox/mlx4/mcg.c            |    2=20
 drivers/net/ppp/ppp_deflate.c                       |   20 +
 drivers/net/usb/qmi_wwan.c                          |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |   28 +-
 drivers/net/wireless/intersil/p54/p54pci.c          |    3=20
 drivers/parisc/led.c                                |    3=20
 drivers/pci/pcie/aspm.c                             |   49 ++--
 drivers/pci/quirks.c                                |   19 +
 drivers/power/supply/cpcap-battery.c                |    3=20
 drivers/power/supply/power_supply_sysfs.c           |    6=20
 drivers/video/fbdev/sm712.h                         |   12=20
 drivers/video/fbdev/sm712fb.c                       |  243 +++++++++++++++=
+----
 fs/btrfs/extent-tree.c                              |   25 +-
 fs/ceph/super.c                                     |    7=20
 fs/cifs/smb2ops.c                                   |   14 -
 fs/cifs/smb2pdu.c                                   |    1=20
 fs/fuse/file.c                                      |    9=20
 fs/nfs/filelayout/filelayout.c                      |    2=20
 fs/nfs/nfs4state.c                                  |    4=20
 fs/ufs/util.h                                       |    2=20
 include/linux/bpf.h                                 |    1=20
 include/linux/of.h                                  |    4=20
 include/linux/pci.h                                 |    2=20
 include/linux/skbuff.h                              |    9=20
 kernel/bpf/hashtab.c                                |   23 +
 kernel/bpf/syscall.c                                |    5=20
 kernel/sched/cpufreq_schedutil.c                    |    1=20
 kernel/trace/trace_events.c                         |    3=20
 lib/Makefile                                        |   11=20
 net/core/dev.c                                      |    2=20
 net/ipv4/esp4.c                                     |   20 +
 net/ipv4/ip_vti.c                                   |    5=20
 net/ipv4/xfrm4_policy.c                             |   24 +
 net/ipv6/xfrm6_tunnel.c                             |    4=20
 net/mac80211/iface.c                                |    3=20
 net/tipc/core.c                                     |   14 -
 net/vmw_vsock/virtio_transport.c                    |   13 -
 net/vmw_vsock/virtio_transport_common.c             |    7=20
 net/xfrm/xfrm_user.c                                |    2=20
 security/apparmor/apparmorfs.c                      |   13 -
 security/inode.c                                    |   13 -
 tools/objtool/Makefile                              |    3=20
 tools/perf/bench/numa.c                             |    4=20
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   31 +-
 virt/kvm/arm/arm.c                                  |   11=20
 70 files changed, 720 insertions(+), 226 deletions(-)

Adrian Hunter (3):
      perf intel-pt: Fix instructions sampling rate
      perf intel-pt: Fix improved sample timestamp
      perf intel-pt: Fix sample timestamp wrt non-taken branches

Al Viro (3):
      securityfs: fix use-after-free on symlink traversal
      apparmorfs: fix use-after-free on symlink traversal
      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Alexander Shishkin (1):
      intel_th: msu: Fix single mode with IOMMU

Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Andrey Smirnov (1):
      power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_S=
UPPLY_DEBUG

Arnaldo Carvalho de Melo (1):
      perf bench numa: Add define for RUSAGE_THREAD if not present

Bhagavathi Perumal S (1):
      mac80211: Fix kernel panic due to use of txq after free

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_opl=
ock_level()

Damien Le Moal (1):
      dm zoned: Fix zone report handling

Daniel Borkmann (2):
      bpf: add map_lookup_elem_sys_only for lookups from syscall side
      bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Dmitry Osipenko (3):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divi=
der
      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
      memory: tegra: Fix integer overflow on tick value calculation

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Eric Dumazet (1):
      net: avoid weird emergency message

Florian Fainelli (1):
      net: Always descend into dsa/

Gary Hook (1):
      x86/mm/mem_encrypt: Disable all instrumentation for early SME setup

Greg Kroah-Hartman (2):
      Revert "cifs: fix memory leak in SMB2_read"
      Linux 4.14.122

Helge Deller (4):
      parisc: Export running_on_qemu symbol for modules
      parisc: Skip registering LED when running in QEMU
      parisc: Use PA_ASM_LEVEL in boot code
      parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD co=
de

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jeremy Sowden (1):
      vti4: ipip tunnel deregistration fixes.

John Garry (1):
      driver core: Postpone DMA tear-down until after devres release for pr=
obe failure

Jonas Karlman (1):
      clk: rockchip: fix wrong clock definitions for rk3328

Jorge E. Moreira (1):
      vsock/virtio: Initialize core virtio vsock before registering the dri=
ver

Josh Poimboeuf (1):
      x86_64: Add gap to int3 to allow for call emulation

Junwei Hu (2):
      tipc: switch order of device registration to fix a crash
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Leo Yan (1):
      clk: hi3660: Mark clk_gate_ufs_subsys as critical

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Luca Coelho (1):
      iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()

Miklos Szeredi (1):
      fuse: fix writepages on 32bit

Mikulas Patocka (1):
      dm delay: fix a crash when invalid device is specified

Nathan Chancellor (1):
      objtool: Allow AR to be overridden with HOSTAR

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check

Nikolai Kostrigin (1):
      PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken

Nikolay Borisov (1):
      btrfs: Honour FITRIM range constraints during free space trim

Nikos Tsironis (1):
      dm cache metadata: Fix loading discard bitset

Olga Kornievskaia (1):
      PNFS fallback to MDS if no deviceid found

Pan Bian (1):
      p54: drop device reference count if fails to enable device

Peter Zijlstra (2):
      x86_64: Allow breakpoints to emulate call instructions
      ftrace/x86_64: Emulate call function while updating in breakpoint han=
dler

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Sabrina Dubroca (1):
      esp4: add length check for UDP encapsulation

Song Liu (1):
      Revert "Don't jump to compute_result state from check_result state"

Stefan M=E4tje (2):
      PCI: Factor out pcie_retrain_link() function
      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stefano Garzarella (1):
      vsock/virtio: free packets during the socket release

Steffen Klassert (1):
      xfrm4: Fix uninitialized memory read in _decode_session4

Su Yanjun (1):
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Tingwei Zhang (1):
      stm class: Fix channel free in stm output free path

Tobin C. Harding (1):
      sched/cpufreq: Fix kobject memleak

Tony Lindgren (1):
      power: supply: cpcap-battery: Fix division by zero

Willem de Bruijn (1):
      net: test nouarg before dereferencing zerocopy pointers

Yifeng Li (9):
      fbdev: sm712fb: fix brightness control on reboot, don't set SR30
      fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75
      fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-C=
R3F
      fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
      fbdev: sm712fb: fix crashes during framebuffer writes by correctly ma=
pping VRAM
      fbdev: sm712fb: fix support for 1024x768-16 mode
      fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled disp=
lay
      fbdev: sm712fb: fix crashes and garbled display during DPMS modesetti=
ng
      fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallth=
rough

YueHaibing (2):
      ppp: deflate: Fix possible crash in deflate_init
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Yufen Yu (1):
      md: add mddev->pers to avoid potential NULL pointer dereference

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzpdMsACgkQONu9yGCS
aT5HYhAAufX9tGrnOLfX7j+t7P/d5Fhr6A9U64LBiDovcBN7p825bptVWnwry9jS
UNyMtQqBwtToEeQRJGg2r2BHzbizWv0W+gNarNm7Ciwj2fO+UCi+A8hRwBHm4anV
uQXeEBh2jnPPKhSx6SEPX5goQ31q+b1SmxRXIpq88LXu5V0JZD1c/TB4ywrIcn7t
pQrtSlNMvlJq8VBIecRUrGp7RUD4zIQXGYugVuAFllfjAYsl1/kPCxOUVndtO276
KBxvuKZZYwnt/MPKj2S4mGDy7I9vH6jmuSwlcxo69kmQHmL0iLF65UZqGytc/5nx
f0+33XvYwegd+Ggu1SHA+DSrO8+0Ue7Qltj+falVkN4G/fHJ45NtbeZ/FI5B5xXX
t5qov8RMav9bwBCmMtGOPth2S4bY40t69R7dtqnEU9Obk0+MuerNZdzPqfhZQier
eF003iFLpBMoeycfM6rvbWOrQtCuzW/txeUbHqDEDvRMUjpe3m7bVGdbyXsWyBh5
bE1pygz6CZKsnhQWbrLjOeQpIIpTOcnANaKc8uvTSWjoCAAXgn366KvjimvG/KNa
fpnkStYq8Uise3fpgwAyUR3s1gvkSKzNG9regSPBzMWj3SFqO4dz7pHpHnytVn1a
RYJKqWU45xGGgWh47Fgue6IpyJDwREtEcSh2ks0KZKO3/ZSSVcM=
=49uB
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
