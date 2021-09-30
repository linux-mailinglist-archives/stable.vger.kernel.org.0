Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D801D41E1C3
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 20:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbhI3Sya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 14:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239130AbhI3Sya (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 14:54:30 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5055CC06176A;
        Thu, 30 Sep 2021 11:52:47 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i19so26049183lfu.0;
        Thu, 30 Sep 2021 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zsZzgfbUxGvjY/35BurfncfGOk+t4Oowod0eAnc2ywY=;
        b=D7wBGA4MHOGlZToVTsDa3JbYniANqoTYX/L6Nf4gW7M0qzAFuTAAmQT4b0mgmasKe1
         B13/UIE0PYaJ53o6dCSwAeSoc7wpvW2mHhhGhij/ZeDEjjVSsYmD1kYBGvvlFczFo0WV
         jfET0P/eh9p6p6HZrKVCSeWXoPpzIrxV+YesYe9n/bhkGIrpkhcCJdM/aG0V1EGp0USs
         B9y71wxNnfgalkU/Y0ExhC7ttpwhxmEJDtBZbhK5oiXRRjTM9OUmsEqwSmDcVr5dRnzk
         uLFeE0+VikbsX+VUIz64f9vqBcOi72dUJws2t/P8+53sAK9ZmczIZcjCmCbYoPPOKg1t
         nxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zsZzgfbUxGvjY/35BurfncfGOk+t4Oowod0eAnc2ywY=;
        b=UyVaXWYuLnxXVSgQfi9G7gCUZ4KT5dHtThAJv0H1z/EHhXHPVUBGEdpArQRy0l6ZQV
         +/cmErZb1ctI75AK5ADBFj422LfOM0XqWytVsQnAaACoWmj+nKRvBV4uic0MKbtYsoqa
         kAMetLxJfF2YCUpZ+Chn3c0PQI+7Oz4X1xEufaRLL46fSyOFm9JUGUUdHdfzzUKHMKjY
         04Q6NlYysAIWr+e+Zdh/cKFhZv5yxGK20jySfcTnLsNIUL5PW+47ebXVxcQH5vsnRTXY
         GrN+GqJAfUS126wkSq3lFLik8/y93Gp/gJVQ9diZEgKLJTFDEeEW8WKWZKkSgGgOEgJC
         2WqQ==
X-Gm-Message-State: AOAM530nT3nvCA8SDsCqLTP4FJgfWt+2/1k2TwoUlwkW712neuGgkvJn
        /SoiUUBrUxa7NSz2jfPw0i8xkl0cY3e/MUxTYkk=
X-Google-Smtp-Source: ABdhPJyuLNTMt0ZfVRJivxJBhQSBqt1uAJ+pmxKpumn8GqdqEowJcyZIyMRooTQjTfPV8wn3f2cuHNFaz00vrHt0a6Y=
X-Received: by 2002:a2e:a26b:: with SMTP id k11mr7698881ljm.185.1633027964954;
 Thu, 30 Sep 2021 11:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210930155633.2745201-1-frieder@fris.de> <20210930155633.2745201-9-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-9-frieder@fris.de>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Thu, 30 Sep 2021 20:52:33 +0200
Message-ID: <CAEyMn7YbYAUvxEgKDB4x4AGomhBeuBDj71b2LuCs1A2emToU0w@mail.gmail.com>
Subject: Re: [PATCH 8/8] arm64: dts: imx8mm-kontron: Leave reg_vdd_arm always
 powered on
To:     Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Frieder,

Am Do., 30. Sept. 2021 um 17:57 Uhr schrieb Frieder Schrempf <frieder@fris.de>:
>
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> When the cpufreq driver is enabled, the buck2 regulator is kept powered on
> by the dependency between the CPU nodes with 'cpu-supply' set. Without the
> cpufreq driver the kernel will power off the regulator as it doesn't see
> any users. This is obviously not what we want, therefore keep the regulator
> powered on in any case.
>
> Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Tested-by: Heiko Thiery <heiko.thiery@gmail.com>

> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> index 213014f59b46..c3418d263eb4 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> @@ -105,6 +105,7 @@ reg_vdd_arm: BUCK2 {
>                                 regulator-min-microvolt = <850000>;
>                                 regulator-max-microvolt = <950000>;
>                                 regulator-boot-on;
> +                               regulator-always-on;
>                                 regulator-ramp-delay = <3125>;
>                                 nxp,dvs-run-voltage = <950000>;
>                                 nxp,dvs-standby-voltage = <850000>;
> --
> 2.33.0
>
