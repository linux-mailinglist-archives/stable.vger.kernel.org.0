Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395BC5F1BAD
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 12:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJAKCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 06:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJAKCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 06:02:01 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082EF106A0B
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 03:01:58 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o7so3014582lfk.7
        for <stable@vger.kernel.org>; Sat, 01 Oct 2022 03:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=isfPLY9jR+ZoVFd10vcMUlsBh00yNt/v6qsBgWfkVWc=;
        b=hxNu9GOBZ6OIkmPu2dYmNAKLY1tyR/nJ1sTFR9UeuKhUBoOgnCGxi8SyBg74NCLWp8
         asr+EAkSain2o5Hfv4mxJlgY1q9DK/lbFRUevmba9mwnKUsCCy/4mhVxHswclCRbEGQY
         vFQ0BHJE+ruWr6x/SUodam6kiRDcr9f76jrXhNA4oDXk/pWwvguXsf8N3HGoHk0bRcuO
         y5ylnycQY1xmgsBCrNLAaCL3AbCIsA5K/M2op7LO93dXVPG9nKqedUxoUaWCGFa6JiSo
         wM9rIbx3A0EruJb7XuDxLZsKygLcdhiPBw7zme2vEd+YOcwaOuX448UkMyapJ+Ye0X3R
         NGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=isfPLY9jR+ZoVFd10vcMUlsBh00yNt/v6qsBgWfkVWc=;
        b=wZmF2LF9bwX12OXsnHXOvoTTVgLV1eZmOROdw7dKC5eT9g0PQt9+9wronPWwwH7W4S
         ycczQqI6n8xRpDRurFR3a8mpaUh5yHdQViCxC1zfJD2LNBidq0LB0Ym46Pd6KntwTMUB
         Uau/s5Zgg1JjIev/iJFmPDUDBVWI8zW24P2r/iKQCGauteJnXL+pQKGg0t92bGbcyodr
         J9JK1QE5UT4fwYzGHLmBOCI01wexWwctBEz+M3JNWnA1qcK4XNLjGswEFnyN3flh2Jxt
         ATcX2fA4j95NmQceKYlDe8TfWRnFFLeznsxPcShPFOHTfo7zICR/Htoe0ypZTZotETQr
         v10Q==
X-Gm-Message-State: ACrzQf0ZpDXAfh2WRzfZJOSQjFWBKuX2xJ3OlLNDIN4Tua+6Ac8nQoqT
        EGHeHMupGFcIGT+kcrr2UkdJmg==
X-Google-Smtp-Source: AMsMyM7AETj/ipTqs1kEJZXmUiYV4pkMkE02jy6ZWJlax6twD1+N3FeRcIW9pV+jANPCJDNRYyzenQ==
X-Received: by 2002:a05:6512:3b97:b0:497:ab81:dcb1 with SMTP id g23-20020a0565123b9700b00497ab81dcb1mr4629226lfv.496.1664618516936;
        Sat, 01 Oct 2022 03:01:56 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id b37-20020a05651c0b2500b0026dcac60624sm219926ljr.108.2022.10.01.03.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Oct 2022 03:01:56 -0700 (PDT)
Message-ID: <11a99a84-47ec-ca3e-5781-0f17ed33dbf9@linaro.org>
Date:   Sat, 1 Oct 2022 12:01:55 +0200
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAD=FV=WSbpV4aqyHgSX6rwanQmZYG1hdNourjP5DEmsfdq6aDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/09/2022 22:12, Doug Anderson wrote:
> Hi,
> 
> On Fri, Sep 30, 2022 at 11:22 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> The pin configuration (done with generic pin controller helpers and
>> as expressed by bindings) requires children nodes with either:
>> 1. "pins" property and the actual configuration,
>> 2. another set of nodes with above point.
>>
>> The qup_spi2_default pin configuration used second method - with a
>> "pinmux" child.
>>
>> Fixes: 8d23a0040475 ("arm64: dts: qcom: db845c: add Low speed expansion i2c and spi nodes")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> ---
>>
>> Not tested on hardware.
>> ---
>>  arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>> index 132417e2d11e..a157eab66dee 100644
>> --- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>> @@ -1123,7 +1123,9 @@ &wifi {
>>
>>  /* PINCTRL - additions to nodes defined in sdm845.dtsi */
>>  &qup_spi2_default {
>> -       drive-strength = <16>;
>> +       pinmux {
>> +               drive-strength = <16>;
>> +       };
> 
> The convention on Qualcomm boards of this era is that muxing (setting
> the function) is done under a "pinmux" node and, unless some of the
> pins need to be treated differently like for the UARTs, configuration
> (bias, drive strength, etc) is done under a "pinconf" subnode.

Yes, although this was not expressed in bindings.

> I
> believe that the "pinconf" subnode also needs to replicate the list of
> pins, or at least that's what we did everywhere else on sdm845 /
> sc7180.

Yes.

> 
> Thus to match conventions, I assume you'd do:
> 
> &qup_spi2_default {
>   pinconf {

No, because I want a convention of all pinctrl bindings and drivers, not
convention of old pinctrl ones. The new ones are already moved or being
moved to "-state" and "-pins". In the same time I am also unifying the
requirement of "function" property - enforcing it in each node, thus
"pinconf" will not be valid anymore.

>     pins = "gpio27", "gpio28", "gpio29", "gpio30";
>     drive-strength = <16>;
>   };
> };
> 
> We've since moved away from this to a less cumbersome approach, but
> for "older" boards like db845c we should probably match the existing
> convention, or have a flag day and change all sdm845 boards over to
> the new convention.

That's what my next patchset from yesterday was doing. Unifying the
bindings with modern bindings and converting DTS to match them.

https://lore.kernel.org/linux-devicetree/20220930200529.331223-1-krzysztof.kozlowski@linaro.org/T/#t


Best regards,
Krzysztof

