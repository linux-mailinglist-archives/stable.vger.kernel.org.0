Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1211664F4
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 18:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgBTReK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 12:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgBTReK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 12:34:10 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC29A24672;
        Thu, 20 Feb 2020 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582220050;
        bh=1c3CW2q7VFBSmddI0CyeRQXbfNNVbuUebZ1kdB+IYG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CydWACu04SQXPcrHxR+KvmwQ0aaAQSOBGIsqALec7Ck6fevMttxeVp1HTsMm90Ab3
         pQwnPu2gM0fkIhbcqlmlivf37fssrEpZPQ1uXsDwicidfDm0JZ7qma57JulqmeqNpX
         gMQhJKoXy1tju088vIzqmFkWIjqGDgsQ7P0jbFhQ=
Date:   Thu, 20 Feb 2020 12:34:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH AUTOSEL 5.5 389/542] clocksource/drivers/hyper-v: Reserve
 PAGE_SIZE space for tsc page
Message-ID: <20200220173408.GH1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-389-sashal@kernel.org>
 <MW2PR2101MB10526693E43DF07E03D5EB0FD7150@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10526693E43DF07E03D5EB0FD7150@MW2PR2101MB1052.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 04:11:03PM +0000, Michael Kelley wrote:
>This patch does not need to be backported to any stable releases.  It is prep work for guests on Hyper-V ARM64 when the guest page size is 16K or 64K, and that functionality isn't upstream yet.

Now dropped, thank you.

-- 
Thanks,
Sasha
