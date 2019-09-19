Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB3EB7675
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 11:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbfISJiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 05:38:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34045 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388528AbfISJiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 05:38:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so1909954pfa.1;
        Thu, 19 Sep 2019 02:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aPQZX75eGCHHOA9xBqmoxYONNt6hD+Mzeu1vL3J5n3A=;
        b=auURJFzzrlVA7mzw/iOfIsJ19Y1tAdOUS7kwrwA0EmbS+mzV+LTrCMzUkfPFNf3SzR
         OF1qqPCo96/Vw5DmD326jyMijY3mg/9/LNV/p7F2ZdEF7cYTqzPIzQ/X7hLoKrdGWPQ5
         iS0fajK6vX9EG9UkBHRDp3Gwx6sIMlotP6s+439V3uG3UoSXSBkDMrlPsKborMb+5cAI
         BAFOv2BPkokGP0xJJxiauYxann2nsnpFnnk/f8mg9oa97Z6gmgwkQAc5iK1sDQ3B0IXm
         IclCkKIripNNV6L38BTj4Hel28PLQRknAIR5r8cVVcmg0rUO0bxxMJ9J5aNB7cHeYzvM
         SXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aPQZX75eGCHHOA9xBqmoxYONNt6hD+Mzeu1vL3J5n3A=;
        b=Ya+kDgyIGVuTejVDj+jYt1VQqjJx76HQKiPaYxJg9+nh4gI4gZR1KV1iaCJl8mvFvV
         8/fMHoNEmgWX+GZ+QutDTCfjQpzT6G33rDFkWn5UVLT5xb3jJh0sQWW9uBugGYWCxJlM
         7dm6CQWKXVt2G9DBp5pVfUEBmiix3qxX/l3Y9RXTvi/DJBwXXEhGzYeMVUqbS8M+YeCD
         l+EANDzCUhrMgg7U2EDpMH2JFkH94kd974mUtiOAAsN0HFfPsV3Rd4mpdmSDb4C1CMm9
         ISz/PnvhD/WzB9iNYm44S/PvWMXUVTleuvA+bQSkXIUoZKZR/69hfo2J6RVIwIA2ViVg
         vOqw==
X-Gm-Message-State: APjAAAXUe8I1C7wKuOcIZNaYDxOj9dyhAmaz3pTh29JprAZDvguanKnE
        +nKBDeVtaFs8R7aLOgdRJiU=
X-Google-Smtp-Source: APXvYqzhdqxaILYLz4e+BU488lA2/koYI30EPl7yozoNvfBAkqP10Mj3jl0eqZa/k4y/4BsDS2/ICQ==
X-Received: by 2002:a62:5f83:: with SMTP id t125mr9299959pfb.125.1568885901269;
        Thu, 19 Sep 2019 02:38:21 -0700 (PDT)
Received: from Gentoo ([103.231.91.69])
        by smtp.gmail.com with ESMTPSA id 193sm12291525pfc.59.2019.09.19.02.38.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 02:38:20 -0700 (PDT)
Date:   Thu, 19 Sep 2019 15:08:07 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.16
Message-ID: <20190919093804.GA3289@Gentoo>
References: <20190919085903.GA2612971@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20190919085903.GA2612971@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:59 Thu 19 Sep 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.16 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h

Thank you so much Greg! :)

