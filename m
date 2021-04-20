Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056B036537A
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhDTHsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhDTHsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 03:48:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD6560241;
        Tue, 20 Apr 2021 07:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618904852;
        bh=cDAgqDSILaYUTJgmq4lMp/YcdhVZuLucmtzjLdTLJFc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VZpv34/jOFIoad1qrF1Ga6EOiJOivMZzoGcF5QWB2Lx6e910yu6bGvSyyf7fu/47v
         ff8j1GXDDF+Qeom4tlEzzkAdT35+X9IB7prkgufSnyNkprgz4YYAIkT8UybcjugaAK
         EQaXH7VBMMONfpcH8vpTFToEtffMayOpFSNPvRDhBIhSnlKQ7PawwR/Z9WHjst2kYn
         5k/ry6u1JkmXl7xCsuBjqPNaD6c7IG/yPLj/bNt2GzynIWYlaubFGG2BMb107fRJ6a
         gbywlWGzf/2NrCpnjj8tdawSYMVQ8ufKl4lRi+0YzHdbYcx+XgIMOj1bBmn698eVbu
         FGOaxSOzkBklg==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Fix START_TRANSFER link state check
In-Reply-To: <bcefaa9ecbc3e1936858c0baa14de6612960e909.1618884221.git.Thinh.Nguyen@synopsys.com>
References: <bcefaa9ecbc3e1936858c0baa14de6612960e909.1618884221.git.Thinh.Nguyen@synopsys.com>
Date:   Tue, 20 Apr 2021 10:47:25 +0300
Message-ID: <87eef5mm7m.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> The START_TRANSFER command needs to be executed while in ON/U0 link
> state (with an exception during register initialization). Don't use
> dwc->link_state to check this since the driver only tracks the link
> state when the link state change interrupt is enabled. Check the link
> state from DSTS register instead.
>
> Note that often the host already brings the device out of low power
> before it sends/requests the next transfer. So, the user won't see any
> issue when the device starts transfer then. This issue is more
> noticeable in cases when the device delays starting transfer, which can
> happen during delayed control status after the host put the device in
> low power.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 799e9dc82968 ("usb: dwc3: gadget: conditionally disable Link State=
 change events")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB+hw0RHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbGBxAAnFFXtLnGfIm4lB9IF6swcmnvDgc8Mhs+
1suAbrTVNnAZw1VuRko6fMSZjHcjGjicuDVxa8Q3ZP5wKu2ykOhMkRADTE7muk2M
NjB6gjW8NLAyL5Y6gjHRTnyZgkmQpcvOp8JnnN/ky7xviU2emvUGfAKqQ5V5JVGL
LSx2gwaKw8MGgp9IVpEdDHCmAGrf3IbtgAlzrBqrhz2LKvAnhke5u3AgyKiiiPM2
P1U5IiAP2xjQYASe2Sz0pAuxdY/4XBMq3OFH98ABmnDzfLd5kjDiuW38NThBHn7s
LyckewcRjGI9Nwp/QmbrpnrrlpEaXACE8nq9REk++chenXD9NXFTwFSB9S79OMip
3vi/O1+HLspzV+O2RhxJ3SjRdHRk1q/wczjGvZFvsM3J4IMAy3rOaWQueky9A1HZ
FUxvmNb9Ih92atAsqh3f41b6+sFSR34VAzAie2sk5qiZKWlrpH0oP6D0ykObqCbx
s3+ATyGYdHnqEB+OCd8rF+xTIskbUZF/3jWVd9Qmj7bzFu8VLMZ3l7mx90o0iSKk
5ULPhWuPw3CpwcPegxnBxzNvIDs5cnlWZIkAjuq7UWQojYfQJIk3QRoonQyTzwK2
tV56xzAJQvj96GNqZfDGSOuP0UxfvOvyN0Kadkhy6gmwQCcEAv5YRws5hZhaw6Pz
EWgAkjlNEck=
=nIE/
-----END PGP SIGNATURE-----
--=-=-=--
