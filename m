Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792D736A98E
	for <lists+stable@lfdr.de>; Sun, 25 Apr 2021 23:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhDYVlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 17:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhDYVlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Apr 2021 17:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A926861166;
        Sun, 25 Apr 2021 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619386870;
        bh=4PTe0oxvrsHB0LuabnUuMahHLZLghnyLpqYj3yeQbTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWtaTijmn7bHLHo7sMaAjpDcYB1P8MEGZGswFyBk1Gj7VdqrWzqQlO1HmyoL1TzAn
         rDzrTtFGFTj/LabEWPfC2/kEl3vTygNTQIcNEbrlM0SvFbaA66y6KrmBsbuAfpRb2k
         6LhI1H2Kj9mbC8HI6crlvZzX1dm26E+wwpoRO1+hXuWtZ/oIPdrWUd6xCEddMuKuoY
         OQV7gjsYR0P7vKCfLBvZ9LEGNM5CMGO2dHffbRjgdXSoqyx3WYkS9BgbG7OHOJ5URD
         8fWbRId1eByqCKCUk4ZMs5T2OsKCic60K8vs03/M6jxSrofhgXIt0YIWiTRfWjI7MA
         70xKFLiTJ+tmA==
Date:   Sun, 25 Apr 2021 17:41:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 17/23] i2c: mv64xxx: Fix random system lock
 caused by runtime PM
Message-ID: <YIXh9dX7QhlV+flN@sashalap>
References: <20210419204343.6134-1-sashal@kernel.org>
 <20210419204343.6134-17-sashal@kernel.org>
 <20210420083050.09375c3b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210420083050.09375c3b@thinkpad>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 08:30:50AM +0200, Marek Behún wrote:
>On Mon, 19 Apr 2021 16:43:36 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> This first appeared with commit e5c02cf54154 ("i2c: mv64xxx: Add runtime
>> PM support").
>
>I forgot to add Fixes: tag to this commit. But the bug first appeared with
>commit
>  e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support")
>which is in 5.12, but not 5.11 or any others.
>
>So this fix is not needed for the stable releases (althogh it does not
>break anything on those...).

I'll drop it, thanks!

-- 
Thanks,
Sasha