Thanks,
Bhaskar
>
>------------
>
> Makefile                                           |    2
> arch/powerpc/include/asm/uaccess.h                 |    1
> arch/s390/kvm/interrupt.c                          |   10 +
> arch/s390/kvm/kvm-s390.c                           |    4
> arch/sparc/kernel/sys_sparc_64.c                   |   33 ++--
> arch/x86/Makefile                                  |    1
> arch/x86/boot/compressed/acpi.c                    |  143 +++++++++++++--=
---
> arch/x86/include/asm/kvm_host.h                    |    2
> arch/x86/kernel/ima_arch.c                         |   12 +
> arch/x86/kvm/mmu.c                                 |  101 ++++++++++++-
> arch/x86/kvm/svm.c                                 |   42 ++++-
> arch/x86/kvm/vmx/nested.c                          |   12 -
> arch/x86/kvm/x86.c                                 |    7
> arch/x86/purgatory/Makefile                        |   35 ++--
> drivers/base/core.c                                |   53 ++++++
> drivers/bluetooth/btusb.c                          |    5
> drivers/clk/clk.c                                  |   38 ++++
> drivers/clk/rockchip/clk-mmc-phase.c               |    4
> drivers/crypto/talitos.c                           |   70 ++++++---
> drivers/firmware/ti_sci.c                          |    8 -
> drivers/gpio/gpio-mockup.c                         |    1
> drivers/gpio/gpiolib-acpi.c                        |   42 ++++-
> drivers/gpio/gpiolib.c                             |   16 +-
> drivers/gpu/drm/drm_panel_orientation_quirks.c     |   12 +
> drivers/gpu/drm/i915/intel_dp_mst.c                |   10 +
> drivers/gpu/drm/i915/intel_workarounds.c           |    5
> drivers/gpu/drm/lima/lima_gem.c                    |    2
> drivers/gpu/drm/mediatek/mtk_drm_drv.c             |    5
> drivers/gpu/drm/meson/meson_plane.c                |   16 ++
> drivers/iio/adc/stm32-dfsdm-adc.c                  |  162 +++++++++++++++=
+-----
> drivers/iio/adc/stm32-dfsdm.h                      |   24 ++-
> drivers/isdn/capi/capi.c                           |   10 +
> drivers/mmc/host/bcm2835.c                         |    2
> drivers/mmc/host/sdhci-pci-o2micro.c               |    2
> drivers/mmc/host/tmio_mmc.h                        |    1
> drivers/mmc/host/tmio_mmc_core.c                   |   16 +-
> drivers/mtd/nand/raw/mtk_nand.c                    |   21 +-
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    7
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   29 +--
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    3
> drivers/net/phy/phylink.c                          |    6
> drivers/net/tun.c                                  |   16 +-
> drivers/net/usb/cdc_ether.c                        |   10 +
> drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    5
> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    2
> drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |    5
> drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   18 --
> drivers/net/wireless/rsi/rsi_91x_usb.c             |    1
> drivers/pci/pci-driver.c                           |    3
> drivers/platform/x86/pcengines-apuv2.c             |    2
> drivers/platform/x86/pmc_atom.c                    |    8 +
> drivers/regulator/twl-regulator.c                  |   23 ++
> fs/btrfs/tree-log.c                                |   16 +-
> fs/ubifs/tnc.c                                     |   16 +-
> include/linux/phy_fixed.h                          |    1
> include/linux/syscalls.h                           |   19 ++
> include/uapi/asm-generic/unistd.h                  |    2
> include/uapi/linux/isdn/capicmd.h                  |    1
> ipc/util.h                                         |   25 ---
> kernel/cgroup/cgroup.c                             |   10 +
> kernel/irq/resend.c                                |    2
> kernel/module.c                                    |   51 ++++--
> mm/z3fold.c                                        |    7
> net/bridge/br_mdb.c                                |    2
> net/core/dev.c                                     |    2
> net/core/skbuff.c                                  |   19 ++
> net/core/sock_map.c                                |    3
> net/ipv4/tcp_input.c                               |    2
> net/ipv6/ping.c                                    |    2
> net/ipv6/route.c                                   |    8 -
> net/sched/sch_generic.c                            |    9 -
> net/sched/sch_hhf.c                                |    2
> net/sctp/protocol.c                                |    2
> net/sctp/sm_sideeffect.c                           |    2
> net/sctp/socket.c                                  |    3
> net/tipc/name_distr.c                              |    3
> 76 files changed, 955 insertions(+), 322 deletions(-)
>
>Alex Williamson (1):
>      PCI: Always allow probing with driver_override
>
>Alexander Duyck (1):
>      ixgbe: Prevent u8 wrapping of ITR value to something less than 10us
>
>Andreas Kemnade (1):
>      regulator: twl: voltage lists for vdd1/2 on twl4030
>
>Andrew F. Davis (1):
>      firmware: ti_sci: Always request response from firmware
>
>Arnd Bergmann (2):
>      ipc: fix semtimedop for generic 32-bit architectures
>      ipc: fix sparc64 ipc() wrapper
>
>Bj=C3=B8rn Mork (1):
>      cdc_ether: fix rndis support for Mediatek based smartphones
>
>Chen-Yu Tsai (1):
>      clk: Fix debugfs clk_possible_parents for clks without parent string=
 names
>
>Chris Wilson (1):
>      drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+
>
>Christophe JAILLET (2):
>      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
>      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
>
>Christophe Leroy (6):
>      crypto: talitos - check AES key size
>      crypto: talitos - fix CTR alg blocksize
>      crypto: talitos - check data blocksize in ablkcipher.
>      crypto: talitos - fix ECB algs ivsize
>      crypto: talitos - Do not modify req->cryptlen on decryption.
>      crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.
>
>Cong Wang (1):
>      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
>
>Dan Carpenter (2):
>      mt76: Fix a signedness bug in mt7615_add_interface()
>      mt76: mt7615: Use after free in mt7615_mcu_set_bcn()
>
>Daniel Drake (1):
>      Revert "mmc: sdhci: Remove unneeded quirk2 flag of O2 SD host contro=
ller"
>
>Douglas Anderson (1):
>      clk: rockchip: Don't yell about bad mmc phases when getting
>
>Enrico Weigelt (1):
>      platform/x86: pcengines-apuv2: use KEY_RESTART for front button
>
>Eric Biggers (1):
>      isdn/capi: check message length in capi_write()
>
>Eric Dumazet (1):
>      net: sched: fix reordering issues
>
>Filipe Manana (1):
>      Btrfs: fix assertion failure during fsync and use of stale transacti=
on
>
>Fuqian Huang (1):
>      KVM: x86: work around leak of uninitialized stack contents
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.16
>
>Gustavo A. R. Silva (1):
>      mm/z3fold.c: fix lock/unlock imbalance in z3fold_page_isolate
>
>Hans de Goede (2):
>      gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and b=
lacklist
>      drm: panel-orientation-quirks: Add extra quirk table entry for GPD M=
icroPC
>
>Henry Burns (1):
>      mm/z3fold.c: remove z3fold_migration trylock
>
>Hui Peng (1):
>      rsi: fix a double free bug in rsi_91x_deinit()
>
>Igor Mammedov (1):
>      KVM: s390: kvm_s390_vm_start_migration: check dirty_bitmap before us=
ing it as target for memset()
>
>Ilya Maximets (1):
>      ixgbe: fix double clean of Tx descriptors with xdp
>
>Jeff Kirsher (1):
>      ixgbevf: Fix secpath usage for IPsec Tx offload
>
>Jessica Yu (1):
>      modules: always page-align module section allocations
>
>Jim Mattson (1):
>      kvm: nVMX: Remove unnecessary sync_roots from handle_invept
>
>John Fastabend (1):
>      net: sock_map, fix missing ulp check in sock hash case
>
>Junichi Nomura (1):
>      x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernels
>
>Kent Gibson (2):
>      gpio: fix line flag validation in linehandle_create
>      gpio: fix line flag validation in lineevent_create
>
>Linus Torvalds (1):
>      x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to s=
ilence GCC9 build warning
>
>Liran Alon (1):
>      KVM: SVM: Fix detection of AMD Errata 1096
>
>Maciej =C5=BBenczykowski (2):
>      net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (an=
d others)
>      ipv6: addrconf_f6i_alloc - fix non-null pointer check to !IS_ERR()
>
>Mario Limonciello (1):
>      Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"
>
>Mimi Zohar (1):
>      x86/ima: check EFI SetupMode too
>
>Moritz Fischer (1):
>      net: fixed_phy: Add forward declaration for struct gpio_desc;
>
>Muchun Song (1):
>      driver core: Fix use-after-free and double free on glue directory
>
>Neal Cardwell (1):
>      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
>
>Neil Armstrong (1):
>      drm/meson: Add support for XBGR8888 & ABGR8888 formats
>
>Nicolas Dichtel (1):
>      bridge/mdb: remove wrong use of NLM_F_MULTI
>
>Nishka Dasgupta (1):
>      drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto
>
>Olivier Moysan (2):
>      iio: adc: stm32-dfsdm: fix output resolution
>      iio: adc: stm32-dfsdm: fix data type
>
>Paolo Bonzini (1):
>      KVM: nVMX: handle page fault in vmread
>
>Richard Weinberger (1):
>      ubifs: Correctly use tnc_next() in search_dh_cookie()
>
>Roman Gushchin (1):
>      cgroup: freezer: fix frozen state inheritance
>
>Sean Christopherson (1):
>      KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
>
>Shmulik Ladkani (1):
>      net: gso: Fix skb_segment splat when splitting gso_size mangled skb =
having linear-headed frag_list
>
>Stanislaw Gruszka (2):
>      Revert "rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band"
>      mt76: mt76x0e: disable 5GHz band for MT7630E
>
>Stefan Chulski (1):
>      net: phylink: Fix flow control resolution
>
>Stefan Wahren (1):
>      Revert "mmc: bcm2835: Terminate timeout work synchronously"
>
>Steffen Dirkwinkel (1):
>      platform/x86: pmc_atom: Add CB4063 Beckhoff Automation board to crit=
clk_systems DMI table
>
>Steffen Klassert (1):
>      ixgbe: Fix secpath usage for IPsec TX offload.
>
>Stephen Boyd (1):
>      clk: Simplify debugfs printing and add a newline
>
>Steve Wahl (1):
>      x86/purgatory: Change compiler flags from -mcmodel=3Dkernel to -mcmo=
del=3Dlarge to fix kexec relocation errors
>
>Subash Abhinov Kasiviswanathan (1):
>      net: Fix null de-reference of device refcount
>
>Suraj Jitindar Singh (1):
>      powerpc: Add barrier_nospec to raw_copy_in_user()
>
>Thomas Huth (1):
>      KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT i=
octl
>
>Ulf Hansson (2):
>      mmc: tmio: Fixup runtime PM management during probe
>      mmc: tmio: Fixup runtime PM management during remove
>
>Vasily Khoruzhick (1):
>      drm/lima: fix lima_gem_wait() return value
>
>Ville Syrj=C3=A4l=C3=A4 (1):
>      drm/i915: Limit MST to <=3D 8bpc once again
>
>Wei Yongjun (1):
>      gpio: mockup: add missing single_release()
>
>Xiaolei Li (1):
>      mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue
>
>Xin Long (3):
>      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
>      tipc: add NULL pointer check before calling kfree_rcu
>      sctp: fix the missing put_user when dumping transport thresholds
>
>Yang Yingliang (3):
>      tun: fix use-after-free when register netdev failed
>      modules: fix BUG when load module with rodata=3Dn
>      modules: fix compile error if don't have strict module rwx
>
>YueHaibing (1):
>      kernel/module: Fix mem leak in module_add_modinfo_attrs
>
>Yunfeng Ye (1):
>      genirq: Prevent NULL pointer dereference in resend_irqs()
>



--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl2DTG4ACgkQsjqdtxFL
KRXMNggAgotMXFArSxrx0Zk7Bvo4KhVsINzxBMFa1mbzrbM02d9CtcvlMj//NJ+U
xCWhZKV5z8j7m3jX+w8fZcuYOwEFKwicnN9chfn4Mp1H0XH/nZn2/qtzqUyya2zX
BvvTXIPGbkj/DVT76OnuG9ADCjPztrEYHVlrMf2MFuEtzkHAI59RH+ynte84UNJR
RDN4KeQ+xYyzIP20SUq4JFqUxXI7xm4CzcOIwAqaId0epqhgp4UWZwsOTGGh9ocf
n0RNgUqxciX/+qRvpjaqTsr9a8gShgm/QGgHsHNOvGxJTK2RSs9p7aXaPINVUWnY
xOmERH9RvahAm2gz8xzfWisSW7KH8g==
=CRzP
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
