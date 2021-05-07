Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4CE376741
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhEGOxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 10:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235877AbhEGOxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 10:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F4C61075;
        Fri,  7 May 2021 14:52:17 +0000 (UTC)
Date:   Fri, 7 May 2021 15:52:15 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
Message-ID: <20210507145215.GC26528@arm.com>
References: <20210507033725.1479129-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507033725.1479129-1-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 08:37:25PM -0700, Peter Collingbourne wrote:
> A valid implementation choice for the ChooseRandomNonExcludedTag()
> pseudocode function used by IRG is to behave in the same way as with
> GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
> which must have a non-zero value in order for IRG to properly produce
> pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
> on soft reset and thus may reset to 0. Therefore we must initialize
> RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
> as expected.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: stable@vger.kernel.org

Rather than a generic cc stable that goes all the way to 4.4, please
add:

Fixes: 3b714d24ef17 ("arm64: mte: CPU feature detection and initial sysreg configuration")
Cc: <stable@vger.kernel.org> # 5.10.x

Thanks.

-- 
Catalin
