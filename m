Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9562416214A
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 08:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgBRHDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 02:03:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59393 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgBRHDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 02:03:15 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1j3wuV-0007Ym-Hi; Tue, 18 Feb 2020 08:03:11 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1j3wuU-0005OG-LI; Tue, 18 Feb 2020 08:03:10 +0100
Date:   Tue, 18 Feb 2020 08:03:10 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 0/2] serial: imx: Backport fixes for irq handling to v4.14
Message-ID: <20200218070310.ibv2m2f7ihfaevrp@pengutronix.de>
References: <20200217140740.29743-1-frieder.schrempf@kontron.de>
 <20200218045008.GA2049358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200218045008.GA2049358@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 05:50:08AM +0100, gregkh@linuxfoundation.org wrote:
> On Mon, Feb 17, 2020 at 02:08:00PM +0000, Schrempf Frieder wrote:
> > From: Frieder Schrempf <frieder.schrempf@kontron.de>
> > 
> > A customer of ours has problems with RS485 on i.MX6UL with the latest v4.14
> > kernel. They get an exception like below from time to time (the trace is
> > from an older kernel, but the problem also exists in v4.14.170).
> > 
> > As the cpuidle state 2 causes large delays for the interrupt that controls the
> > RS485 RTS signal (which can lead to collisions on the bus), cpuidle state 2 was
> > disabled on this system. This aspect might cause the exception happening more
> > often on this system than on other systems with default cpuidle settings.
> > 
> > Looking for solutions I found Uwe's patches that were applied in v4.17 being
> > mentioned here [1] and here [2]. In [1] Uwe notes that backporting these fixes
> > to v4.14 might not be trivial, but I tried and in my opinion found it not to be
> > too problematic either.
> > 
> > With the backported patches applied, our customer reports that the exceptions
> > stopped occuring. Given this and the fact that the problem seems to be known
> > and quite common, it would be nice to get this into the v4.14 stable tree. 
> 
> Thanks for the backports, both now queued up.

To complete these fixes you also want to backport

	101aa46bd221 serial: imx: fix a race condition in receive path

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
