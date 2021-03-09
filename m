Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA522332AB4
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 16:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCIPit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 10:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhCIPih (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 10:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF3265238;
        Tue,  9 Mar 2021 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615304316;
        bh=ywcMiRWM7hxvvEevLFLmRZPE513OmPXFK30CWeV/bnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoqUOhWstxhc6j+BT+/nG/8KmEbGuGHDfQDJtT8PSM7qlmONXExdIkKFVOWoj2H09
         1g2RzuZpQ+02f6bqqZi8rlUz0CoRDN8AjCRK7HwdtX5U9LFzhZNcUbC4S+3KkddZPS
         OjfH/8iv5zwaG7ItlWupbSOr9a6AeArpIRMpXk5y7TLvAsu6y4eseQYyjxSVK6K43q
         nx21K4j/sVb/jpg5AnCpAg/cnPDDMTLRcv0MUa/E6u2iotAR4/RI6K6G+cuZ3/Awgm
         6uVTnu8QnOBRFeEAOl7LT2rHDAbHFUFhut6vo/f53S6J1Er6TLV1Pj9iWof7H0lkF8
         foE1sl5DjFgmw==
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL
Date:   Tue,  9 Mar 2021 15:38:29 +0000
Message-Id: <161529596129.3814589.13038514678630962150.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com>
References: <4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Mar 2021 17:10:23 +0100, Andrey Konovalov wrote:
> When CONFIG_DEBUG_VIRTUAL is enabled, the default page_to_virt() macro
> implementation from include/linux/mm.h is used. That definition doesn't
> account for KASAN tags, which leads to no tags on page_alloc allocations.
> 
> Provide an arm64-specific definition for page_to_virt() when
> CONFIG_DEBUG_VIRTUAL is enabled that takes care of KASAN tags.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL
      https://git.kernel.org/arm64/c/86c83365ab76

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
