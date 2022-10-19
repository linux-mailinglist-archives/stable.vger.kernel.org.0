Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDCE604C04
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiJSPrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJSPqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F37626ADB;
        Wed, 19 Oct 2022 08:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC9B4B823AC;
        Wed, 19 Oct 2022 15:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F2C433B5;
        Wed, 19 Oct 2022 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666194026;
        bh=5iL5zOpkFfjWVF0xfuYrHBqn0ovN+HVmFEHrIY1+Wl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=02MH5jdIwEu9jZlrBnb9IEubpyL+4rkAPj+goELaXuhqBpqlbUb0XT8fW2GW539EN
         aDfQWFIPrnsbvNcVJag6xj5IPqUUbeU39XtcaKAXblPuWysKx3w+FbvotLdUvJ7hCU
         m9oElNSlUB2ykenxHo/vyp4unN7CLI0LzidBo8mM=
Date:   Wed, 19 Oct 2022 17:40:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 438/862] arm64: dts: qcom: sc8280xp-pmics: Remove reg
 entry & use correct node name for pmc8280c_lpg node
Message-ID: <Y1AaZzpgDEG+idWg@kroah.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083309.338035619@linuxfoundation.org>
 <Y1AYtZVc5b7L+9Pj@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1AYtZVc5b7L+9Pj@hovoldconsulting.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 05:33:09PM +0200, Johan Hovold wrote:
> On Wed, Oct 19, 2022 at 10:28:45AM +0200, Greg Kroah-Hartman wrote:
> > From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > 
> > [ Upstream commit 7dac7991408f77b0b33ee5e6b729baa683889277 ]
> > 
> > Commit eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")
> > dropped PWM reg declaration for pm8350c pwm(s), but there is a leftover
> > 'reg' entry inside the lpg/pwm node in sc8280xp dts file. Remove the same.
> > 
> > While at it, also remove the unused unit address in the node
> > label.
> > 
> > Also, since dt-bindings expect LPG/PWM node name to be "pwm",
> > use correct node name as well, to fix the following
> > error reported by 'make dtbs_check':
> > 
> >   'lpg' does not match any of the regexes
> > 
> > Fixes: eeca7d46217c ("arm64: dts: qcom: pm8350c: Drop PWM reg declaration")
> 
> Despite the Fixes tag, this is not a bug a fix but rather a cleanup for
> compliance with the DT schema (for which there are thousands of similar
> warnings).
> 
> Please drop.

Now dropped, thanks.

greg k-h
