Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9660285A47
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 10:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgJGISM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 04:18:12 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:49432 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgJGISL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 04:18:11 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4C5nJt4PySzMnHB;
        Wed,  7 Oct 2020 10:18:06 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C5nJT6bdXz2TTHp;
        Wed,  7 Oct 2020 10:17:45 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.126) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 7 Oct
 2020 10:17:13 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Krzysztof Kozlowski <krzk@kernel.org>
CC:     Oleksij Rempel <linux@rempel-privat.de>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Date:   Wed, 7 Oct 2020 10:17:11 +0200
Message-ID: <5729679.lNAy7qQNGU@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <CAJKOXPctS2DGkQW3EhP5Tg0y39oVF0xhEcmbs=T0vHmUsMgsQw@mail.gmail.com>
References: <20201006160814.22047-1-ceggers@arri.de> <20201006160814.22047-2-ceggers@arri.de> <CAJKOXPctS2DGkQW3EhP5Tg0y39oVF0xhEcmbs=T0vHmUsMgsQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.126]
X-RMX-ID: 20201007-101751-4C5nJT6bdXz2TTHp-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday, 7 October 2020, 09:50:23 CEST, Krzysztof Kozlowski wrote:
> I replied to your v2 with testing, so what happened with all my tested tags?

I am quite new to the kernel development process. Seems that I should 
integrate all "Tested-by" tags into following version of my patches.

In which cases shall the tested tags be kept and in which cases they become 
invalid?

Best regards
Christian



