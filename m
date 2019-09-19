Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF2B7FF0
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbfISRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 13:23:54 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35725 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbfISRXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 13:23:54 -0400
X-Originating-IP: 90.65.161.137
Received: from localhost (lfbn-1-1545-137.w90-65.abo.wanadoo.fr [90.65.161.137])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 090811BF210;
        Thu, 19 Sep 2019 17:23:51 +0000 (UTC)
Date:   Thu, 19 Sep 2019 19:23:50 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: atmel: Fix crash when using more than 4 gpio CS
Message-ID: <20190919172350.GZ21254@piout.net>
References: <20190919153847.7179-1-gregory.clement@bootlin.com>
 <20190919160315.GQ3642@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919160315.GQ3642@sirena.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/09/2019 17:03:15+0100, Mark Brown wrote:
> On Thu, Sep 19, 2019 at 05:38:47PM +0200, Gregory CLEMENT wrote:
> 
> > With this patch, when using a gpio CS, the hardware CS0 is always
> > used. Thanks to this, there is no more limitation for the number of
> > gpio CS we can use.
> 
> This is going to break any system where we use both a GPIO chip select
> and chip select 0.  Ideally we'd try to figure out an unused chip select
> to use here...

The point is that this use case is already broken and this patch fixes
the crash and is easily backportable.

Fixing the CS + gpio CS should probably be done in a separate patch.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
