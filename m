Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6983D108F25
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfKYNrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbfKYNrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:47:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06F96207FD;
        Mon, 25 Nov 2019 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574689663;
        bh=ZPQ21pCbzLNmwSrk2jDu3ZnDVPnjdyHKcMTQ08fY9lk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3wi7XNfK1sqP8VAu7sTv/oJ69ex+bTujD0I8Ej6ujgkH8Q8fu3/JsvBvRCrwZHE4
         6VbwRAyxRAIouCuhrmvOC6WZNR+L1wDoNqEXtH4bf4Kaya48mSgQOVVfMx7lp6qsWS
         Su1iA5+nOr/lXyHtUthjyxae/BwpiSnIBOu6vkIw=
Date:   Mon, 25 Nov 2019 08:47:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 5/8] bcache: silence static checker warning
Message-ID: <20191125134742.GB5861@sasha-vm>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-5-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122105253.11375-5-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:52:50AM +0000, Lee Jones wrote:
>From: Dan Carpenter <dan.carpenter@oracle.com>
>
>[ Upstream commit da22f0eea555baf9b0a84b52afe56db2052cfe8d ]
>
>In olden times, closure_return() used to have a hidden return built in.
>We removed the hidden return but forgot to add a new return here.  If
>"c" were NULL we would oops on the next line, but fortunately "c" is
>never NULL.  Let's just remove the if statement.

So this doesn't actually fix anything?

-- 
Thanks,
Sasha
