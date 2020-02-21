Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF5167EF2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 14:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgBUNqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 08:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgBUNqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 08:46:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D40208C4;
        Fri, 21 Feb 2020 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582292765;
        bh=mBsHTSw31L0TMb2yfrDynuDuS482C9HiTD/9hJCN4RU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gC+ilwwfB+TVg9PnDX3mEufg5OgILbWwqwtHVvXkPgiWonRQYib282g7WkjOfeSLM
         BSyiPdD3Scce6VZ1bMYZckuugPf2s+HIZkCMqKIOqfsD8yiV9KokPBk8+rxjuvGv3t
         Vy+8Ow1QRxMDe6pReskGbNxa+vtEWEDhKlLgjOls=
Date:   Fri, 21 Feb 2020 08:46:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patch "soc: fsl: qe: change return type of cpm_muram_alloc() to
 s32" has been added to the 5.5-stable tree
Message-ID: <20200221134604.GL1734@sasha-vm>
References: <20200221012743.D5A0E208E4@mail.kernel.org>
 <89ccc850-54af-aaec-4a9e-330dcb814ca7@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <89ccc850-54af-aaec-4a9e-330dcb814ca7@rasmusvillemoes.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 09:53:04AM +0100, Rasmus Villemoes wrote:
>On 21/02/2020 02.27, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     soc: fsl: qe: change return type of cpm_muram_alloc() to s32
>>
>> to the 5.5-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      soc-fsl-qe-change-return-type-of-cpm_muram_alloc-to-.patch
>> and it can be found in the queue-5.5 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Isn't that what I did when I replied to the AUTOSEL mail a week ago?
>
>https://lore.kernel.org/stable/a920b57f-ad9e-5c25-3981-0462febd952a@rasmusvillemoes.dk/
>
>The TL;DR is the last part of the middle paragraph "... I think they
>should not be added to any -stable kernel."

You did and I've missed your mail, sorry. I'll drop it now.

-- 
Thanks,
Sasha
