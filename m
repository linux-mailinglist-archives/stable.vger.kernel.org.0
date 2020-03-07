Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58DE17D08C
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgCGXU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:28 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268C52075A;
        Sat,  7 Mar 2020 23:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623228;
        bh=4fuwdMLIHd//6XWMuWv2AC9Lv1VQaSgrcXZByjYo2d4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=q/OXaQ6hPxDsoHlWTU6lr2eyZCYsERuQXkZ5nIbcUPRqft2o0Yi83OETqWeQ9LpG3
         /UXZhW4UM6K56x40wWyze8Ln3Nn1KCQxg3XKWJNdEdUNbK4IhB3pj06yM6lfSUgMXf
         7kHZqSsQCkEvHaQs6AwnxxlGuObuDOeR8g0PFa4A=
Date:   Sat, 07 Mar 2020 23:20:27 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, x86@kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [patch 1/7] genirq/debugfs: Add missing sanity checks to interrupt injection
In-Reply-To: <20200306130623.500019114@linutronix.de>
References: <20200306130623.500019114@linutronix.de>
Message-Id: <20200307232028.268C52075A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 536e2e34bd00 ("genirq/debugfs: Triggering of interrupts from userspace").

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172.

v5.5.8: Build failed! Errors:
    kernel/irq/debugfs.c:217:48: error: expected ‘)’ before ‘{’ token
    kernel/irq/debugfs.c:229:2: error: expected expression before ‘}’ token

v5.4.24: Build failed! Errors:
    kernel/irq/debugfs.c:217:48: error: expected ‘)’ before ‘{’ token
    kernel/irq/debugfs.c:229:2: error: expected expression before ‘}’ token

v4.19.108: Failed to apply! Possible dependencies:
    b525903c254d ("genirq: Provide basic NMI management for interrupt lines")

v4.14.172: Failed to apply! Possible dependencies:
    6988e0e0d283 ("genirq/msi: Limit level-triggered MSI to platform devices")
    72a8edc2d913 ("genirq/debugfs: Add missing IRQCHIP_SUPPORTS_LEVEL_MSI debug")
    b525903c254d ("genirq: Provide basic NMI management for interrupt lines")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
