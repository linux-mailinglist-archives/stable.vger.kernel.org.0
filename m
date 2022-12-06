Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E173643AF8
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 02:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiLFBwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 20:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiLFBwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 20:52:40 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823FDCC0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 17:52:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b11so13005765pjp.2
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 17:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20210112.gappssmtp.com; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9wq3sEslTe2wjtzi0HVrmtWkh3tKeKcL922j6vnHc3I=;
        b=bn7WmcYFiVr1ZBHM12wr1+B13mUX6nYBO+r4drQeTeRvNkzLPDYVxAOOkTRFm/IPZZ
         d5obdZGAao678P94FkTJehIindN9Va1j0H6lxnwNHRcc0h/nUCRWhFaI2QinVylXZD1y
         0/FDX+QRcDKC8NvYUgtSnu30AZz3YDL8onyR4hZwJoqzKe4FkUwxRsZcSs3nj16fqQWn
         E28GLxsh/mhfFDDYHakqJvbDukvTGnosjnhFKyKv9Nxf64qczEGbkZ/rmkSXQHmSADuZ
         eZvbyPgekU+eInYgrr79Lklsko9rZDT9oizymet1s29bZAgSytuRHjrDuNvvqZ84GhSS
         MSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wq3sEslTe2wjtzi0HVrmtWkh3tKeKcL922j6vnHc3I=;
        b=IFiKEq7Q4l5zOaW40L0wwbuwCQXVyj+ZkkWbIq/LiP3Vanzn6k86rx6P4yU+NkP0RG
         A0ntRvfqJ/ZJfy8av1ZW2T35VGxSoyh0LZorgmmt2pb22ejGxzXPX8dx8m+rpQCJjsMW
         ynsZVqQqJ/uNs7HjIJRY0V4vvkReGEKZ+QM+bu7l/g0nETd3JAMQLFH4lRPBB+9/T5tD
         IXm1T5VvvNBaqQGO4TsJRjGfokH6WrSDKPRR+OsqzbF9Ks5tSCvK6k56OuBGD1qha/kw
         xa+6pLkvW1s/EBeAD/2JDC8mh0BZ84zX+r0VffEBJjPy+SBl91hPW5Ni7ymUAKRBK+0c
         A+Gw==
X-Gm-Message-State: ANoB5pkK/fryTIE5TyNL/0g1H0NpToqj+h8YvmTBd+4r/sjVjS/9sUk/
        jm/VWkumotCuvbics7fOlb0QtQ==
X-Google-Smtp-Source: AA0mqf6f9RKrNngUJ22MXDTYAzo0a6epnkQqeqO7OciRjYG80O8Ntb5ScXEB8e7y6XGrQ4dZ8yk2fA==
X-Received: by 2002:a17:90a:ae16:b0:218:fada:57fd with SMTP id t22-20020a17090aae1600b00218fada57fdmr57504410pjq.12.1670291557935;
        Mon, 05 Dec 2022 17:52:37 -0800 (PST)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79492000000b00575b6f8b84esm1761375pfk.26.2022.12.05.17.52.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Dec 2022 17:52:36 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <96677D90-C895-4356-83A9-A116A91F199A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_ABE18D77-661A-4EE8-9B60-6ACD02A2D6FD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Date:   Mon, 5 Dec 2022 18:52:34 -0700
In-Reply-To: <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
X-Mailer: Apple Mail (2.3273)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_ABE18D77-661A-4EE8-9B60-6ACD02A2D6FD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Wed, Nov 23, 2022 at 08:39:50PM +0100, Jan Kara wrote:
> When manipulating xattr blocks, we can deadlock infinitely looping
> inside ext4_xattr_block_set() where we constantly keep finding xattr
> block for reuse in mbcache but we are unable to reuse it because its
> reference count is too big. This happens because cache entry for the
> xattr block is marked as reusable (e_reusable set) although its
> reference count is too big. When this inconsistency happens, this
> inconsistent state is kept indefinitely and so ext4_xattr_block_set()
> keeps retrying indefinitely.
>=20
> The inconsistent state is caused by non-atomic update of e_reusable =
bit.
> e_reusable is part of a bitfield and e_reusable update can race with
> update of e_referenced bit in the same bitfield resulting in loss of =
one
> of the updates. Fix the problem by using atomic bitops instead.
>=20
> CC: stable@vger.kernel.org
> Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> Reported-and-tested-by: Jeremi Piotrowski =
<jpiotrowski@linux.microsoft.com>
> Reported-by: Thilo Fromm <t-lo@linux.microsoft.com>
> Link: =
https://lore.kernel.org/r/c77bf00f-4618-7149-56f1-b8d1664b9d07@linux.micro=
soft.com/
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas






--Apple-Mail=_ABE18D77-661A-4EE8-9B60-6ACD02A2D6FD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmOOoGIACgkQcqXauRfM
H+Aqnw//QBW7/HVTLpxi1sTTLZZ552mZq2fqt7p+ukXFA6wyH7cRtVT3Vamqc2T7
uGAa3OOXt/WDmuHsLdHXzCqPwOF+vp2wAz4CAV7Ki1tbSPazgImVo1uCwAgZiCvw
IKbwB4ERb4XdxRwyjDr3Fo2VX3m1poju1ex9jqA7MUn+dWlfjfAn95Tz+E1CuXEQ
7o5E4q74ea3szh6u8tIa7J6Cq6uEqb+kth1/1Y+CBFJF1nCHB43KFEkETeLWVuG0
klIEXyhaRXGxOfZ3CM5cHbdNwk8qMYKxCgQr9CeAAeB3VR2fJcR7cdfyiggdAL7r
CGtIRor2N6ZPegDV2CH+BgZaWf+v6onquHoB9/ntmeXq6dh27UaMVh7KGpeaKob4
U4gdkyedifGHue1tL8QpqZuQzHnUu601450lMeCMhu4OC+p4LgE5Dh1tLDzdDu/z
5lk1AyBfr251ss/ljoAicOmE4WJaPSSmEshm8TN0mOzxbg/9T5zyXIuKGFwvK3Xq
8AOpX5epq8wU+uFts1xPwNP8wU8ASnAvA6xbWERt+ac3qqAOSQC21XfXZ0PuVXS9
pDUgDlQqIQnCp9d+YCiO5w+MNqp6DK0t56aXYtOtwFNa460PhozbDkIWoRrhCLKI
992VVzuB2x4LXNxhGpyqW5MmJxOU6LD6WUpf/XtlbfQZEGUa0DE=
=X8gG
-----END PGP SIGNATURE-----

--Apple-Mail=_ABE18D77-661A-4EE8-9B60-6ACD02A2D6FD--
