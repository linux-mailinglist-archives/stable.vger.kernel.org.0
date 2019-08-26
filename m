Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065749D89E
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfHZVle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbfHZVle (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:41:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75189217F5;
        Mon, 26 Aug 2019 21:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855693;
        bh=DwV/hMakv11sHXBA7Xl8fXFLh4OTtcE1REwOTduv7Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xup+NyCt2VTBDCEnMpWoN1YNKVh5fFtLyh+0mLsMjoAQy8ve2npgz5cBpU0mIfx3a
         VLtV4A930JD0GKXg4eZCTAUgsUJGeTEZGL9EZAQmdp0WlhPHiFX4AZNI+LzZCNXnve
         Cd1qa//0+sDj8sTk0RccPwFw6ZgclYEvEP4sACs4=
Date:   Mon, 26 Aug 2019 17:41:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: fs/io_uring.c stable additions
Message-ID: <20190826214132.GM5281@sasha-vm>
References: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 02:39:28PM -0600, Jens Axboe wrote:
>Hi,
>
>Round two of this show, I forget to add these stable tags sometimes
>apparently... Can you add these four to 5.2 stable? Again listed
>in order of how they should be applied.
>
>a982eeb09b6030e567b8b815277c8c9197168040

This one seems to fix sqe links, which were only introduced in the 5.3
merge window?

>500f9fbadef86466a435726192f4ca4df7d94236
>a3a0e43fd77013819e4b6f55e37e0efe8e35d805
>08f5439f1df25a6cf6cf4c72cf6c13025599ce67

These 3 look okay, but I haven't queued them up as you were explicit
with ordering instructions, and as I can't take the first one I'm
playing it safe.

--
Thanks,
Sasha
