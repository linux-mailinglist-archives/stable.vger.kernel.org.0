Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD86DC94BE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfJBXQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 19:16:54 -0400
Received: from avon.wwwdotorg.org ([104.237.132.123]:44522 "EHLO
        avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbfJBXQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 19:16:54 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2019 19:16:54 EDT
Received: from [10.20.204.51] (unknown [216.228.112.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by avon.wwwdotorg.org (Postfix) with ESMTPSA id 809F71C00ED;
        Wed,  2 Oct 2019 17:07:56 -0600 (MDT)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.100.3 at avon.wwwdotorg.org
Subject: Re: [PATCH 1/4] clk: tegra: Enable fuse clock on Tegra124
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        stable@vger.kernel.org
References: <20191001211346.104400-1-swarren@wwwdotorg.org>
 <20191002224944.D324720659@mail.kernel.org>
From:   Stephen Warren <swarren@wwwdotorg.org>
Message-ID: <3d5aef63-1103-922f-7293-cf538d4d60cf@wwwdotorg.org>
Date:   Wed, 2 Oct 2019 17:07:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002224944.D324720659@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/2/19 4:49 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75, v4.14.146, v4.9.194, v4.4.194.
> 
> v5.3.1: Build OK!
> v5.2.17: Build OK!
> v4.19.75: Build OK!
> v4.14.146: Build OK!
> v4.9.194: Build OK!
> v4.4.194: Failed to apply! Possible dependencies:
>      8d99704fde54 ("clk: tegra: Format tables consistently")
>      c4947e364b50 ("clk: tegra: Fix 26 MHz oscillator frequency")

The conflict in 4.4 is trivial to resolve, so I can send an explicit 
backport for that kernel after it's accepted in mainline.

That said, there may be a v2 of this patch that's implemented 
differently, and that may not conflict; we'll see what happens.
