Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F892FC22D
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 10:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKNJIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 04:08:24 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:49433 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfKNJIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 04:08:24 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47DFyD3Dj2z9sSc; Thu, 14 Nov 2019 20:08:20 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 29430fae82073d39b1b881a3cd507416a56a363f
In-Reply-To: <20191104023305.9581-2-alastair@au1.ibm.com>
To:     "Alastair D'Silva" <alastair@au1.ibm.com>, alastair@d-silva.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>, Qian Cai <cai@lca.pw>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Allison Randal <allison@lohutok.net>
Subject: Re: [PATCH v5 1/6] powerpc: Allow flush_icache_range to work across ranges >4GB
Message-Id: <47DFyD3Dj2z9sSc@ozlabs.org>
Date:   Thu, 14 Nov 2019 20:08:20 +1100 (AEDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-11-04 at 02:32:53 UTC, "Alastair D'Silva" wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> When calling flush_icache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> Cc: stable@vger.kernel.org

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/29430fae82073d39b1b881a3cd507416a56a363f

cheers
