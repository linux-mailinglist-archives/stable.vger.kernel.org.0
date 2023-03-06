Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E296ACFF7
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 22:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCFVNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 16:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCFVNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 16:13:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7420770424;
        Mon,  6 Mar 2023 13:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEAC160A09;
        Mon,  6 Mar 2023 21:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28664C433EF;
        Mon,  6 Mar 2023 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678137228;
        bh=3MhRHHlpE1lnP+tWoJVTJYtxcPDvlY0XmXPWFB2LO8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yDmMzPOya+mNeCDFLmrE2N9KpCFwN3SFIAaxSf+wSafOR/tXdcXXxfD20+Z020udX
         vmGNFkn+3Fe0pprCr3btisH5vBepkuNyP3a8t9SLchGIMcnBw1ss6Ng/uCNsH8eFeD
         4dwxj34aGpxYRo4XO5o6RNzB/TbM6bpi5WXrMZng=
Date:   Mon, 6 Mar 2023 13:13:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     <mm-commits@vger.kernel.org>, <willy@infradead.org>,
        <vishal.moola@gmail.com>, <stable@vger.kernel.org>, <sj@kernel.org>
Subject: Re: +
 mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20230306131347.1bc804d86adf6bab09f67966@linux-foundation.org>
In-Reply-To: <5b44cbd0-c3c7-aa1d-5fbf-ef752c8f4343@huawei.com>
References: <20230304195241.6DD11C433EF@smtp.kernel.org>
        <5b44cbd0-c3c7-aa1d-5fbf-ef752c8f4343@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Mar 2023 15:01:39 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> > Link: https://lkml.kernel.org/r/20230304193949.296391-3-sj@kernel.org
> > Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
> 
> This is accepted in v6.3-rc1,
> 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > Cc: <stable@vger.kernel.org>	[6.2.x]
> so no need to stable ?

Yup, I'll remove that, thanks.
