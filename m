Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC68D21198
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 03:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfEQBHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 21:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfEQBHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 21:07:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD29E206BF;
        Fri, 17 May 2019 01:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558055228;
        bh=4DUCsxJB0P9y4uOwgcf8Xi5dNUQ3fc1vHdZYEzrIwbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8J2bsdIyo8UyT4mccVemyc8q2rMD9rOK6lk7aXTlqC22ULFCP6xkwmty+tMJEBEt
         gMY5Wiww5H5fVUVM32vBZfEtPQXFgB0rvqjS6viwrfYv01Ux0x+5zWKs1Mljt4VWcy
         PqhYzAj2Odp9tn+sScnBqd0LxKscWe+LbjI3hLN4=
Date:   Thu, 16 May 2019 21:07:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, linux-integrity@vger.kernel.org,
        linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
Message-ID: <20190517010706.GA11972@sasha-vm>
References: <20190516161257.6640-3-roberto.sassu@huawei.com>
 <20190517001001.9BEF620848@mail.kernel.org>
 <1558053020.4507.32.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558053020.4507.32.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 08:30:20PM -0400, Mimi Zohar wrote:
>On Fri, 2019-05-17 at 00:10 +0000, Sasha Levin wrote:
>>
>> How should we proceed with this patch?
>
>Yikes!  This was posted earlier today.  I haven't even had a chance to
>look at it yet.  Similarly for "[PATCH 4/4] ima: only audit failed
>appraisal verifications".

Hi Mimi,

This is just a very early warning, it doesn't mean it's going in -stable
any time soon :)

I find that giving this alert now results in more responses as people
still have this patch + context in their mind. If we sent alerts such as
these before we actually add patches to -stable people tend to respond
less as usually they have moved to work on something else.

--
Thanks,
Sasha
