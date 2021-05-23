Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC938DA38
	for <lists+stable@lfdr.de>; Sun, 23 May 2021 10:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhEWIWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 04:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhEWIWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 May 2021 04:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF82C61263;
        Sun, 23 May 2021 08:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621758074;
        bh=MICF+Uu1HkhetRxQCscJNaBrHSc35hE+tXwnn6k6VUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BxQGlTsr5rBXr9k0Gh1xiDMJaKVu8hEpBcU8BD75BH1RlSMLE5q/MOipnZP80e3S3
         ZA3H/dO78sbvmjI/DZxaUPTPHLc5yrVGjiyxI3dIh1NlDue3adN5ruhgORXE+qYoSD
         iXLMxUIrvdCuVo+I9ACpjjz7Qd9cuVeSacORuac8=
Date:   Sun, 23 May 2021 10:21:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Francois Gervais <fgervais@distech-controls.com>,
        linux-rtc@vger.kernel.org,
        Michael McCormick <michael.mccormick@enatel.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] rtc: pcf85063: fallback to parent of_node
Message-ID: <YKoQds5N0dP2Gjg5@kroah.com>
References: <20210310211026.27299-1-fgervais@distech-controls.com>
 <161861118020.865088.6364463756780633947.b4-ty@bootlin.com>
 <20210522153636.ymyyq4vtzz2dq5k2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210522153636.ymyyq4vtzz2dq5k2@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 22, 2021 at 05:36:36PM +0200, Marc Kleine-Budde wrote:
> Hello Greg,
> 
> On 17.04.2021 00:16:40, Alexandre Belloni wrote:
> > On Wed, 10 Mar 2021 16:10:26 -0500, Francois Gervais wrote:
> > > The rtc device node is always or at the very least can possibly be NULL.
> > > 
> > > Since v5.12-rc1-dontuse/3c9ea42802a1fbf7ef29660ff8c6e526c58114f6 this
> > > will lead to a NULL pointer dereference.
> > > 
> > > To fix this we fallback to using the parent node which is the i2c client
> > > node as set by devm_rtc_allocate_device().
> > > 
> > > [...]
> > 
> > Applied, thanks!
> > 
> > [1/1] rtc: pcf85063: fallback to parent of_node
> >       commit: 03531606ef4cda25b629f500d1ffb6173b805c05
> > 
> > I made the fallback unconditionnal because this should have been that way from
> > the beginning as you point out.
> 
> can you queue this for stable, as it causes a NULL Pointer deref with
> (at least) v5.12.

After it hits Linus's tree, let stable@vger.kernel.org know the id and
we will glad to add it to the stable trees.

thanks,

greg k-h
