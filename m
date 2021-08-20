Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CC93F27FE
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhHTH7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 03:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhHTH7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 03:59:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F80861042;
        Fri, 20 Aug 2021 07:58:27 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mGzQ1-0068ip-K3; Fri, 20 Aug 2021 08:58:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        kernel-team@android.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2] KVM: arm64: vgic: Resample HW pending state on deactivation
Date:   Fri, 20 Aug 2021 08:58:22 +0100
Message-Id: <162944629227.1671663.6947098620852443792.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819180305.1670525-1-maz@kernel.org>
References: <20210819180305.1670525-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, andre.przywara@arm.com, kernel-team@android.com, suzuki.poulose@arm.com, rananta@google.com, ricarkol@google.com, eric.auger@redhat.com, stable@vger.kernel.org, alexandru.elisei@arm.com, oupton@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Aug 2021 19:03:05 +0100, Marc Zyngier wrote:
> When a mapped level interrupt (a timer, for example) is deactivated
> by the guest, the corresponding host interrupt is equally deactivated.
> However, the fate of the pending state still needs to be dealt
> with in SW.
> 
> This is specially true when the interrupt was in the active+pending
> state in the virtual distributor at the point where the guest
> was entered. On exit, the pending state is potentially stale
> (the guest may have put the interrupt in a non-pending state).
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Resample HW pending state on deactivation
      commit: 3134cc8beb69d0db9de651081707c4651c011621

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


