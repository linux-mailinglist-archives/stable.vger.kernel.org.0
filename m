Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D494FAF0C
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbiDJQuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiDJQuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 12:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2224B840;
        Sun, 10 Apr 2022 09:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146C26113C;
        Sun, 10 Apr 2022 16:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8806CC385A1;
        Sun, 10 Apr 2022 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649609268;
        bh=hO9A2F/25MAoV4v+nd/ot/P4QBj++EwbRLucOjDye0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KXdQur3tYIB8K/1YvCrqOdtNHzPwNYebCDK5YSi3HeC3OARPu7kQeEy/7IRXGi2+3
         jXKqDQLraE6674gC3MfbDlXtfrrS9BPsXplfsvUTMIOtIhKTv393iF+gr5Th5Bvo/B
         Gf9hO5EFYTRldDHzW/YWwCyrf/TIYGirF2Oq2uPc3FZ3Zz7LtFDPi3OZx6gUqsGz30
         /LMf540KeZ7yVhpP0l2ew8gZhG2cM6xzGAzMbLpVfVF0T34cLUmDRsSLH+EkfYvoAr
         M2jJzEL7JJOv29A2qp6jqTJlwn9HeGETkLNK+Cw3BhN7eVNswm4juCb/uci1WIu4UT
         BI1nXRjciCU2g==
Date:   Sun, 10 Apr 2022 17:55:39 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, robh+dt@kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/8] iio: sx9324: Fix default precharge internal
 resistance register
Message-ID: <20220410175539.4741d312@jic23-huawei>
In-Reply-To: <20220410174952.6660e013@jic23-huawei>
References: <20220406165011.10202-1-gwendal@chromium.org>
        <20220406165011.10202-2-gwendal@chromium.org>
        <CAE-0n532f37UD8OyiFc0_ROzgc24Hb=aOYN+ALgruiehiNTfuQ@mail.gmail.com>
        <20220410174952.6660e013@jic23-huawei>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Apr 2022 17:49:52 +0100
Jonathan Cameron <jic23@kernel.org> wrote:

> On Wed, 6 Apr 2022 10:14:01 -0700
> Stephen Boyd <swboyd@chromium.org> wrote:
> 
> > Quoting Gwendal Grignou (2022-04-06 09:50:04)  
> > > Fix the default value for the register that set the resistance:
> > > it has to be 0x10 per datasheet.
> > >
> > > Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > > ---    
> > 
> > Reviewed-by: Stephen Boyd <swboyd@chromium.org>  
> Applied to the fixes-togreg branch of iio.git.
> 
> I'm crossing my fingers that I'll be able to simultaneously
> queue this fix and the rest of the series on different branches
> without any significant merge problems...
I can't :(  So I'll have to wait for this one to
work it's way around to being upstream for my togreg branch.
Hence holding the rest for now.

Jonathan

> 
> Jonathan
> 

