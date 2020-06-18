Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45101FFB37
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 20:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgFRSmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 14:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgFRSmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 14:42:44 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12453C06174E;
        Thu, 18 Jun 2020 11:42:43 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jlzUm-0000dc-OJ; Thu, 18 Jun 2020 20:42:40 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 27E02101482; Thu, 18 Jun 2020 20:42:40 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     20181129133119.29387-1-linus.walleij@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] irq: Request and release resources for chained IRQs
In-Reply-To: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz>
References: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz>
Date:   Thu, 18 Jun 2020 20:42:40 +0200
Message-ID: <87tuz8b4gv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Heidelberg <david@ixit.cz> writes:
> is there chance to get this patch included or could be this issue 
> solved with different approach?

Included into what? This patch is incorrect as I pointed out in review
here:

  https://lore.kernel.org/lkml/alpine.DEB.2.21.1812071143480.14498@nanos.tec.linutronix.de/

So why are you even asking?

I recommended to switch this away from chained handler and then the
whole story ended with this mail:

  https://lore.kernel.org/lkml/alpine.DEB.2.21.1812071404140.14498@nanos.tec.linutronix.de/

I have no idea how the GPIO people solved that problem, but certainly
not by applying this.

Thanks,

        tglx
