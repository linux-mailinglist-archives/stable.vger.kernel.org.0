Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0E49CBA3
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiAZN4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:56:09 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:52515 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiAZN4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:56:08 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A6DFF200005;
        Wed, 26 Jan 2022 13:56:04 +0000 (UTC)
Date:   Wed, 26 Jan 2022 14:56:04 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc:     Greg KH <gregkh@linuxfoundation.org>, a.zummo@towertech.it,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rtc: mc146818-lib: fix RTC presence
 check" failed to apply to 5.16-stable tree
Message-ID: <YfFS9PFhQYssAAMj@piout.net>
References: <164302970310788@kroah.com>
 <df1a2547-c863-f416-58c9-4f64cce1f522@o2.pl>
 <Ye69PKB2V/R/NxN8@kroah.com>
 <23a5748e-55ca-69af-c9ff-d68a413a331d@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23a5748e-55ca-69af-c9ff-d68a413a331d@o2.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/01/2022 17:27:16+0100, Mateusz Jończyk wrote:
> W dniu 24.01.2022 o 15:52, Greg KH pisze:
> > On Mon, Jan 24, 2022 at 03:45:30PM +0100, Mateusz Jończyk wrote:
> >> W dniu 24.01.2022 o 14:08, gregkh@linuxfoundation.org pisze:
> >>> The patch below does not apply to the 5.16-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >> Wait, this patch was not intended for submission into stable yet, at least not in this form.
> >> Why did it end up in the stable queue?
> > Because it was marked with a "Fixes:" tag and I reviewed it and it
> > looked like it actually fixed an issue.
> >
> > Is this not the case?
> 
> Yes, that's correct. But I'm afraid that this patch will cause regressions on some systems.
> (Mr Alexandre Belloni said something similar of my series). So I'd like to wait till at least Linux 5.17 (final) is
> released to see if it causes any trouble.
> 

Well, it will be in 5.17, any regression it causes will have to be
fixed and we can then backport the fix.


-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
