Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5FE137F9
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfEDGyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:54:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55026 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfEDGyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 02:54:50 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 32DCD802D0; Sat,  4 May 2019 08:54:37 +0200 (CEST)
Date:   Sat, 4 May 2019 08:54:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.39-stable review
Message-ID: <20190504065447.GA16530@amd>
References: <20190502143333.437607839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-05-02 17:20:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.39 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat 04 May 2019 02:32:17 PM UTC.
> Anything received after that time might be too late.

These do not meet stable criteria afaict: (3-5... I see this is
probably security bug; it would be good to mention in the preparation
patches what is going on because otherwise it is tricky to understand).

?? 03/72] mm: make page ref count overflow check tighter and m -- not sure =
description is good enough; preparation for later changes?
?? 04/72] mm: add try_get_page() helper function -- adds unused function
?? 05/72] mm: prevent get_user_pages() from overflowing page r -- over
  100 line limit and depedns on previous patches. get_gate_page() change
  not in -rc?.. it is in -next.
?? 08/72] s390: limit brk randomization to 32MB -- dunno, english is bad. I=
t explains 1GB is a problem, but then it goes to 32MB?
?? 23/72] serial: ar933x_uart: Fix build failure with disabled -- this is n=
ot minimal fix; tricky to verify=20
?? 30/72] usb: gadget: net2272: Fix net2272_dequeue() -- dunno. "Only compi=
le tested". Do we believe someone actually tested it before it went to stab=
le?
?? 35/72] net: ks8851: Delay requesting IRQ until opened -- this fixes cosm=
etic problem in dmesg, not a serious bug.
?? 43/72] ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dts -- enables s=
upport for faster mmc on i.mx6. Not sure it qualifies as serious bug?
?? 46/72] net: xilinx: fix possible object reference leak -- patch to fix i=
t up.
?? 58/72] leds: trigger: netdev: fix refcnt leak on interface  -- cleanups =
with a fix in one package
?? 70/72] ptrace: take into account saved_sigmask in PTRACE{GE -- so
  GETSIGMASK returns wrong mask to userspace. ... but does it cause any
  problems and is there anyone relying on old behaviour?

I reviewed these for stable and they seem ok:

A 01/72] selinux: use kernel linux/socket.h for genheaders an
A 02/72] Revert "ACPICA: Clear status of GPEs before enabling
A 07/72] ARM: dts: bcm283x: Fix hdmi hpd gpio pull
A 11/72] net: stmmac: dont set own bit too early for jumbo fr
A 12/72] qlcnic: Avoid potential NULL pointer dereference
A 13/72] xsk: fix umem memory leak on cleanup
A 16/72] netfilter: nft_set_rbtree: check for inactive elemen
A 17/72] netfilter: bridge: set skb transport_header before e
A 18/72] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
A 19/72] netfilter: ip6t_srh: fix NULL pointer dereferences
A 20/72] s390/qeth: fix race when initializing the IP address
A 21/72] ARM: imx51: fix a leaked reference by adding missing
A 22/72] sc16is7xx: missing unregister/delete driver on error
A 24/72] KVM: arm64: Reset the PMU in preemptible context
A 25/72] KVM: arm/arm64: vgic-its: Take the srcu lock when wr
A 26/72] KVM: arm/arm64: vgic-its: Take the srcu lock when pa
A 27/72] usb: dwc3: pci: add support for Comet Lake PCH ID  =20
A 28/72] usb: gadget: net2280: Fix overrun of OUT messages  =20
A 29/72] usb: gadget: net2280: Fix net2280_dequeue()
A 31/72] ARM: dts: pfla02: increase phy reset duration
A 32/72] i2c: i801: Add support for Intel Comet Lake
A 33/72] net: ks8851: Dequeue RX packets explicitly
A 34/72] net: ks8851: Reassert reset pin if chip ID check fai
A 36/72] net: ks8851: Set initial carrier state to down
A 41/72] net: macb: Add null check for PCLK and HCLK        =20
A 42/72] net/sched: dont dereference a->goto_chain to read th
A 44/72] drm/tegra: hub: Fix dereference before check
A 45/72] NFS: Fix a typo in nfs_init_timeout_values()
A 47/72] net: ibm: fix possible object reference leak
A 48/72] net: ethernet: ti: fix possible object reference lea
A 49/72] drm: Fix drm_release() and device unplug
A 50/72] gpio: aspeed: fix a potential NULL pointer dereferen
A 51/72] drm/meson: Fix invalid pointer in meson_drv_unbind()
A 52/72] drm/meson: Uninstall IRQ handler
A 53/72] ARM: davinci: fix build failure with allnoconfig
A 54/72] scsi: mpt3sas: Fix kernel panic during expander rese
A 55/72] scsi: aacraid: Insure we dont access PCIe space duri
A 56/72] scsi: qla4xxx: fix a potential NULL pointer derefere
A 59/72] x86/realmode: Dont leak the trampoline kernel addres
A 60/72] usb: u132-hcd: fix resource leak
A 61/72] ceph: fix use-after-free on symlink traversal
A 63/72] x86/mm: Dont exceed the valid physical address space
A 64/72] libata: fix using DMA buffers on stack
A 65/72] gpio: of: Fix of_gpiochip_add() error path
A 66/72] nvme-multipath: relax ANA state check
A 67/72] perf machine: Update kernel map address and re-order
A 68/72] kconfig/[mn]conf: handle backspace (^H) key  =20
A 69/72] iommu/amd: Reserve exclusion range in iova-domain  =20
A 71/72] leds: pca9532: fix a potential NULL pointer derefere -- but I doub=
t it is problem in wild
A 72/72] leds: trigger: netdev: use memcpy in device_name_sto

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzNNzcACgkQMOfwapXb+vK46wCcDhZxy34UUBKVrUWnWDLYkNOq
grYAn2Jbn8bDZ1grIbL9DxJUJJda3XmY
=Fzuy
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
