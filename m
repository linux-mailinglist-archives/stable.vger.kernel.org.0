Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAC53BFACE
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 14:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGHNCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 09:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhGHNCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 09:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1DC61481;
        Thu,  8 Jul 2021 12:59:22 +0000 (UTC)
Date:   Thu, 8 Jul 2021 13:59:19 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 2/2] selftest: use mmap instead of posix_memalign to
 allocate memory
Message-ID: <20210708125919.GB9966@arm.com>
References: <20210707184313.3697385-1-pcc@google.com>
 <20210707184313.3697385-3-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707184313.3697385-3-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 11:43:13AM -0700, Peter Collingbourne wrote:
> This test passes pointers obtained from anon_allocate_area to the
> userfaultfd and mremap APIs. This causes a problem if the system
> allocator returns tagged pointers because with the tagged address ABI
> the kernel rejects tagged addresses passed to these APIs, which would
> end up causing the test to fail. To make this test compatible with
> such system allocators, stop using the system allocator to allocate
> memory in anon_allocate_area, and instead just use mmap.
> 
> Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Fixes: c47174fc362a ("userfaultfd: selftest")
> Cc: <stable@vger.kernel.org> # 5.4
> Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
