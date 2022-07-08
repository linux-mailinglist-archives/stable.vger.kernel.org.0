Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFA456B6EC
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiGHKL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 06:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiGHKL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 06:11:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2D184EDA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 03:11:47 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m6-20020a05600c3b0600b003a0489f412cso679274wms.1
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 03:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=81okasB3g0ekpD8niaqxxgdkdfiBn6Pr7NqUFt5DBEo=;
        b=GG2oup2rv/ga/OnSyutUz+S+rBqREaqHTkx+gB+ADu7sa0SBu42CvT0CSElqsSFWhZ
         Lr+Q+l6DrU4UfBc4bH621yyvfTEU4ylv+RH1Qh6aYwDQLAT7A12x2AvYvn1Y/mZi8lCc
         ZgMh604fWqZ1iW9+KCdZhf7fgB0+R2ZUU8QivYy9x1NeN7j2K7nYu+dAmgiMXpxsorOk
         2xwOdjbOJb7p9A6g6OG88iO66uVe81StH6gcxVck63+H2Hec41b86vbLy5uy6DQk06ji
         x6PwtSvJU7OHxBxCehyjzcRmW0ftH/T6m9vqDIIyfLsqRUzMCMGBtGulWCzeKTegq8mB
         mTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=81okasB3g0ekpD8niaqxxgdkdfiBn6Pr7NqUFt5DBEo=;
        b=Ez5UQeUXsa/ks3YOUIZ3wGAOqprdZrZAZaSVbu4CRSQ0QzmJ0cuY3sObeRUfEEw1L/
         vGcJX33YfE2+RbGiPRIlKbEWFMlQJhNozWTyCQr/okr+r4G43SeYV/AtO1rF5cffSvcm
         5DjdsyhLf4XaP08TNIk/4g2P/xa8VWgveO27zBKK62LshBF4zEiT6WM5GFxF0uolGiKL
         R/10AsWc84/v2qpfvBR/t/Z6mf/FzLbJofUiDrDUxenXKAeuu9pNVQmqcJzmQscGDKBm
         MN9/fe4NiV4gVF15dhOw7xOmXyqELXhLuFI35jUP8iK8Hw78cYoMnjnseSZkLRAQoNl6
         titg==
X-Gm-Message-State: AJIora8Fj/TKv/kJ4JSukZGnnUpODyXnd9qhN35dXzYenteckb6tnMyl
        IT1N481hW0kq8FwKl43rNaRIiw==
X-Google-Smtp-Source: AGRyM1vDkPE98jrS2Me8n5r7/R9H34mgmtL+Fc/cv224985Zm6C1y8NPkd/Aw90Ph3on7smNzjvWCA==
X-Received: by 2002:a05:600c:4243:b0:3a2:db2d:ebdc with SMTP id r3-20020a05600c424300b003a2db2debdcmr1786084wmm.41.1657275106530;
        Fri, 08 Jul 2022 03:11:46 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id bk12-20020a0560001d8c00b0021d7050ace4sm327428wrb.77.2022.07.08.03.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 03:11:45 -0700 (PDT)
Message-ID: <42056cab-237c-3f3a-da43-5138be64243b@linaro.org>
Date:   Fri, 8 Jul 2022 11:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] soundwire: qcom: fix max auto-enumeration devices
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
References: <20220708091947.5610-1-srinivas.kandagatla@linaro.org>
 <20220708100453.GM2316@kadam>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220708100453.GM2316@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 08/07/2022 11:04, Dan Carpenter wrote:
> On Fri, Jul 08, 2022 at 10:19:47AM +0100, Srinivas Kandagatla wrote:
>> Controller only supports up to max of 1-11 device ids via auto-enumeration,
>> and it has only those many registers.
>>
>> In the existing code, we can protentially cross this boundary and read incorrect
>> registers.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>> Thanks to Dan for reporting an overflow issue, which turned out to be
>> another issue, where we could read registers that do not belong to
>> auto-enumeration devid.
>> Either way this fixes both issues, one reported by Dan and other
>> incorrect register access.
>>
>> Thanks,
>> Srini
>>
>>   drivers/soundwire/qcom.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
>> index 9df970eeca45..dd1365a44458 100644
>> --- a/drivers/soundwire/qcom.c
>> +++ b/drivers/soundwire/qcom.c
>> @@ -119,6 +119,8 @@
>>   #define MAX_FIFO_RD_RETRY 3
>>   #define SWR_OVERFLOW_RETRY_COUNT 30
>>   #define SWRM_LINK_STATUS_RETRY_CNT 100
>> +/* devid 1 - 11 */
>> +#define SWRM_MAX_AUTO_ENUM_DEVICES	11
>>   
>>   enum {
>>   	MASTER_ID_WSA = 1,
>> @@ -479,7 +481,7 @@ static int qcom_swrm_enumerate(struct sdw_bus *bus)
>>   	int i;
>>   	char *buf1 = (char *)&val1, *buf2 = (char *)&val2;
>>   
>> -	for (i = 1; i <= SDW_MAX_DEVICES; i++) {
>> +	for (i = 1; i <= SWRM_MAX_AUTO_ENUM_DEVICES; i++) {
> 
> I'm sorry, I don't understand.  Both of these defines are 11 so this
> doesn't change anything?
> 
My bad, I thought this was 15...


--srini


> regards,
> dan carpenter
> 
>>   		/* do not continue if the status is Not Present  */
>>   		if (!ctrl->status[i])
>>   			continue;
>> -- 
>> 2.25.1
