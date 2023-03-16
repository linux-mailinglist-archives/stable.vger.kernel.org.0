Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FFC6BDCA3
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 00:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCPXFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 19:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCPXFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 19:05:14 -0400
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008B3DF71D;
        Thu, 16 Mar 2023 16:05:13 -0700 (PDT)
Received: by mail-il1-f169.google.com with SMTP id i19so1861056ila.10;
        Thu, 16 Mar 2023 16:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thMkU6ted+c8alWkbLjie9Y71TBDBsMu8SDhF9nCN7s=;
        b=zYY9KedhrnB2A826wquGNeVcom8a7YnfPiY50orNl6oSJqIahh32u2yWAzaetKYsi0
         BGQFU6jXY95nAeT1LbqyNZiAjlEEIXvYnqlDCLlJ5KlJ9ysfEGeLcUR7CAgRhJPmt+BE
         dlbyBB8Cd6HHLYyGyWPH4E4QiJ4CrMTXwCiCm45wi0R7asXIn8+51K7fU/UKD3qaiWJ0
         cmdnZlQDZOs9cRBHcQ6S25mbGBjIJNjBjRdP64ArcWoXZxLZ2Hc6+gHU58Z7YE8R1fhq
         N5x6hCeVAr2+uXW7u7qM0SyiURtwLdQaa2U4E+/DaTnF5K3/qT2r46mrnUiJmdsn5CBn
         YO6Q==
X-Gm-Message-State: AO0yUKXpkHqX1HOydv5h/3zxIIkZmdUUixkISpUmgcZgrFHI9jI3RV1z
        q6OYVcbgCQyD4Vyyf9Cr0A==
X-Google-Smtp-Source: AK7set+8oLHhJQmH6Hy7Rz+7+N2cSYpk23KfiyKAuIipRqOturr9duw5L/q51oU+HA1VHJOKO87qdA==
X-Received: by 2002:a05:6e02:1d04:b0:317:9891:8a28 with SMTP id i4-20020a056e021d0400b0031798918a28mr10902176ila.26.1679007913243;
        Thu, 16 Mar 2023 16:05:13 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id f46-20020a02242e000000b003c4e02148e5sm177775jaa.53.2023.03.16.16.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:05:12 -0700 (PDT)
Received: (nullmailer pid 4052527 invoked by uid 1000);
        Thu, 16 Mar 2023 23:05:10 -0000
Date:   Thu, 16 Mar 2023 18:05:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Venkata Prasad Potturu <quic_potturu@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] ASoC: dt-bindings: qcom,lpass-rx-macro: correct minItems
 for clocks
Message-ID: <167900791031.4052474.90763164656557078.robh@kernel.org>
References: <20230310100937.32485-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310100937.32485-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Fri, 10 Mar 2023 11:09:37 +0100, Krzysztof Kozlowski wrote:
> The RX macro codec comes on some platforms in two variants - ADSP
> and ADSP bypassed - thus the clock-names varies from 3 to 5.  The clocks
> must vary as well:
> 
>   sc7280-idp.dtb: codec@3200000: clocks: [[202, 8], [202, 7], [203]] is too short
> 
> Fixes: 852fda58d99a ("ASoC: qcom: dt-bindings: Update bindings for clocks in lpass digital codes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>

