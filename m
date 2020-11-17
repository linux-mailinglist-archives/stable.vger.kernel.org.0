Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730E02B6896
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 16:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgKQPWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 10:22:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:44930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgKQPWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 10:22:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 85B29AC23;
        Tue, 17 Nov 2020 15:22:29 +0000 (UTC)
Date:   Tue, 17 Nov 2020 16:22:27 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rashmica Gupta <rashmica.g@gmail.com>
Subject: Re: [PATCH v2 2/8] powernv/memtrace: fix crashing the kernel when
 enabling concurrently
Message-ID: <20201117152227.GB15987@linux>
References: <20201111145322.15793-1-david@redhat.com>
 <20201111145322.15793-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111145322.15793-3-david@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 03:53:16PM +0100, David Hildenbrand wrote:
> Fixes: 9d5171a8f248 ("powerpc/powernv: Enable removal of memory for in memory tracing")
> Cc: stable@vger.kernel.org# v4.14+
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Rashmica Gupta <rashmica.g@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
