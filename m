Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FEA17F3C7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 10:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJJfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 05:35:01 -0400
Received: from sauhun.de ([88.99.104.3]:46628 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgCJJfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 05:35:01 -0400
Received: from localhost (p54B33196.dip0.t-ipconnect.de [84.179.49.150])
        by pokefinder.org (Postfix) with ESMTPSA id 5B9AB2C1EB6;
        Tue, 10 Mar 2020 10:34:59 +0100 (CET)
Date:   Tue, 10 Mar 2020 10:34:59 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
Message-ID: <20200310093458.GF1987@ninjato>
References: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2020 at 05:15:03PM +0200, Jarkko Nikula wrote:
> Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
> pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
> enabled device since the driver has not released the requested IRQ before
> calling the pci_free_irq_vectors().
>=20
> Here driver requests an IRQ using devm_request_irq() but automatic
> release happens only after remove callback. Fix this by explicitly
> freeing the IRQ before calling pci_free_irq_vectors().
>=20
> Fixes: 21aa3983d619 ("i2c: designware-pci: Switch over to MSI interrupts")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Applied to for-current, thanks!


--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl5nX0IACgkQFA3kzBSg
KbYJ1Q/+IRTLl2HjjcF7dkCI2Z8F1Lj190v04UHT/Khx1j8PPF0ZSIoBd2a7SGoE
4SIsfvOyhE0rkET+WPvblhF9CHAsrOUfH2s85rwFRKaBF74UqIsAHMO+ZwDASng3
ObWgz0+kLm3BAhtyWQIBGRLWK1cCcoBEifUdnm6rx33XWemmUzF26S3XMV+WHIxM
QoNeYT29sYCOVRjvVVg5X1yFnnkcMh4IWaKxaFDlXES1ID9ZsdaTaRGBXrPtoFCU
KYrKzJTy4KvaJNbaOYZwP5NLJR1940/aYQQkH7KvubE3Gh30oGUiZaG4s6nqdU1a
AGqbZvgaJE0W1ek8TmhcS/0jLuOKtbdNkodBLMpbWeHodfB8CsGznRzDuC37rXeB
9+3OOr0uMe9Q8ltyJdkWu1U+GSh/sQqxIra+8xRze9xS0o9wvoHBv7lRqTnFbdwe
v9GcocMG6QEZQFWSQFva5ZghAdHNEBDzWy2PruPv5tUDvg3hSYMq579kbUbG9VZI
i4hjB6mea9aRtXkRKUXZRQgu2nVsA5fhF2/+p7yqFGablQQdfxvYWn6QDQq//UkQ
T14FtpdxeLN5UCtye6ccW+jr1DLCHNeyxEqMM2q8/cjkcaSGtSTvtYFSiL/GV+yh
FXJvZkiAOj5reTAlKMnw0p4JGyZqKD2654i4MhndBxLi+pd8xZY=
=o8f9
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
