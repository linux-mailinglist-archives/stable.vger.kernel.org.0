Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07B6CA77
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfGRH5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:57:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56482 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389446AbfGRH5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:57:47 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ho1IP-0002Uy-Te; Thu, 18 Jul 2019 09:57:46 +0200
Date:   Thu, 18 Jul 2019 09:57:45 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>
cc:     stable@vger.kernel.org
Subject: Re: Backport request
In-Reply-To: <20190717233810.GC3079@sasha-vm>
Message-ID: <alpine.DEB.2.21.1907180957060.1778@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1907162318380.1767@nanos.tec.linutronix.de> <20190717233810.GC3079@sasha-vm>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

On Wed, 17 Jul 2019, Sasha Levin wrote:

> On Wed, Jul 17, 2019 at 12:08:38AM +0200, Thomas Gleixner wrote:
> > 4001d8e8762f ("genirq: Delay deactivation in free_irq()")
> 
> Thomas, would just this one be relevant for 4.14 (and older)?

No. There the vector handling is completely different.

Thanks,

	Thomas
