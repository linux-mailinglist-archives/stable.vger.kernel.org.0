Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BCE105F04
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 04:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfKVD3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 22:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfKVD3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 22:29:21 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2614206CB;
        Fri, 22 Nov 2019 03:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574393360;
        bh=tuguamdkg+W41T8uuu4hkC6O1BUxUqTIXTvs3BXizwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQagMN7ilwhhxpb97RiwQGmyUqQtoUjzy4c3A9Qf+fmixWO85Gn26FGYlx55XE354
         KtV6pkyohDixOl0sg89s0ipDOM6ygCrR9mZslKXbnkaUMZQjfDMXVJAyyjp9jE6xjl
         jC02CtHCoBsi7xIejrUUBliF2fy9wuZ7MLVXtP+4=
Date:   Thu, 21 Nov 2019 22:29:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 014/115] ata: ahci_brcm: Match BCM63138
 compatible strings
Message-ID: <20191122032919.GL16867@sasha-vm>
References: <20191113015622.11592-1-sashal@kernel.org>
 <20191113015622.11592-14-sashal@kernel.org>
 <bcd8f736-34a7-b0bb-adc1-1f7a092fc1f5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bcd8f736-34a7-b0bb-adc1-1f7a092fc1f5@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 12:07:25PM -0800, Florian Fainelli wrote:
>On 11/12/19 5:54 PM, Sasha Levin wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>>
>> [ Upstream commit fb8506f15f2e394f5f648575cf48a26e8744390c ]
>>
>> Match the "brcm,bcm63138-ahci" compatible string in order to allow this
>> driver to probe on such platforms.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This is a feature and not really a bug fix, is someone specifically
>asking for this to be back ported? Also without the matching SATA PHY
>driver changes:
>
>7b69fa1c5c930886f8a916cc47096dd4044c007a ("phy: brcm-sata: Add BCM63138
>(DSL) PHY init sequence")
>
>this is pretty useless on its own. Same applies to all automatic
>selections, not just this kernel obviously.

Ah, I got it from a distro tree but I see the backported the driver too.
I'll drop it, thanks!

-- 
Thanks,
Sasha
