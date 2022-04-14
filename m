Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE469500BB9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiDNLC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 07:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiDNLC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 07:02:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A500D3AA52
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 04:00:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4114A6122C
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 11:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244D5C385A1;
        Thu, 14 Apr 2022 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649934031;
        bh=hR7NaWxHM8LrEBOFeDXHCDx7DEgASu00D9zXQEw3Uu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U/iw42+1lCZ33GL9ceiuJxC8VrdNIV8nr5nDlSFTxiWXY9JZSE7jyJI/PHs+lHd6o
         Lxf7sTIuqB+GvkEFBpvcngj+UVs134pirVUNR8pcjjQdgJ1k05QwtAh62wpDkJE9vX
         4CzkWU/RR36bZuFEjnxm2vi9+yjs0WC1AD0j82oI=
Date:   Thu, 14 Apr 2022 13:00:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, Deepak Kumar Singh <deesin@codeaurora.org>,
        clew@codeaurora.org, swboyd@chromium.org,
        bjorn.andersson@linaro.org, kuba@kernel.org, elder@kernel.org
Subject: Re: [PATCH 1/3] soc: qcom: aoss: Expose send for generic usecase
Message-ID: <Ylf+zbeq9+fAidmn@kroah.com>
References: <20220413144811.522143-1-elder@linaro.org>
 <20220413144811.522143-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413144811.522143-2-elder@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 13, 2022 at 09:48:09AM -0500, Alex Elder wrote:
> From: Deepak Kumar Singh <deesin@codeaurora.org>
> 
> commit 8c75d585b931ac874fbe4ee5a8f1811d20c2817f upstream.
> 
> Not all upcoming usecases will have an interface to allow the aoss
> driver to hook onto. Expose the send api and create a get function to
> enable drivers to send their own messages to aoss.
> 
> Signed-off-by: Chris Lew <clew@codeaurora.org>
> Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Link: https://lore.kernel.org/r/1630420228-31075-2-git-send-email-deesin@codeaurora.org

You sent this on, so you should also sign-off on it, right?

thanks,

greg k-h
