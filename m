Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8463DDE02
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhHBQwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 12:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhHBQwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 12:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD63D610FF;
        Mon,  2 Aug 2021 16:52:41 +0000 (UTC)
Date:   Mon, 2 Aug 2021 17:52:39 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <20210802165238.GL18685@arm.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802123830.2195174-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:38:29PM +0100, Marc Zyngier wrote:
> The HYP rodata section is currently lumped together with the BSS,
> which isn't exactly what is expected (it gets registered with
> kmemleak, for example).
> 
> Move it away so that it is actually marked RO. As an added
> benefit, it isn't registered with kmemleak anymore.
> 
> Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org #5.13

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
