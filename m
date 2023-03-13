Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADFC6B75C9
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCMLTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCMLTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:19:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DACB1B2DF
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 04:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C60C61044
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 11:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5C6C433D2;
        Mon, 13 Mar 2023 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678706338;
        bh=GRsBVGBVU4HpPC1Fh/unWissnw5sPg7oVN64UrFAQVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V79+zDJwMmoPFQ1iHR2oX4Z91+7JRLNklLHJkA2w8UGgT2E4ti5LPAps76jNo7ltO
         2LvpOeoprHHNNAJc68/lIX2BXqsgTlzMvQbSY+uMYv9ulWoOzeRLOzR/0t/tx+7shl
         TSxjVQuTZLhXVNGNR8BtcALr7FQevBURgyoUJNfjtycAnfMjvUtWGjX0TZD8GTl5dJ
         tWMa/ozX+rqKt/2Ra2f7uRPZsl8RB9GNK2VQsww4VD4xOQ74bgfuAgoQFLDQhvhGgG
         CL/VdlH7vtsmB58HuXGnfIvwUB/YPu0YK5One7zSI3e9DpoOyC4M2eRMUKA8aWEg6c
         mUe4H57ZwbYrQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgDf-000691-EZ; Mon, 13 Mar 2023 12:19:59 +0100
Date:   Mon, 13 Mar 2023 12:19:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Refactor
 __irq_domain_alloc_irqs()" failed to apply to 5.15-stable tree
Message-ID: <ZA8G3/5Ujsl2/Sc6@hovoldconsulting.com>
References: <1678128515101149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678128515101149@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 07:48:35PM +0100, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> git checkout FETCH_HEAD
> git cherry-pick -x d55f7f4c58c07beb5050a834bf57ae2ede599c7e
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678128515101149@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
> 
> Possible dependencies:
> 
> d55f7f4c58c0 ("irqdomain: Refactor __irq_domain_alloc_irqs()")

The below commit applies fine to 5.15.y. Could you try cherry-picking it
again?

Johan
 
> ------------------ original commit in Linus's tree ------------------
> 
> From d55f7f4c58c07beb5050a834bf57ae2ede599c7e Mon Sep 17 00:00:00 2001
> From: Johan Hovold <johan+linaro@kernel.org>
> Date: Mon, 13 Feb 2023 11:42:47 +0100
> Subject: [PATCH] irqdomain: Refactor __irq_domain_alloc_irqs()
> 
> Refactor __irq_domain_alloc_irqs() so that it can be called internally
> while holding the irq_domain_mutex.
> 
> This will be used to fix a shared-interrupt mapping race, hence the
> Fixes tag.
> 
> Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
> Cc: stable@vger.kernel.org      # 4.8
> Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230213104302.17307-6-johan+linaro@kernel.org
