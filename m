Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431A618A829
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 23:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgCRW3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 18:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCRW3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 18:29:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3352076C;
        Wed, 18 Mar 2020 22:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584570547;
        bh=AyrvIuNfSBjSPCFLC4e6fJBBfjeamCZs3I4Bk/a401I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1LQe9sk3615eGEbtfOborbEp89q6Ox1yvlju2hYMNGLv7sdd36tRKwBm4TohxIx+
         froHbtlslOaE8HEZP5JmWfbk97PoN/5v3hXm4hwraf0k9jq6wMC6PiSojcxmkUT5MZ
         uLziXaZY2NoEzmEUwj/AWdMMcA5AZ+OtfOTjQhLk=
Date:   Wed, 18 Mar 2020 18:29:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] locks: fix a potential use-after-free problem when
 wakeup a waiter
Message-ID: <20200318222906.GJ4189@sasha-vm>
References: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 10:09:20PM +0000, Ben Hutchings wrote:
>This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
>branches:
>
>commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
>Author: yangerkun <yangerkun@huawei.com>
>Date:   Wed Mar 4 15:25:56 2020 +0800
>
>    locks: fix a potential use-after-free problem when wakeup a waiter

I've queued it up for 5.5 and 5.4, thanks!

>I'm a bit surprised that it hasn't yet been applied, while some fixes
>from 5.6-rc6 have.

Greg, I wonder if it makes sense to have you push a "Greg is here
--->" "bookmark" in the form of a tag/branch on linux-stable-rc.git? at
the very least it'll make it easy to see if something was missed or
still waiting in the queue.

-- 
Thanks,
Sasha
