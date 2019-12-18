Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0694D124BDF
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLRPkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 10:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbfLRPkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 10:40:05 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E50F2176D;
        Wed, 18 Dec 2019 15:40:03 +0000 (UTC)
Date:   Wed, 18 Dec 2019 10:40:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Will Deacon <will@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 031/219] arm64: preempt: Fix big-endian
 when checking preempt count in assembly
Message-ID: <20191218104001.2b2773b7@gandalf.local.home>
In-Reply-To: <20191216094523.GA9938@willie-the-truck>
References: <20191122054911.1750-1-sashal@kernel.org>
        <20191122054911.1750-24-sashal@kernel.org>
        <20191214021403.GA1357@home.goodmis.org>
        <20191216094523.GA9938@willie-the-truck>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 Dec 2019 09:45:24 +0000
Will Deacon <will@kernel.org> wrote:

> Yup, without 396244692232 this commit makes no sense. That's why I didn't CC
> stable or add a Fixes tag :(

I'm wondering if we should add a tag to state "not to be backported",
to tell auto select to ignore a patch that appears to be a fix.

-- Steve
