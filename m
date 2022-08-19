Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C7C59A410
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353671AbiHSQmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354122AbiHSQlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4B21296E1;
        Fri, 19 Aug 2022 09:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBE99B82822;
        Fri, 19 Aug 2022 16:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A702FC433D6;
        Fri, 19 Aug 2022 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660925356;
        bh=4Qe5bnMK7e8Vdu1dOTSY/frhtjwhHd6k+3/lBQwHc18=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cOBQl1LU96kx800WoiXna18ama0ZZh7LmAxs/US+MaNABdfaawbENZ/FLRBbNwRfw
         IHmh6x8+DK59rMZqFx8FE57uNfSoGtm+rpkl89KfnmQ/oAzDyWWX/TW5tQvgxRy+2H
         P8Bf95Ota2+1Hg5DzVnh5/WJL2Ye0uFJwIuJPE8FjjyD2z7qs8HwYt9FVF+SPRLF/Y
         BJCh5QublDGpsA4dqcGAIMx1AJC5boXCj1Z5op2KVD9NYzCItaYpbq5OfE6B4A8yOH
         Dkn3UGrRTG+12EPjm7/tJtFN2n4kc85MYBhzzDKgCQK5PsFDX6Ij5LW2HwgDCyNfvG
         WH9pxh6FhqYOA==
Received: by mail-ua1-f52.google.com with SMTP id e3so1955013uax.4;
        Fri, 19 Aug 2022 09:09:16 -0700 (PDT)
X-Gm-Message-State: ACgBeo3kqTzeyHmgmtj8tYSbgO8gOvjEpPRLp9EIVX4uTBKVHJlfO0ll
        8XqCrsmnQPpcVuclT+TrBcHWZO4/ap5DTGx18A==
X-Google-Smtp-Source: AA6agR4hVMZMGFZWoej1ekKhG9RcXxu/9rbogNBLoJnqbvFaaQCfUcXi+i0wkukb0+iHaKryynQ6hedqvzUCuuYfcVk=
X-Received: by 2002:ab0:4565:0:b0:395:b672:508 with SMTP id
 r92-20020ab04565000000b00395b6720508mr3119861uar.63.1660925355671; Fri, 19
 Aug 2022 09:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153829.135562864@linuxfoundation.org> <20220819153835.859060503@linuxfoundation.org>
In-Reply-To: <20220819153835.859060503@linuxfoundation.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 19 Aug 2022 11:09:04 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKY_Bq_-hd6xS-XSA9KZdDLUyj8PevD-_HniPyg9JqjRA@mail.gmail.com>
Message-ID: <CAL_JsqKY_Bq_-hd6xS-XSA9KZdDLUyj8PevD-_HniPyg9JqjRA@mail.gmail.com>
Subject: Re: [PATCH 5.10 146/545] dt-bindings: Update QCOM USB subsystem
 maintainer information
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 10:52 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Wesley Cheng <quic_wcheng@quicinc.com>
>
> [ Upstream commit e059da384ffdc93778e69a5f212c2ac7357ec09a ]
>
> Update devicetree binding files with the proper maintainer, and updated
> contact email.

I don't think this needs to go to stable.

> Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Link: https://lore.kernel.org/r/20220603021432.13365-1-quic_wcheng@quicinc.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  Documentation/devicetree/bindings/phy/qcom,qmp-usb3-dp-phy.yaml | 2 +-
>  Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml       | 2 +-
>  .../devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml         | 2 +-
>  .../devicetree/bindings/regulator/qcom,usb-vbus-regulator.yaml  | 2 +-
>  Documentation/devicetree/bindings/usb/qcom,dwc3.yaml            | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
