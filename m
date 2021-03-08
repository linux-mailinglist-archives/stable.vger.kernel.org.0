Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008ED330AE0
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhCHKLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 05:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231826AbhCHKKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 05:10:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1AF650E6;
        Mon,  8 Mar 2021 10:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615198238;
        bh=/V82QLDDIg9euFCDX9mBgExm/Ii84ElnU5ldT/eQqAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1/q5hJblf+PTGoJbSLnpuXpIgLaf0m5TgtD8ZXPKhCPouy2R164m8z9sq6VAtN+P
         ZLEz8sCUCzw4k4FVKjF6tWIzqfD/5eWM0mdNEscxfPyNQV97xfnWsXVDgXFpWdg9Qo
         A5hI14OfK67ART91fzVHQbkQ72FMRegYLYYb2xRg=
Date:   Mon, 8 Mar 2021 11:10:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     cJ-ko@zougloub.eu, samitolvanen@google.com, snitzer@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm verity: fix FEC for RS roots unaligned
 to block size" failed to apply to 4.19-stable tree
Message-ID: <YEX4HDAx3PMhW1MU@kroah.com>
References: <161512534156239@kroah.com>
 <82970d00-c11d-e2fb-5999-d953f46901fa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82970d00-c11d-e2fb-5999-d953f46901fa@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 10:27:21PM +0100, Milan Broz wrote:
> On 07/03/2021 14:55, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hello,
> 
> I think the patch should be backported to 4.19, only trivial diff context change needed.
> Backported patch based on top of 4.19.179 is in attachment.
> 
> For older longterm (4.9, 4.14) it cannot be easily backported without additional
> changes to dm-bufio (mainly support for non-power-of-two block sizes).

Thanks, now queued up.

greg k-h
