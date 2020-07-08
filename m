Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ADB21930B
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 00:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGHWDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 18:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGHWDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 18:03:04 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AF72078B;
        Wed,  8 Jul 2020 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594245784;
        bh=e728ffDVeqv3WeOeJ7GNFTrNtwbhwF2eVYgQ+USzSnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy98ets4HLJmLAdBvOCQPsDA1OhRQuMl+JiDC0T5A7ygtUZwqdMy6GtRuZR4MLp6C
         mqbLq25w8Mv3FBLj/VfgSomNK58RRM2Nvp1b1jtKvaxFlg2wkxJ15Qorwma5G5vyjR
         eGOTyRSmV8d+RnZ5OF0bNApntkE1LM6iOmL6JXb0=
From:   Will Deacon <will@kernel.org>
To:     Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
Date:   Wed,  8 Jul 2020 23:02:39 +0100
Message-Id: <159424054981.2034173.14116435447086960033.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708162546.26176-1-will@kernel.org>
References: <20200708162546.26176-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jul 2020 17:25:46 +0100, Will Deacon wrote:
> PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
> pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE which
> encodes attributes for EL1 stage-1 mappings such as UXN and nG, which are
> RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.
> 
> Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
> at EL2.

Applied to arm64 (for-next/fixes), thanks!

[1/1] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
      https://git.kernel.org/arm64/c/68cf617309b5

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
