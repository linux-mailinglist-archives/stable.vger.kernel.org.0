Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9A91C772
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 13:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfENLGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 07:06:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33857 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfENLGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 07:06:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so8472545pgt.1
        for <stable@vger.kernel.org>; Tue, 14 May 2019 04:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=researchut.com; s=google;
        h=sender:message-id:subject:from:reply-to:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version;
        bh=kF4p+PLc6PZq4xFYLsNSRMvLS4CosrKkFxDaMx5qmNw=;
        b=Es05UnvC7oUZz20SzvVw8IJ5OfVN+FEf2AfjS8xtysBGnEVuon9qrtxElywnlx4ag7
         gNo4ZxQWaW+Jpzh4xWUXSVu8kJw2H9rAMDOqdQkttXWpC0dNajIcZzcOYMleYDNuwY5P
         IO1TtQT2+g3XskBUUO5NNffDtlN09cg+ojsh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:message-id:subject:from:reply-to:to:cc
         :date:in-reply-to:references:organization:user-agent:mime-version;
        bh=kF4p+PLc6PZq4xFYLsNSRMvLS4CosrKkFxDaMx5qmNw=;
        b=jnlqjAmJHpqOn36C3jqEhX+Mck57EHTPp5GFA5BxCWu0Vuc6pWROO0IefGL9+yOjpp
         3wPRoFqOrNZpl/JE4U83anByKNeDFY8+UGZEoP6ShLmxe0iH6U79++8drOnIdaH/mlXd
         nzTjvZ/q6VLG11vTTdfd7lD0rxGo2tGBsKukGqWZMK2S2bNZRINEPSbw8FN3haBq/Yyf
         6suHqx755pVc92/D/YWJP09fT0VT/QIRTE1SS5pgF65v7Dyr+1WUtM/9NGBflLeHADm3
         i3VQns2Ue6cTIwdsNkAOiwle2mpEUXwi20vHuHyRvuef/zGWdbjP/Qca2CE3wXEev48/
         cdbQ==
X-Gm-Message-State: APjAAAXhk7T1XYLwnUBEeWyoiknSUk0O3KvgeVplYp7UGX0AC4ogaBiN
        Jqp2cRtyYTfg3dPl7/L3Q8d4Pw==
X-Google-Smtp-Source: APXvYqxx+GzooYIpzZKPpiNR1iurdcRXx9NeaAqAGvgyzLEpXmRXijmvdMCz2j/2KdcUGVEZTJ31bw==
X-Received: by 2002:a63:4a66:: with SMTP id j38mr18412606pgl.199.1557832007943;
        Tue, 14 May 2019 04:06:47 -0700 (PDT)
Received: from priyasi ([157.45.46.216])
        by smtp.gmail.com with ESMTPSA id q20sm28742402pfi.166.2019.05.14.04.06.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 04:06:47 -0700 (PDT)
Received: from [127.0.0.1] (helo=localhost)
        by priyasi with esmtp (Exim 4.92)
        (envelope-from <rrs@debian.org>)
        id 1hQVGZ-0003Gq-Ii; Tue, 14 May 2019 16:36:39 +0530
Message-ID: <ae549525ebe4075c9598d8598d39e7d3d088878a.camel@debian.org>
Subject: Re: [PATCH] um: Don't hardcode path as it is architecture dependent
From:   Ritesh Raj Sarraf <rrs@debian.org>
Reply-To: rrs@debian.org
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, debian-kernel@lists.debian.org,
        Richard Weinberger <richard@nod.at>
Date:   Tue, 14 May 2019 16:36:38 +0530
In-Reply-To: <20190514102645.GA6845@kroah.com>
References: <20190514101656.10228-1-rrs@debian.org>
         <20190514102645.GA6845@kroah.com>
Organization: Debian
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UAt7QqTyq0lm73lKYdDn"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-UAt7QqTyq0lm73lKYdDn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On Tue, 2019-05-14 at 12:26 +0200, Greg KH wrote:
> On Tue, May 14, 2019 at 03:46:57PM +0530, Ritesh Raj Sarraf wrote:
> > The current code fails to run on amd64 because of hardcoded
> > reference to
> > i386
> >=20
> > Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >   arch/um/drivers/port_user.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> What is the git commit id of this patch in Linus's tree?

The git commit id should be: 9ca19a3a3e2482916c475b90f3d7fa2a03d8e5ed
The web url is:=20
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D9ca19a3a3e2482916c475b90f3d7fa2a03d8e5ed


--=20
Ritesh Raj Sarraf | http://people.debian.org/~rrs
Debian - The Universal Operating System

--=-UAt7QqTyq0lm73lKYdDn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQCVDstmIVAB/Yn02pjpYo/LhdWkFAlzaoT4ACgkQpjpYo/Lh
dWl1dRAAjcOHf3sqZgAIqXqVpYvrPb5m5gREuHQ/zYqAKAQY8LPblKHy7uY944xW
wBusMft1XqVcaKNMjfwfjGg5SL3vbaR/KbPtdXv82C7kg17OO1ujbw68hwpbmXmY
gXtI77dY3BP1dy9mvvYmD3j0howd9LGgr9NRPjf40E4Go1Pvgr6CSrVWLpBkRaA9
q4RvirWPEhUQUXgSRufWPvqHqiWefKeCSFlXPv42RsXIP87Ls1yY8aZxykWID/s2
azMhLiMfxgfk7N0rjPR/MXoO6GI0EM7gaETj6waUhe9sxb2qWTPPHhUTkEyvR1US
GvX98jrKtL1hxGJ6UH6XtG20nGSxGl7sIUTwMyq3VPIMwayyzPKHeaMqduJDJIn3
jnEHUdExZ50F1FRhVWtkACLISFWxo2Ixx9rbKtFKBaPIGK/ks9tuxL4RnOc8Mmh1
jXklnyTpdQq5B/z45O0CJoyNwh0JCtIENB/nEIij4UID6BTio5ptnFjKYIpNPAfo
mYIyIOIdCV8OUSAsAduUuuvg90LW4n660eajNC2MjlyLeBkcuG0J7WbR9bL7iFiK
qHmPLA7rRyyjHcpyXf1PS87v9yD7sN1ebVxnQ08oHpjLbHTDPRnHDncVJFcybsX0
QRqnBmn0P2rKlbKvKyZFedM+cCcNGoCeoNBxWKjILEwWMH/3TGg=
=pL6H
-----END PGP SIGNATURE-----

--=-UAt7QqTyq0lm73lKYdDn--

