Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7736755F7CD
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiF2HDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiF2HDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:03:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D7A3CFFD;
        Wed, 29 Jun 2022 00:01:28 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LXsng1F2yz4xXj;
        Wed, 29 Jun 2022 17:01:27 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc:     Mike Rapoport <rppt@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu>
References: <95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/book3e: Fix PUD allocation size in map_kernel_page()
Message-Id: <165648606412.2953426.2179337415180941004.b4-ty@ellerman.id.au>
Date:   Wed, 29 Jun 2022 17:01:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 10:56:17 +0200, Christophe Leroy wrote:
> Commit 2fb4706057bc ("powerpc: add support for folded p4d page tables")
> erroneously changed PUD setup to a mix of PMD and PUD. Fix it.
> 
> While at it, use PTE_TABLE_SIZE instead of PAGE_SIZE for PTE tables
> in order to avoid any confusion.
> 
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/book3e: Fix PUD allocation size in map_kernel_page()
      https://git.kernel.org/powerpc/c/986481618023e18e187646b0fff05a3c337531cb

cheers
