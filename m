Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C43DB5DC
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 11:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhG3J0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 05:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238183AbhG3J0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 05:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF056052B;
        Fri, 30 Jul 2021 09:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627637168;
        bh=ThT6OYQ4yozuXXtILfF6vNRargfhIGe0lBl/jn3lu/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VpSOy2YWT+mMQiTYvXsfQ5iY9s0ISR8unztEqIwBPjxgFqmOgP+5cuajR89uonxx9
         0Ly56vmUUVaJdmWB0f2BRTzqnIpAhV9Mw62lSP7u4LWcybcC/tWILxIf2rLSWp9Es2
         P9kf8UsxbvntrRhKHyKWPs0vTuImNj1EgWwo7sg0=
Date:   Fri, 30 Jul 2021 11:26:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alan Young <consult.awy@gmail.com>
Cc:     stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: pcm: Call substream ack() method
 upon compat mmap" failed to apply to 5.4-stable tree
Message-ID: <YQPFqOmmJCJM9Ref@kroah.com>
References: <162728697013399@kroah.com>
 <e26c27fb-12e8-f1c1-0dde-50fd68623118@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e26c27fb-12e8-f1c1-0dde-50fd68623118@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 09:38:52AM +0100, Alan Young wrote:
> This commit is not applicable before the 64-bit time_t in user space with
> 32-bit compatibility changes introduces by
> 80fe7430c7085951d1246d83f638cc17e6c0be36 in 5.6.

That is odd, as that is not what you wrote in the patch itself:

>     Fixes: 9027c4639ef1 ("ALSA: pcm: Call ack() whenever appl_ptr is updated")

So is the Fixes: tag here incorrect?

thanks,

greg k-h
