Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D455A6B47
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiH3RwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiH3RwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:52:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B978A7FC
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 10:48:25 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id bn9so12161973ljb.6
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 10:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=PSuf5+uKyRCAUiI+NXml1CeEx283tkYLDjiJC0rmPIc=;
        b=Pa38oV3EVhdVuxDZfh0mLFLLZj0UBeyf9wUuaxsSKLBOQMSwP/+JXnyg/+1bYSvB6P
         clumNFaYdbLtvk3RCoO7z7tXkfk3qhapicwWk09WHdnxzWc6l/jfpXnmuEU6KnrEz6Kt
         VofAZ3ldyFZosiRqzUpeLIlIMVS5EmYCySQI7+EOvU+4cABLf/SL19ENqRy7bEdgXjgl
         v1/C7lRGBdGDQM+im6QASqFK3eALWIvAwXYcsU/o7jVMguTS3WO9LcyxT/iQR3MKPL/T
         5U0Lw0y9tdW7IwO+/VcodE8+Mip00rT3Vv6Vl3fb1N3QUAG1skvdmwM8K6uAuldeB38q
         PIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PSuf5+uKyRCAUiI+NXml1CeEx283tkYLDjiJC0rmPIc=;
        b=kEEUFV9U9B5KdnfdGDYwrfbLWbCd7/2bvby4LFyMHtlcYWBcKzhqxD78IPHHwP6Pyx
         NUtnu5315fzEXlkKVu+0NMwjPKgHlLFSmNamiTY3wvtsGn1TuDgEP6CsVOJTWWbNKYwj
         rQg+a3w1PFQeccdoA9+c6HKybb5Bo7AgM9JQ0Zde+o1lT8tmY1I7mrrawOc1I4tO95DY
         T01yEsUxQj1r+rYaO8vxaeoMK0j/mQTqqc0wpBq9YSp2b0G+83smrRnbO27UvCcUp1Z3
         K4hp+DY+iW1qSDb/kw6thuwmsFEYxFztVH4gwTyhSSko7xkL0S2u4j+S7VJmI82TSDfv
         rdow==
X-Gm-Message-State: ACgBeo1xTql8scDLevxIUKub7ADahurm2tsEU1mphLnPoGRiw2HTZIeX
        dpnzW2qjbacO+/Yg1iXK87Iyn0mhjTArSUzG
X-Google-Smtp-Source: AA6agR7HZ6jJHiaVODBD57pgKGHlsu+AMUYygh3v4y+9xL4VMk3jrHV/vfKt6fcZwoaqiu0Yk7UBwg==
X-Received: by 2002:a05:651c:905:b0:261:d00c:e71 with SMTP id e5-20020a05651c090500b00261d00c0e71mr7370638ljq.407.1661881702529;
        Tue, 30 Aug 2022 10:48:22 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id n2-20020a05651203e200b0048a757d1303sm997253lfq.217.2022.08.30.10.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 10:48:22 -0700 (PDT)
Message-ID: <3c319873-72c9-632c-7c32-4ee909aa1e64@linaro.org>
Date:   Tue, 30 Aug 2022 20:48:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/3] slimbus: qcom-ngd: use correct error in message of
 pdr_add_lookup() failure
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
 <a437b91a-281d-56b3-41bf-15d9593ece74@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <a437b91a-281d-56b3-41bf-15d9593ece74@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/08/2022 20:33, Jeff Johnson wrote:
> On 8/30/2022 5:13 AM, Krzysztof Kozlowski wrote:
>> Use cprrect error code, instead of previous 'ret' value, when printing
> 
> s/cprrect/correct/
> 

Thanks. I'll fix it.

Best regards,
Krzysztof
