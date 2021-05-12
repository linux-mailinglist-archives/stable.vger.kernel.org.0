Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3137B903
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELJYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELJYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5357A611C9;
        Wed, 12 May 2021 09:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620811402;
        bh=MI/1GImj2UXsi/QisdJG1A/f299swqnYD82HkSWMIy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvnR3E/kj0NqwxMTENIL0lJ6qGGUajwvOHFzUDBUwI57W5Ei9LkaQhNhR0c9L9qTl
         sr7Gd6xJm1dqA++ptwkg+jhkT3fVkfawkexcTAag1v3UV0+DhjG9uNEvPFWcP/z+Xw
         tjKjmg7zDbTv995YAnL1c/a6qAzCWTKRM3cdni1o=
Date:   Wed, 12 May 2021 11:23:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     hi-angel@yandex.ru, todd.e.brandt@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Restructure trace_clock_global()
 to never block" failed to apply to 4.14-stable tree
Message-ID: <YJueiDIIcH0MavZv@kroah.com>
References: <162063664219298@kroah.com>
 <20210511114115.2a8ea027@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511114115.2a8ea027@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 11:41:15AM -0400, Steven Rostedt wrote:
> On Mon, 10 May 2021 10:50:42 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> This should work for 4.14, 4.9 and 4.4.

Now queued up, thanks!

greg k-h
