Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E62306AC
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 11:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgG1Jh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 05:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgG1Jh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 05:37:28 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D376E207E8;
        Tue, 28 Jul 2020 09:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595929048;
        bh=wP02xrsKYUNmDyHtJarWzJDBrD/jNyRBXPSTSxeL+zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXfGdVzYn6gO0cgYQPI+TElG3KbeGPHH7dlI6qTqsutL4c+leW9+MchRkUpbG8FAs
         gy9b1TsZmIq2Pap3ODFIYAx+d5yKhTCTLRqN36RURwomWTnP2GlEE7iJtcwaiUAR58
         TtijSnIpvmFSkRrSBDq5e6QH6GxuXCyZyXGdQzQs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k0M34-00Fbfk-BE; Tue, 28 Jul 2020 10:37:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>
Cc:     kernel-team@android.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: Don't inherit exec permission across page-table levels
Date:   Tue, 28 Jul 2020 10:37:22 +0100
Message-Id: <159592902849.3866216.16184306169833610349.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723101714.15873-1-will@kernel.org>
References: <20200723101714.15873-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org, kernel-team@android.com, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jul 2020 11:17:14 +0100, Will Deacon wrote:
> If a stage-2 page-table contains an executable, read-only mapping at the
> pte level (e.g. due to dirty logging being enabled), a subsequent write
> fault to the same page which tries to install a larger block mapping
> (e.g. due to dirty logging having been disabled) will erroneously inherit
> the exec permission and consequently skip I-cache invalidation for the
> rest of the block.
> 
> [...]

Applied to kvm-arm64/fixes-5.8-3, thanks!

[1/1] KVM: arm64: Don't inherit exec permission across page-table levels
      commit: b757b47a2fcba584d4a32fd7ee68faca510ab96f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


