Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDC581A14
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 21:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiGZTGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 15:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiGZTGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 15:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2861AD88
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 12:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7746151D
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 19:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09CCC433C1;
        Tue, 26 Jul 2022 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658862408;
        bh=uVEK4X3+ZAd5ynFN+0mycH9egCEFflQb/U7Rl/9aE40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YSZcv8S3Oyisik20CD/uHqwVLjKt9rboPRdX6IuG7G3g3qB44JA+zkP84BG3V07jy
         IRDFMCD2MCVFwoIwgciLDUCLk4/Dclfff6Hvz55V08ehW3jfpk3CHvOZwYfd3nkehx
         FLevyaWl+fvHscl/mvqD+4W0vmPksGTU2NB3b0so=
Date:   Tue, 26 Jul 2022 12:06:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/hmm: fault non-owner device private entries
Message-Id: <20220726120646.88badf17bf26527d9238bc14@linux-foundation.org>
In-Reply-To: <13611387-35ce-b03c-261d-96ba305c9061@nvidia.com>
References: <20220725183615.4118795-1-rcampbell@nvidia.com>
        <20220725183615.4118795-2-rcampbell@nvidia.com>
        <87mtcwacg7.fsf@nvdebian.thelocal>
        <13611387-35ce-b03c-261d-96ba305c9061@nvidia.com>
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

On Tue, 26 Jul 2022 09:51:24 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:

> >> Cc: stable@vger.kernel.org
> >> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> > This should be 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
> 
> Looks better to me too.
> I assume Andrew will update the tags.

Yes, I updated the patch.
