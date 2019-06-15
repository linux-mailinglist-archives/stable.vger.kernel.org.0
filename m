Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B9C4726E
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfFOWir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfFOWir (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 18:38:47 -0400
Received: from localhost (unknown [107.242.116.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F752073F;
        Sat, 15 Jun 2019 22:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560638326;
        bh=BUyUhZ4q1if9QMjFUVdtd/uzawhIDLu3vUCDGW+hGR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x7agobaf94z2juYUTQD4S2nA+EtWg6Pc8lQu6q/c9fQy/7yRX5jmOYNBWMfW5UNZM
         rpHBRCSMaJ/h9kVxMrAXh8hiRNb5AkSo9s744F0+vPXbnSX85m37VALB1DLQP/7Ufb
         rHcegzPEulk+26A+4T23psdzCCOiz3TRNLbnzF6M=
Date:   Sat, 15 Jun 2019 18:38:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] hugetlbfs: Use i_mmap_rwsem to fix page
 fault/truncate race
Message-ID: <20190615223843.GT1513@sasha-vm>
References: <20181203200850.6460-3-mike.kravetz@oracle.com>
 <20190614215632.BF5F721473@mail.kernel.org>
 <f8cea651-8052-4109-ea9b-dee3fbfc81d1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f8cea651-8052-4109-ea9b-dee3fbfc81d1@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 04:33:53PM -0700, Mike Kravetz wrote:
>On 6/14/19 2:56 PM, Sasha Levin wrote:
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: ebed4bfc8da8 [PATCH] hugetlb: fix absurd HugePages_Rsvd.
><snip>
>>
>> How should we proceed with this patch?
>>
>
>I hope you do nothing with this as the patch is not upstream.

We do not, it's just a way to get more responses before people moved on
to dealing with other work.

--
Thanks,
Sasha
