Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D454078D8
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhIKOix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 10:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhIKOiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 10:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF02F6109F;
        Sat, 11 Sep 2021 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631371060;
        bh=84Cd2vOP9REiG2aS/zAnKdQoXRWMqJxSobDAiNggsa4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FQfw082n5Us1doOLjpG0rHeAEKLIqPk3d4fvgy2WHWY9ZYSQQLQ7fzCXkne1w4S3g
         1eEoosqFk/X4d2CnTUrDVv/X72rsRjI9gXVT5yuOJBU4U+Qj7yKBmXQZTW4v+tCFoQ
         tAzhV8Lj2aZqBtR1fN5x+IQxw7r6+LRJwhl4AzqxYgsuVsrwrFZWN60GzS/RnnlrGD
         pU7Q1jzmGXHlEy6AGDvnrApouBowtXmFi443HZmfYvu2gFNaBSdT7R5pNo4AcVfNK8
         ZR8nxx4UK0aG378EzKP4YwZ0gjGvg8Fq2jpoWeoJPRCApO5ojsgZ8phlQ9AI6IMP10
         /J6N+9BH63Dyw==
Date:   Sat, 11 Sep 2021 10:37:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 191/252] btrfs: reset this_bio_flag to avoid
 inheriting old flags
Message-ID: <YTy/MgvEZLaVC5Q3@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-191-sashal@kernel.org>
 <20210909115504.GA15306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210909115504.GA15306@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 01:55:04PM +0200, David Sterba wrote:
>On Thu, Sep 09, 2021 at 07:40:05AM -0400, Sasha Levin wrote:
>> From: Qu Wenruo <wqu@suse.com>
>>
>> [ Upstream commit 4c37a7938496756649096a7ec26320eb8b0d90fb ]
>
>Please drop this patch from stable queue, thanks.

I've dropped all the patches you've pointed out, thanks!

-- 
Thanks,
Sasha
