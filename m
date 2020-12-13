Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF15D2D8DC0
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 15:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395127AbgLMOGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 09:06:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395074AbgLMOGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Dec 2020 09:06:31 -0500
Date:   Sun, 13 Dec 2020 09:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607868350;
        bh=mcbojKX0rCRAglq8j0baJ+vgXce4rMTNLcaD/nWwNHs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rRFQLa9PCwMZs0lPKS99ktrsTgouLcbSl8Wem5V5bqvQpsD5VnSfXkjJkwDv6NpTP
         wYi8ROaa6VTvX1JMo/pD7EayF2ds/o4Bh2HD+DjRVHnRSTuWGz1+NY9VukNrnmOgBv
         zWlyg3DYQevPMBJ4qe9HX8IXTWiyLHK9C2CZ5CPIsSfXd+llpnf0rIXyXtJOMaLuJA
         FeEzDOO1d1pjE2yFrwqwrLLrNlh3LDvfPPRMltmi3ikLrvqqauzeiSmphedv+1IwEx
         uQYLBzXaoa0SF7zjUhhOfPMNx17/ZjnEUrvUhbTJWa+2k8Rp5NHeo4Zjgr/RJ5Dpcw
         3F+kzL1Linugg==
From:   Sasha Levin <sashal@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of
 incoming packet in storvsc_on_channel_callback()
Message-ID: <20201213140549.GP643756@sasha-vm>
References: <20201212160804.2334982-1-sashal@kernel.org>
 <20201212160804.2334982-15-sashal@kernel.org>
 <20201212180901.GA19225@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201212180901.GA19225@andrea>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 12, 2020 at 07:09:01PM +0100, Andrea Parri wrote:
>Hi Sasha,
>
>On Sat, Dec 12, 2020 at 11:07:56AM -0500, Sasha Levin wrote:
>> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
>>
>> [ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]
>
>FYI, we found that this commit introduced a regression and posted a
>revert:
>
>  https://lkml.kernel.org/r/20201211131404.21359-1-parri.andrea@gmail.com
>
>Same comment for the AUTOSEL 5.4, 4.19 and 4.14 you've just posted.

I'll drop those, thanks!

-- 
Thanks,
Sasha
