Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE929DE58
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgJ1WTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731730AbgJ1WRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:43 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9CD7247B3;
        Wed, 28 Oct 2020 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603897973;
        bh=9ClaS39qsu/8IFZeXHaVx8PcmKehSz9sH+qzL4vXJxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=co88HEQHIL5+KsFEIyZ1iMP+lEmwUbGs90igcu0t9SFvJwRYsCz6Zceb/tQX0k8h4
         Wv0pj60BkZl4dUvuQGdz3g/BimVof8eTpIJgkmWJdG+GkN8yiYmIGVweIrNu7cXOpD
         cPsSvSXGu5YPXxaq2AdLKJujm65qVV5nluI6LLJk=
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
Date:   Wed, 28 Oct 2020 15:12:36 +0000
Message-Id: <160388361710.744976.4736349542337915760.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201023154751.1973872-1-swboyd@chromium.org>
References: <20201023154751.1973872-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Oct 2020 08:47:50 -0700, Stephen Boyd wrote:
> According to the SMCCC spec[1](7.5.2 Discovery) the
> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> SMCCC_RET_NOT_SUPPORTED.
> 
>  0 is "workaround required and safe to call this function"
>  1 is "workaround not required but safe to call this function"
>  SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
      https://git.kernel.org/arm64/c/1de111b51b82

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
