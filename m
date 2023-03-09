Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4EC6B18F3
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 02:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCIBz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 20:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCIBzz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 20:55:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCEA7B106;
        Wed,  8 Mar 2023 17:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95ED5619E4;
        Thu,  9 Mar 2023 01:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9083C433D2;
        Thu,  9 Mar 2023 01:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678326953;
        bh=7K1zDoYHvERoTGV0MPG9gBDxpCQuGkPoP45v7mpT59Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q2PEfWYKPm4UftxTQMS0NtgdbFDjMpZPEq9z6PC2G0Tbsfa6H/7zu5eHEgcXY0Toz
         wUKN8kuqZdtL1C3lz2nsuhTukTqBhLGHDdpeRcMaTQHzalm1pQCUlAPjcLDVlY7aBR
         sJAS9g2wAOAS6HeoLA26926K+A/Ta1k7a3lVdaKE=
Date:   Wed, 8 Mar 2023 17:55:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     Liam.Howlett@oracle.com, snild@sony.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Stable@vger.kernel.org
Subject: Re: [PATCH] maple_tree: Fix the error of mas->min/max in
 mas_skip_node()
Message-Id: <20230308175552.60b3f6a3efda2289dc6c5bc9@linux-foundation.org>
In-Reply-To: <20230307160340.57074-1-zhangpeng.00@bytedance.com>
References: <20230307160340.57074-1-zhangpeng.00@bytedance.com>
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

On Wed,  8 Mar 2023 00:03:40 +0800 Peng Zhang <zhangpeng.00@bytedance.com> wrote:

> The assignment of mas->min and mas->max is wrong. mas->min and mas->max
> should represent the range of the current node. After mas_ascend()
> returns, mas-min and mas->max already represent the range of the current
> node, so we should delete these assignments of mas->min and mas->max.
> 

Please fully describe the user-visible effects of the flaw, especially
when proposing a -stable backport.

