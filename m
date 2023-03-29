Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140E06CD864
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 13:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjC2LYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 07:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC2LYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 07:24:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D240C6
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:24:30 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id h25so19655185lfv.6
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680089069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bqRvDrf+LQjYdWpmaqzz2Gtf9PBY/+z/KX3/Flqh8zo=;
        b=J15yimuSbI/QHHkde0jQbkLiVnMFJ0pwJ3jsJ8A+gTcf10SptIjTp8duoBMmP64HOE
         Re4DDS3AYZnNGELgZjvkQUZMsmXxbbaM+fWzGPZy7ChVuvDEfeVcBsPZte9rhXzCF5Yv
         /49CrCfCE7Sc1igVj+4i71jQdLBt+ULPTz7adSUo/tEr2JEE19fwi+g5TOH/u7J4m7tW
         k348HcGAaoa5JnY6BiT1yTVEV+9A7FxfjXadtcqyFjlCAG7omZ7kEt+ROUJQv4UGaHxk
         BPYzCGkuIxc8EAoCN6WkeKcYeNRrSlzSU9g4bIFJ4wqwXetX81gEoWUOyKTuKjkJhyJX
         e0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680089069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bqRvDrf+LQjYdWpmaqzz2Gtf9PBY/+z/KX3/Flqh8zo=;
        b=xk1UUk+q94Wsk33X733FA8XpztidIBBRiUjomItYG9XdbSNgnhUbV7UcZLr5hbxWQy
         D/+rd1J3WwiCfHWGWaICvWN9u42KDejWzze3HtLJO+bAUf8Ee345cozBih2Nt0A42dR3
         lsQuBk3/+omRLHX9gkkxfux9kHHBbCn2le32hOL/BGISlPkKHg0IScAHY3Fhd6B0r1y1
         VI4QHMvE/GLuSMkz5RyTzfd6dOXKzVB8D1IULE5xmVL2ngf/1YZkJmCcMZBPOXoKLsiM
         Tex/3rBl/BVMKeBr7vGJBtOfsmvo6tqjDgtr32Lgj5OHqoQnWZvrhcbCfiJSXx8/JTVD
         i+7A==
X-Gm-Message-State: AAQBX9e4DsbHiFyE2omwNNnQoTN5nhr0Jy7foAU4VPou9OYdHkS7g/fK
        2dz5wNPz2Kl9Qxgr7Dua9aYVzA==
X-Google-Smtp-Source: AKy350bYzEOoUSw6cqkGqFLbQhDHA1c4SLLhwVXtXFCwCzlrfCjvVgQhuWXvohm9l2QUOfhgtgfNNw==
X-Received: by 2002:a19:550b:0:b0:4e9:c627:195d with SMTP id n11-20020a19550b000000b004e9c627195dmr5339617lfe.57.1680089068735;
        Wed, 29 Mar 2023 04:24:28 -0700 (PDT)
Received: from [192.168.1.101] (abxj225.neoplus.adsl.tpnet.pl. [83.9.3.225])
        by smtp.gmail.com with ESMTPSA id m22-20020a195216000000b004db4936c866sm5407496lfb.38.2023.03.29.04.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 04:24:28 -0700 (PDT)
Message-ID: <a35bd0e2-b54e-ffa7-e54b-468a3cf77703@linaro.org>
Date:   Wed, 29 Mar 2023 13:24:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
 <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com> <20230328093853.GA5695@thinkpad>
 <20230329052600.GA5575@thinkpad> <ZCP4MHe+9M24S4nJ@hovoldconsulting.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <ZCP4MHe+9M24S4nJ@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 29.03.2023 10:34, Johan Hovold wrote:
