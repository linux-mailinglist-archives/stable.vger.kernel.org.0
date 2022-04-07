Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFC34F7851
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242402AbiDGH6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242549AbiDGH56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:57:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE72110BC;
        Thu,  7 Apr 2022 00:55:59 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t4so4331117pgc.1;
        Thu, 07 Apr 2022 00:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TOz25wHfDzd9sXTS50dp1IowcYfvoVvOBFfUpyDR3yk=;
        b=kb5rAxUELmYUf9tms2ggR8vAR8qwKI/NZBlPSbTZVcWdm/vBuQnE21463mt/4t45K8
         eLID/dpGD173ZrfCDOBmzvu1XwHP2J5h1iieD+5Io99+moJDAj++I3PK/UFpX2boFYV4
         2Cf4Tt4TjI6Wi8TM/yOW9nvQF2jd+lI6qBTclouiKUsrAaGwjr+VL6yx3WWFo+vvoLED
         vvxaUk0nNSXgAs/DoC6byqm2QRef43TQZhyERk3xaTslFJHGRhofzRVkTfgTopHjxo9z
         fcpwR25l9+WdDh8QCoxKCTIriskY//MM68gOt4eFMTGmEy8pA6Cl8A0QqYTQ+hKvQzOG
         1QgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TOz25wHfDzd9sXTS50dp1IowcYfvoVvOBFfUpyDR3yk=;
        b=wPPO+3ubl4C3I8wtDC5xQ2SK3I10pLe2PiazAiSfNODy2K8VGXXtWsZhZmkPBFOa1f
         hszIJSGBE8WJ+3tuNxiFaq8zpYCkG3C7ZOL9VGXhslB8uo64zqE0mOZ3V3V90uhPVrw5
         Yk0NdhRRTshClHuhyLV11ALE+nsUr0ROzS6nlH+19TI4DOB5MaFCUITaK3Rlzj0zjABw
         AqitJghMe9TD410Aj6o12F9t2hEbkP2D+YtRqwvoMwMinPU54BkJK1/IWkGZV/Bu62hZ
         qVyfms4awFDALKBqb5DsJhU9rMVU0nJx7g/KTmLV+m+EwgR1x1YnFW0tWBHos0HZ6Lou
         mybw==
X-Gm-Message-State: AOAM532lqatbolciRMDr4065GbO0Kj3E05L57EnvgSXcnoAqhRH4o0Uf
        9WNft3rXi4ah4ARtjundTaA=
X-Google-Smtp-Source: ABdhPJxH4CWSpZivZmqfPSd1HqEHw6wg1FHzv3RnyWwb95opsfKr+MhYq9zcf5Pzo+Im7b3cY/+Ieg==
X-Received: by 2002:a63:de41:0:b0:398:db26:bb6 with SMTP id y1-20020a63de41000000b00398db260bb6mr10252850pgi.516.1649318159300;
        Thu, 07 Apr 2022 00:55:59 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id l22-20020a17090aaa9600b001ca7a005620sm7533812pjq.49.2022.04.07.00.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 00:55:59 -0700 (PDT)
Message-ID: <56e105f3-f6b9-c70b-97ad-62e2c5966f40@gmail.com>
Date:   Thu, 7 Apr 2022 14:55:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133055.820319940@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/22 20.44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
