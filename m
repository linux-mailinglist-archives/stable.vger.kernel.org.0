Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F714D193D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiCHNf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:35:27 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8192A4614E;
        Tue,  8 Mar 2022 05:34:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z11so17067493pla.7;
        Tue, 08 Mar 2022 05:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZorT4FrRioS4YIby9ntgOY0ZGNSuG1e3aHD+8o6rf34=;
        b=QavLYDE1g/C9R/yhROiePjagkGJrDSjHib4hr7nXDptMArgtMqZG2h56+CI/KK2mYS
         ORryqtSu9y57v/qhAB5Z6ZLBhYOW655oDbHwmbdvXp0C7zuuh2qJuZeTimVPVdUV2wva
         Y9AU0DbNCmp5ut8qigdcl+fWUtgpdoZITaBbwIJCRWfubuGPl2L5DfOFGtSK2QHM4cRQ
         btg7H9lrG0Tiwjzj1ulwHrkHWIe3NCa1UbhMT5HxRXW/mnjRmdfDFxNe3KByDKSgA8kU
         SZ6Ue6G9xM5GaxlG88U0xJ/AcEXVjKOi+Kb4chjBcaeSUpZ91EkNOxfRhQ0wwVknaxLu
         Ar7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZorT4FrRioS4YIby9ntgOY0ZGNSuG1e3aHD+8o6rf34=;
        b=fAc3sJYLM21oPSfmANmJIdQ/JddkDUawOCOhDIWwAQ+bVyO8Z2+yjGBHc9R2yk/Q5R
         GUK4CSkf9rShfXr4hAborT2yi0rOyvu7tZkl6RtmgjZ0YpHuICuJMBIbBgcRe7DMb7NF
         NGXFDUP/lMmWjFGKOi3VmFrCb8DINSDznJyCLdmE58ByqXNTcOg/CWOlPvA9GJEkLDBV
         spACcoiMCXBcmhvDJPed1wMSVZOr45laA5zrpR0is6phSF81KKyZ2KTfE/8yJHTZiZGL
         Lbr8J4rOj2BCh/voSvcTgKxdldxrsfPIAqSsmds61RWxmxTA0A7WfVoY/TC0/3/+xhKm
         dUlQ==
X-Gm-Message-State: AOAM5308iRiWcLc454FaCOjenhGmhk0GHTetEvOt1ssyyNz1ykePvBFt
        F6joG5rbDY+4BCOmYISa9CI=
X-Google-Smtp-Source: ABdhPJx65QSaMAQuNeyGXo0LW4G43VA4nmZNgT6KpePHU1Ksr60yBUCeFMeHqPqMt0lNNnP0/QaZNw==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr17584684plk.50.1646746470091;
        Tue, 08 Mar 2022 05:34:30 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b004f11e614565sm19772492pfu.189.2022.03.08.05.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:34:29 -0800 (PST)
Message-ID: <8cc0987a-cf72-c658-e55b-7b3b6787ddac@gmail.com>
Date:   Tue, 8 Mar 2022 20:34:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.10 000/104] 5.10.104-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220307162142.066663718@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220307162142.066663718@linuxfoundation.org>
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

On 07/03/22 23.28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
