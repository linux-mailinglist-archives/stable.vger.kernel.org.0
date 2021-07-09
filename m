Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1843B3C2BA3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 01:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhGIXa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 19:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIXa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 19:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B3C1613B2;
        Fri,  9 Jul 2021 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625873264;
        bh=FPE3+BhCWyOoJj1St5NWSfhZrajf2+MELy947NPkjCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ROq96No2ekMQXtnoNmbFZOIeTknxLfvKGyk3X33N4C4ej1+bHMjFXkjyHxVVuNlZP
         ySJAXi7W+6vkdrM/9uzHW0SDgxti583pfThbKzECsAybx32n9l2Blnzv3Fh3qyhh3B
         34Kt75sRUCKqDUEQtwculdws9jxFO7YM6jSGFv1Y=
Date:   Fri, 9 Jul 2021 16:27:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
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
Message-Id: <20210709162742.ee10cac911a6304e97ab1b5e@linux-foundation.org>
In-Reply-To: <20210707184313.3697385-3-pcc@google.com>
References: <20210707184313.3697385-1-pcc@google.com>
        <20210707184313.3697385-3-pcc@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  7 Jul 2021 11:43:13 -0700 Peter Collingbourne <pcc@google.com> wrote:

> This test passes pointers obtained from anon_allocate_area to the
> userfaultfd and mremap APIs. This causes a problem if the system
> allocator returns tagged pointers because with the tagged address ABI
> the kernel rejects tagged addresses passed to these APIs, which would
> end up causing the test to fail. To make this test compatible with
> such system allocators, stop using the system allocator to allocate
> memory in anon_allocate_area, and instead just use mmap.

Doesn't apply to current mainline.  Can you please resync and redo?

> Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Fixes: c47174fc362a ("userfaultfd: selftest")
> Cc: <stable@vger.kernel.org> # 5.4

This patch then won't apply to earlier kenrels, so please be prepared
to help Greg resolve this.

