Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E941557F81
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiFWQNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFWQNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B368027FD2
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F041B8229C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915DAC3411B;
        Thu, 23 Jun 2022 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000824;
        bh=rHOxf6BejIcABHanrjTro0BCApuqe0OrwVBdkk8uWhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvhnynkNlVYBmv/NmTSf/8QkTePcRMDcLJ7F99Yyrgnxv83oZ4eeRt2Kx2WJH8aPg
         07uDtWSkiH/UMw+Gy0/XFglsdJV15I/sWb6Jfsfv0LQ559/LfZPbCN1TlX49D8k+IN
         9Wxsfq7npUP6v7D+H09LN1cXNR91Un4FfFpSo338=
Date:   Thu, 23 Jun 2022 18:13:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Walle <michael@walle.cc>
Cc:     stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: backport of 8cb0cd68bef7 (dt-bindings: nvmem: sfp: Add clock
 properties)
Message-ID: <YrSRNRxrst+sBvYW@kroah.com>
References: <20220622114810.3398108-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622114810.3398108-1-michael@walle.cc>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 01:48:10PM +0200, Michael Walle wrote:
> Hi Greg,
> 
> This patch should have been picked for the 5.18 branch where the device
> tree binding was introcuded first, but instead it landed in -next without a
> Fixes: tag [1].
> 
> Now there is a backwards incompatible change between 5.18 and the upcoming
> 5.19. Thus, can this be picked up for the 5.18 tree?
> 
> More background can be found in [2].
> 
> -michael
> 
> [1] https://lore.kernel.org/r/3b8fc56f64508f7604f3b9e14b048568@walle.cc
> [2] https://lore.kernel.org/r/4a45db184fbadc278624571dfbeb5004@walle.cc

Now queued up, thanks.

greg k-h
