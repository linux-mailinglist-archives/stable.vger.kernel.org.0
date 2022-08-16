Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE694595BD6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiHPMi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiHPMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:38:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9C5EDF7;
        Tue, 16 Aug 2022 05:38:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 17so9114745pli.0;
        Tue, 16 Aug 2022 05:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=KyIawfeWtCWjFVR0/zyQY4FM/yjIIpkpCCdIx8dakdk=;
        b=IN7yT+IENiDj8CQ/pkDT/lrYusRzb2mwnhfGBClmw8VUeElB9fpRp2LHyLsM4P5744
         gM6tMqcog3NuChENSEKwQL8m65VHIkcMrBMZ4GWSVdr9mvv5kBDAHb/KfwKtIKXZF8Zw
         VdcXv7CBR3rtXCRccIvelb+R68ak5SGqnqB3PItyb/QQYwz5z9OBK5Zcrchna5r4p1DE
         YZ6x0loo2o/cka0J7eawkmRUbZ123BTeosLD/qDrQuAh5aMKj+alsfI0EpMTaBsxyXRd
         DraTIcc7sD65uqOmxVJfFvBX2I3rwRcc8EYpB/WXQPMMNPTbDBtpe0QrM+DpqctK5wxg
         Pv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=KyIawfeWtCWjFVR0/zyQY4FM/yjIIpkpCCdIx8dakdk=;
        b=CTWprlSmsRRJ81hfR+miBFGhPO5n2h8V8ldbtW0cm+W5ZCjesHFcauH84gMrikZypH
         axlUoVczguXOuvS/YRHq9p6Ark67we1l+NfgWlZZfwAl2kh6E9U1uiYF4EY3z8pEnYax
         BPeYel2XoYoD0KKg2pTeJiumkytiGsexdgXddE+Sl12HKhXSg9MSXIZvcrFyWP2ZDXrn
         /33q3DiHE83dKWDzRTEp1PhKDEb9VmrH2yjyviHq/Lp/1w1CJyhl/UZhngG8CZX7SzG5
         HieriHqzIX71yNb2tUaTNi/mv35hPchoO+jrGQKqMUFSk5lH8UXuLA73RDHPXkk/RD1i
         /0rw==
X-Gm-Message-State: ACgBeo1kLoDTMAa0e9pksEZjKlujc/cIjF4bHp5cNjNb6DwD9mFk0SGP
        ryU9pg+/9v7BtWOrmY+Wl14=
X-Google-Smtp-Source: AA6agR6MZVxLTWSrIx699h6LSoqS0z8rqe29ARhyaP0fKYBneQt1ceBt9feUKbv5rGd4h8vxAn88FQ==
X-Received: by 2002:a17:903:120d:b0:171:4fa0:7b4a with SMTP id l13-20020a170903120d00b001714fa07b4amr21184838plh.45.1660653505064;
        Tue, 16 Aug 2022 05:38:25 -0700 (PDT)
Received: from debian.me (subs10b-223-255-225-224.three.co.id. [223.255.225.224])
        by smtp.gmail.com with ESMTPSA id 202-20020a6214d3000000b00518285976cdsm8349667pfu.9.2022.08.16.05.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 05:38:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1EFA9103124; Tue, 16 Aug 2022 19:38:20 +0700 (WIB)
Date:   Tue, 16 Aug 2022 19:38:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: Big load on lkml created by -stable patchbombs was Re: [PATCH
 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <YvuPvHb7T6WYEQf/@debian.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ddTInXOxl7VxFpBB"
Content-Disposition: inline
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ddTInXOxl7VxFpBB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2022 at 01:56:14PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > > > This is the start of the stable review cycle for the 5.19.2 release.
> > > > There are 1157 patches in this series, all will be posted as a resp=
onse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > >=20
> > > Hi Greg,
> > >=20
> > > Perhaps its time that you just send a single email to LKML pointing w=
here to
> > > find the stable releases. These patch bombs are bringing vger down to=
 its
> > > knees, and causing delays in people's workflows. This doesn't just af=
fect
> > > LKML, but all other vger mailing lists. Probably because LKML has the=
 biggest
> > > subscriber base that patch bombs to it can slow everything else down.
> > >=20
> > > I sent 3 patches to the linux-trace-devel list almost 4 hours ago, an=
d they
> > > still haven't shown up. I was going to point people to it tonight but=
 it's now
> > > going to have to wait till tomorrow.
> >=20
> > Email is async, sometimes it takes longer than others to recieve
> > messages.
>=20
> Well, email is pretty fast most of the month.
>=20
> > My "patch bombs" get sent out slow to the mail servers, there is work to
> > fix up vger and move it over to the LF-managed infrastructure, perhaps
> > work with the vger admins to help that effort out?
>=20
> I'm pretty used to -stable patches going to l-k, so I got used to
> current workflow. OTOH ... -stable _is_ quite significant fraction of
> total lkml traffic, and I see how people may hate that.
>=20
> Is not it ultimately for vger admins to decide what kind of load they
> consider acceptable?
>=20
> Would it make sense to somehow batch the messages, or perhaps to
> modify patchbombing scripts to send patches "slowly" so that -stable
> does not DoS other lkml users?
>=20
> Actually, if the patch is same between multiple -stable releases
> (which is rather common case) sending it just once tagged with "this
> goes to 4.9, 4.14, 4.19 and 5.10" would both take less bandwidth and
> make review easier. (But I see it may not be that easy).
>=20

Hi Pavel,

I have to breakdown In-Reply-To chain.

I can't see the message you sent above on lore, so I had to "lei up"
in order to get it. On lore, the patch series thread [1] displayed
is until [1001/1157], and rest of the thread (including yours) is skipped.
Actually, I can see your message from search results [2].

I guess why more than a thousand of patches must be reviewed for this
stable review cycle is because many of them (which have stable list CCed)
are errorneously submitted and merged for 6.0 merge window, not as
stabilization fixes for 5.19. But I also wonder if any of these patches
are not actually qualified for stable (new drivers?).

[1]: https://lore.kernel.org/stable/20220815180439.416659447@linuxfoundatio=
n.org/T/#u
[2]: https://lore.kernel.org/stable/20220816115614.GB27428@duo.ucw.cz/

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--ddTInXOxl7VxFpBB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYvuPswAKCRD2uYlJVVFO
o+tQAQCkbjFkJzkL4kNynWznFOadIgus2/HuOELuSpoRaVvXTQEAn7R6WOpcOs73
EJqG4em/mjsNdkTEIwocebccyM9U7gE=
=pgX5
-----END PGP SIGNATURE-----

--ddTInXOxl7VxFpBB--
