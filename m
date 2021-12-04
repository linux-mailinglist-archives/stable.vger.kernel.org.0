Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80814685CB
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 15:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhLDPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 10:00:55 -0500
Received: from mout.gmx.net ([212.227.15.19]:50665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhLDPAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Dec 2021 10:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638629837;
        bh=+S58f8eVPWQBogPxi9fZe55JnxEmNgBER82cHfGBLK4=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=RreADAhKH+4ljBQdbMTUygQqtLF7cDoYmaYfXAbee/qIiOJq0nkKD+LH7VLgd5mym
         xTDQu5oMEEmTtOzenCyOLqUj2BJ3S6P59XJ58OZfplUnoMnvyy0fIOrA5AifTRGT+5
         8EJIQ0BB0pAWsLc2eK+xwfzY9XTz6yHjggTm2FHg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.151.242]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MY6Cl-1n5TlJ3rBN-00YOH1; Sat, 04
 Dec 2021 15:57:16 +0100
Message-ID: <46b2abb0-ee45-88de-c920-eab37df813f2@gmx.de>
Date:   Sat, 4 Dec 2021 15:57:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH AUTOSEL 4.4 4/9] parisc: Provide an extru_safe() macro to
 extract unsigned bits
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
References: <20211130145402.947049-1-sashal@kernel.org>
 <20211130145402.947049-4-sashal@kernel.org>
 <20211204121553.GA14855@duo.ucw.cz>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20211204121553.GA14855@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pgqSzOhrAoInXu/Hj8Bft2T7pWMCSrMfzO9P7k+oG2ApFmdiv5m
 yAbewc/m5xV9HgIKm2jnXAXNSqVfaDG0bUL1IRVOBNI6lb+aYRjogtJFzBnmoRGY8v+a8sn
 ItMojriUglg4VsBEWuGqSOJH1uaBYSRU0GOI5dHy3L3YZiDzhGu1lcy6bsytzhQgryy3km8
 k91Wki05S+m9RUmTb9TtQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:25R0L5skEKM=:eTH0JGUo1lCGuXk/eWuvxa
 VynY/Q4yTr7+iCEwNpQxxrFq1kBkWKDER0u88J5DWTlwu+2KWyCmO8NHyb91SGU3IC5BAyLi9
 Eu+9+wipuSOAO7HqCIR5NNTVlY7zfybjgb3oG4LvAPJbyK3Bmdrc6Kzu/GepZ9YBYnTo5+bua
 8PDz0F6fKNEdbxvao9D5PHNaey1rA4jOVeSNROMccBqKrHpIIAFbl9VeRd/Y6/h0Tjqex7cDu
 bvUsLZjzmi6N95aGexxd6lU02Pz6I81Ue6huUPcThFjFRc9sfdQbnaFQGtAqscYwQSv4yNGmZ
 5qnzNO3tc0JqZPHQuduqk1LWQqb6YaHXUYkXfxVgUWO0q+uHdqwVEvyLF/2XMUWDBfGjjJCEQ
 lrC4K0Vvenrypygy7AUfS3is+j4bRwonFaH+xUnxHfL6MW2KekHF3Ubeujn/tEDwPsjiiGmMQ
 ZTiTsnmtUgUKX6abDkVdu9Ab8ThhZMf6Vv4DWLaFb/EFMZkm3QV9OcgQnFReCEac74zFCcWwn
 7W/9aXillR6l0AXsLuVKrQk8XH3kL70zLSSlEgLv1kJJvKhEeX2o3qeK/0Wqqxo1+0Yw6XahF
 AgTVZeirEgrEmsd2hVi7cfvW1iRJrtSSgrfenUTqklLoWQiI8WyjoSUPlhhmcP/aSv7tKzC8e
 TkDEnSDzD/eFCEYYZ45c0zthSacIbzRBmpeKyqM3qg6BPESdSDMC3sDyH7OcBpoaR+AdzxRnK
 n0qtRXw/WvIR/pVlj8ROBs3Ze3otGsgZ4we2BDE2xr0wuiNlzp/4ag9lc6tXiwcnXzofH/ybV
 d/pHCgMxYZ4D/kq0PDrjaIDx3b8qJvrtClQXAui/++U+nsY2X1Ib2DyomPGEiImdVFV76KUID
 fEM3vrEpP4ua1aRmpNZmSpzMvvpA5PbwFf2kU+zyoRgPnUclPFL6Hd9w+tKprglo9Uvkj6ehK
 pjG+KaX2dZxc+T5jNuzPYC7hPSDiQZBZjGPy1iPo0K7gA4vdegoBc4cHkFjPEzBw8BTRIYEfb
 Plvn0r0y2SVJTY9ORtQs6nXNK9hRapJ3Ef/iR6a0U5Agq0THZ/91ZyWutRNxb8hN64Mfu4Ej6
 qGgPPBle0D3wzA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/21 13:15, Pavel Machek wrote:
> Hi!
>
>> From: Helge Deller <deller@gmx.de>
>>
>> [ Upstream commit 169d1a4a2adb2c246396c56aa2f9eec3868546f1 ]
>>
>> The extru instruction leaves the most significant 32 bits of the
>> target register in an undefined state on PA 2.0 systems.
>> Provide a macro to safely use extru on 32- and 64-bit machines.
>
> As the macro is not used by subsequent 4.4 patches,

That's basically true, but in case we backport some patches later on,
it's handy if it's already in.

> I don't believe this is suitable for -stable.

Please note that I didn't added a backport-request in my original commit.
I'm fine with any decision if it's either dropped or kept.

Helge
