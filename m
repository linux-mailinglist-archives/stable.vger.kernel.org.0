Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63823335A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgG3NsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 09:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbgG3NsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:48:13 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D02C21D95;
        Thu, 30 Jul 2020 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596116893;
        bh=Mn72VU+8uk3Y766iO1dWxYnvmxO5GSYOQLE23IyXWik=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=nKYYmI4OPZAkayMyuquoNHXOFimlLLTg9CFz1E8jT4KSVe5pdmMzZ0ESN8GskIDvA
         ioA9i0/FTzi/jSn66vQvfd875PDKPBq2giUHf8bCjCk8ZxhZFF1xjdv1tFI7FS59bg
         21fEskqkA32LwW/SXBU3TP0kLHYAM0QdH3yUnrok=
Date:   Thu, 30 Jul 2020 13:48:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Cc:     John Keeping <john@metanate.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [tip: irq/urgent] genirq/affinity: Make affinity setting if activated opt-in
In-Reply-To: <159585991142.4006.928637752238313572.tip-bot2@tip-bot2>
References: <159585991142.4006.928637752238313572.tip-bot2@tip-bot2>
Message-Id: <20200730134813.0D02C21D95@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: baedb87d1b53 ("genirq/affinity: Handle affinity setting on inactive interrupts correctly").

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135.

v5.7.11: Build OK!
v5.4.54: Failed to apply! Possible dependencies:
    008f1d60fe25 ("x86/apic/vector: Force interupt handler invocation to irq context")
    c16816acd086 ("genirq: Add protection against unsafe usage of generic_handle_irq()")

v4.19.135: Failed to apply! Possible dependencies:
    008f1d60fe25 ("x86/apic/vector: Force interupt handler invocation to irq context")
    35ae7df21be0 ("irqchip/gic-v3-its: Don't map the MSI page in its_irq_compose_msi_msg()")
    c16816acd086 ("genirq: Add protection against unsafe usage of generic_handle_irq()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
