Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A46D5B05B1
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiIGNvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 09:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiIGNvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 09:51:01 -0400
X-Greylist: delayed 317 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 06:50:47 PDT
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A3F140BF8
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 06:50:46 -0700 (PDT)
Received: from 8bytes.org (p4ff2bb62.dip0.t-ipconnect.de [79.242.187.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 9925F40793;
        Wed,  7 Sep 2022 15:45:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1662558328;
        bh=iFiaRZ7atn07KtTJA7EX1xTm4N7M+wbNCgbxCsXt6Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiCtPyNdqHxtBjuEcikhA6TYHpIaQ8bPP05J5GUs6etfMDU5/fh+/tAQEiWCD3/FM
         W1C4r/FZ5AAo9bF/QzBv6+1Rhp3LdH3aE7kxnw/hcSIhnI99R6EcVy/cylBBHUXSC1
         mx/+c26Hu8aIG3aVAbc7es7hp3tYgRCWywpbZs3FoCuZHmGY0QFCgESio3LKtGdWc1
         YCheiFy5UAybYr2J5c1+XeS5JHBq27r9oIPjf5F6r6sKHWmJ9WXVUs0cSgqlWzRDI5
         RT5HFx7gNd7EkPFG/nM+y9aWj0GU55rXpE77WTcZarorEyMrZc4gMzwx4Jx9QtDOMK
         gPhl4x0trSGcw==
Date:   Wed, 7 Sep 2022 15:45:27 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, robin.murphy@arm.com,
        virtualization@lists.linux-foundation.org, iommu@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] iommu/virtio: Fix interaction with VFIO
Message-ID: <Yxigd/hKLp8g6UfJ@8bytes.org>
References: <20220825154622.86759-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825154622.86759-1-jean-philippe@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 04:46:24PM +0100, Jean-Philippe Brucker wrote:
> Cc: stable@vger.kernel.org
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
> Since v2 [1], I tried to refine the commit message.
> This fix is needed for v5.19 and v6.0.

Applied for 6.0, thanks.

