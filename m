Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8042B5E2B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKQLWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727321AbgKQLWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:22:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F78B221F8;
        Tue, 17 Nov 2020 11:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605612141;
        bh=GXG2wpiFphoY9JcnU69PcCsaVedaNSTVhdJdNl0+DeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C9AOubgR/b3oV28WQxI53myeZmJxFxMimTvZX5q3IJvFZRLjeNeziJQ1ymIVw4r4p
         EWQwPWH0AKuTtxcorZd/18izxTWLacwB77U0Z8h2bBMBu0KUwD57Fue/JhfjVlsESI
         Qm5ibRTMKc3GnNKI/r9xfUeRl2vKn94knDePn/hs=
Date:   Tue, 17 Nov 2020 12:23:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, peterz@infradead.org,
        mingo@kernel.org, mathieu.poirier@linaro.org, kiyin@tencent.com,
        dan.carpenter@oracle.com
Subject: Re: [v4.9.y] backport of few missed perf fixes
Message-ID: <X7OynckqadusPjk2@kroah.com>
References: <20201112133112.w3z6vyq5m5p7aowx@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201112133112.w3z6vyq5m5p7aowx@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 01:31:12PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> These are few missing commits for stable v4.9.y branch.

<snip>

> 
> Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> Signed-off-by: "kiyin(尹亮)" <kiyin@tencent.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
> Cc: Anthony Liguori <aliguori@amazon.com>
> --
>  kernel/events/core.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> [sudip: Backported to 4.9: adjust context]
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  kernel/events/core.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Odd way to add your s-o-b :)

I've queued these and the 4.14 patches up, thanks.

greg k-h
