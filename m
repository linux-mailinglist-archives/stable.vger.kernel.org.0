Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DACA7E89
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 10:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfIDIzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 04:55:16 -0400
Received: from mail.netline.ch ([148.251.143.178]:50422 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDIzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 04:55:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id CC7A12A6042;
        Wed,  4 Sep 2019 10:55:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 0IACsxtVyKVm; Wed,  4 Sep 2019 10:55:12 +0200 (CEST)
Received: from thor (116.245.63.188.dynamic.wline.res.cust.swisscom.ch [188.63.245.116])
        by netline-mail3.netline.ch (Postfix) with ESMTPSA id D8D472A6016;
        Wed,  4 Sep 2019 10:55:11 +0200 (CEST)
Received: from localhost ([::1])
        by thor with esmtp (Exim 4.92.1)
        (envelope-from <michel@daenzer.net>)
        id 1i5R4I-0004yY-Dc; Wed, 04 Sep 2019 10:55:10 +0200
Subject: Re: [PATCH AUTOSEL 4.19 044/167] drm/amdgpu: validate user pitch
 alignment
To:     Daniel Vetter <daniel@ffwll.ch>, Sasha Levin <sashal@kernel.org>,
        Dave Airlie <airlied@linux.ie>
Cc:     Yu Zhao <yuzhao@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable <stable@vger.kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-44-sashal@kernel.org>
 <7957107d-634f-4771-327e-99fdd5e6474e@daenzer.net>
 <20190903170347.GA24357@kroah.com> <20190903200139.GJ5281@sasha-vm>
 <CAKMK7uFpBnkF4xABdkDMZ8TYhL4jg6ZuGyHGyVeBxc9rkyUtXQ@mail.gmail.com>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Openpgp: preference=signencrypt
Autocrypt: addr=michel@daenzer.net; prefer-encrypt=mutual; keydata=
 mQGiBDsehS8RBACbsIQEX31aYSIuEKxEnEX82ezMR8z3LG8ktv1KjyNErUX9Pt7AUC7W3W0b
 LUhu8Le8S2va6hi7GfSAifl0ih3k6Bv1Itzgnd+7ZmSrvCN8yGJaHNQfAevAuEboIb+MaVHo
 9EMJj4ikOcRZCmQWw7evu/D9uQdtkCnRY9iJiAGxbwCguBHtpoGMxDOINCr5UU6qt+m4O+UD
 /355ohBBzzyh49lTj0kTFKr0Ozd20G2FbcqHgfFL1dc1MPyigej2gLga2osu2QY0ObvAGkOu
 WBi3LTY8Zs8uqFGDC4ZAwMPoFy3yzu3ne6T7d/68rJil0QcdQjzzHi6ekqHuhst4a+/+D23h
 Za8MJBEcdOhRhsaDVGAJSFEQB1qLBACOs0xN+XblejO35gsDSVVk8s+FUUw3TSWJBfZa3Imp
 V2U2tBO4qck+wqbHNfdnU/crrsHahjzBjvk8Up7VoY8oT+z03sal2vXEonS279xN2B92Tttr
 AgwosujguFO/7tvzymWC76rDEwue8TsADE11ErjwaBTs8ZXfnN/uAANgPLQjTWljaGVsIERh
 ZW56ZXIgPG1pY2hlbEBkYWVuemVyLm5ldD6IXgQTEQIAHgUCQFXxJgIbAwYLCQgHAwIDFQID
 AxYCAQIeAQIXgAAKCRBaga+OatuyAIrPAJ9ykonXI3oQcX83N2qzCEStLNW47gCeLWm/QiPY
 jqtGUnnSbyuTQfIySkK5AQ0EOx6FRRAEAJZkcvklPwJCgNiw37p0GShKmFGGqf/a3xZZEpjI
 qNxzshFRFneZze4f5LhzbX1/vIm5+ZXsEWympJfZzyCmYPw86QcFxyZflkAxHx9LeD+89Elx
 bw6wT0CcLvSv8ROfU1m8YhGbV6g2zWyLD0/naQGVb8e4FhVKGNY2EEbHgFBrAAMGA/0VktFO
 CxFBdzLQ17RCTwCJ3xpyP4qsLJH0yCoA26rH2zE2RzByhrTFTYZzbFEid3ddGiHOBEL+bO+2
 GNtfiYKmbTkj1tMZJ8L6huKONaVrASFzLvZa2dlc2zja9ZSksKmge5BOTKWgbyepEc5qxSju
 YsYrX5xfLgTZC5abhhztpYhGBBgRAgAGBQI7HoVFAAoJEFqBr45q27IAlscAn2Ufk2d6/3p4
 Cuyz/NX7KpL2dQ8WAJ9UD5JEakhfofed8PSqOM7jOO3LCA==
Message-ID: <829c5912-cf80-81d0-7400-d01d286861fc@daenzer.net>
Date:   Wed, 4 Sep 2019 10:55:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uFpBnkF4xABdkDMZ8TYhL4jg6ZuGyHGyVeBxc9rkyUtXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-09-03 10:16 p.m., Daniel Vetter wrote:
> On Tue, Sep 3, 2019 at 10:01 PM Sasha Levin <sashal@kernel.org> wrote:
>> On Tue, Sep 03, 2019 at 07:03:47PM +0200, Greg KH wrote:
>>> On Tue, Sep 03, 2019 at 06:40:43PM +0200, Michel Dänzer wrote:
>>>> On 2019-09-03 6:23 p.m., Sasha Levin wrote:
>>>>> From: Yu Zhao <yuzhao@google.com>
>>>>>
>>>>> [ Upstream commit 89f23b6efef554766177bf51aa754bce14c3e7da ]
>>>>
>>>> Hold your horses!
>>>>
>>>> This commit and c4a32b266da7bb702e60381ca0c35eaddbc89a6c had to be
>>>> reverted, as they caused regressions. See commits
>>>> 25ec429e86bb790e40387a550f0501d0ac55a47c &
>>>> 92b0730eaf2d549fdfb10ecc8b71f34b9f472c12 .
>>>>
>>>>
>>>> This isn't bolstering confidence in how these patches are selected...
>>>
>>> The patch _itself_ said to be backported to the stable trees from 4.2
>>> and newer.  Why wouldn't we be confident in doing this?
>>>
>>> If the patch doesn't want to be backported, then do not add the cc:
>>> stable line to it...
>>
>> This patch was picked because it has a stable tag, which you presumably
>> saw as your Reviewed-by tag is in the patch. This is why it was
>> backported; it doesn't take AI to backport patches tagged for stable...

The patches did point to gaps in validation of ioctl parameters passed
in by userspace. Unfortunately, they turned out to be too strict,
causing valid parameters to spuriously fail. If that wasn't the case,
and the patches didn't have stable tags, maybe we'd be having a
discussion about why they didn't have the tags now...


>> The revert of this patch, however:
>>
>>  1. Didn't have a stable tag.

I guess it didn't occur to me that was necessary, as the patches got
reverted within days.


>>  2. Didn't have a "Fixes:" tag.
>>  3. Didn't have the usual "the reverts commit ..." string added by git
>>  when one does a revert.

I suspect that's because there were no stable commit hashes to
reference, see below.


>> Which is why we still kick patches for review, even though they had a
>> stable tag, just so people could take a look and confirm we're not
>> missing anything - like we did here.
>>
>> I'm not sure what you expected me to do differently here.

Yeah, sorry, I didn't realize it's tricky for scripts to recognize that
the patches have been reverted in this case.


> Yeah this looks like fail on the revert side, they need to reference
> the reverted commit somehow ...
> 
> Alex, why got this dropped? Is this more fallout from the back&forth
> shuffling you're doing between your internal branches behind the
> firewall, and the public history?

I do suspect that was at least a contributing factor.


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer
