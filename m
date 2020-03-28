Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BEB196993
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 22:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgC1Vrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 17:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgC1Vrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 17:47:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7826720716;
        Sat, 28 Mar 2020 21:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585432056;
        bh=kpbSglY0N7qgREA/cJo9vwjN5WY9SBQXP0jQlwjtnQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUx9moe4HeohF3ZJ+XC15mj3j22qjuH9IKvjGcs/QLYfQRWZCzzcgKuOMXBKfo+7q
         uAMaMe54ncTtR1hCjJOg2PIKIOVj3HOUxgjrXmtSvqjQarnKpy22TGyiOksrBBTrPb
         kxUu7XRR8ySqIpeH1oDPi1SfI/BBIJGcF5NUFLDI=
Date:   Sat, 28 Mar 2020 17:47:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Please apply commit 42d84c8490f9 ("vhost: Check docket sk_family
 instead of call getname") to v4.4.y
Message-ID: <20200328214735.GB4189@sasha-vm>
References: <b32c7115-085d-23bf-1e0f-fc7e7dbb9e13@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b32c7115-085d-23bf-1e0f-fc7e7dbb9e13@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 28, 2020 at 08:44:48AM -0700, Guenter Roeck wrote:
>Commit 42d84c8490f9 ("vhost: Check docket sk_family instead of call getname")
>fixes CVE-2020-10942. It has been applied to v4.14.y and later, but not to v4.4.y.
>While it does not apply directly to v4.4.y, its backport to v4.14.y (commit
>ff8e12b0cfe2 in v4.14.y) does. Please apply the backport to v4.4.y as well.

I've queued it for 4.4, thanks!

-- 
Thanks,
Sasha
