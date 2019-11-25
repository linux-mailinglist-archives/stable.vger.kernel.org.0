Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4B108F78
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfKYOBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbfKYOBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 09:01:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9082D20679;
        Mon, 25 Nov 2019 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574690482;
        bh=RKHkvJasBb9XZlFJJM88//Z1Z+h2at816g2Wx2thnNU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=MWOotXo1F/R2WSj5r8nX+ONxRG0aEigugR2ZzYON2qBwjIPkPxiquPymK1FDusmay
         xH5zPQBFjnqU7M+6zOLlCMZy7Pwb33qQ9YjPfaDI3fytPtzo/ipcGjTjIC9llPwo4L
         0eJc0Y/Oxt49SV4C4jvX4P4VUisv6EXWFaj7G+FY=
Date:   Mon, 25 Nov 2019 09:01:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 028/237] Btrfs: fix alignment in declaration
 and prototype of btrfs_get_extent
Message-ID: <20191125140121.GD5861@sasha-vm>
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-28-sashal@kernel.org>
 <20191118111143.GE3001@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191118111143.GE3001@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 12:11:43PM +0100, David Sterba wrote:
>On Sat, Nov 16, 2019 at 10:37:43AM -0500, Sasha Levin wrote:
>> From: Liu Bo <bo.liu@linux.alibaba.com>
>>
>> [ Upstream commit de2c6615dcddf2af868c5cbd1db2e9e73b4beb58 ]
>>
>> This fixes btrfs_get_extent to be consistent with our existing
>> declaration style.
>
>The patch is pure white space fix with no effects. I don't see that it
>would be needed for a followup patch. What was the reason to add it to
>autosel/stable ?

Oh I grabbed it as a dependency for a follow up patch which I ended up
dropping, and forgot this one in. I'll drop it as well, sorry for the
noise.

-- 
Thanks,
Sasha
