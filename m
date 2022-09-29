Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5F5EFB20
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiI2Qnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiI2Qnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 12:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB215313E;
        Thu, 29 Sep 2022 09:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BE42B823CB;
        Thu, 29 Sep 2022 16:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82127C433D6;
        Thu, 29 Sep 2022 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664469820;
        bh=9mWQvPaVJjTbD04hy8ZtGKd+OjPSG6ReZ1r5wr7ScgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrD8DMR0dXa0Hgsm7+7cTFNdGjFTAfEiMc3TLwhA06TZa6VYLR8Rrwi3vulejjArh
         amcrfIcyUuLaQGZfcOuWcYAw2uLMCLY3p1IeXy5Mv/QmeFlkFt/kfbTp6Q/N720/th
         paCT8ns/XSQcqamUgeElU1A3oFJyHUqTiF/lIfJVOvYMwt/SZsyxM8BaduZyAaxc80
         ONtt9zjrZlUhCFqn9v4WXYlb40frxDfVm/kDHax0wPp9j2r8A6/L2BgqMF2XdcVlB5
         W9fDWtiJeqMvqEPvAltmx2QYNgO7evwlOXUBfP0zdt2hrWRbcksroa4VoyF7yOANzL
         jXk60xKwTppXw==
Date:   Thu, 29 Sep 2022 22:13:35 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom-adm: fix wrong sizeof config in
 slave_config
Message-ID: <YzXLNwf2hV1FN4NJ@matsya>
References: <20220915204844.3838-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915204844.3838-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15-09-22, 22:48, Christian Marangi wrote:
> Fix broken slave_config function that uncorrectly compare the
> peripheral_size with the size of the config pointer instead of the size
> of the config struct. This cause the crci value to be ignored and cause
> a kernel panic on any slave that use adm driver.
> 
> To fix this, compare to the size of the struct and NOT the size of the
> pointer.

Applied, thanks

-- 
~Vinod
