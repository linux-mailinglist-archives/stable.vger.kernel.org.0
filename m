Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02860341EF6
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCSOG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhCSOGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 10:06:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDFBC06174A;
        Fri, 19 Mar 2021 07:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vgQC0+TPzmYowFW0QVWSKyadeqMEkQC26WKjNxhcC5k=; b=I5IAKAe3Ts2G6FyAtWKU0bc2AG
        aJovX5vKT+E30CEkP5pJEqtvnxu/ckb7ajuv4UNsKRBlAlDmP6LCni83OIm/R/qrt22GsRBiIDFqq
        q3IUzYB9nLQhOOZ9iG38CIv6E8DfMjzJ/lP5HUVAerNcqsPuoPop5rmQJafQuDFPGg9ZdWhqEPWpp
        Pf7DO8NXof3I10zYCRr7yeLz0/tzRYr+C0fjfUxSRk2ZhV5nC17+nBNjrcnQVqOQzMPjmaEIR594B
        hxoG9vefWSPtRVhppM2dAuNGlBRCYOFaV/m1kbeVozhdZsZjI4v4YhTUArHgXYSpo62VCy4Tq9MwU
        JDVFS62w==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lNFle-004Uua-CB; Fri, 19 Mar 2021 14:06:23 +0000
Date:   Fri, 19 Mar 2021 14:06:22 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] io_uring: Try to merge io requests only for regular files
Message-ID: <20210319140622.GA3420@casper.infradead.org>
References: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 05:28:59AM +0000, Dmitry Monakhov wrote:
> Otherwise we may endup blocking on pipe or socket.
> 
> Fixes: 6d5d5ac ("io_uring: extend async work merge")

7 bytes of sha1 isn't enough.  You can set core.abbrev to 12 or upgrade
to a version of git from this decade to get that automatically.

> 2.7.4

... is from 2016, so you're five years out of date.  Don't get cut
off when git switches from SHA1.
