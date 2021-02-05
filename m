Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9FD3101A1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 01:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhBEA2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 19:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231986AbhBEA2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 19:28:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E8D64D9D;
        Fri,  5 Feb 2021 00:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612484892;
        bh=VyPQeUP6hYEQR+ykMe5wt6/I1Xczuy8ZEfcC2XszI2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lMih/QbVj6JuByqgBKNSF+y9LTPwOy18eaxOHqcjaNB+DqV+IRr7K4FMpscWiRapY
         khlPoypqEi1tJqKPBYxAdU9DNJn21PSSW93C8dz6M0sLlE7/SNVFjVyTYILXaThDDY
         IEvuO1wu/S40zzf03IIw7dVI4svIf9+om0F+UbPIVkPJcxc5D62rLKukjIQjazugrp
         G16ca3YB9sq11Qty3WKg8PCtPXke4PBoBSXVAMoKmtxPkxRyQsVaWpk+JyjJdLVjhW
         zE8jRskpIsxv/I7uCMJgQ1EMoNXl/NpzoOx/5FsYYYpIKddYDvKDJzaarMmAr67Tti
         Kh/LlzPYD7NQQ==
Date:   Thu, 4 Feb 2021 19:28:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.4 03/26] dm integrity: select
 CRYPTO_SKCIPHER
Message-ID: <20210205002811.GV4035784@sasha-vm>
References: <20210120012704.770095-1-sashal@kernel.org>
 <20210120012704.770095-3-sashal@kernel.org>
 <YAfD81Jw/0NU0eWN@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YAfD81Jw/0NU0eWN@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 09:47:31PM -0800, Eric Biggers wrote:
>On Tue, Jan 19, 2021 at 08:26:40PM -0500, Sasha Levin wrote:
>> From: Anthony Iliopoulos <ailiop@suse.com>
>>
>> [ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]
>>
>> The integrity target relies on skcipher for encryption/decryption, but
>> certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
>> compilation errors due to unresolved symbols. Explicitly select
>> CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
>> on it.
>>
>> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/md/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index aa98953f4462e..7dd6e98257c72 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -565,6 +565,7 @@ config DM_INTEGRITY
>>  	select BLK_DEV_INTEGRITY
>>  	select DM_BUFIO
>>  	select CRYPTO
>> +	select CRYPTO_SKCIPHER
>>  	select ASYNC_XOR
>>  	---help---
>>  	  This device-mapper target emulates a block device that has
>
>CRYPTO_SKCIPHER doesn't exist in 5.4 and earlier because it was renamed from
>CRYPTO_BLKCIPHER in 5.5.  If this patch is really important enough to backport,
>CRYPTO_SKCIPHER will need to be changed to CRYPTO_BLKCIPHER.

I'll just drop it, thanks!

-- 
Thanks,
Sasha
