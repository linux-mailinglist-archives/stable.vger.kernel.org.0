Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D08A512DF95
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgAAQu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 11:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgAAQu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 11:50:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EDF206E6;
        Wed,  1 Jan 2020 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577897426;
        bh=GVB0XySnY6omxwBRK74O0aE84xztcOaMzlnpVdtS5sY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIZrsWsAWzJgSaW1GFPlQ5+nLZYlWPDpFD5GoIt7S4FCaUC0kq3qkYibDIffX6zkB
         zQ/zQKRmCpA0T+aApXFXJk8+ASkRD3PVP8zaqIbiZl5yExqgMOJP6lPfKRXAYG97bm
         5VIV5JgmeMjjeHVKbbLVMqlt/Y5AYj/WZ8Plajak=
Date:   Wed, 1 Jan 2020 17:50:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.9, 4.14, 4.19] perf strbuf: Remove redundant
 va_end() in strbuf_addv()
Message-ID: <20200101165023.GA2712976@kroah.com>
References: <20191224000203.14122-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224000203.14122-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 24, 2019 at 09:02:03AM +0900, Nobuhiro Iwamatsu wrote:
> From: Mattias Jacobsson <2pi@mok.nu>
> 
> commit 099be748865eece21362aee416c350c0b1ae34df upstream.
> 
> Each call to va_copy() should have one, and only one, corresponding call
> to va_end(). In strbuf_addv() some code paths result in va_end() getting
> called multiple times. Remove the superfluous va_end().
> 
> Signed-off-by: Mattias Jacobsson <2pi@mok.nu>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sanskriti Sharma <sansharm@redhat.com>
> Link: http://lkml.kernel.org/r/20181229141750.16945-1-2pi@mok.nu
> Fixes: ce49d8436cff ("perf strbuf: Match va_{add,copy} with va_end")
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  tools/perf/util/strbuf.c | 1 -
>  1 file changed, 1 deletion(-)

Now queued up, thanks.

greg k-h
