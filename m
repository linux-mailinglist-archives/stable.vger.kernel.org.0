Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC72C6B6E06
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 04:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCMDhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 23:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCMDha (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 23:37:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72D83251D;
        Sun, 12 Mar 2023 20:37:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so742716pjz.1;
        Sun, 12 Mar 2023 20:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678678648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L22ciYcMAM0TfCyF/RDJtXAokA1sx5bIVKoVAkAry24=;
        b=KvIBiIJUEkq1BrtWHSTFc6//ia6m1foSfQJfyn4wy19SjN1qtoRK9Y1aWD1AxSEc5c
         DHXHfNix/G7SmQ8FZ3mqloLKMjFn9RWdQPnuMwsWbIXion/XwVMc8XZ4fi44tM276KrT
         ijMeRkTeb/+xQ0CGKct33k0X69VJBaZybrEN9c/ANMX6JpTHpxg8oSuTw7/IP1gfV/pr
         ss8wL0OM+uvJmnzoflKu7fD3IOJrc8V4UyILUr3C2WufdWTEGf4MlefMB1ZD9lCpT0+F
         vDQd3Ru74nRJBoyfkmBDVCBPnqPva+AKYkzmmHA6b1tBdJ/phwUVLMFGR+PrSehZBYzP
         vMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L22ciYcMAM0TfCyF/RDJtXAokA1sx5bIVKoVAkAry24=;
        b=0EOQuvkoLgDSZuC45hUtmj5SQICElDY+zgHPP0Z/8IBh1yVOoLI2Vwq7t4BDMj8MVS
         dUDy8+Ritn7DKCMZoylozCJ8xdMdef9tbPDGh+peZVNGRJdAFlKLfYZnUiU7LAmpChGp
         sz0jpl4KefMfCpmt+c8kPeMHtx8MlNPDd1bYJv0Ei2ZONMedy4jBYvgijORTJSVKqDUU
         5ioAk2EKHt/9P/rpDQk5V3fppbOyr6zgsgJTP//23iAyBywmRxutxMscp9l1ezCvcY6e
         egXsARSixMPO20HrwRfuygN+N38rM1C1kFoY+Moh1/F9R4kRltcKreFextl5fQ5AE6Qb
         r18g==
X-Gm-Message-State: AO0yUKWCXFXfcBdlkBgRBUWrDai/UaJ2fi6pX86Mb5iT5RfrbcRZXMlL
        GN0HQAOLKL20rb+Q8gK3QbMGswKcILs=
X-Google-Smtp-Source: AK7set9LPo0sfCpXv48t+q0A6LHsSOgSN6iGGdijcWdrX1+rp3VRTKC981HNXXD1PmIdac6J+LPYHA==
X-Received: by 2002:a05:6a20:2a19:b0:d3:e4d8:a684 with SMTP id e25-20020a056a202a1900b000d3e4d8a684mr3168471pzh.7.1678678648217;
        Sun, 12 Mar 2023 20:37:28 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-80.three.co.id. [180.214.233.80])
        by smtp.gmail.com with ESMTPSA id s199-20020a632cd0000000b00502e48db9aesm3364276pgs.53.2023.03.12.20.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 20:37:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 30A511066BC; Mon, 13 Mar 2023 10:37:24 +0700 (WIB)
Date:   Mon, 13 Mar 2023 10:37:23 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        John Harrison <John.C.Harrison@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: AUTOSEL process
Message-ID: <ZA6acxOlHCq/7IIj@debian.me>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Xq7BdBhmWpe22fxp"
Content-Disposition: inline
In-Reply-To: <Y/zswi91axMN8OsA@sol.localdomain>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Xq7BdBhmWpe22fxp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 27, 2023 at 09:47:46AM -0800, Eric Biggers wrote:
>
> > One of the challanges here is that it's difficult to solicit reviews or
> > really any interaction from authors after a commit lands upstream. Look
> > at the response rates to Greg's "FAILED" emails that ask authors to
> > provide backports to commits they tagged for stable.
>=20
> Well, it doesn't help that most of the stable emails aren't sent to the
> subsystem's mailing list, but instead just to the individual people menti=
oned in
> the commit.  So many people who would like to help never know about it.

