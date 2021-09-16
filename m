Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF26940D0F7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 02:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhIPAhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 20:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233237AbhIPAhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 20:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05CBC610A6;
        Thu, 16 Sep 2021 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631752591;
        bh=1AfdBcgWzbogf8HggZNDU4tJFfcbC5EYH6SpKNmqwFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q20NCwPembe62/tHsWPiOsDVsRICB1+8q4n7JLZ0sqKqZEBhl05vEVPPv7bxmcT4m
         x3VN31kWGayqkEamDlwPMNAa+Sr1LWGI0teoJr1C0LS4hPGz4RXmPdHa2ib6hzGFLy
         fXPDv4I5KRuckvqn5qtAiqXo++djfDIDMd87bbOd3WUzYcs2RXm9LzPhhbngHVB/YX
         aXTShbIMHxwvOJbitMBeIl7zcAogfU+HYjAFAfkr7gACJmFPjnkvLd+aELMA6nc5Su
         VElMcUFYZPl/kPDVJXM5n1n9/HBOVR42H1eqazltbh4bwapcZTcZ3lvELBPhmO5JFD
         xrBWv3wbojbrg==
Date:   Wed, 15 Sep 2021 20:36:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ohhoon Kwon <ohoono.kwon@samsung.com>,
        Ingo Molnar <mingo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 19/25] connector: send event on write to
 /proc/[pid]/comm
Message-ID: <YUKRju8/BayxKeC3@sashalap>
References: <20210913223339.435347-1-sashal@kernel.org>
 <20210913223339.435347-19-sashal@kernel.org>
 <87v932ar5q.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87v932ar5q.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 08:45:37AM -0500, Eric W. Biederman wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> From: Ohhoon Kwon <ohoono.kwon@samsung.com>
>>
>> [ Upstream commit c2f273ebd89a79ed87ef1025753343e327b99ac9 ]
>>
>> While comm change event via prctl has been reported to proc connector by
>> 'commit f786ecba4158 ("connector: add comm change event report to proc
>> connector")', connector listeners were missing comm changes by explicit
>> writes on /proc/[pid]/comm.
>>
>> Let explicit writes on /proc/[pid]/comm report to proc connector.
>
>This is a potential userspace ABI breakage?  Why backport it?
>
>Especially if there is no one asking for the behavior change in
>userspace?

This sounds like a concern with the patch going upstream rather than
going to stable? stable has the same policy around ABI changes such as
upstream.

-- 
Thanks,
Sasha
