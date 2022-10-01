Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4E05F1BA1
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJAJ6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 05:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJAJ6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 05:58:05 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91EAFA25F
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 02:58:03 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id l12so7130246ljg.9
        for <stable@vger.kernel.org>; Sat, 01 Oct 2022 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Lg74YdrNQ3T6av29vUZXf6jb0Fvwg0IUmRSwVmSXrvQ=;
        b=WWcl3zeNaFEKSQvjYL3BGfMNIzSduNPL7gEZy3456dhW6s04O63yPwKg8lVl/V7J66
         jx5cG2FWSiuEWP5dc4pMHEe0Bu/he4Z2oGyG0XSKPEdd8Ru3AR/PqB3P3p2r19lJAO5X
         02Msc6luM5pi4UvKmq4gMouGN538NOkbM63VE4RwPu8Yww6pjTxZdb4IxhHFoRYM3iu3
         jelDj7aLzXOsZzFFSPdN30/ROHtr48m2QHFTyMJn2Mgg00mk+qgUzkklSvdzpdL4ffM+
         eTWKPk3jZgd3i8I4wniSBiNWyHZ9jWSuiYBhvipLHjGZdp1c4itzCOggDgBbZ2llKP+L
         nXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Lg74YdrNQ3T6av29vUZXf6jb0Fvwg0IUmRSwVmSXrvQ=;
        b=2d9vy+oTMlX24jnKb8IZ+VMTlAE6y6hi5jlO2VgC2xgd5GaXL0ErW3xWBIxFZOiNnM
         kN9PMtMHPI3Ums88X58GFrVKhjbO6IaD5ebQXApHmoo2S+F1iaGAbf8/oKQexikYpVUD
         7IBOtNSEBBWIHHJxdcPUHraR0kaaEPkUK5eCANWubWnYW85jRIgJIPDFphWhfBmn1eTs
         /0QX8aIlZqoUQXK979RmCX93aSoDVq+QmXvbH7wr8/FeLmrWwmUsiSPizj8F2KVVP3EH
         jonlvyf0B1PkaMrTzLWpVFTrqdmlK1o34LkNZaONeqHvyw39q+0SaQupaf7+jdSnnLuL
         6/kg==
X-Gm-Message-State: ACrzQf2FZ4IiB6k4bkdgFVv02tJFEAdRqq5nGMYUB5JaIZ+1F8THAiE9
        MPkcIr6ZXpVbEoHf5n698SQ7Xg==
X-Google-Smtp-Source: AMsMyM44bd0wOVQGkOK1HTRrf1lPB4hqKLYjtFXHuqO7b/Lq1+31ewi/V4PVrd9aXjD0xaFjokKuyQ==
X-Received: by 2002:a2e:5344:0:b0:26c:417b:aa78 with SMTP id t4-20020a2e5344000000b0026c417baa78mr3957120ljd.298.1664618282125;
        Sat, 01 Oct 2022 02:58:02 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id b8-20020a2eb908000000b00268335eaa8asm394308ljb.51.2022.10.01.02.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Oct 2022 02:58:01 -0700 (PDT)
Message-ID: <76b3269a-1e04-1e93-c06e-ec0f28536cc5@linaro.org>
Date:   Sat, 1 Oct 2022 11:57:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 1/3] arm64: dts: qcom: sdm630: fix UART1 pin bias
Content-Language: en-US
To:     Doug Anderson <dianders@chromium.org>
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
        "# 4.0+" <stable@vger.kernel.org>
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
 <CAD=FV=WHmGi0yxFNbdQ=BXjypDWkW9iS3jBnr2gUhTa5qch90Q@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAD=FV=WHmGi0yxFNbdQ=BXjypDWkW9iS3jBnr2gUhTa5qch90Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/09/2022 22:19, Doug Anderson wrote:
> Hi,
> 
> On Fri, Sep 30, 2022 at 11:22 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> There is no "bias-no-pull" property.  Assume intentions were disabling
>> bias.
>>
>> Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> ---
>>
>> Not tested on hardware.
>> ---
>>  arch/arm64/boot/dts/qcom/sdm630.dtsi | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This does change behavior and has the potential to break someone.
> Thus, without a bug report or someone to give a tested-by I'm at least
> moderately worried about this going to stable@

Indeed. I can drop Cc-stable, but AUTOSEL can still pick it up because
of Fixes tag. Fixes tag is here important to indicate we are having a
bug before.

> 
> I would also note that convention on Qualcomm SoCs that I've worked on
> was that bias shouldn't be specified in the SoC dtsi file and should
> be left to board files. This is talked a bit about in a previous email
> thread [1].

Uh, that makes a lot of sense. It is almost always a property of a board.

> 
> That being said, it does look like this was the intention of the
> original commit, so thus:
> 
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks.

I can also drop the property entirely to match existing behavior (not
the intention).

> 
> [1] https://lore.kernel.org/lkml/CAD=FV=VUL4GmjaibAMhKNdpEso_Hg_R=XeMaqah1LSj_9-Ce4Q@mail.gmail.com/

Best regards,
Krzysztof

