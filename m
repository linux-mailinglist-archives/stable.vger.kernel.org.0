Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E579C35F359
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 14:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhDNMTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 08:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhDNMTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 08:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DCD6105A;
        Wed, 14 Apr 2021 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618402727;
        bh=eD0xtv2Qct3Qft0jHNeqH2HMiN+vpGVI4dS5xaCtmJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=odqJowLsilyCEA39GUZp924v/jE2KuUF0Ekv2Uwc6CudOjn22I+bM42/rpwrurfUF
         EMdAQC+TeLed/J8HJ3f78KxhgCQzFjUYpxPRQiYVeJM057hTtZXcOZ4jYuNchPavRS
         6x4Cbe4LTnGexIT8Cl1QF8dZK1r17gSBmWPDm/2sXoE9qwwGnwpyrLi6OMn1xT8pRx
         np/8b/76Ceoo24wt+pAS98s2U2L7+Hup/kiJu27N/URydsZZOxWqmJHtKckOh1Ldvj
         71jqQhdhLJ/T80bqhEmmnf551DZRoLk+Ese9aosgA4U6/DWJtYPZByOEbYAqB9HiT4
         CPE++snminrtQ==
Date:   Wed, 14 Apr 2021 08:18:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 6/8] radix tree test suite: Fix compilation
Message-ID: <YHbdpo3dP1INDp0z@sashalap>
References: <20210405160515.269020-1-sashal@kernel.org>
 <20210405160515.269020-6-sashal@kernel.org>
 <20210405181109.GH2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210405181109.GH2531743@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 07:11:09PM +0100, Matthew Wilcox wrote:
>On Mon, Apr 05, 2021 at 12:05:13PM -0400, Sasha Levin wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> [ Upstream commit dd841a749d1ded8e2e5facc4242ee0b6779fc0cb ]
>>
>> Introducing local_lock broke compilation; fix it all up.
>
>I don't think local_lock has been backported to 4.19?

Heh, right, I'll drop it from 5.4 and older.

-- 
Thanks,
Sasha
