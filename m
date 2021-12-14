Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859104745C5
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhLNPBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhLNPBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 10:01:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6675C061574;
        Tue, 14 Dec 2021 07:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684C261513;
        Tue, 14 Dec 2021 15:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766DC34605;
        Tue, 14 Dec 2021 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639494061;
        bh=yrXQAlCk2j9lnmaOpYkt74Q7zQs2pEWeL4OtOPNOxl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RaRZI9ssYQEByI9sdSeWCNAxmP3VU8Ao0VspLApjsET5MBByUZfpKAnfnPNTH4LIN
         aHzU/+7TTRFfTar9nSvHefP6I+43GCgY4GHeyOunWeZg9WXepfrywz8eMdaBtQZwAL
         3CBXC2ZJD1PcJXR1U9zQ6oRQ2nHOymmN4D31NTgo9ostvi6ZmKXFNnif7H6dyfd91Y
         Aa33bShC8BtqJW4UkYGqgV7lpeh8NuIfCyg8a9LeOYjyug23k89944IZKZrMd6M2ts
         H+iXZbA7UqnhbMORIKVeRk2UVd7xypYZhekFrjozoWSWtOPQZZ5m+Ugyw4el6XxjD6
         lSq+pZBe8krTw==
Date:   Tue, 14 Dec 2021 07:00:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20211214070059.1017e7e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <68145d95-1b6a-153e-42ba-43d18b705a70@canonical.com>
References: <20211213092939.074326017@linuxfoundation.org>
        <52a7fa5d-6fa0-a0df-2e88-bd4bf443a671@linaro.org>
        <68145d95-1b6a-153e-42ba-43d18b705a70@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Dec 2021 07:43:18 +0100 Krzysztof Kozlowski wrote:
> On 13/12/2021 19:17, Tadeusz Struk wrote:
> > On 12/13/21 01:29, Greg Kroah-Hartman wrote: =20
> >> This is the start of the stable review cycle for the 5.10.85 release.
> >> There are 132 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10=
.85-rc1.gz
> >> or in the git tree and branch at:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git linux-5.10.y
> >> and the diffstat can be found below. =20
> >=20
> > In this release cycle there were two similar nfc fixes:
> >=20
> > fd79a0cbf0b2 nfc: fix segfault in nfc_genl_dump_devices_done
> > 4cd8371a234d nfc: fix potential NULL pointer deref in nfc_genl_dump_ses=
_done
> >=20
> > The list here only includes the second one. The first is still missing.
> > The same applies to 5.15 =20
>=20
> With my review tag for this other fix I mentioned it needs Fixes and
> Cc-stable, but these were not added by Jakub when applying. It won't be
> picked up automatically by Greg.
>=20
> Jakub,
> What's weird, the cc-stable was also removed from my commit which is not
> good. Few other people add Fixes tag without Cc-stable when they want to
> annotate it should not go to stable. This one should go to stable, so it
> should have cc-stable (which I put there).

=F0=9F=98=B3 no idea what happened here, I remember adding the tags, sorry..
