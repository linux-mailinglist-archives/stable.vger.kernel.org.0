Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C423450284C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiDOKdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 06:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiDOKcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 06:32:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414F3DF35
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 03:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C59B82DEC
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D26EC385A6;
        Fri, 15 Apr 2022 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650018611;
        bh=Y5nxhE01u2njuT8fZpPyZgZAqV+q+rkBjjaK6ZcO96I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmafjsC10QoEkmgWxjzXdOizLdl82BPSlGry5Jx+Vne7/VmZUmuVRY86bAmggrcnl
         igNLsHvR6GevikYIzz7+mpLKvYps0Q/fGyOI9M3WOZkHFDNnhuFb5vOXrw9KwHmlZr
         8eKqBhXLC5J50D9Mc5jCIX3iJ2D4gPB21HrLUqvI=
Date:   Fri, 15 Apr 2022 12:30:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, kuba@kernel.org,
        bjorn.andersson@linaro.org, quic_clew@quicinc.com,
        quic_deesin@quicinc.com, swboyd@chromium.org, elder@kernel.org
Subject: Re: [PATCH v2 0/3] net: ipa: backport for v5.15.y
Message-ID: <YllJMW8JGpmawLzN@kroah.com>
References: <20220414152131.713724-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414152131.713724-1-elder@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 10:21:28AM -0500, Alex Elder wrote:
> This series is a back-port for stable branch version 5.15 *only*.
> The IPA patches have already been applied to v5.16.y, and they are
> not required for versions prior to 5.15.
> 
> There was a missing prerequisite commit that prevented building the
> code successfully when back-porting to v5.15 was first attempted.
> That commit has been added to the front of this series.  All three
> commits otherwise cherry-pick cleanly.
> 
> Version 2 just adds my sign-off on the first patch (and is rebased).
> 
> 					-Alex
> 
> Alex Elder (2):
>   dt-bindings: net: qcom,ipa: add optional qcom,qmp property
>   net: ipa: request IPA register values be retained
> 
> Deepak Kumar Singh (1):
>   soc: qcom: aoss: Expose send for generic usecase
> 
>  .../devicetree/bindings/net/qcom,ipa.yaml     |  6 +++
>  drivers/net/ipa/ipa_power.c                   | 52 ++++++++++++++++++
>  drivers/net/ipa/ipa_power.h                   |  7 +++
>  drivers/net/ipa/ipa_uc.c                      |  5 ++
>  drivers/soc/qcom/qcom_aoss.c                  | 54 ++++++++++++++++++-
>  include/linux/soc/qcom/qcom_aoss.h            | 38 +++++++++++++
>  6 files changed, 161 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/soc/qcom/qcom_aoss.h
> 
> -- 
> 2.32.0
> 

All now queued up, thanks.

greg k-h
