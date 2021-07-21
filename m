Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797683D1047
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGUNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 09:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232706AbhGUNNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 09:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFC36121E;
        Wed, 21 Jul 2021 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626875663;
        bh=pI4XkDwOJwLyMALjTS8Fb3LlbMQYJsr0MdDlZIjZ84w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jnBgTMCT14Na17njkrbbizVHmkCxYwAkrFqi0OwXag7GJ3BLOGPs7LM585HAvMMJU
         gdfgwFg7w+lwSXcw6k3CpzGMFOCLj3SEIWmZHcknpURmYyRYpQkZvbaAPRn+2+bn+h
         az5ADeo9oa7M1WMvM5UMFmOxY0OiSPDtI2owNpH0oFmw8FZCncqEl/9ApPgt9E8/+d
         OQoQQ8QTEHvhQrTs/d5xexPRE6KV6aoZARtEb4s1htUCqSDITHbXQqrmFyxTGcX7Qz
         h3NRK48sXkGYWRovOtcR30+sXuG4ActhdzlXuwEtcCU1HqPy97C5h97QOSx98jJvZn
         egUcyjWEHo13Q==
Date:   Wed, 21 Jul 2021 09:54:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Backporting armada-3700-rwtm-firmware DTS changes to stable
 kernel
Message-ID: <YPgnDbYZ5ynFLLxD@sashalap>
References: <20210720222559.k4zoqr2rk62pj7ky@pali>
 <YPdWVTB0tWvsgKR3@sashalap>
 <20210721132156.qsgodbs53glltijh@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210721132156.qsgodbs53glltijh@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 03:21:56PM +0200, Pali Rohár wrote:
>On Tuesday 20 July 2021 19:03:49 Sasha Levin wrote:
>> On Wed, Jul 21, 2021 at 12:25:59AM +0200, Pali Rohár wrote:
>> > Hello Greg & Sasha, I would like to ask you for your opinion about
>> > backporting DTS patches to stable kernel which allows usage of hwrng on
>> > Marvell Armada 3700 devices.
>> >
>> > Driver is already part of 5.4 kernel, just DTS bindings are not there.
>> > I do not know if such backport is suitable for stable kernels. In file
>> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> > is written that "New device IDs and quirks are also accepted" where
>> > "device id" could mean also small DTS change...
>>
>> We could, that's how I've been parsing that rule.
>>
>> > What do you think? Question is about these 3 small commits:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90ae47215de3fec862aeb1a0f0e28bb505ab1351
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d2f6d0c99f7f95600e633c7dc727745faaf95e
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a52a48973b355b3aac5add92ef50650ae37c2bd
>>
>> If it was actually tested on 5.4, I could queue it up for the next
>> release cycle.
>
>Hello Sasha! Now I tested these patches on top of stable 5.4 and hwrng
>is working fine.

Thanks for testing. Queued up...

-- 
Thanks,
Sasha
