Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD26BCA3B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCPJBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 05:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCPJBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 05:01:12 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A3FA1022
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 02:01:04 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y15so1384141lfa.7
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 02:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678957263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=STRpmbegW6vAktajLsUer7M8TEjuM7uHg3Y0OX0ulxA=;
        b=X5RJX0xqSHGSUigKKAzUeg2omSfttMVKGtj5XW+AiID4lT4he28rMT7iFZjHaN26sG
         fwZUKB7fSaFW6+vCXYZvsaXyv5rYqeOY324p/LENvLmeudJqmUZJDMoEa14feON4LTYv
         Qolum3r4w1v2vRqGdVWmwxJkA5RDp9EvcX4aAVvIeaYGC4XSz0il8QOhjlDcurZjjMRo
         UpFcdlG6VsnGqrE7x6Ax6JW3V47dVcUs0t03aeInFXlwbaJRp+X6AA2zxWTghmGh7nv/
         j2GUeOIvDUDdU9QjHCGZXeSJQqfmzZPOB9+d/XHcTs1h2a4yWZ8f1079yvmXSit9i8ml
         ybFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678957263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=STRpmbegW6vAktajLsUer7M8TEjuM7uHg3Y0OX0ulxA=;
        b=e8dSUDlzFuoApsb+5OpU9R9cKdIAwHmS0ubuZSbpUJslQjT0eIJNR+EFEFX7SByO+t
         lt1Ksg4cF8K7XXkYqT8Y+LOMHXKATnROaJsqoFXSyIIEGyrMU+tCBa2KDzR4R0723OEf
         RE1kVHwm4XcobWkXGNSxXgij/UNBLWKmBMc9nWeP5JvGnWajegaRZm2AcPTOEd4LdRqN
         6V+sW13Z3nlFuxWLcNZoE/pxEedzvWUCPWyG60/OORKVz4YHV2uEtZm38+qkaQIOjDOs
         G5cizE93LsP6yfQo3OTr78sVjptGhrKzHQo1oAyaIPFL5Ln8znhOXnAobww9mXY3iB6j
         116w==
X-Gm-Message-State: AO0yUKU6c6Auf0N03qhkL04NFzNfQWvMkdzefCH/5JjaHImiXOvx4AqC
        IUUM0cDrW7a9wk8QThATA6oPOQ==
X-Google-Smtp-Source: AK7set/FL9DVO5r+BRfdFE/uzlVw1jazBc9Tu7WS4d5j0LKdv5+j8GQzCg3J/ALIBGUWURjeTJ81SQ==
X-Received: by 2002:ac2:494b:0:b0:4dd:a76e:dfff with SMTP id o11-20020ac2494b000000b004dda76edfffmr2680145lfi.23.1678957262915;
        Thu, 16 Mar 2023 02:01:02 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id v7-20020a056512096700b004d858fa34ebsm1143374lft.112.2023.03.16.02.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 02:01:02 -0700 (PDT)
Message-ID: <0a3a9c3d-8d04-5b58-0f74-eb20759b1430@linaro.org>
Date:   Thu, 16 Mar 2023 11:01:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Content-Language: en-GB
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        paul.elder@ideasonboard.com
References: <20230316083335.429724157@linuxfoundation.org>
 <ZBLaULVciUIN+b4P@duo.ucw.cz> <ZBLaqsSWyRD+N4M9@duo.ucw.cz>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <ZBLaqsSWyRD+N4M9@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/03/2023 11:00, Pavel Machek wrote:
> (added patch authors to cc)
> 
>>> This is the start of the stable review cycle for the 4.14.310 release.
>>> There are 20 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>>> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>>>      clk: qcom: mmcc-apq8084: remove spdm clocks
>>
>> This looks like a cleanup, we should not need it in stable.

Totally agree here.

>>
>>> Paul Elder <paul.elder@ideasonboard.com>
>>>      media: ov5640: Fix analogue gain control
>>
>> This is an API tweak, not a bugfix. This will have negative impact on
>> users upgrading from 4.14.309 and 4.14.310, because you can be pretty
>> sure someone out there uses the "old" interface in their
>> application. I'm probably responsible for that sin in millipixels
>> fork.
>>
>> Best regards,
>> 								Pavel
>> 								
> 
> 
> 

-- 
With best wishes
Dmitry

