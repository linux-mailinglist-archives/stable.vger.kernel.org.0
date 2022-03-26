Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3C4E7FB1
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 08:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiCZHHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiCZHHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 03:07:31 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DFF249C7C;
        Sat, 26 Mar 2022 00:05:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so10364847plg.5;
        Sat, 26 Mar 2022 00:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IuLPzOFcPfRBD9YvtrSpiynaCCbnkp8ViJ4z5qQgTW0=;
        b=MFguf+LwUrhR3LwewKznkaJvWfeqcdf4V9ngOl4LF7gFuwlQO3PBw67XNoQVrPDfpt
         08wiuaLCvgEbCuPqz7y1o/wxMSmr3AzVlFb7qDs+N0N0iybBENH7TfFhTqF7KKixiWVt
         lLfjefDh1/0/J2Jg1RBZe2OxbmNut4WTt9HedNE2qOLOhrjNIRh3mKUsx1zzLK6cJhzV
         UT2DN68XPWXVVucDS6Z9JgBpPRS7Y0Z7d9lc3nQ6xnRiQ8gdFrH1cg8f2Fdi6PGp1x9w
         xhbggsQhd/lt94VnTVcFzcb4ZQ3b5SgbtkDfTrcmO2iHLKlGstACjfcvMaIat5Cmeluz
         xrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IuLPzOFcPfRBD9YvtrSpiynaCCbnkp8ViJ4z5qQgTW0=;
        b=vI6KQLkoOV8yaM6gD5SnxdOIcfUVD4KlRNa/ctnVoNVb6PhKg55h0J0gBXTttyMDuK
         K75FFG1peNl6a+Hw8GiskDqhm5Mp8gEyGAe4cexmqpIrEtUMZYgNZEjmgY074Jsu+RzE
         lkcoTa1fLCS4RTs8btuO+fsO75MCUL1rO1yiqkDVSHf3lnZGsmqQ1+5QDEfQa0HeXheY
         33SFB704hmpvojBQEvIMtuEpsO9x3MKVJQtXreB2sKYmu6Da5vRLZZGDhr7KK/yGbd3z
         Qx41+jv7MTrA+Hte2bHNHOuZ+kg/y9pyOyCEdrUNchYeiyS6cu7z3o4st/ZNHkkqEcax
         PydA==
X-Gm-Message-State: AOAM530KmBPPir1+rR/43hCNl7wNt7h3ogwd/IUxMC/Bq+LbGaPuFSwF
        Zbn45P9NyFech/X6HzHWW80=
X-Google-Smtp-Source: ABdhPJyPP9DqkOvlbagWD3+S8fA8Jau2A5WoiwJCclODGS/tOiMv0HsIpP7TE9p5BYtq7h6+oCYiFA==
X-Received: by 2002:a17:90b:1b12:b0:1c7:6f5d:d7e8 with SMTP id nu18-20020a17090b1b1200b001c76f5dd7e8mr24990608pjb.154.1648278355165;
        Sat, 26 Mar 2022 00:05:55 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-83.three.co.id. [180.214.233.83])
        by smtp.gmail.com with ESMTPSA id p16-20020a056a000b5000b004faed463907sm8350042pfo.0.2022.03.26.00.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 00:05:54 -0700 (PDT)
Message-ID: <2b3af5d1-8233-45a6-7a44-a19f7010cd6b@gmail.com>
Date:   Sat, 26 Mar 2022 14:05:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220325150419.757836392@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/03/22 22.04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
