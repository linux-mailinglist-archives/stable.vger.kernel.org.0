Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C755B6A
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfFYWkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYWkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 18:40:53 -0400
Received: from localhost (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB9A20645;
        Tue, 25 Jun 2019 22:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561502453;
        bh=yjPidyFpMiJNtpZuOeDvkjTSPAz9/K9DU2uS44mJR7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yOfgLqO7c/l0chCkd2MjNQJYWD48a5pgWfDXIKf5ZlZ3rMFJJCwvA26ELG4IMl9yN
         7IhNcgwZwF4h0suLDcu+rVDH4BiwRGxAVWSJnZK0sfGc8EAW2Z5oNMZ7p37es4nrqg
         Ir0NMQK9mDsrnSLc0v23wW51KPlE7D5v2qvG3+EQ=
Date:   Tue, 25 Jun 2019 18:40:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Josh Hunt <johunt@akamai.com>
Cc:     gregkh@linuxfoundation.org, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190625224050.GE7898@sasha-vm>
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
>On 6/25/19 1:26 PM, Sasha Levin wrote:
>>On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
>>>Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
>>
>>You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
>
>I wasn't sure if I should reference the upstream commit or stable 
>commit. dad3a9314 is the version of the commit from linux-4.14.y. 
>There may be a similar issue with the Fixes tag below since that also 
>references the 4.14 vers of the change.

We try to just reference upstream commits when possible. I can edit
these if this patch will be merged.

--
Thanks,
Sasha
