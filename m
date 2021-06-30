Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369E43B8254
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhF3Mpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhF3Mpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:45:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2738E61461;
        Wed, 30 Jun 2021 12:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625056998;
        bh=J0Gszs8pv1ZVL9B9l2TF6Y0s+M7aKB70DnAjQIctv0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nU2WTDr7v65lyactIc5lmNxQx01B4g2ebLDbUjUnj68SmArfYikVP++lDEzyQAvdp
         AflRvkxgCGGIIAxXEMn14rrnX09gOxRy49iF0PnJzz1Gh7SCWcqS9GBxEBgrNFbj2O
         cFeCmI6XY8U4CADW64ACd1GWYnkq3nVItsXkbC9695ADa0JBEFjPlLEB6y+WbG9CBj
         o5G/jYPbU9LeWIG0nUYa/Jwt62jZhR4MnfcKyaCxudo94lvBXpXT3I9QsRrp/CJwi+
         uhb5p49NHHLDKsoMPQp5BOr7MZzPhT5wHYPkFGVlKs/GxKpmE8fP3l+itrvTtLpbcR
         8/u6edBlrrVqQ==
Date:   Wed, 30 Jun 2021 08:43:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Fox Chen <foxhlchen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.12 000/110] 5.12.14-rc1 review
Message-ID: <YNxm5VZ1K/IIzVfu@sashalap>
References: <20210628141828.31757-1-sashal@kernel.org>
 <60da130e.1c69fb81.c638f.a74a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <60da130e.1c69fb81.c638f.a74a@mx.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 11:21:02AM -0700, Fox Chen wrote:
>On Mon, 28 Jun 2021 10:16:38 -0400, Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.12.14 release.
>> There are 110 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.13
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
>> and the diffstat can be found below.
>>
>> Thanks,
>> Sasha
>>
>
>5.12.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
>
>Tested-by: Fox Chen <foxhlchen@gmail.com>

Thanks for testing Fox!

-- 
Thanks,
Sasha
