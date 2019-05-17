Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111FC214C5
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfEQHsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:48:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41414 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbfEQHsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 03:48:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id f12so2961425plt.8;
        Fri, 17 May 2019 00:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e7Qp6LKHj/3mNID2lgCFKasc6WOLBr9UOnuN8ZBiMPs=;
        b=Pn1spgbfnlJ//Sxh/ucpxJMn9BqZcLkyGy5a0seP4zK/hkUIneSIXJ6KlB4n5H7kiy
         e7ws1VDwKLFVuC47vuyLFgpTzJJOuqEAU6dUKp90dmEh24/46lCuFzSM3k9iBFV1rlRm
         uy+Au0hPA4xqFwBzys+YfaTQFSl9OouU8DqdtaMXU6Vb7meOMiBVUGGEwW7CZ8zEfYSJ
         OwheHXcGMzcjwj09s6YshFaQFBfX/SzIWvPSbyaCtjBAcevSONPIn8IYhEYlK4CF8UiA
         DtjDEHO5Y62GfMUJlnxZFxZf3wX4yZgcXRSlPfzYOz1aMnQmEsDKdIle3JgDBDCOiNUW
         ph8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e7Qp6LKHj/3mNID2lgCFKasc6WOLBr9UOnuN8ZBiMPs=;
        b=DDwBOEAtAp/H3ldtwnrLSYZ7TGTm5m9tvEa8wYV8Jf3wWKQMH5m/eNUYsD28V/gJ0J
         D75Sav0yX1kKw5nhGh3QqqN5PiY67fuOVydXJsaETBe0Zc7xMICt3tHNO+q8RIxlD5gy
         /1ALfBSkwPg6g9gJmLlunulN2/YP6YNQY5Do28ZH/xWmtNrxnKPy1zR8r7N3cd0osnbI
         6PxEd66+j3bWCtSjvEEZtU//8ppz3Wp4FvH3Cfs3Ia/mof/NmQcZmNf0TMIlIPgUlhRj
         2m9DhQRvVQKUgz/qptWqM7DbWbU2kjOq/0EjY+AWgP0S4Zf66keHOzZdwvT8i4/okOoZ
         it0g==
X-Gm-Message-State: APjAAAXnuLv4vxd2fKJ1veeEkxK9G19CQJbtNamjddlibwVwix8nsChl
        gT8dLLeqZPUmEFasXdUZUW4=
X-Google-Smtp-Source: APXvYqy526LfwOWppbt2UWvHx7Ut7Cfm8CtpP9cgTXMcWbnWThRyf65ipWkZdCWrjHkLvrSLF1ZCyg==
X-Received: by 2002:a17:902:9348:: with SMTP id g8mr12771830plp.174.1558079285793;
        Fri, 17 May 2019 00:48:05 -0700 (PDT)
Received: from debian ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id g17sm13726504pfk.55.2019.05.17.00.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 00:48:04 -0700 (PDT)
Date:   Fri, 17 May 2019 13:17:52 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.3
Message-ID: <20190517074752.GA4114@debian>
References: <20190517073706.GA11119@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20190517073706.GA11119@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg! :)=20

