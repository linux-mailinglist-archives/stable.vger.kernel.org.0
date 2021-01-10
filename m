Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5922F0670
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAJKZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 05:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbhAJKZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 05:25:02 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A70239CF;
        Sun, 10 Jan 2021 10:24:21 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kyXtT-006Psw-TX; Sun, 10 Jan 2021 10:24:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mathias Kresin <dev@kresin.me>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Suman Anna <s-anna@ti.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        David Lechner <david@lechnology.com>
Subject: Re: [PATCH] irqchip: Simplify the TI_PRUSS_INTC Kconfig
Date:   Sun, 10 Jan 2021 10:24:15 +0000
Message-Id: <161027422717.65915.12337837723270334988.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108162901.6003-1-s-anna@ti.com>
References: <20210108162901.6003-1-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dev@kresin.me, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, tsbogend@alpha.franken.de, fancer.lancer@gmail.com, s-anna@ti.com, hauke@hauke-m.de, martin.blumenstingl@googlemail.com, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, grzegorz.jaszczyk@linaro.org, lokeshvutla@ti.com, linux-omap@vger.kernel.org, tony@atomide.com, ssantosh@kernel.org, david@lechnology.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 Jan 2021 10:29:01 -0600, Suman Anna wrote:
> The TI PRUSS INTC irqchip driver handles the local interrupt controller
> which is a child device of it's parent PRUSS/ICSSG device. The driver
> was upstreamed in parallel with the PRUSS platform driver, and was
> configurable independently previously. The PRUSS interrupt controller
> is an integral part of the overall PRUSS software architecture, and is
> not useful at all by itself.
> 
> [...]

Applied to irq/irqchip-next, thanks!

[1/1] irqchip: Simplify the TI_PRUSS_INTC Kconfig
      commit: b8e594fa20d2e33d40c7a8c7c106549a35c38972

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