> On Wed, Mar 29, 2023 at 10:56:00AM +0530, Manivannan Sadhasivam wrote:
>> On Tue, Mar 28, 2023 at 03:09:03PM +0530, Manivannan Sadhasivam wrote:
>>> On Tue, Mar 28, 2023 at 10:54:53AM +0200, Johan Hovold wrote:
>>>> On Sat, Mar 25, 2023 at 10:22:13PM +0530, Manivannan Sadhasivam wrote:
>>>>> Add missing quirks for the USB DWC3 IP.
>>>>
>>>> This is not an acceptable commit message generally and certainly not for
>>>> something that you have tagged for stable.
>>>>
>>>> At a minimum, you need to describe why these are needed and what the
>>>> impact is.
>>>>
>>>
>>> I can certainly improve the commit message. But usually the quirks are copied
>>> from the downstream devicetree where qualcomm engineers would've added them
>>> based on the platform requirements.
>>>
>>>> Also, why are you sending as part of a series purporting to enable
>>>> runtime PM when it appears to be all about optimising specific gadget
>>>> applications?
>>>>
>>>
>>> It's not related to this series I agree but just wanted to group it with a
>>> series touching usb so that it won't get lost.
>>>
>>> I could respin it separately though in v2.
> 
> That's also generally best for USB patches as Greg expects series to be
> merged through a single tree.
> 
>>>> Did you confirm that the below makes any sense or has this just been
>>>> copied verbatim from the vendor devicetree (it looks like that)?
>>>>
>>>
>>> As you've mentioned, most of the quirks are for gadget mode which is not
>>> supported by the upstream supported boards. So I haven't really tested them but
>>> for I assumed that Qcom engineers did.
>>>
>>>> The fact that almost none of the qcom SoCs sets these also indicates
>>>> that something is not right here.
>>>>
>>>>> Cc: stable@vger.kernel.org # 5.20
>>>>> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
>>>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>>>> ---
>>>>>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
>>>>>  1 file changed, 14 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
>>>>> index 0d02599d8867..266a94c712aa 100644
>>>>> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
>>>>> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
>>>>> @@ -3040,6 +3040,13 @@ usb_0_dwc3: usb@a600000 {
>>>>>  				iommus = <&apps_smmu 0x820 0x0>;
>>>>>  				phys = <&usb_0_hsphy>, <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
>>>>>  				phy-names = "usb2-phy", "usb3-phy";
>>>>> +				snps,hird-threshold = /bits/ 8 <0x0>;
>>>>> +				snps,usb2-gadget-lpm-disable;
>>>>
>>>> Here you are disabling LPM for gadget mode, which makes most of the
>>>> other properties entirely pointless.
>>
>> Checked with Qcom on these quirks. So this one is just disabling lpm for USB2
>> and rest of the quirks below are for SS/SSP modes.
> 
> No, snps,hird-threshold is for USB2 LPM and so is
> snps,is-utmi-l1-suspend and snps,has-lpm-erratum as you'll see if you
> look at the implementation.
> 
>>>>> +				snps,is-utmi-l1-suspend;
>>>>> +				snps,dis-u1-entry-quirk;
>>>>> +				snps,dis-u2-entry-quirk;
>>>>
>>>> These appear to be used to optimise certain gadget application and
>>>> likely not something that should be set in a dtsi.
>>>>
>>>
>>> I will cross check these with Qcom and respin accordingly.
>>>
>>
>> These quirks are needed as per the DWC IP integration with this SoC it seems.
>> But I got the point that these don't add any values for host only
>> configurations. At the same time, these quirks still hold true for the SoC even
>> if not exercised.
>>
>> So I think we should keep these in the dtsi itself.
> 
> Please take a closer look at the quirks you're enabling first. Commit
> 729dcffd1ed3 ("usb: dwc3: gadget: Add support for disabling U1 and U2
> entries") which added 
> 
>>>>> +				snps,dis-u1-entry-quirk;
>>>>> +				snps,dis-u2-entry-quirk;
> 
> explicitly mentions
> 
> 	Gadget applications may have a requirement to disable the U1 and U2
> 	entry based on the usecase.
> 
> which sounds like something that needs to be done in a per board dts at
> least.
> 
> Perhaps keeping all of these in in the dtsi is correct, but that's going
> to need some more motivation than simply that some vendor does so (as
> they often do all sorts of things they should not).
I'm looking at the DWC3 code and admittedly I don't understand much,
but is there any harm to keeping them? What if somebody decides to
plug in a laptop as a gadget device?

Konrad

> 
> Johan
