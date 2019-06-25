Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9176525CF
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 10:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfFYIBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 04:01:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35825 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYIBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 04:01:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so9056233pfd.2;
        Tue, 25 Jun 2019 01:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w6Y1izjDl1vzSBfnI9uk6yT2a4+EvqlLhhxvE/73exs=;
        b=vAGyBXdQZvFx9vKb7Ef1EYK/XOkL+bhvEfPptziYQnnN6dn2W19HuOrNBxA4o7MP2P
         lqWOTOpp78RVg6tvT4o8Nggsxlz0r66kaqUvJomQpNvTmYCL6mKqJuTmw5iEExpsiHmo
         y2HmPK8zH++qWGs8SdUQX7hyyNGJhdrmZrVW+rrl3yiVhLin/GlwLfjRgPG3NkPdoZj9
         IRHSueX4j+kftJqTqkAuPQTKrUz8cenoOPAJZ5fonitm+6m83EZRqwvbhe8IaavEeXn9
         R9C1tGBqc+obh8b1sHekCk8o6ikyTWb5ey8MB5zcB+VYe8K8DtwOb+85q1vo/6DjZHCp
         YD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w6Y1izjDl1vzSBfnI9uk6yT2a4+EvqlLhhxvE/73exs=;
        b=ayPRSUuvMfArpAlMXPUwusELNVJhQDtaoQa3aTPAddFcSd83LPVUy1wVtjrx21AtQ6
         zZxKDqp0gGD0ptstaqGEwRViTjQ7IWtt1Dqlc44RFU+QitDNxAqT2dnDy3Qkqij+USqZ
         qQGBwUZX2ZgA6R7Pm+tr/ohL0jGjO0T/2C/9UIFo/1mcV5zw79PwTmm8vhund2nsCWYl
         XVCFGDqra9U/7/Mkp5KfXy4DpmRwPRU+LUw0ezePLqv2T9gLGXh71KTfH9Z3Aq8xS6Ge
         Kzdhzy6yBznOVXjWmBzgJeF5qCbvMuCw7ykM+IIE2YM5jcGmjbvTdKtZPeicG1xrt29x
         QQ5g==
X-Gm-Message-State: APjAAAWlFzW65J7LiKHvisMEpDVI8xoqU1pteklWTbdxU4xq0NYSDlaZ
        LvLCPf7VFfom8eSe4zJ3RRYvc77euIareA==
X-Google-Smtp-Source: APXvYqwLTS+/7b6YUsHhopdPppFj403WBA3iaLfv1O4BuTHoYPQjBRBgr/8fSAoh/FNL7oJNY50vGA==
X-Received: by 2002:a63:4419:: with SMTP id r25mr38904890pga.247.1561449707616;
        Tue, 25 Jun 2019 01:01:47 -0700 (PDT)
Received: from Gentoo ([103.231.90.174])
        by smtp.gmail.com with ESMTPSA id y68sm15294468pfy.164.2019.06.25.01.01.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 01:01:46 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:31:33 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.15
Message-ID: <20190625080133.GB2167@Gentoo>
References: <20190625075156.GA27224@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20190625075156.GA27224@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Greg!=20

