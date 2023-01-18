Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B606727D7
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjARTF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 14:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjARTFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 14:05:23 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA771817B;
        Wed, 18 Jan 2023 11:05:21 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 134ED1EC0646;
        Wed, 18 Jan 2023 20:05:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674068720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9qHB2EOibAtLSrG+MwPw/tL0T1kkYYJw1nnGQj0Y0/E=;
        b=VkFM+cNi56Ng6zWoHeHfp5tI6VmPFFqLbgaeJeeungYbuMgTTg4FDoneqRPsmF1Wjj+EdU
        H9/Lx4AMGNA+LLrv+2abG+ZuQJzBCeK5OxNd5Os0Rk/vSHplwdMuaRMOr9aGR+RUnQmc+j
        /jzb1P4IN94GONAAshJp1w27nzA5xXY=
Date:   Wed, 18 Jan 2023 20:05:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        ahalaney@redhat.com, steev@kali.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 01/17] EDAC/device: Respect any driver-supplied
 workqueue polling value
Message-ID: <Y8hC6x1eO6GXJGI3@zn.tnic>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-2-manivannan.sadhasivam@linaro.org>
 <20230118174625.oo5gi36q45kfbgoq@builder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118174625.oo5gi36q45kfbgoq@builder.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 11:46:25AM -0600, Bjorn Andersson wrote:
> On Wed, Jan 18, 2023 at 08:38:48PM +0530, Manivannan Sadhasivam wrote:
> > The EDAC drivers may optionally pass the poll_msec value. Use that value
> > if available, else fall back to 1000ms.
> > 
> >   [ bp: Touchups. ]
> > 
> > Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
> > Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Your S-o-b should be the last one to indicate that you are the  one
> certifying the origin of this patch.

I took his and massaged it a bit.

I'll fix up the order properly when applying.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
