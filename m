Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792616BBBF9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCOSYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCOSYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:24:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61F170F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1380B81DD3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 18:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33E8C433D2;
        Wed, 15 Mar 2023 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678904674;
        bh=GbGVQmsgbjKeIEXNiRHXf+jNK84m8HMDLQxFi1C96a0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zgQvdhURA3UHbWeD6Khe7cQp8zZEGXgMBxV8Z3DstgDlRbo36lHGQNzlRvADClunQ
         erNdkaCARl1Bq1vHQ701/vWqIQxlaqeDwj1AQxlJyNZJ71NJFLZscMD4bpssJpttNq
         gPdcMTJ0bDJNYZBm+J3ahHc5z++4vKi0TNOvQ2tA=
Date:   Wed, 15 Mar 2023 19:24:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH for-6.1.y] Revert "ASoC: codecs: lpass: register mclk
 after runtime pm"
Message-ID: <ZBINX5qbdmY5CQOD@kroah.com>
References: <20230315181900.2107200-1-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315181900.2107200-1-amit.pundir@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 11:49:00PM +0530, Amit Pundir wrote:
> This reverts commit 7b642273438cf500d36cffde145b9739fa525c1d which is
> commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 upstream.
> 
> This patch broke RB5 (Qualcomm SM8250) devboard. The device
> reboots into USB crash dump mode after following error:
> 
>     qcom_q6v5_pas 17300000.remoteproc: fatal error received: \
>     ABT_dal.c:278:ABTimeout: AHB Bus hang is detected, \
>     Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
> 
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
>  sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
>  sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
>  sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
>  sound/soc/codecs/lpass-wsa-macro.c |  9 +++++----
>  4 files changed, 23 insertions(+), 22 deletions(-)

Is this also reverted in Linus's tree?  If not, why not?

thanks,

greg k-h
