Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63E6D901B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 09:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjDFHFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbjDFHFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 03:05:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4544EE
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 00:03:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so146852559edb.13
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 00:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680764611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xt6w7DBEEp2oP9gq6uM1fJrHBdn8VFiv3bhU+Z8knvc=;
        b=hVmARTOWOi8zcXg/wquYPGxpaxjcdvjoCiWvCn/vQkTDpU56ZAhW4rutJ//Xzx6vz6
         sk3iRLVpvhW3aaX6lykCTeKgQdHEX3JMgzS3Fd8W/zp/KAEo3Uym7g3mEqBTKJ918jtL
         ZptyNafVhadzQfCoJ9p/gMqw2crPzdyyUqSqaxzOQBoP36R43wjUYT0BWvOWLp/G4g4r
         w2MNwZyMW99BYuaI53XP55LtMnPpEKKSs3VklWerLWaPLAqduIdjf2PAm+v4eSgUnQ3P
         4jdU3H4yFFIg4N6F6dc7AXYvM5/+VezfVxrJ8j51k/LsJlDEj4wZKerHQUaes0qBUMwa
         FFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680764611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xt6w7DBEEp2oP9gq6uM1fJrHBdn8VFiv3bhU+Z8knvc=;
        b=BLGtZnn2ottK9MtZTEYahZt435Ncr/wUJE7ZgdSI/QXDKym0piRmqV0er9MwksX1vO
         rmXFQo/bvbc4cCXhWSuRxkMs6mcjke+hMc3YUPwNZli6Gd6JxDbF9eAn/2dn46LfMKv0
         tjEpeT3D3BBbYGI882IH8ErTBzVgxRy+qI29b/w0QFOwEgY7kU44J0etj5hNZ67YFIyM
         09EcId9csg99G3hOg6QxY/c3gen4nDAv/MgmYOG1ywIl99d9GXWvH7P+CWXbNI/WnR3K
         /p35OkltN75Jg/AJ8UzeYoYh4I20MyrehPZDZXwWUR/jkgszouZg7eCZTFVklHueQGVy
         rKdA==
X-Gm-Message-State: AAQBX9cXSoZjvhE4VhXvccPrLncvfB/+WEJx+OQkx5QosSa/Skf40e6j
        4NnXc3eakMd2ZR7CPV1L+vaQPw==
X-Google-Smtp-Source: AKy350YnhKpndWCuKkoEX1F9XMUWGFxBZSXdLPSCgbRgT7xN4Z0Df2myKsprNtK3DO5NAXHENav20w==
X-Received: by 2002:a17:906:9145:b0:931:df8d:113 with SMTP id y5-20020a170906914500b00931df8d0113mr4673121ejw.26.1680764611021;
        Thu, 06 Apr 2023 00:03:31 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed? ([2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906c08d00b0092f289b6fdbsm390050ejz.181.2023.04.06.00.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:03:30 -0700 (PDT)
Message-ID: <11de8706-5753-472b-1fe0-de80bb3d8c8c@linaro.org>
Date:   Thu, 6 Apr 2023 09:03:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] soundwire: qcom: Fix enumeration of second device on the
 bus
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Patrick Lai <quic_plai@quicinc.com>
References: <20230405142926.842173-1-krzysztof.kozlowski@linaro.org>
 <ecc13046-1a4f-77e7-c4dc-a5a4c1248572@linux.intel.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ecc13046-1a4f-77e7-c4dc-a5a4c1248572@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/04/2023 17:01, Pierre-Louis Bossart wrote:
> 
> 
> On 4/5/23 09:29, Krzysztof Kozlowski wrote:
>> Some Soundwire buses (like &swr0 on Qualcomm HDK8450) have two devices,
>> which can be brought from powerdown state one after another.  We need to
>> keep enumerating them on each slave attached interrupt, otherwise only
>> first will appear.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> ---
>>
>> Cc: Patrick Lai <quic_plai@quicinc.com>
>> ---
>>  drivers/soundwire/qcom.c | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
>> index c296e0bf897b..1e5077d91f59 100644
>> --- a/drivers/soundwire/qcom.c
>> +++ b/drivers/soundwire/qcom.c
>> @@ -587,14 +587,9 @@ static irqreturn_t qcom_swrm_irq_handler(int irq, void *dev_id)
>>  			case SWRM_INTERRUPT_STATUS_CHANGE_ENUM_SLAVE_STATUS:
>>  				dev_dbg_ratelimited(swrm->dev, "SWR new slave attached\n");
>>  				swrm->reg_read(swrm, SWRM_MCP_SLV_STATUS, &slave_status);
>> -				if (swrm->slave_status == slave_status) {
>> -					dev_dbg(swrm->dev, "Slave status not changed %x\n",
>> -						slave_status);
> 
> it's not clear to me how removing this test helps with the two-device
> configuration?
> 
> Or is this a case where the status for both devices changes at the same
> time but the interrupt status remains set, so the next iteration of the
> loop is ignored?

I think the patch is not correct. I misinterpreted the slave status
field and after double checking I see two speakers bound. Please ignore
for now.

Best regards,
Krzysztof

