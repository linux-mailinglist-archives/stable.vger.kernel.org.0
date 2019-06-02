Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2732380
	for <lists+stable@lfdr.de>; Sun,  2 Jun 2019 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFBOLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jun 2019 10:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfFBOLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Jun 2019 10:11:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB5827939;
        Sun,  2 Jun 2019 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559484697;
        bh=XWIQtRm3YBgJzMgx47r1GeU6a0hziX3Bayzxz7HYHDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2C6Lsyqjl1lq8cMl5HmJSDmhu68WMgHeXo8d7wvsyLcWYJhTi3LKPzGrDF2N57jni
         RNWBGChMzbkjHSvYFxIzqNjCcgNBi4laBkGooBA61hNXEU13ngYQSa7o5xsteZNDwV
         8n+4BWuAsTcEVS99GcQHNLzJgFGdsGYaHTIessyE=
Date:   Sun, 2 Jun 2019 10:11:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kangjie Lu <kjlu@umn.edu>, Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Rob Herring <robh@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.4 44/56] video: imsttfb: fix potential NULL
 pointer dereferences
Message-ID: <20190602141135.GP12898@sasha-vm>
References: <20190601132600.27427-1-sashal@kernel.org>
 <20190601132600.27427-44-sashal@kernel.org>
 <20190601161929.GA5028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190601161929.GA5028@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 01, 2019 at 09:19:29AM -0700, Greg Kroah-Hartman wrote:
>On Sat, Jun 01, 2019 at 09:25:48AM -0400, Sasha Levin wrote:
>> From: Kangjie Lu <kjlu@umn.edu>
>>
>> [ Upstream commit 1d84353d205a953e2381044953b7fa31c8c9702d ]
>>
>> In case ioremap fails, the fix releases resources and returns
>> -ENOMEM to avoid NULL pointer dereferences.
>>
>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>> Cc: Aditya Pakki <pakki001@umn.edu>
>> Cc: Finn Thain <fthain@telegraphics.com.au>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> [b.zolnierkie: minor patch summary fixup]
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/video/fbdev/imsttfb.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>
>Why only 4.4.y?  Shouldn't this be queued up for everything or none?

It's on all branches. Something weird happened with git-send-email and
mail.kernel.org, and apparently the rest of the branches didn't get all
their mails sent out. Sadly I don't have the logs for that :(

--
Thanks,
Sasha
