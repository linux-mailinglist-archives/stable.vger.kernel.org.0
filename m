Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60FD44F1
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfJKQF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 12:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfJKQF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 12:05:29 -0400
Received: from localhost (unknown [131.107.147.255])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29843206CD;
        Fri, 11 Oct 2019 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570809929;
        bh=VLCpLlsGJdIt9QQjzE4HufyIf5Lzrt0iRXPBoqHHuf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=laY7xpyZCQaV4aQz6mpW5LvNJojBdkwFJJ2pflkPf2h8HYyJ1DP2fcoFxK4Yw14Qc
         vA5kT9GHWbib1sDQcF4TQEXMdhWJYuZ4fS59P2/QMNyxt8+c5mqP7Y9T90Uz/HBRo3
         fy1ljQY0YoHtPyxGsocmXM19P2wZKFPjUsGvZML4=
Date:   Fri, 11 Oct 2019 12:05:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 082/114] powerpc/book3s64/radix: Rename
 CPU_FTR_P9_TLBIE_BUG feature flag
Message-ID: <20191011160528.GD2635@sasha-vm>
References: <20191010083544.711104709@linuxfoundation.org>
 <20191010083612.352065837@linuxfoundation.org>
 <20191011112106.GA28994@amd>
 <20191011125838.GA1147624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191011125838.GA1147624@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 02:58:38PM +0200, Greg Kroah-Hartman wrote:
>On Fri, Oct 11, 2019 at 01:21:06PM +0200, Pavel Machek wrote:
>> Hi!
>>
>> > From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> >
>> > Rename the #define to indicate this is related to store vs tlbie
>> > ordering issue. In the next patch, we will be adding another feature
>> > flag that is used to handles ERAT flush vs tlbie ordering issue.
>> >
>> > Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
>> > Cc: stable@vger.kernel.org # v4.16+
>> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> > Link:
>> > https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com
>>
>> Apparently this is upstream commit
>> 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 , but the changelog does not
>> say so.
>
>Yeah, somehow when Sasha backported this, he didn't add that :(
>
>Nor did he add his signed-off-by :(
>
>I'll go fix it up and add mine, thanks for noticing it.

I forgot to run my "prettyfying" script on it, sorry and thanks for
catching it.

-- 
Thanks,
Sasha
