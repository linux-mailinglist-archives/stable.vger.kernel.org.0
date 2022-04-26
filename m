Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BF50F149
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245606AbiDZGph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245611AbiDZGoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B4CE099;
        Mon, 25 Apr 2022 23:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0287CB81C1E;
        Tue, 26 Apr 2022 06:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF1AC385AE;
        Tue, 26 Apr 2022 06:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650955250;
        bh=6torebe632s6Xh8593qZioLSF0dyeFQL93aZy68b2AU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKqg1mY+zPEmj0CIcvgxqV4kN9oczi+6n9FcLrbgXCfl5q87ug6obd0BE2YwGn9br
         TLqNHVJjwZBc6mpkwIhwg+OhDd0BOYJAhU2fIH3ncr9w/GfHLFhdG4OpTr1q1MenZS
         bI5u0Ya/Ie5vBC6/MSi4RxceFLOFb1/F1gkCWe7c=
Date:   Tue, 26 Apr 2022 08:40:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
Message-ID: <YmeT7yC4896tlwi9@kroah.com>
References: <20220421220011.1750952-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421220011.1750952-1-elder@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 05:00:11PM -0500, Alex Elder wrote:
> commit 73419e4d2fd1b838fcb1df6a978d67b3ae1c5c01 upstream.
> 
> At least three platforms require the "qcom,qmp" property to be
> specified, so the IPA driver can request register retention across
> power collapse.  Update DTS files accordingly.
> 
> Cc: <stable@vger.kernel.org>    # 5.15.x
> Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
> Signed-off-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Link: https://lore.kernel.org/r/20220201140723.467431-1-elder@linaro.org
> ---
> Enable this feature, now that 8ff8bdb8c92d6 ("net: ipa: request IPA
> register values be retained") has been accepted into linux-5.15.y.

Both now queued up, thanks.

greg k-h
