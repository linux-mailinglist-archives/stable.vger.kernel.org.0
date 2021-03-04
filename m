Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7372B32CEC9
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhCDIvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:51:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56812 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhCDIvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 03:51:16 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C9311C0B8A; Thu,  4 Mar 2021 09:50:34 +0100 (CET)
Date:   Thu, 4 Mar 2021 09:50:33 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com,
        syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 663/663] net_sched: fix RTNL deadlock again caused
 by request_module()
Message-ID: <20210304085032.GB25188@amd>
References: <20210301161141.760350206@linuxfoundation.org>
 <20210301161214.647700971@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20210301161214.647700971@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Although this looks serious, it only has been reported by syzbot, so it
> seems hard to trigger this by humans. And given the size of this patch,
> I'd suggest to make it to net-next and not to backport to stable.

I'd also preffer this not to be in stable. Long patch in series of
600, with few days to review it all, and patch was not really in
mainline for long enough.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBAn1gACgkQMOfwapXb+vIlbQCgmQehifjgF4rzJPequHCI3mgK
XsMAoMCi18VBmTbp6J88ZxA7zYDodHOk
=7U3A
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