On 15:51 Tue 25 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.15 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                                   |    2
> arch/arc/boot/dts/hsdk.dts                                 |    4
> arch/arc/include/asm/cmpxchg.h                             |   14 -
> arch/arc/mm/tlb.c                                          |   13 -
> arch/arm/boot/dts/am57xx-idk-common.dtsi                   |    1
> arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi                  |   40 +--
> arch/arm/configs/mvebu_v7_defconfig                        |    1
> arch/arm/mach-imx/cpuidle-imx6sx.c                         |    3
> arch/arm64/Makefile                                        |    1
> arch/arm64/include/uapi/asm/ptrace.h                       |    8
> arch/arm64/kernel/ssbd.c                                   |    1
> arch/mips/include/asm/ginvt.h                              |    2
> arch/mips/kernel/uprobes.c                                 |    3
> arch/parisc/math-emu/cnv_float.h                           |    8
> arch/powerpc/include/asm/ppc-opcode.h                      |    1
> arch/powerpc/mm/mmu_context_book3s64.c                     |   46 +++
> arch/powerpc/net/bpf_jit.h                                 |    2
> arch/powerpc/net/bpf_jit_comp64.c                          |    8
> arch/riscv/mm/fault.c                                      |   13 +
> arch/sparc/kernel/mdesc.c                                  |    2
> arch/sparc/kernel/perf_event.c                             |    4
> arch/x86/entry/vdso/vclock_gettime.c                       |   15 +
> arch/x86/kernel/cpu/resctrl/rdtgroup.c                     |    2
> arch/x86/kvm/mmu.c                                         |   16 -
> arch/xtensa/kernel/setup.c                                 |    3
> crypto/hmac.c                                              |    4
> drivers/android/binder.c                                   |   16 +
> drivers/dma-buf/udmabuf.c                                  |    1
> drivers/dma/dma-jz4780.c                                   |   32 +-
> drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c             |    3
> drivers/dma/mediatek/mtk-cqdma.c                           |    4
> drivers/dma/sprd-dma.c                                     |   29 +-
> drivers/fpga/dfl-afu-dma-region.c                          |    2
> drivers/fpga/dfl.c                                         |   16 +
> drivers/fpga/stratix10-soc.c                               |    6
> drivers/gpu/drm/arm/hdlcd_crtc.c                           |   14 -
> drivers/gpu/drm/arm/malidp_drv.c                           |   13 -
> drivers/gpu/drm/i915/intel_display.c                       |   38 ++-
> drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                        |  146 +++++++=
++--
> drivers/hwmon/hwmon.c                                      |    2
> drivers/hwmon/pmbus/pmbus_core.c                           |   34 ++
> drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h                    |    2
> drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c               |   25 +-
> drivers/iio/temperature/mlx90632.c                         |    9
> drivers/infiniband/hw/hfi1/chip.c                          |   14 +
> drivers/infiniband/hw/hfi1/chip.h                          |    1
> drivers/infiniband/hw/hfi1/fault.c                         |    5
> drivers/infiniband/hw/hfi1/sdma.c                          |    9
> drivers/infiniband/hw/hfi1/tid_rdma.c                      |    4
> drivers/infiniband/hw/hfi1/user_exp_rcv.c                  |    3
> drivers/infiniband/hw/hfi1/user_sdma.c                     |   12
> drivers/infiniband/hw/hfi1/user_sdma.h                     |    1
> drivers/infiniband/hw/hfi1/verbs.c                         |    2
> drivers/infiniband/hw/hfi1/verbs_txreq.c                   |    2
> drivers/infiniband/hw/hfi1/verbs_txreq.h                   |    3
> drivers/infiniband/hw/qib/qib_verbs.c                      |    2
> drivers/infiniband/sw/rdmavt/mr.c                          |    2
> drivers/infiniband/sw/rdmavt/qp.c                          |    3
> drivers/input/misc/uinput.c                                |   22 +
> drivers/input/mouse/synaptics.c                            |    2
> drivers/input/touchscreen/silead.c                         |    1
> drivers/misc/habanalabs/memory.c                           |    6
> drivers/misc/lkdtm/usercopy.c                              |   10
> drivers/mmc/core/core.c                                    |    5
> drivers/mmc/core/sdio.c                                    |   13 -
> drivers/mmc/core/sdio_io.c                                 |   77 ++++++
> drivers/mmc/core/sdio_irq.c                                |    4
> drivers/mmc/host/mtk-sd.c                                  |   39 +--
> drivers/mmc/host/renesas_sdhi_core.c                       |    9
> drivers/mmc/host/sdhci-pci-o2micro.c                       |    5
> drivers/net/can/flexcan.c                                  |    2
> drivers/net/can/xilinx_can.c                               |    2
> drivers/net/dsa/mv88e6xxx/chip.c                           |    2
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c           |    4
> drivers/net/ethernet/mediatek/mtk_eth_soc.c                |   15 -
> drivers/net/ipvlan/ipvlan_main.c                           |    2
> drivers/net/phy/phylink.c                                  |   13 -
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   17 -
> drivers/nvme/host/core.c                                   |    3
> drivers/nvme/target/io-cmd-bdev.c                          |    1
> drivers/parport/share.c                                    |    2
> drivers/s390/net/qeth_l2_main.c                            |    2
> drivers/s390/net/qeth_l3_main.c                            |   32 ++
> drivers/scsi/smartpqi/smartpqi_init.c                      |    6
> drivers/scsi/ufs/ufshcd-pltfrm.c                           |   11
> drivers/scsi/ufs/ufshcd.c                                  |    3
> drivers/staging/erofs/erofs_fs.h                           |   13 -
> drivers/staging/erofs/internal.h                           |    2
> drivers/staging/erofs/super.c                              |   19 +
> drivers/usb/chipidea/udc.c                                 |   20 +
> drivers/usb/host/xhci-ring.c                               |   15 +
> drivers/usb/host/xhci.c                                    |   25 +-
> drivers/usb/host/xhci.h                                    |    9
> fs/btrfs/reada.c                                           |    5
> fs/cifs/cifsfs.c                                           |    1
> fs/cifs/cifsglob.h                                         |    5
> fs/cifs/connect.c                                          |    2
> fs/cifs/file.c                                             |    8
> fs/cifs/smb2maperror.c                                     |    2
> fs/namespace.c                                             |    1
> fs/overlayfs/inode.c                                       |   60 ++++
> fs/overlayfs/namei.c                                       |    8
> fs/overlayfs/overlayfs.h                                   |    3
> fs/overlayfs/ovl_entry.h                                   |    6
> fs/overlayfs/super.c                                       |  161 +++++++=
++++--
> fs/overlayfs/util.c                                        |   12
> fs/pnode.c                                                 |    1
> include/linux/mmc/host.h                                   |    1
> include/linux/mmc/sdio_func.h                              |    6
> include/net/bluetooth/hci_core.h                           |    3
> include/net/cfg80211.h                                     |    3
> kernel/trace/trace.c                                       |    6
> kernel/trace/trace.h                                       |   18 +
> kernel/trace/trace_kdb.c                                   |    6
> net/bluetooth/hci_conn.c                                   |   10
> net/bluetooth/l2cap_core.c                                 |   33 ++
> net/can/af_can.c                                           |    1
> net/mac80211/ieee80211_i.h                                 |    3
> net/mac80211/mlme.c                                        |   12
> net/mac80211/rx.c                                          |    2
> net/mac80211/tdls.c                                        |   23 +
> net/mac80211/util.c                                        |    4
> net/mac80211/wpa.c                                         |    7
> net/wireless/core.c                                        |    8
> net/wireless/nl80211.c                                     |   12
> scripts/checkstack.pl                                      |    2
> scripts/package/Makefile                                   |    2
> security/apparmor/include/policy.h                         |   11
> security/apparmor/policy_unpack.c                          |   49 +++
> tools/testing/selftests/cgroup/test_core.c                 |    7
> tools/testing/selftests/cgroup/test_memcontrol.c           |    4
> tools/testing/selftests/net/forwarding/router_broadcast.sh |    5
> tools/testing/selftests/pidfd/pidfd_test.c                 |    4
> tools/testing/selftests/vm/Makefile                        |    2
> tools/testing/selftests/vm/userfaultfd.c                   |    2
> 135 files changed, 1278 insertions(+), 328 deletions(-)
>
>Alakesh Haloi (1):
>      userfaultfd: selftest: fix compiler warning
>
>Alex Shi (3):
>      kselftest/cgroup: fix unexpected testing failure on test_memcontrol
>      kselftest/cgroup: fix unexpected testing failure on test_core
>      kselftest/cgroup: fix incorrect test_core skip
>
>Alexander Mikhaylenko (1):
>      Input: synaptics - enable SMBus on ThinkPad E480 and E580
>
>Alexandra Winter (1):
>      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event
>
>Amir Goldstein (2):
>      ovl: detect overlapping layers
>      ovl: make i_ino consistent with st_ino in more cases
>
>Andrey Smirnov (1):
>      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLO=
AD
>
>Andy Lutomirski (1):
>      x86/vdso: Prevent segfaults due to hoisted vclock reads
>
>Andy Strohman (1):
>      nl80211: fix station_info pertid memory leak
>
>Anisse Astier (2):
>      arm64/sve: <uapi/asm/ptrace.h> should not depend on <uapi/linux/prct=
l.h>
>      arm64: ssbd: explicitly depend on <linux/prctl.h>
>
>Anssi Hannula (1):
>      can: xilinx_can: use correct bittiming_const for CAN FD core
>
>Arnd Bergmann (1):
>      ovl: fix bogus -Wmaybe-unitialized warning
>
>Avri Altman (1):
>      scsi: ufs: Check that space was properly alloced in copy_query_respo=
nse
>
>Baolin Wang (2):
>      dmaengine: sprd: Fix the possible crash when getting descriptor stat=
us
>      dmaengine: sprd: Add validation of current descriptor in irq handler
>
>Christian Brauner (2):
>      tests: fix pidfd-test compilation
>      fs/namespace: fix unprivileged mount propagation
>
>Colin Ian King (1):
>      dmaengine: dw-axi-dmac: fix null dereference when pointer first is n=
ull
>
>Crt Mori (1):
>      iio: temperature: mlx90632 Relax the compatibility check
>
>Dan Carpenter (2):
>      dmaengine: mediatek-cqdma: sleeping in atomic context
>      scsi: smartpqi: unlock on error in pqi_submit_raid_request_synchrono=
us()
>
>Daniel Smith (1):
>      Input: silead - add MSSL0017 to acpi_device_id
>
>Dave Martin (1):
>      arm64: Silence gcc warnings about arch ABI drift
>
>Douglas Anderson (5):
>      mmc: core: API to temporarily disable retuning for SDIO CRC errors
>      mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
>      Revert "brcmfmac: disable command decode in sdio_aos"
>      brcmfmac: sdio: Disable auto-tuning around commands expected to fail
>      brcmfmac: sdio: Don't tune while the card is off
>
>Eduardo Valentin (1):
>      hwmon: (core) add thermal sensors only if dev->of_node is present
>
>Eric Biggers (2):
>      crypto: hmac - fix memory leak in hmac_init_tfm()
>      cfg80211: fix memory leak of wiphy device name
>
>Eric Long (3):
>      dmaengine: sprd: Fix the incorrect start for 2-stage destination cha=
nnels
>      dmaengine: sprd: Fix block length overflow
>      dmaengine: sprd: Fix the right place to configure 2-stage transfer
>
>Fabio Estevam (1):
>      ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
>
>Faiz Abbas (2):
>      ARM: dts: dra76x: Update MMC2_HS200_MANUAL1 iodelay values
>      ARM: dts: am57xx-idk: Remove support for voltage switching for SD ca=
rd
>
>Gao Xiang (1):
>      staging: erofs: add requirements field in superblock
>
>Gen Zhang (1):
>      mdesc: fix a missing-check bug in get_vdev_port_node_info()
>
>George G. Davis (1):
>      scripts/checkstack.pl: Fix arm64 wrong or unknown architecture
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.15
>
>Guenter Roeck (1):
>      xtensa: Fix section mismatch between memblock_reserve and mem_reserve
>
>Helge Deller (1):
>      parisc: Fix compiler warnings in float emulation code
>
>Jaesoo Lee (1):
>      nvme: Fix u32 overflow in the number of namespace list calculation
>
>James Morse (1):
>      x86/resctrl: Don't stop walking closids when a locksetup group is fo=
und
>
>Jan Kundr=E1t (1):
>      ARM: mvebu_v7_defconfig: fix Ethernet on Clearfog
>
>Jann Horn (1):
>      apparmor: enforce nullbyte at end of tag string
>
>Joakim Zhang (1):
>      can: flexcan: fix timeout when set small bitrate
>
>Johannes Berg (1):
>      mac80211: drop robust management frames from unknown TA
>
>John Johansen (1):
>      apparmor: fix PROFILE_MEDIATES for untrusted input
>
>Jose Abreu (2):
>      ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC n=
ode
>      ARC: [plat-hsdk]: Add missing FIFO size entry in GMAC node
>
>Jouni Malinen (1):
>      mac80211: Do not use stack memory with scatterlist for GMAC
>
>Julian Wiedmann (2):
>      s390/qeth: handle limited IPv4 broadcast in L3 TX path
>      s390/qeth: check dst entry before use
>
>Kaike Wan (1):
>      IB/hfi1: Validate fault injection opcode user input
>
>Kamenee Arumugam (1):
>      IB/hfi1: Validate page aligned for a given virtual address
>
>Kees Cook (1):
>      lkdtm/usercopy: Moves the KERNEL_DS test to non-canonical
>
>Lorenzo Bianconi (1):
>      iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller
>
>Lucas Stach (1):
>      udmabuf: actually unmap the scatterlist
>
>Manikanta Pubbisetty (1):
>      {nl,mac}80211: allow 4addr AP operation on crypto controlled devices
>
>Marcel Holtmann (2):
>      Bluetooth: Align minimum encryption key size for LE and BR/EDR conne=
ctions
>      Bluetooth: Fix regression with minimum encryption key size alignment
>
>Masahiro Yamada (1):
>      MIPS: mark ginvt() as __always_inline
>
>Mathias Nyman (2):
>      xhci: detect USB 3.2 capable host controllers correctly
>      usb: xhci: Don't try to recover an endpoint if port is in error stat=
e.
>
>Miaohe Lin (1):
>      net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is=
 set
