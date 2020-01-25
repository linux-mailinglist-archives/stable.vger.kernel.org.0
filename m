Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F841497F6
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 22:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAYVlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 16:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgAYVln (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 16:41:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1024820716;
        Sat, 25 Jan 2020 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579988503;
        bh=EkoP8mp3H+BuaFmFH9KUtUPs07vqCNs8nUzXWhJ/RHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fB4tHrRsWahRKd/nvTJ1BEt7XKx37Je0atpPqw5IvDLj/8ZIV8yuGAi78TtadRd0o
         lXwyikMCVkw8iavUfTkRwpVcQ50vnkb5zWxyiKElaiXX3K6XkkMk3KbF9vCChfRIB3
         mGPuRS9Kqx6R8hnDWcbPcNOFdIvEJfOOwNbd+YTg=
Date:   Sat, 25 Jan 2020 16:41:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V4] x86/Hyper-V: Balloon up according to request page
 number
Message-ID: <20200125214141.GK1706@sasha-vm>
References: <20200121034912.2725-1-Tianyu.Lan@microsoft.com>
 <MW2PR2101MB1052B2248B0F9B92F98A2201D70D0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052B2248B0F9B92F98A2201D70D0@MW2PR2101MB1052.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 04:36:26AM +0000, Michael Kelley wrote:
>From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Monday, January 20, 2020 7:49 PM
>>
>> Current code has assumption that balloon request memory size aligns
>> with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
>> balloon driver receives non-aligned balloon request, it produces warning
>> and balloon up more memory than requested in order to keep 2MB alignment.
>> Remove the warning and balloon up memory according to actual requested
>> memory size.
>>
>> Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory
>> block")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>

Queued up, thanks!

-- 
Thanks,
Sasha
