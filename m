Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542114982B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiAXOww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:52:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238361AbiAXOwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:52:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1441FB810A4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B84C340E5;
        Mon, 24 Jan 2022 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643035967;
        bh=P5eExyEEtTxSdxLT8qWGxBWwmSqxqcp1PS6Y6nlUMHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAkf84dnn5nzWI7sREL9DdjLQJ53O9lTAOn7pv7zRIVWP2jn2HUfQVHn2l8zygYJg
         bnFIGYrKbT77tTTmhXXdT8jccy9W0QW4HPCb0SmYiezN6iJoW59zTqYZpOPNryc1RV
         5+hiZN49OarjAgF2DyN/aNGbcWKBgojCT0NzVFgY=
Date:   Mon, 24 Jan 2022 15:52:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rtc: mc146818-lib: fix RTC presence
 check" failed to apply to 5.16-stable tree
Message-ID: <Ye69PKB2V/R/NxN8@kroah.com>
References: <164302970310788@kroah.com>
 <df1a2547-c863-f416-58c9-4f64cce1f522@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df1a2547-c863-f416-58c9-4f64cce1f522@o2.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 03:45:30PM +0100, Mateusz Jończyk wrote:
> W dniu 24.01.2022 o 14:08, gregkh@linuxfoundation.org pisze:
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> Wait, this patch was not intended for submission into stable yet, at least not in this form.
> Why did it end up in the stable queue?

Because it was marked with a "Fixes:" tag and I reviewed it and it
looked like it actually fixed an issue.

Is this not the case?

> The return values from mc146818_get_time() changed in between,
> so it is natural that it does not apply.
> 
> See
> commit d35786b3a28dee20 ("rtc: mc146818-lib: change return values of mc146818_get_time()")

Ok, so will a working backport be sent sometime in the future?

thanks,

greg k-h
