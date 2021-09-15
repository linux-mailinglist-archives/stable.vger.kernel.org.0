Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF2C40C44A
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhIOLVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232699AbhIOLVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D36DE60F5B;
        Wed, 15 Sep 2021 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631704797;
        bh=mvoUo4XIOrSf9ot7VbRRZs2qB3ApgbCQN4wIItEYmBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGTDxulFubP/5XYduyPTLKfzarto+k6dYca6Qjp2aQ4uqQ4zNCvxG5/cW22zF26rv
         TBi3g3CM+FKmDsp6av7samZ3auKspMMCiY+sOqnnDoRgJWu716xvVRYr9+K87cU0xC
         rQcSbTY88jPkemuiC3vx6stUgXbnk1V7FWeu0rW4=
Date:   Wed, 15 Sep 2021 13:19:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: 5.10 stable backports
Message-ID: <YUHW23s5Wy6Aw6tI@kroah.com>
References: <81a1f0ea-d875-8cce-6ac1-3307a656bb92@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81a1f0ea-d875-8cce-6ac1-3307a656bb92@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 09:49:05AM -0600, Jens Axboe wrote:
> Hi Greg,
> 
> Looked over the 5.10/13/14 stable failures, and here's the queue for
> 5.10. I'll be sending 5.13 and 5.14 after this.

Now queued up,t hanks.

greg k-h
