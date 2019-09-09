Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEAFADA9E
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 16:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfIIN7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 09:59:30 -0400
Received: from mail.andi.de1.cc ([85.214.55.253]:43216 "EHLO mail.andi.de1.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfIIN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 09:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/AFGG/f6EaJVXJNRdgri096CPzRiFvet7SwlKHTMKh4=; b=TI2mf67XY3jlg30elZyEGOQzQ
        af405SRfOPFtWLppj1PdSHwiUGgF8GRtgwaRMtl3PG3s5BYWkKHidXCzkZemv/qj51k2GAn1GpR43
        +2HapYaxNwNp9avJvKy7ILiNSfDUTNnJYcaVAtIazJfhhUO//31/3uaQ3A01JQ9XZMVdo=;
Received: from [2a02:790:ff:1019:7ee9:d3ff:fe1f:a246] (helo=localhost)
        by mail.andi.de1.cc with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1i7KCR-0002fX-Dv; Mon, 09 Sep 2019 15:59:23 +0200
Received: from [::1] (helo=localhost)
        by localhost with esmtp (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1i7KCO-0007EI-Tt; Mon, 09 Sep 2019 15:59:21 +0200
Date:   Mon, 9 Sep 2019 15:59:11 +0200
From:   Andreas Kemnade <andreas@kemnade.info>
To:     Adam Ford <aford173@gmail.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Nishanth Menon <nm@ti.com>, vireshk@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] regulator: twl: voltage lists for vdd1/2 on twl4030
Message-ID: <20190909155911.63f8bb54@kemnade.info>
In-Reply-To: <CAHCN7xJ0RmRQwo3bSF6FoLjOtrg5YZAMD9+=332LMzLLR1qdDA@mail.gmail.com>
References: <20190814214319.24087-1-andreas@kemnade.info>
        <CAHCN7xL4K+1nJDXDRs7yVi6LhGL-4uPu9M+SN1dcOPu8=M8s2g@mail.gmail.com>
        <CAHCN7xJ0RmRQwo3bSF6FoLjOtrg5YZAMD9+=332LMzLLR1qdDA@mail.gmail.com>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/i1vz99ml6P9dqs764owEbgp"; protocol="application/pgp-signature"
X-Spam-Score: -1.0 (-)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/i1vz99ml6P9dqs764owEbgp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Sep 2019 08:32:06 -0500
Adam Ford <aford173@gmail.com> wrote:


> > > The patch fixes declaration of VDD1/2 regulators by
> > > adding proper voltage lists.
> > >
> > > Fixes: 498209445124 ("regulator: core: simplify return value on supor=
ted_voltage")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Andreas Kemnade <andreas@kemnade.info> =20
> >
> > Tested-by: Adam Ford <aford173@gmail.com> #logicpd-torpedo-37xx-devkit
> > =20
>=20
> I am not sure who the right maintainer is, but as of today, cpufreq
> for users of twl4030 on 5.3-RC8 is still broken without this patch.
> Is there any way it can be applied before the final release?
>=20
seems to have arrived in Mark Brown's regulator branches. and in linux-next=
/pending-fixes.
But did not go further...

Regards,
Andreas

--Sig_/i1vz99ml6P9dqs764owEbgp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEPIWxmAFyOaBcwCpFl4jFM1s/ye8FAl12Wq8ACgkQl4jFM1s/
ye84Jw//S1zGHJKjlOFnpDDPhc/2QqOWuOmzhP2x79Vh4Iv+cmyvcUdhkJTWi5gA
W/Meomgy7EQ3jvFv3HCkOBd64kk32PFjo5COjR/FwzTuDiVRaBfsLb/wjc4IOKCg
0llnlB7V3lX9ZmTkGRg3GbnJhdGn+fiAl41YQ16sUQ6Ef52nneE0x+mX7z50KvjD
BQhAbXzsBZLLcW/MH12DkszXc5JJ3FtU9/yx0B4UKPCCY9BeqoUYGTZrJ2yop7b5
RiCTcsxa659f6kGybnIGb743cYi1ibc6yGHIsR9qQf53hIvKFR+bXzjZ/UoGca02
VHOtATygBzHOsg5EKFwit60h3l1tvuPHb5LzqYok+lWHQtF1FFVcr2tGvlEycGd5
TF8XnlPUhEMFS7eGaB7r3xuZoTaVevhCOpznNQfVk8U/ebpW0K5I7Vu6XMKmbqIt
nXG/7GPk1hdcQdqqRg3mPDvNB8vcFv5L9duOmL+rW5nkF6Xmyr4v8vmyqBeYaZ3R
/gBXy3oCIwxIxpEJXmlGZOI/3cdKDJncib+PJRICPHfbubT86iZp3psMVCdtCohA
rqd4On/JjPvsVPc7rHyU//K/v9PnzkWIwXKRTDfP2lhbgPoRyrYh7cwRdBA/aw0o
ru9SIpgvx+oEsoXcQf1KB53IyntcG/6OT7F7ibxld69Pam3wBpM=
=+Fw/
-----END PGP SIGNATURE-----

--Sig_/i1vz99ml6P9dqs764owEbgp--
