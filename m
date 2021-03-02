Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4482632B26A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343762AbhCCAxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581538AbhCBS6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 13:58:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4024264F30;
        Tue,  2 Mar 2021 18:57:26 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lHACy-00GmGh-Fa; Tue, 02 Mar 2021 18:57:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>
Cc:     kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in guest exit
Date:   Tue,  2 Mar 2021 18:57:12 +0000
Message-Id: <161471117621.3770794.6810105085499786951.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210226181211.14542-1-will@kernel.org>
References: <20210226181211.14542-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Feb 2021 18:12:11 +0000, Will Deacon wrote:
> Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
> context") tracks the currently running vCPU, clearing the pointer to
> NULL on exit from a guest.
> 
> Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
> kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
> code to go off into the weeds when it saves the DISR assuming that the
> CPU context is embedded in a struct vCPU.
> 
> [...]

Applied to kvmarm-master/fixes, thanks!

[1/1] KVM: arm64: Avoid corrupting vCPU context register in guest exit
      commit: a8a0f5dbcdf57d89bb8d555c6423763d99a156c1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


