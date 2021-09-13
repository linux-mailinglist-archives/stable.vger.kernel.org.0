Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCBE409A77
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbhIMRQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232274AbhIMRQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 13:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22F661056;
        Mon, 13 Sep 2021 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631553291;
        bh=XQojvyEAY3TweqFlpwWf93IfNTBDHJrZ6nVC+mOHQ4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYUY9uk03eynP3EoWHZmKoUYfNna+6aGN0uB5dQvhb92oMW6Xty6pyLfD81/kfSKL
         Cf+p885cF9rmG0ytk68z8dbKCfab2fOjatXjkDt5vRC1jmuu9ZZqKMUH3/d6k9mueD
         RfD6Lsl5b5EtcaA+ciKsy5WAIbmAHv1+ASPl7OWduEHBuydvv7uiMvX5Ss1KcNhGh5
         DRllXAnn3KhIjvNGUjqMjYq5QPuZVyjz1Ec+/DrYix2U6lta4tjXRw5sXHvaGiCENP
         1WZRyxSYBb5ksHPoEiYiUfsgTjmvhrADuMMgw+92ZLUgiMxHoPsbh+u/64JJZwjk/j
         y4Fl/XPEKkXFQ==
Date:   Mon, 13 Sep 2021 13:14:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Dmitry Osipenko <digetx@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 133/252] spi: tegra20-slink: Improve runtime
 PM usage
Message-ID: <YT+HCdNjfQxQayYH@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-133-sashal@kernel.org>
 <20210909123751.GA5176@sirena.org.uk>
 <f75c5c9c-8430-f650-5d0a-3490ac6aa3de@gmail.com>
 <20210909130450.GB5176@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210909130450.GB5176@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 02:04:50PM +0100, Mark Brown wrote:
>On Thu, Sep 09, 2021 at 03:45:45PM +0300, Dmitry Osipenko wrote:
>> 09.09.2021 15:37, Mark Brown пишет:
>
>> > This feels new featureish to me - it'll give you runtime PM where
>> > previously there was none.
>
>> Apparently all patches which have a word 'fix' in commit message are
>> auto-selected. I agree that it's better not to port this patch.
>
>Yeah, it's a fairly common source of false positives :/

And some of that falls on me: if it's obvious that the "fix" isn't a
real fix, I won't take it. In cases like this it's not clear to me
whether it's purely a better behaviour, or whether the devices staying
on/off/etc causes an actual problem.

-- 
Thanks,
Sasha
