Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2D673629
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 11:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjASK4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 05:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjASKzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 05:55:50 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61A4ABEB;
        Thu, 19 Jan 2023 02:55:48 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 961E61EC066E;
        Thu, 19 Jan 2023 11:55:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674125746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lcn4N9fyTNKvQ9zDDgSsMMj+iC85MnhL8BdRTj/QuUc=;
        b=UJ1aPOmNZShmaszWSUDN9rjRZZGSdUEe9ga9RRiAfvunb/f9l33MDGZve1NateXvqhdnNg
        tKGrcT2D2yNg32I5iIsvVaBhbuQr4C1feTi1kJNUPjIgtvBePdGOZwkf8Ic7/JKTm33Q8N
        NIHVA2Zng7ESr7fqw9BMivFQYGLvrbg=
Date:   Thu, 19 Jan 2023 11:55:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, tony.luck@intel.com,
        quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 01/17] EDAC/device: Respect any driver-supplied
 workqueue polling value
Message-ID: <Y8khrX3rNL0C7sNY@zn.tnic>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118150904.26913-2-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 08:38:48PM +0530, Manivannan Sadhasivam wrote:
> The EDAC drivers may optionally pass the poll_msec value. Use that value
> if available, else fall back to 1000ms.
> 
>   [ bp: Touchups. ]
> 
> Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
> Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
> Cc: <stable@vger.kernel.org> # 4.9
> Link: https://lore.kernel.org/r/COZYL8MWN97H.MROQ391BGA09@otso
> ---
>  drivers/edac/edac_device.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
