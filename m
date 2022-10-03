Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6DA5F3512
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJCR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJCR6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:58:35 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ADE2D74C
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 10:57:47 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u14so2711748ljk.4
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 10:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ZPof+jI/R1dfmUkJy1EKqNxrIvq4pry+XXXXmem36f4=;
        b=y7ZFz/7zxfuHoIJfOY92zSTEkeSvPP+wBDhQDqvUs5aTnzb+4QOtA24ye/649cB7en
         W5xAu+jR3rvNXDoJR7XoxjDctDA/oHdq4HQNeSP07edi7cmthudvaW79/HSW5Cljtz7C
         H5gbKMGNZplstjbXjf8VgKfSBNQMMQULEz+uWeWH7OZUAKPtcTChITXB7eKsD7oB4An7
         4NLSpsdX0rpLDHJW1dNrN4K+g9bo/++GkP3NzqlOKrkoYdFGfd56THhISUcuwn7YA2Mq
         l/orygnQt4lliHozTZmynuwqEM78fTqYMf7WY6k31H0REpgzaQ0G9QxhCR9XnmwRpu8H
         qYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZPof+jI/R1dfmUkJy1EKqNxrIvq4pry+XXXXmem36f4=;
        b=4JBN2/+/QQRbR8CKKADcFNlkf2fq8Xh5mLy/DF6gstgv9Aj6nMayY8iEvcQSShCNC1
         xLQEoteUxjc1KSl65T69OUUk1I/o9sZ647WtB/ICyO7SHtV5VZlPntl6aUWptI69CqjI
         8C4ucCMc0V/CkhZCf3jMyv/bEOFRrToEOiNfGHJ7JTH6sO/ktN7C4t3gdLniDi0aZOuI
         78/ZypuwYYwTBYop3yH2BzTMK2TY6rrT7xUAHrQ58PLjPxlYcFqrkOERoa4n0fiQssuk
         0GVC+3cG0Lj26An2ZRwz8FjWcBVoY5srSIz5gfaTIwQ+Aam2/J0GIG7FDd4GQ71v5H/o
         EmmA==
X-Gm-Message-State: ACrzQf02rWlacg77d70VXPuePqFvwUSaktxBrympo7fjkry6J4cF8tc2
        W3nEcb3oLGKcXSaSsKCk4X9Iiw==
X-Google-Smtp-Source: AMsMyM4zxlNrMG71JyuCr0C3hCUHzKzy3LAX/vjNbM8E1pmke49EjFhDiQMzyViR5K5PZeetOMKjlw==
X-Received: by 2002:a2e:b4b9:0:b0:26d:d08c:1b88 with SMTP id q25-20020a2eb4b9000000b0026dd08c1b88mr2558306ljm.269.1664819866139;
        Mon, 03 Oct 2022 10:57:46 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id o20-20020a056512231400b00492d064e8f8sm1543640lfu.263.2022.10.03.10.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 10:57:45 -0700 (PDT)
Message-ID: <c0bf359a-1ee9-04e2-2c58-9e7e8f3e12f7@linaro.org>
Date:   Mon, 3 Oct 2022 19:57:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/3] arm64: dts: qcom: sdm845-db845c: correct SPI2 pins
 drive strength
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
 <20220930182212.209804-2-krzysztof.kozlowski@linaro.org>
 <CAD=FV=WSbpV4aqyHgSX6rwanQmZYG1hdNourjP5DEmsfdq6aDA@mail.gmail.com>
 <11a99a84-47ec-ca3e-5781-0f17ed33dbf9@linaro.org>
 <CAD=FV=URMX9umJfqYOhnnnjsr09As-6mKAHs0YNZFK8n2K337g@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAD=FV=URMX9umJfqYOhnnnjsr09As-6mKAHs0YNZFK8n2K337g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/10/2022 17:40, Doug Anderson wrote:
>>>>
>>>> diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>>>> index 132417e2d11e..a157eab66dee 100644
>>>> --- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>>>> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>>>> @@ -1123,7 +1123,9 @@ &wifi {
>>>>
>>>>  /* PINCTRL - additions to nodes defined in sdm845.dtsi */
>>>>  &qup_spi2_default {
>>>> -       drive-strength = <16>;
>>>> +       pinmux {
>>>> +               drive-strength = <16>;
>>>> +       };
>>>
>>> The convention on Qualcomm boards of this era is that muxing (setting
>>> the function) is done under a "pinmux" node and, unless some of the
>>> pins need to be treated differently like for the UARTs, configuration
>>> (bias, drive strength, etc) is done under a "pinconf" subnode.
>>
>> Yes, although this was not expressed in bindings.
>>
>>> I
>>> believe that the "pinconf" subnode also needs to replicate the list of
>>> pins, or at least that's what we did everywhere else on sdm845 /
>>> sc7180.
>>
>> Yes.
>>
>>>
>>> Thus to match conventions, I assume you'd do:
>>>
>>> &qup_spi2_default {
>>>   pinconf {
>>
>> No, because I want a convention of all pinctrl bindings and drivers, not
>> convention of old pinctrl ones. The new ones are already moved or being
>> moved to "-state" and "-pins". In the same time I am also unifying the
>> requirement of "function" property - enforcing it in each node, thus
>> "pinconf" will not be valid anymore.
> 
> Regardless of where we want to end up, it feels like as of ${SUBJECT}
> patch this should match existing conventions in this file. If a later
> patch wants to change the conventions in this file then it can, but
> having just this one patch leaving things in an inconsistent state
> isn't great IMO...
> 
> If this really has to be one-off then the subnode shouldn't be called
> "pinmux". A subnode called "pinmux" implies that it just has muxing
> information in it. After your patch this is called "pinmux" but has
> _configuration_ in it.
> 

It is a poor argument to keep some convention which is both
undocumented, not kept in this file and known only to some folks
(although that's effect of lack of documentation). Even the bindings do
not say it should be "pinconf" but they mention "config" in example. The
existing sdm845.dts uses config - so why now there should be "pinconf"?
By this "convention" we have both "pinmux" and "mux", perfect. Several
other pins do not have pinmux/mux/config at all.

This convention was never implemented, so there is nothing to keep/match.

Changing it to "config" (because this is the most used "convention" in
the file and bindings) would also mean to add useless "pins" which will
be in next patch removed.

Best regards,
Krzysztof

