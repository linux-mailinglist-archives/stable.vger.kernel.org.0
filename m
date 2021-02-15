Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0737731BB14
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBOOal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhBOOak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 09:30:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFE864E32;
        Mon, 15 Feb 2021 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613399400;
        bh=j9YIgdZu4XNUe4yZFow/wND7OuQqpoLPcPBL1XNqjQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EcKP9GKnVKoN6u8AeJhO2ixV0zfL1MHELvUAy8vT3JdMpswjThZZRt9NRAZvtb1qI
         9G926OFImVDMSsNlps2q3i7jNU/3jL8k17Zdi+h2YWHz1/sRZhL4gDicvRgMknbZOM
         l4gQyu6bFfytneKe1p3FvzTNcm7plpN+959gwjWg=
Date:   Mon, 15 Feb 2021 15:29:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Sergey.Semin@baikalelectronics.ru, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based
 busyloop with" failed to apply to 4.4-stable tree
Message-ID: <YCqFZe4Jex3LW7Oj@kroah.com>
References: <1610354218200130@kroah.com>
 <YCcXikcgdTJxbelw@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCcXikcgdTJxbelw@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 13, 2021 at 12:04:26AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 11, 2021 at 09:36:58AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, along with 2a499b452952 ("usb: dwc3: ulpi: fix checkpatch warning")
> which makes backporting easy.

Thanks for all of these, now queued up.

greg k-h