On 09:37 Fri 17 May , Greg KH wrote:
>I'm announcing the release of the 5.1.3 kernel.
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
> Makefile                                            |    2
> arch/powerpc/include/asm/book3s/64/pgalloc.h        |    3
> arch/powerpc/include/asm/reg_booke.h                |    2
> arch/powerpc/kernel/idle_book3s.S                   |   20 +++++
> drivers/hwmon/occ/sysfs.c                           |    8 +-
> drivers/hwmon/pwm-fan.c                             |    2
> drivers/i2c/i2c-core-base.c                         |    5 +
> drivers/isdn/gigaset/bas-gigaset.c                  |    9 +-
> drivers/md/raid5.c                                  |   19 +----
> drivers/net/bonding/bond_options.c                  |    7 -
> drivers/net/ethernet/cadence/macb_main.c            |    6 -
> drivers/net/ethernet/freescale/dpaa/dpaa_eth.c      |    2
> drivers/net/ethernet/freescale/ucc_geth_ethtool.c   |    8 --
> drivers/net/ethernet/seeq/sgiseeq.c                 |    1
> drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c   |    2
> drivers/net/phy/phy_device.c                        |   11 +--
> drivers/net/tun.c                                   |   14 +++
> drivers/net/wireless/marvell/mwl8k.c                |   13 ++-
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c |    1
> drivers/pci/controller/pci-hyperv.c                 |   23 ++++++
> drivers/platform/x86/dell-laptop.c                  |    6 -
> drivers/platform/x86/sony-laptop.c                  |    8 +-
> drivers/platform/x86/thinkpad_acpi.c                |   72 ++++++++++++++=
+++++-
> drivers/usb/serial/generic.c                        |   39 ++++++++--
> drivers/virt/fsl_hypervisor.c                       |   29 ++++----
> drivers/virt/vboxguest/vboxguest_core.c             |   31 ++++++++
> drivers/virtio/virtio_ring.c                        |    1
> fs/f2fs/data.c                                      |   17 +++-
> fs/f2fs/f2fs.h                                      |   13 +++
> fs/f2fs/file.c                                      |    2
> fs/f2fs/gc.c                                        |    2
> fs/f2fs/segment.c                                   |   13 +--
> fs/kernfs/dir.c                                     |    5 -
> include/linux/i2c.h                                 |    3
> net/8021q/vlan_dev.c                                |    4 -
> net/bridge/br_if.c                                  |   13 +--
> net/core/fib_rules.c                                |    6 -
> net/core/flow_dissector.c                           |    3
> net/dsa/dsa.c                                       |   11 ++-
> net/ipv4/raw.c                                      |    4 -
> net/ipv6/sit.c                                      |    2
> net/packet/af_packet.c                              |   25 +++++-
> net/tipc/socket.c                                   |    4 -
> security/selinux/hooks.c                            |    8 +-
> tools/testing/selftests/seccomp/seccomp_bpf.c       |   43 ++++++-----
> 45 files changed, 375 insertions(+), 147 deletions(-)
>
>Andrea Parri (1):
>      kernfs: fix barrier usage in __kernfs_new_node()
>
>Christophe Leroy (1):
>      net: ucc_geth - fix Oops when changing number of buffers in the ring
>
>Corentin Labbe (1):
>      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filter=
ing
>
>Damien Le Moal (1):
>      f2fs: Fix use of number of devices
>
>Dan Carpenter (2):
>      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
>      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl
>
>David Ahern (1):
>      ipv4: Fix raw socket lookup for local traffic
>
>Dexuan Cui (3):
>      PCI: hv: Fix a memory leak in hv_eject_device_work()
>      PCI: hv: Add hv_pci_remove_slots() when we unload the driver
>      PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if ne=
cessary
>
>Eric Dumazet (1):
>      flow_dissector: disable preemption around BPF calls
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.3
>
>Gustavo A. R. Silva (2):
>      platform/x86: sony-laptop: Fix unintentional fall-through
>      rtlwifi: rtl8723ae: Fix missing break in switch statement
>
>Hangbin Liu (2):
>      fib_rules: return 0 directly if an exactly same rule exists when NLM=
_F_EXCL not supplied
>      vlan: disable SIOCSHWTSTAMP in container
>
>Hans de Goede (1):
>      virt: vbox: Sanity-check parameter types for hgcm-calls coming from =
userspace
>
>Harini Katakam (1):
>      net: macb: Change interrupt and napi enable order in open
>
>Heiner Kallweit (1):
>      net: phy: fix phy_validate_pause
>
>Jarod Wilson (1):
>      bonding: fix arp_validate toggling in active-backup mode
>
>Jason Wang (2):
>      tuntap: fix dividing by zero in ebpf queue selection
>      tuntap: synchronize through tfiles array instead of tun->numqueues
>
>Jiaxun Yang (1):
>      platform/x86: thinkpad_acpi: Disable Bluetooth for some machines
>
>Johan Hovold (1):
>      USB: serial: fix unthrottle races
>
>Kees Cook (1):
>      selftests/seccomp: Handle namespace failures gracefully
>
>Laurentiu Tudor (2):
>      dpaa_eth: fix SG frame cleanup
>      powerpc/booke64: set RI in default MSR
>
>Lei YU (1):
>      hwmon: (occ) Fix extended status bits
>
>Mario Limonciello (1):
>      platform/x86: dell-laptop: fix rfkill functionality
>
>Nigel Croxon (1):
>      Don't jump to compute_result state from check_result state
>
>Paolo Abeni (1):
>      selinux: do not report error on connect(AF_UNSPEC)
>
>Parthasarathy Bhuvaragan (1):
>      tipc: fix hanging clients using poll with EPOLLOUT flag
>
>Paul Bolle (1):
>      isdn: bas_gigaset: use usb_fill_int_urb() properly
>
>Petr =C5=A0tetiar (1):
>      mwl8k: Fix rate_idx underflow
>
>Rick Lindsley (1):
>      powerpc/book3s/64: check for NULL pointer in pgd_alloc()
>
>Russell Currey (1):
>      powerpc/powernv/idle: Restore IAMR after idle
>
>Stefan Wahren (1):
>      hwmon: (pwm-fan) Disable PWM if fetching cooling data fails
>
>Stephen Suryaputra (1):
>      vrf: sit mtu should not be updated when vrf netdev is the link
>
>Thomas Bogendoerfer (1):
>      net: seeq: fix crash caused by not set dev.parent
>
>Tobin C. Harding (1):
>      bridge: Fix error path for kobject_init_and_add()
>
>Wolfram Sang (1):
>      i2c: core: ratelimit 'transfer when suspended' errors
>
>YueHaibing (3):
>      net: dsa: Fix error cleanup path in dsa_init_module
>      packet: Fix error path in packet_init
>      virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed
>



--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzeZx8ACgkQsjqdtxFL
KRWf8gf9EZhg53Ncsfyz7mf3h2CmrX6b6DuTqJDzoi8OOduRqsmL51ZLVxGhxzIq
WVubmvAK+5u/mWEgj5F4tyJDHEhZuEhFhgfQLCrDIbivQM4vv3WwvH5aId5f/3dq
zGOOiDYiVIqPks1Zzp/x+eAQdd4E4b1kIW1zrxdBOy3F9D7kGfPnKEx7FwiL4TFV
xnuzpNVvlbWt3mgar/Wb3X4GZ5QS4EVLZDQoBi5KlCxeSsaZLL1Ndhm7fur9Y8iG
HxD18P1VYrgGY/y4fXce6Q2YMi3MLyHLAqBzEtoc/tNSOltHQv1rwW4LycPi0w8V
E12CRJ69Dax6L0sfjlDsAdD+b4rcXQ==
=7K0+
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
