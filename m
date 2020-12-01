Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74A2C983E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 08:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgLAHgl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Dec 2020 02:36:41 -0500
Received: from mailout05.rmx.de ([94.199.90.90]:48477 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgLAHgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 02:36:40 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4ClYms0Rytz9vZl;
        Tue,  1 Dec 2020 08:35:57 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4ClYmS2TjMz2TTLk;
        Tue,  1 Dec 2020 08:35:36 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 08:34:53 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Wolfram Sang <wsa@kernel.org>, <wsa@the-dreams.de>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "David Laight" <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Tue, 1 Dec 2020 08:34:52 +0100
Message-ID: <18285740.IRuNKOj0Az@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201010110920.GB4669@ninjato>
References: <20201009110320.20832-1-ceggers@arri.de> <20201009110320.20832-2-ceggers@arri.de> <20201010110920.GB4669@ninjato>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-083538-4ClYmS2TjMz2TTLk-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Saturday, 10 October 2020, 13:09:20 CET, Wolfram Sang wrote:
> On Fri, Oct 09, 2020 at 01:03:18PM +0200, Christian Eggers wrote:
> > According to the "VFxxx Controller Reference Manual" (and the comment
> > block starting at line 97), Vybrid requires writing a one for clearing
> > an interrupt flag. Syncing the method for clearing I2SR_IIF in
> > i2c_imx_isr().
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
> > Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Cc: stable@vger.kernel.org
> 
> Applied to for-next, thanks!
> 
I cannot find my patches in kernel/git/wsa/linux.git, branch "for-next".
Did they get lost?

regards
Christian




