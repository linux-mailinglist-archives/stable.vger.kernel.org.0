Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC02337F91
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 23:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfFFV2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 17:28:13 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:50046 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfFFV2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 17:28:12 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id D9DDD4E5E;
        Thu,  6 Jun 2019 23:28:09 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id b2c764d9;
        Thu, 6 Jun 2019 23:28:07 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     sashal@kernel.org
Cc:     jason@lakedaemon.net, jhogan@kernel.org, john@phrozen.org,
        ldir@darbyshire-bryant.me.uk, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, marc.zyngier@arm.com,
        paul.burton@mips.com, ralf@linux-mips.org, stable@vger.kernel.org,
        tglx@linutronix.de, ynezz@true.cz,
        =?UTF-8?q?Karl=20P=C3=A1lsson?= <karlp@etactica.com>
Subject: Re: [PATCH AUTOSEL 4.9 18/25] MIPS: perf: ath79: Fix perfcount IRQ assignment
Date:   Thu,  6 Jun 2019 23:28:04 +0200
Message-Id: <1559856484-8579-1-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20190507054123.32514-18-sashal@kernel.org>
References: <20190507054123.32514-18-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Karl has reported to me today, that he's experiencing weird reboot hang on his
devices with 4.9.180 kernel and that he has bisected it down to my backported
patch.

I would like to kindly ask you for removal of this patch.  This patch should
be reverted from all stable kernels up to 5.1, because perf counters were not
broken on those kernels, and this patch won't work on the ath79 legacy IRQ
code anyway, it needs new irqchip driver which was enabled on ath79 with
commit 51fa4f8912c0 ("MIPS: ath79: drop legacy IRQ code").

Thanks!

Cheers,

Petr
