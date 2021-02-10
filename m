Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9435316C20
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhBJRKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhBJRKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 12:10:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F58364E77;
        Wed, 10 Feb 2021 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612976966;
        bh=7seGJWhCZNh4jS921GuRjIARtdD3+bBH7qwyHjoxvp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rK6f2dOzywGvkXtBdIQlvOksgz9tfxk584TbglR4hEPYrIdrgfVxhutXlmRAxEo18
         JD6cfZ+gIVb59zcqaEDegCirX8WrVumiYyyLtaR12DdF9PkZU9UXHuAv9kA4QRVQDI
         ifpLmLBdHJQ0huclP/l8LfdLEVaIf3UDPZuhnSG8=
Date:   Wed, 10 Feb 2021 18:09:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     stable <stable@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rostedt <rostedt@goodmis.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: [stable 4.4, 4.9, 4.14, 4.19 LTS] Missing fix "memcg: fix a
 crash in wb_workfn when a device disappears"
Message-ID: <YCQTQyRlCsJHXzIQ@kroah.com>
References: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537870616.15400.1612973059419.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 11:04:19AM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> While reconciling the lttng-modules writeback instrumentation with its counterpart
> within the upstream Linux kernel, I notice that the following commit introduced in
> 5.6 is present in stable branches 5.4 and 5.5, but is missing from LTS stable branches
> for 4.4, 4.9, 4.14, 4.19:
> 
> commit 68f23b89067fdf187763e75a56087550624fdbee
> ("memcg: fix a crash in wb_workfn when a device disappears")
> 
> Considering that this fix was CC'd to the stable mailing list, is there any
> reason why it has not been integrated into those LTS branches ?

Yes, it doesn't apply at all.  If you think this is needed, I will
gladly take backported and tested patches.

But why do you think this is needed in older kernels?  Have you hit
this in real-life?

thanks,

greg k-h
