Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2086D6E9498
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 14:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjDTMhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 08:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjDTMhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 08:37:00 -0400
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E161A8
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 05:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K2TNg7Ts3/2obGqaOrQjihA/VI+n+dN68nA/TBtp00M=; b=Xo63V84ZRyv5nCcfz7RqkVL8MN
        vT8DOOmxAw0RE3zh+d70JfIQyVJdCqbvhwb21lulPztXGJ68H0Kt4EHWdBIBYNWZhWcFXjpxP6Vax
        iNaR4cW980AK1Fzq6He5v5Z+DzIplAUy0WsFzbh+3/sZf+9eH7FBByfusDCfQjM4o6WHEz/Cis947
        LIs1duBm2RiSD1SvJVRFkLtDUJ4Fordy3cWDd14qGEMhc3GYwMVMu7QQMtB/NhiGuhgcEZSWsDu60
        y/H1B+xHV2SG4j3BdONO05juweIh4StxesbJXI+gBRkzHpjzOaaoonBxJ+0crzBXWmLyL5s42QA2V
        nVDmp8dw==;
Received: from 201-92-79-199.dsl.telesp.net.br ([201.92.79.199] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1ppTWc-006pbs-TE; Thu, 20 Apr 2023 14:36:35 +0200
Message-ID: <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com>
Date:   Thu, 20 Apr 2023 09:36:28 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Content-Language: en-US
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
 <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/04/2023 17:04, Deucher, Alexander wrote:
> [...]
>> So, let me check if I understood properly: there are 2 trees (-fixes a=
nd -next),
>> and the problem is that their merge onto mainline happens apart and th=
ere
>> are kind of duplicate commits, that were first merged on -fixes, then =
"re-
>> merged" on -next, right?
>>
>=20
> Each subsystem works on new features, then when the merge window opens,=
 Linus pulls them into mainline.  At that point, mainline goes into RCs a=
nd then mainline is bug fixes only.  Meanwhile in parallel, each subsyste=
m is working on new feature development for the next merge window (subsys=
tem -next trees).  The trees tend to lag behind mainline a bit.  Most dev=
elopers focus on them in support of upcoming features.  They are usually =
also where bugs are fixed.  If a bug is fixed in the -next tree, what's t=
he best way to get it into mainline?  I guess ideally it would be fixed i=
n mainline and them mainline would be merged into everyone's -next branch=
, but that's not always practical.  Often times new features depend on bu=
g fixes and then you'd end up stalling new development waiting for a back=
 merge, or you'd have to rebase your -next branches regularly so that the=
y would shed any patches in mainline which is not great either.  We try a=
nd cherry-pick -x when we can to show the relationship.
>=20
>> Would be possible to clean the -next tree right before the merge, usin=
g
>> some script to find commits there that are going to be merged but are
>> already present? Then you'd have a -next-to-merge tree that is clean a=
nd
>> doesn't present dups, avoiding this.
>=20
> There's no real way to clean it without rewriting history.  You'd basic=
ally need to do regular backmerges and rebases of the -next trees.  Also =
then what do you do if you already have a feature in -next (say Dave or D=
aniel have already pulled in my latest amdgpu PR for -next) and you reali=
ze that one of those patches is an important bug fix for mainline?  If th=
e drm -next tree rebased then all of the other drm driver trees that feed=
 into it would need to rebase as well otherwise they'd have stale history=
=2E
>=20
> You also have the case of a fix in -next needing to land in mainline, b=
ut due to differences in the trees, it needs backporting to apply properl=
y.
>=20
>>
>> Disclaimer: I'm not a maintainer, maybe there are smart ways of doing =
that or
>> perhaps my suggestion is silly and unfeasible heh But seems likely tha=
t other
>> maintainers face this problem as well and came up with some solution -=

>> avoiding the dups would be a good thing, IMO, if possible.
>=20
>=20
> No worries.  I agree.  I haven't seen anything so far that really addre=
sses handles this effectively.
>=20
> Alex

Thanks a bunch Alex, I appreciate your time detailing the issue, which
seems...quite complex and annoying, indeed =3D{

What I'll do from now on is trying to check all hashes that match a
commit, so I can add more than one fixes tag if that makes sense. At
least, this way I can prevent missing fixes in stable like this patch heh=


@Greg, can you pick this one? Thanks!

Cheers,


Guilherme
