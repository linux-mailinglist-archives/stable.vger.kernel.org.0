Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0C310DA3E
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 20:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfK2Twr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 14:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfK2Twr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 14:52:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7D8208E4;
        Fri, 29 Nov 2019 19:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575057166;
        bh=Q4hMOLiPxpztGU/azL8yG58j5nUbDssGN+NA2O95A6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vbHXHLdycd2oPCekmntsJyj/94qjpQRP68il8Yyyrxvga0QksuzJqVbIqA2dQoqgr
         29+kOo6e5l8c2+48uXP3O4j0CramrX4hi0XePzbjefjDCXUQxJgc4dc706Gf50itcj
         YLdk8fpSU120x+7Nh+Ca/KunqDsVhPE+aaWWEs2s=
Date:   Fri, 29 Nov 2019 14:52:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: io_uring stable additions
Message-ID: <20191129195245.GR5861@sasha-vm>
References: <a552f6b6-bdb8-afb8-b178-1d30d4d9ece6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a552f6b6-bdb8-afb8-b178-1d30d4d9ece6@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 04:40:38PM -0800, Jens Axboe wrote:
>Hi,
>
>I have a few commits that went into 5.5-rc that should go into stable. The
>first one is:
>
>commit 181e448d8709e517c9c7b523fcd209f24eb38ca7
>Author: Jens Axboe <axboe@kernel.dk>
>Date:   Mon Nov 25 08:52:30 2019 -0700
>
>    io_uring: async workers should inherit the user creds
>
>and I'm attaching a 5.4 port of this patch, since the one in 5.5 is built
>on top of new code. The 5.4 port will apply all the way back to 5.1 when
>io_uring was introduced.
>
>Secondly, these two (in order):
>
>commit 4257c8ca13b084550574b8c9a667d9c90ff746eb
>Author: Jens Axboe <axboe@kernel.dk>
>Date:   Mon Nov 25 14:27:34 2019 -0700
>
>    net: separate out the msghdr copy from ___sys_{send,recv}msg()
>
>and
>
>commit d69e07793f891524c6bbf1e75b9ae69db4450953
>Author: Jens Axboe <axboe@kernel.dk>
>Date:   Mon Nov 25 17:04:13 2019 -0700
>
>    net: disallow ancillary data for __sys_{send,recv}msg_file()
>
>should be applied to 5.3/5.4 stable as well. They might look like pure
>networking commits, but only io_uring uses the interface.
>
>These three fix important issues, which is why we need them in stable.

I've queued these three fixes to 5.4 and 5.3, thanks!

-- 
Thanks,
Sasha
