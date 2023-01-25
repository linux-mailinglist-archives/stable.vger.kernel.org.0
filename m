Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95367B34B
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 14:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbjAYN3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 08:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjAYN3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 08:29:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDD44B490;
        Wed, 25 Jan 2023 05:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8376B8199F;
        Wed, 25 Jan 2023 13:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A322C433EF;
        Wed, 25 Jan 2023 13:29:35 +0000 (UTC)
Date:   Wed, 25 Jan 2023 13:29:32 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, linux-mm@kvack.org,
        Saravana Kannan <saravanak@google.com>, stable@vger.kernel.org,
        Calvin Zhang <calvinzhang.cool@gmail.com>,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] Revert "mm: kmemleak: alloc gray object for reserved
 region with direct map"
Message-ID: <Y9EuvNGJOZ9KZzWH@arm.com>
References: <20230124230254.295589-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124230254.295589-1-isaacmanjarres@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 03:02:54PM -0800, Isaac J. Manjarres wrote:
> This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.
> 
> Kmemleak operates by periodically scanning memory regions for pointers
> to allocated memory blocks to determine if they are leaked or not.
> However, reserved memory regions can be used for DMA transactions
> between a device and a CPU, and thus, wouldn't contain pointers to
> allocated memory blocks, making them inappropriate for kmemleak to
> scan. Thus, revert this commit.
> 
> Cc: stable@vger.kernel.org # 5.17+
> Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