>
>Michael Ellerman (1):
>      powerpc/mm/64s/hash: Reallocate context ids on fork
>
>Miguel Ojeda (1):
>      tracing: Silence GCC 9 array bounds warning
>
>Mike Marciniszyn (7):
>      IB/hfi1: Close PSM sdma_progress sleep window
>      IB/hfi1: Avoid hardlockup with flushlist_lock
>      IB/hfi1: Correct tid qp rcd to match verbs context
>      IB/hfi1: Silence txreq allocation warnings
>      IB/rdmavt: Fix alloc_qpn() WARN_ON()
>      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
>      IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value
>
>Mike Salvatore (1):
>      apparmor: reset pos on failure to unpack for various functions
>
>Miklos Szeredi (1):
>      ovl: don't fail with disconnected lower NFS
>
>Minwoo Im (1):
>      nvmet: fix data_len to 0 for bdev-backed write_zeroes
>
>Naohiro Aota (1):
>      btrfs: start readahead also in seed devices
>
>Naresh Kamboju (1):
>      selftests: vm: install test_vmalloc.sh for run_vmtests
>
>Naveen N. Rao (1):
>      powerpc/bpf: use unsigned division instruction for 64-bit operations
>
>Nikita Yushchenko (1):
>      net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0
>
>Oded Gabbay (1):
>      habanalabs: fix bug in checking huge page optimization
>
>Paul Cercueil (1):
>      dmaengine: jz4780: Fix transfers being ACKed too soon
>
>Peter Chen (1):
>      usb: chipidea: udc: workaround for endpoint conflict issue
>
>Raul E Rangel (1):
>      mmc: sdhci: sdhci-pci-o2micro: Correctly set bus width when tuning
>
>Robert Hancock (1):
>      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages
>
>Robin Murphy (2):
>      drm/arm/hdlcd: Actually validate CRTC modes
>      drm/arm/hdlcd: Allow a bit of clock tolerance
>
>Ronnie Sahlberg (2):
>      cifs: add spinlock for the openFileList to cifsInodeInfo
>      cifs: fix GlobalMid_Lock bug in cifs_reconnect
>
>Russell King (1):
>      net: phylink: avoid reducing support mask
>
>Scott Wood (2):
>      fpga: dfl: afu: Pass the correct device to dma_mapping_error()
>      fpga: dfl: Add lockdep classes for pdata->lock
>
>Sean Christopherson (1):
>      KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT
>
>Sean Wang (2):
>      net: ethernet: mediatek: Use hw_feature to judge if HWLRO is support=
ed
>      net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OF=
FSET is enabled
>
>ShihPo Hung (1):
>      riscv: mm: synchronize MMU after pte change
>
>Stanley Chu (1):
>      scsi: ufs: Avoid runtime suspend possibly being blocked forever
>
>Steve French (1):
>      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write
>
>Thomas Hellstrom (1):
>      drm/vmwgfx: Use the backdoor port if the HB port is not available
>
>Todd Kjos (1):
>      binder: fix possible UAF when freeing buffer
>
>Trevor Bourget (1):
>      kbuild: tar-pkg: enable communication with jobserver
>
>Ulf Hansson (1):
>      mmc: core: Prevent processing SDIO IRQs when the card is suspended
>
>Ville Syrj=E4l=E4 (1):
>      drm/i915: Don't clobber M/N values during fastset check
>
>Vineet Gupta (1):
>      ARC: fix build warnings
>
>Wen He (1):
>      drm/arm/mali-dp: Add a loop around the second set CVAL and try 5 tim=
es
>
>Wen Yang (1):
>      fpga: stratix10-soc: fix use-after-free on s10_init()
>
>Willem de Bruijn (1):
>      can: purge socket error queue on sock destruct
>
>Wolfram Sang (1):
>      mmc: sdhi: disallow HS400 for M3-W ES1.2, RZ/G2M, and V3H
>
>Xin Long (1):
>      selftests: set sysctl bc_forwarding properly in router_broadcast.sh
>
>Yonglong Liu (1):
>      net: hns: Fix loopback test failed at copper ports
>
>Young Xiao (1):
>      sparc: perf: fix updated event period in response to PERF_EVENT_IOC_=
PERIOD
>
>Yu Wang (1):
>      mac80211: handle deauthentication/disassociation from TDLS peer
>
>YueHaibing (2):
>      parport: Fix mem leak in parport_register_dev_model
>      MIPS: uprobes: remove set but not used variable 'epc'
>
>jjian zhou (2):
>      mmc: mediatek: fix SDIO IRQ interrupt handle flow
>      mmc: mediatek: fix SDIO IRQ detection issue
>



--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0R1NkACgkQsjqdtxFL
KRUDIwgAzpksqwaZnrKRvdi5Dji97KqXa0TVn+AxDxtMi82KOahe7rMQDkm9CQzL
kdcfB2RGUZ6ewCBea+HcaU+igVUA0Yg33qu8J0S2d62ZV087OFxRtv8VZZsjBRZx
Wi6FIu40iWa8ohboRaWaQPpNIkQYnjLpeGD+TTtBBgn6KGqYclfuCP8v95BbZ2DO
XVe/InvS0CM1mXX8nXQoYftZaX2M3Zt4gXwfulmj6oORhmF2Hip65bHT7ms+8u4F
8L25XDVbGwbxd0s5p6WEkFPakdgok2Jmb97LqUKXy7Q1Ejrzup4f038PRLM7a/HA
HO/XEJb/pT6garfUI8xtN9tYJi8w4Q==
=1Zor
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
