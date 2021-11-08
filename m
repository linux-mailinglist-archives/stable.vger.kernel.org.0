Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30667447E2F
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhKHKpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 05:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233424AbhKHKpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 05:45:13 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7AE4610FF;
        Mon,  8 Nov 2021 10:42:29 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mk26d-00480a-HH; Mon, 08 Nov 2021 10:42:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, will@kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com
Subject: Re: [PATCH] arm64/kvm: extract ESR_ELx.EC only
Date:   Mon,  8 Nov 2021 10:42:20 +0000
Message-Id: <163636813221.2539373.16277310841922173561.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211103110545.4613-1-mark.rutland@arm.com>
References: <20211103110545.4613-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, stable@vger.kernel.org, will@kernel.org, james.morse@arm.com, catalin.marinas@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Nov 2021 11:05:45 +0000, Mark Rutland wrote:
> Since ARMv8.0 the upper 32 bits of ESR_ELx have been RES0, and recently
> some of the upper bits gained a meaning and can be non-zero. For
> example, when FEAT_LS64 is implemented, ESR_ELx[36:32] contain ISS2,
> which for an ST64BV or ST64BV0 can be non-zero. This can be seen in ARM
> DDI 0487G.b, page D13-3145, section D13.2.37.
> 
> Generally, we must not rely on RES0 bit remaining zero in future, and
> when extracting ESR_ELx.EC we must mask out all other bits.
> 
> [...]

Applied to next, thanks!

[1/1] arm64/kvm: extract ESR_ELx.EC only
      commit: 8bb084119f1acc2ec55ea085a97231e3ddb30782

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


