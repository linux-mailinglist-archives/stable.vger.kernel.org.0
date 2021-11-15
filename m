Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5034506DF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhKOObM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236593AbhKOOaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 09:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2834261BD4;
        Mon, 15 Nov 2021 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636986476;
        bh=O1qUcrgJ5txgRiFc+DXluXOpG/AE+ul1hgW0LeegGwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNqszhlFzmEXx0Z2ofBgCB7JKmCKbJA8eYLHomXJIt08vUCTBi2lNuwu2xBXy7UUH
         P1fcL2fCBaTsMzMezmzWunYd4GpBPjQeV/Zf8CUT++dcAuFqtbxB6bwiwXUP4QJaz4
         7zupSbhbk98s4RkSWapSFR2M8Bd9OmNqNjK1qQiY=
Date:   Mon, 15 Nov 2021 15:27:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     daniel@mariadb.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io-wq: serialize hash clear with wakeup"
 failed to apply to 5.14-stable tree
Message-ID: <YZJuamsLzOu3Qyn8@kroah.com>
References: <1636899953125228@kroah.com>
 <2b04ecb8-0c06-005e-115d-296ecbf41a4f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b04ecb8-0c06-005e-115d-296ecbf41a4f@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 14, 2021 at 07:39:27AM -0700, Jens Axboe wrote:
> On 11/14/21 7:25 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This needs a few more backports - here are two backports that it depends
> on, and then this one backported as well.

Now queued up, thanks.

greg k-h
