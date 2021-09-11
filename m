Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111784078E1
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhIKOkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 10:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhIKOkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 10:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FFC060FDC;
        Sat, 11 Sep 2021 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631371131;
        bh=dZn8CBZ/jljIR+TuDA0kiSG744zlOMHtWHIQraxsDD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fpxLV+hHMXz5YzPgeBEwWsznYK7N5Cieg2xLkC92YCT0LbvO3loFw9w1b1o/dxfsK
         JcXOuwClCCcNOeOOjpdJ+jPlUFLVlVgek026VH4xpaqq9GiczmF+MJ+eBcecYY+RB5
         uVZAtL/9wz+4aT7coK3wSVkgffPGs5/NeKNKY4L+7bRffQvp96MbYl6mzvq2bMWGGK
         J+Ag5EZnVpL63iQQSb+WkufgBzbyFhS66Y6KMcyOkwhCV1AvB+W4MZC1c1KXLmWNYv
         9yPvy40eo6JVJxjcgZgXcc3bume9tN13HDoWWSLX7GaQBcM09s9LT2CSKzfSaYWbOU
         jeIN2ZpZ4DrYg==
Date:   Sat, 11 Sep 2021 10:38:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: Re: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with
 no command-line arguments
Message-ID: <YTy/etsK39d/+Zhh@sashalap>
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-24-sashal@kernel.org>
 <20210910074535.GA454@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210910074535.GA454@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 09:45:36AM +0200, Pavel Machek wrote:
>Hi!
>
>> Handle the case where the Command-line Arguments table field
>> does not exist.
>>
>> ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6
>
>I'm not sure what is going on here, but adding unused definition will
>not make any difference for 4.4 users, so we don't need this in
>-stable...?

Ugh, dropped, thanks!

I wonder what this patch actually does upstream.

-- 
Thanks,
Sasha
