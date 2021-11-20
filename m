Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0B457C39
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 08:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhKTHmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 02:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237061AbhKTHmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Nov 2021 02:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6A360EAF;
        Sat, 20 Nov 2021 07:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637393991;
        bh=4/tQyZf051j2Hd0Wuo7KsU8oBaaoVF9YEWfxhTfOBbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8NX/sXEAZOig1+Hx93KWzBHbrYQ62Wnv/HDuCWzj649KhaIdV8aQyKH3OVRW4DLM
         0jiEo8fD5x90siLlQoBG8Sydf1laa+8kJSysCF9LZbKDkD0RNZa7DsvrY1YKN2h+D7
         8z5rdn75I8BVdOIkszC3VmP8aM/L/7tBK/Ee+Nos=
Date:   Sat, 20 Nov 2021 08:39:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10 03/21] loop: Use blk_validate_block_size() to
 validate block size
Message-ID: <YZimRBMpcbcLMCJN@kroah.com>
References: <20211119171443.892729043@linuxfoundation.org>
 <20211119171444.002617211@linuxfoundation.org>
 <20211119214522.GA23353@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119214522.GA23353@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 10:45:22PM +0100, Pavel Machek wrote:
> Hi!
> 
> > commit af3c570fb0df422b4906ebd11c1bf363d89961d5 upstream.
> > 
> > Remove loop_validate_block_size() and use the block layer helper
> > to validate block size.
> 
> This is just a cleanup, and it needs previous cleanup to be
> applied. I would not mind if both were dropped from stable series.

No, it is not a cleanup, it fixes a real bug as reported on the stable
mailing list.

greg k-h
