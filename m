Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6554738E6D1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhEXMqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhEXMqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 08:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F4F61151;
        Mon, 24 May 2021 12:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621860302;
        bh=9eF1B+lCgVcGfvxMI8iyWawnoLTg1xQrIafehihlN6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ai6gCZG4+a3d9h44JQEtsUbDizPk0tix8MxcjkDQreZB4HidLH1VfaE6iV3dNPTjT
         W5bZZiD6B4B5xWPXhDuZoX/djZkHtjP8AE9k5rNmVPBClxOGS3vtIspgcTk0EKVrva
         0QCER5UeZ/sN0KM+7iXD71OM34srdFpikSgJlX7Q=
Date:   Mon, 24 May 2021 14:45:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Francois Gervais <fgervais@distech-controls.com>,
        linux-rtc@vger.kernel.org,
        Michael McCormick <michael.mccormick@enatel.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] rtc: pcf85063: fallback to parent of_node
Message-ID: <YKufzM5Z5uQSn7DO@kroah.com>
References: <20210310211026.27299-1-fgervais@distech-controls.com>
 <161861118020.865088.6364463756780633947.b4-ty@bootlin.com>
 <20210522153636.ymyyq4vtzz2dq5k2@pengutronix.de>
 <YKoQds5N0dP2Gjg5@kroah.com>
 <20210523182441.he5kqrlhargchaxw@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210523182441.he5kqrlhargchaxw@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 23, 2021 at 08:24:41PM +0200, Marc Kleine-Budde wrote:
> On 23.05.2021 10:21:10, Greg Kroah-Hartman wrote:
> > On Sat, May 22, 2021 at 05:36:36PM +0200, Marc Kleine-Budde wrote:
> > > > [1/1] rtc: pcf85063: fallback to parent of_node
> > > >       commit: 03531606ef4cda25b629f500d1ffb6173b805c05
> > > > 
> > > > I made the fallback unconditionnal because this should have been that way from
> > > > the beginning as you point out.
> > > 
> > > can you queue this for stable, as it causes a NULL Pointer deref with
> > > (at least) v5.12.
> > 
> > After it hits Linus's tree, let stable@vger.kernel.org know the id and
> > we will glad to add it to the stable trees.
> 
> It's in Linus's tree since v5.13-rc1~64^2~19 and the commit id is
> 03531606ef4c ("rtc: pcf85063: fallback to parent of_node").

Now queued up, thanks.

greg k-h
