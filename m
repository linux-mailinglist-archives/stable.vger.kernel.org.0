Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837D23501EF
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhCaOKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 10:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235987AbhCaOJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 10:09:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F6060FDA;
        Wed, 31 Mar 2021 14:09:58 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lRbXg-004ukh-6k; Wed, 31 Mar 2021 15:09:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     David Brazdil <dbrazdil@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Support PREL/PLT relocs in EL2 code
Date:   Wed, 31 Mar 2021 15:09:52 +0100
Message-Id: <161719959909.4006212.10052506514541179289.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210331133048.63311-1-dbrazdil@google.com>
References: <20210331133048.63311-1-dbrazdil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, stable@vger.kernel.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 31 Mar 2021 13:30:48 +0000, David Brazdil wrote:
> gen-hyprel tool parses object files of the EL2 portion of KVM
> and generates runtime relocation data. While only filtering for
> R_AARCH64_ABS64 relocations in the input object files, it has an
> allow-list of relocation types that are used for relative
> addressing. Other, unexpected, relocation types are rejected and
> cause the build to fail.
> 
> [...]

Applied to kvm-arm64/misc-5.13, thanks!

[1/1] KVM: arm64: Support PREL/PLT relocs in EL2 code
      commit: 77e06b300161d41d65950be9c77a785c142b381d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


