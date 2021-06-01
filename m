Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71F3974B8
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhFAN6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFAN6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:58:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89827C061574;
        Tue,  1 Jun 2021 06:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PYkGLsUaYHx4YUXUEF2hLnezEVw9FCUy2NVjB346Zfs=; b=JbKOgLZ4P7H+naEMxvc0KYDB4j
        K6EbAI4f5D/cBecypuyT8x4iYHEmXZclSnek5vxp8P5K/MpKNz6h4OA4TO9MPbwoauFQODuiqQODx
        cqH5udgQoBFYkq5PEMM8sCGL0lHqo6SlmlHmw/FKd7T5+rTwRhXwLkDN1fn5B/EcZSYvmJAJ2OZo9
        J8TSbXSoKqWHbyiHs/I2MJKsU56d0HIT660bDum83vPpwY2yph9IAziTWBd3o7wwFNQKaC72xx0Fn
        G36fnzkLjz04r+S/0tPoqS2GmQBZVvi3m1Og86vxN4QuMS3FgsxOs2G/grgYtPJoBf0O6S1Dj0f25
        wm5ABzNg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lo4sp-00A5Vk-Ja; Tue, 01 Jun 2021 13:56:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2EACA30019C;
        Tue,  1 Jun 2021 15:56:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 64958286DEB1A; Tue,  1 Jun 2021 15:56:37 +0200 (CEST)
Date:   Tue, 1 Jun 2021 15:56:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        yao.jin@linux.intel.com, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] perf/x86/intel/uncore: Fix M2M event umask for
 Ice Lake server
Message-ID: <YLY8lZ+YuvJ6Uj33@hirez.programming.kicks-ass.net>
References: <1622552943-119174-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622552943-119174-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 06:09:03AM -0700, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> Perf tool errors out with the latest event list for the Ice Lake server.
> 
> event syntax error: 'unc_m2m_imc_reads.to_pmm'
>                            \___ value too big for format, maximum is 255
> 
> The same as the Snow Ridge server, the M2M uncore unit in the Ice Lake
> server has the unit mask extension field as well.
> 
> Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
> Reported-by: Jin Yao <yao.jin@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org

Thanks!
