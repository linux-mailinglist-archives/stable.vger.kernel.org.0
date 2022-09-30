Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F25F1327
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 22:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbiI3UF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 16:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiI3UFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 16:05:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26ED12417E
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:05:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r18so11219463eja.11
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=FSnWEFqvu0sKIXdGnUiQR7VfRWkAet9cenDbxULwh2w=;
        b=Ul5ze0+/2m4BXfb95pG+apPjLW7jTgNgFl7FFgLeM9QESeTVv3x521/Dujq22sTS8p
         br6ks7PSUfFdwzc07cRO5UMPNGuzaWe7CWDOE/YE1+22sI58Y5wyGnDngS8SOBNK/lI/
         fakh9nc3+22GwofHyn9IXl4zXFhHsJw3yKq3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FSnWEFqvu0sKIXdGnUiQR7VfRWkAet9cenDbxULwh2w=;
        b=KSxTd/Zo9/9vK4Jfe/g2EfWw3L1Q0cUaxo2NGi9f/zzJdg3I8xrBgQJBaAs1ejjdua
         +06sg4FmBmY1X/k/YgPjJPpr4UXHANXNNVbpIwBX9lj2MzyUd5p8GC4oTLuTrDfpfj4p
         JSlZxeBiXtFbQhALABriQQkV/2dIvUTFSHVhUdSDXFwF8Xl+A9CfV3m6xxH7oSYrilX1
         cW7w0+WmwX8XMyV1amcu38ESaXvCS689CUbQKEYLQE2zoNdkeowoa6lsFLQ24POJO6dk
         eV4K5UjOJI/XIKvXFPj535dviHR00CRE5MFyaqR3LoeauTC50CcLyDv20ajQuAsCToR8
         V5gQ==
X-Gm-Message-State: ACrzQf11HHO/3++fFQFYpkmjZG2gmJkHmEH6AhLBAboB8PCPr2vrBqC0
        GDiu3HPbQe+3Ho+JKO0KUp3+XiXEa9NqxmoP
X-Google-Smtp-Source: AMsMyM7T9+0KUU13cPHSFCtqI8be/LEU07FzP3BCzLbE65tXgUFRGGwG4txBZYRSpnCToGL6r+olkA==
X-Received: by 2002:a17:906:fd84:b0:730:acee:d067 with SMTP id xa4-20020a170906fd8400b00730aceed067mr7728773ejb.206.1664568345420;
        Fri, 30 Sep 2022 13:05:45 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709060cc100b0078246b1360fsm1609592ejh.131.2022.09.30.13.05.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 13:05:45 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id m4so8383438wrr.5
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:05:45 -0700 (PDT)
X-Received: by 2002:a5d:6488:0:b0:22b:3b0b:5e72 with SMTP id
 o8-20020a5d6488000000b0022b3b0b5e72mr7002267wri.138.1664568344847; Fri, 30
 Sep 2022 13:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org> <20220930182212.209804-3-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220930182212.209804-3-krzysztof.kozlowski@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 30 Sep 2022 13:05:33 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UZBL7SbLkkjYs0dSAxjLPnVW3dd_UfoPB8L_Hf0MhvLw@mail.gmail.com>
Message-ID: <CAD=FV=UZBL7SbLkkjYs0dSAxjLPnVW3dd_UfoPB8L_Hf0MhvLw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Fritz Koenig <frkoenig@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Sep 30, 2022 at 11:22 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> There is no "bias-no-pull" property.  Assume intentions were disabling
> bias.
>
> Fixes: 79e7739f7b87 ("arm64: dts: qcom: sdm845-cheza: add initial cheza dt")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> ---
>
> Not tested on hardware.
> ---
>  arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
