Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DAD392AEE
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhE0JkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235675AbhE0JkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 05:40:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4BD613E6;
        Thu, 27 May 2021 09:38:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lmCTT-003uZK-7Z; Thu, 27 May 2021 10:38:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kernel-team@android.com, stable@vger.kernel.org,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Prevent mixed-width VM creation
Date:   Thu, 27 May 2021 10:38:37 +0100
Message-Id: <162210830475.2571522.12133742975467988953.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524170752.1549797-1-maz@kernel.org>
References: <20210524170752.1549797-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, maz@kernel.org, kernel-team@android.com, stable@vger.kernel.org, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 18:07:52 +0100, Marc Zyngier wrote:
> It looks like we have tolerated creating mixed-width VMs since...
> forever. However, that was never the intention, and we'd rather
> not have to support that pointless complexity.
> 
> Forbid such a setup by making sure all the vcpus have the same
> register width.

Applied to fixes, thanks!

[1/1] KVM: arm64: Prevent mixed-width VM creation
      commit: 66e94d5cafd4decd4f92d16a022ea587d7f4094f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


