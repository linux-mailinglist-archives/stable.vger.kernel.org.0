Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9290B4B1D98
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 06:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiBKFN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 00:13:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiBKFNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 00:13:55 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3C11020;
        Thu, 10 Feb 2022 21:13:54 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d187so14231820pfa.10;
        Thu, 10 Feb 2022 21:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=MXuK0QF/Dtl5zTZVXaT1BNbH7Mz3Kr01UOrIEItVZiE=;
        b=KI2bJKkgDKwgoZ5Y8xKF2YLOoZS031E1+fjB6Vwp2IybRmwP706tUmQ9LhemBbWLcs
         hJOTu08YffLl+Sgjg45FM6PZJTSvhn10G2mmhviZQrocOlUFfRZIht1hCCg1V7factnN
         lyNXFo3IXlt3DawKAY/MPTWntRia4SCcVVoS6QN563FsNQlSZnejt2Du/o31GafaL9Lb
         HZfDHrzukEkkBEIwGv41QBua4bkpL/If61QTlSAxSYMKEAbAP7m9fEpdlhiiOKKxKIjz
         2VSbPtz2KUHxs4P40UqaOeYrBsu5yFCl1Z+3IIHbX9W+2MbMLkZ0IY+jbMQI8U9XmhIM
         A7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=MXuK0QF/Dtl5zTZVXaT1BNbH7Mz3Kr01UOrIEItVZiE=;
        b=DaegfNLEmfi8gT40Zi+Y6x+FrUl3qsfFFAp1Zoj8USdDhOgqm7uxDP/uleo9wDEBd3
         nRVYb36Rs6NuUG6VBV5cNcNfSx/dhoXGzkQnIjCm597Q7PjnN+jjbaUSd6wjoDhsgihg
         3L3sVX0L6Fj3uKpKBFP8UsW6wOMBaKS9Ezq1RcUdWNIb5avMVHtZkQ8MY5mDrjgT7TK4
         HGDgZRgD2YrAPWmmieu7VQTBhb+YfdWH4uEEbNb2jXZYmGCuxWBufXxsxyh5mWp1CAEf
         I9ne4QkwPNuAv6bQeImz36ABX1eDagQfcp1nDurjlq4XSKGBrN+QqU2CxV8JTpmWNR5b
         EnRw==
X-Gm-Message-State: AOAM531ATjnd7Ylzr+acI8nH51Xa6uFD5qqm6LsZvvToIbTSJm2HfDcD
        ElgfIsdGpvGIyZi8//EypT9N1RgCUOMn5Q==
X-Google-Smtp-Source: ABdhPJw8koRofs/YsdUPIsVEE/znkG1crga6y0XiAJdFPNcacEfs8ay+pJ3XdbVWTcW9ltwc9B79DQ==
X-Received: by 2002:a63:945:: with SMTP id 66mr2323pgj.432.1644556434305;
        Thu, 10 Feb 2022 21:13:54 -0800 (PST)
Received: from [192.168.43.80] (subs32-116-206-28-48.three.co.id. [116.206.28.48])
        by smtp.gmail.com with ESMTPSA id p2sm13185915pfo.125.2022.02.10.21.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 21:13:53 -0800 (PST)
Message-ID: <1b8cca6f-a892-3cd8-e9b6-1e0e781dd3bb@gmail.com>
Date:   Fri, 11 Feb 2022 12:13:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220209191249.980911721@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
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

On 10/02/22 02.14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
