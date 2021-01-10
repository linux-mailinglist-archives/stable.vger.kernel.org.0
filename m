Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75D82F066C
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 11:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAJKZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 05:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbhAJKZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 05:25:02 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604F9236F9;
        Sun, 10 Jan 2021 10:24:21 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kyXtT-006Psw-4e; Sun, 10 Jan 2021 10:24:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mathias Kresin <dev@kresin.me>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Serge Semin <fancer.lancer@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] irqchip: mips-cpu: set IPI domain parent chip
Date:   Sun, 10 Jan 2021 10:24:14 +0000
Message-Id: <161027422717.65915.10926355857179319603.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107213603.1637781-1-dev@kresin.me>
References: <20210107213603.1637781-1-dev@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dev@kresin.me, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, tsbogend@alpha.franken.de, fancer.lancer@gmail.com, hauke@hauke-m.de, martin.blumenstingl@googlemail.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jan 2021 22:36:03 +0100, Mathias Kresin wrote:
> Since commit 55567976629e ("genirq/irqdomain: Allow partial trimming of
> irq_data hierarchy") the irq_data chain is valided.
> 
> The irq_domain_trim_hierarchy() function doesn't consider the irq + ipi
> domain hierarchy as valid, since the ipi domain has the irq domain set
> as parent, but the parent domain has no chip set. Hence the boot ends in
> a kernel panic.
> 
> [...]

Applied to irq/irqchip-next, thanks!

[1/1] irqchip: mips-cpu: set IPI domain parent chip
      commit: 599b3063adf4bf041a87a69244ee36aded0d878f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


