Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD92561315E
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJaHtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaHtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:49:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B435764F
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47BFEB81188
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD6FC433D6;
        Mon, 31 Oct 2022 07:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667202560;
        bh=VvY0auFKerEEweXqVBe7CD172oz7o2zwvd2w+EkIGsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBOPZiHz8AZnJ2Fc/Uuqk39ZWwdH1R9DCdbd7ai28KInflCaDvpci9vB3pZu3veuJ
         RLzyL/HBakWovqhNUuEO+s0H9aSOX98BXA/o+7I1fJ+gTozK8ccyUtpWozneQCvqwy
         iuwcwsGp/8994zJKnPd4gXKEi9x7sUd8dH5eBsXM=
Date:   Mon, 31 Oct 2022 08:50:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 4.9-stable tree
Message-ID: <Y19+ORs+b9gZN15E@kroah.com>
References: <1666796846105131@kroah.com>
 <Y1rM/w5zV8im4Z8o@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1rM/w5zV8im4Z8o@monkey>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 11:25:03AM -0700, Mike Kravetz wrote:
> On 10/26/22 17:07, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> >From c90324c242ddfabe1cc328bdeda1e2cbf4b77d61 Mon Sep 17 00:00:00 2001
> From: Rik van Riel <riel@surriel.com>
> Date: Wed, 26 Oct 2022 13:28:04 -0700
> Subject: [PATCH] mm,hugetlb: take hugetlb_lock before decrementing
>  h->resv_huge_pages
> 
> commit 12df140f0bdfae5dcfc81800970dd7f6f632e00c upstream.

All now queued up, thanks.

greg k-h