Let me joining in the discussion.

In this case, Greg send these FAILED emails to upstream commit authors,
but some of them have expectation that their commits can be backported
automatically (without conflicts), so when Greg ask them to "manually"
do the backport (and with resolving conflicts between), they have
little to no idea on what should they do. That's why there was a doc
patch sent [1] specifically on this matter. Fortunately, some others
are aware on this and send the backport.

> I don't know, is it obvious?  You've said in the past that sometimes you'=
d like
> to backport a commit even if the maintainer objects and/or it is known bu=
ggy.
> https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailb=
ox.org
> also didn't explicitly say "Don't backport this" but instead "This patch =
has
> issues", so maybe that made a difference?
>=20
> Anyway, the fact is that it happened.  And if it happened in the one bug =
that I
> happened to look at because it personally affected me and I spent hours
> bisecting, it probably is happening in lots of other cases too.  So it se=
ems the
> process is not working...
>=20
> Separately from responses to the AUTOSEL email, it also seems that you ar=
en't
> checking for any reported regressions or pending fixes for a commit before
> backporting it.  Simply searching lore for the commit title
> https://lore.kernel.org/all/?q=3D%22drm%2Famdgpu%3A+use+dirty+framebuffer=
+helper%22
> would have turned up the bug report
> https://lore.kernel.org/dri-devel/20220918120926.10322-1-user@am64/ that
> bisected a regression to that commit, as well as a patch that Fixes that =
commit:
> https://lore.kernel.org/all/20220920130832.2214101-1-alexander.deucher@am=
d.com/
> Both of these existed before you even sent the AUTOSEL email!
>=20
> So to summarize, that buggy commit was backported even though:
>=20
>   * There were no indications that it was a bug fix (and thus potentially
>     suitable for stable) in the first place.
>   * On the AUTOSEL thread, someone told you the commit is broken.
>   * There was already a thread that reported a regression caused by the c=
ommit.
>     Easily findable via lore search.
>   * There was also already a pending patch that Fixes the commit.  Again =
easily
>     findable via lore search.

Recently there was a regression in linux-5.15.y that was caused by faulty
backport of upstream 85636167e3206c ("drm/i915: Don't use BAR mappings for =
ring
buffers with LLC") as 4eb6789f9177a5 ("drm/i915: Don't use BAR mappings for
ring buffers with LLC"). Fortunately, the upstream commit wasn't AUTOSEL'd =
by
Sasha's scripts and the culprit backport got reverted.

[CC'ed the upstream commit author and corresponding ML.]

>=20
> So it seems a *lot* of things went wrong, no?  Why?  If so many things ca=
n go
> wrong, it's not just a "mistake" but rather the process is the problem...

Testing the backports are also important, hence before a stable release is
made, there is -rc review when testers can test linux-x.y trees as
published in linux-stable-rc.git tree. The testing quality depends
on how many testers test and send their report, as well as the type of
test. For example, I do basic cross-compile test for arm64 and ppc64.

Did they spot the regression I mentioned earlier? Nope, until after the
release, where production users reported the regression. If they do, they
would have replied to appropriate backported patch that caused the
problem.

Thanks.

[1]: https://lore.kernel.org/linux-doc/20230303162553.17212-1-vegard.nossum=
@oracle.com/

--=20
An old man doll... just what I always wanted! - Clara

--Xq7BdBhmWpe22fxp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZA6aZgAKCRD2uYlJVVFO
o2xQAP96ak8HVvGHnRi6a/Kpxdk40Zt45FH1TCXgiO2ZLvSYBwD/dMRpEA4jdsaB
3/5+NS0INOpYiRnI1j1jB5Ni1p9wMgM=
=47A2
-----END PGP SIGNATURE-----

--Xq7BdBhmWpe22fxp--
