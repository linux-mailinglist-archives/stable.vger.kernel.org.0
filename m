Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E23796BB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhEJSBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 14:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232262AbhEJSBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 14:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01681611BD;
        Mon, 10 May 2021 18:00:32 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Evgenii Stepanov <eugenis@google.com>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [PATCH v2] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
Date:   Mon, 10 May 2021 19:00:31 +0100
Message-Id: <162066962704.23704.7597765574879024372.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210507185905.1745402-1-pcc@google.com>
References: <20210507185905.1745402-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 May 2021 11:59:05 -0700, Peter Collingbourne wrote:
> A valid implementation choice for the ChooseRandomNonExcludedTag()
> pseudocode function used by IRG is to behave in the same way as with
> GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
> which must have a non-zero value in order for IRG to properly produce
> pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
> on soft reset and thus may reset to 0. Therefore we must initialize
> RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
> as expected.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
      https://git.kernel.org/arm64/c/37a8024d2655

-- 
Catalin

