Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF8A32B266
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbhCCAxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581539AbhCBS6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 13:58:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D528B64F2F;
        Tue,  2 Mar 2021 18:57:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lHACy-00GmGh-4N; Tue, 02 Mar 2021 18:57:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] kvm: arm64: nvhe: Save the SPE context early
Date:   Tue,  2 Mar 2021 18:57:11 +0000
Message-Id: <161471117620.3770794.12358302238773672698.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210302120345.3102874-1-suzuki.poulose@arm.com>
References: <20210302120345.3102874-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, mark.rutland@arm.com, stable@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021 12:03:45 +0000, Suzuki K Poulose wrote:
> The nVHE KVM hyp drains and disables the SPE buffer, before
> entering the guest, as the EL1&0 translation regime
> is going to be loaded with that of the guest.
> 
> But this operation is performed way too late, because :
>   - The owning translation regime of the SPE buffer
>     is transferred to EL2. (MDCR_EL2_E2PB == 0)
>   - The guest Stage1 is loaded.
> 
> [...]

Applied to kvmarm-master/fixes, thanks!

[1/1] kvm: arm64: nvhe: Save the SPE context early
      commit: cfe1e2b6949785e90e84918295f2be1b6fd152b6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


