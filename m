Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA154F7A91
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiDGI5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiDGI5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:57:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DE1C7F26;
        Thu,  7 Apr 2022 01:55:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ch16-20020a17090af41000b001ca867ef52bso6035448pjb.0;
        Thu, 07 Apr 2022 01:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=e/SRJZVa+pnGFAQo/DwKcWQpRPq+V+tMl7YCYye8ky8=;
        b=Za5XoHpE3z6/fpXB3ca8tbDAq9xX0zhpil4PKZb0dvl/rgE7sgQg/bkx4mHJY/IH6P
         cxjXlZrvDwbZsfqacuCmxrQTj/qqlcy0c7kC9y7DUMM7hER+FC6zVmEghCMBeQo1s9uG
         U3FLUTf0zpoFMszLWUbyisyJzur9Z/1hWs9jg6yYjkWVNcxYJZRyO8YptFBnwLPM0YNb
         Nc3MEaFgzw6zKKzbbcU0ghuGBbxJYjMxb34t16Alh+BkliXaf088ALOrs+vuWYh8mMpa
         i8a92U9ExfWjLS+/1QSgKbjwNxdnZZs288jgwSFDt+WF0iwMmV8ye4lQBiYuvsHUYZWz
         6sXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/SRJZVa+pnGFAQo/DwKcWQpRPq+V+tMl7YCYye8ky8=;
        b=HbCig1hR2hMG33ps6PxVk5vNDuC/IW2A8L9yNNu/hvcir36CgrdD4fh/DKzqDu6HyD
         YtmzbyFutirf1CBMQyRwrMXseM08lMzlrSXUp6I65XFsGyXV3L3/xZUeA2EjZPfkvOV+
         0HpIThUJVD2ocY1a5scqdq1yCY/CYswpmJu+Hv7ZCj6GJGlqR/2DP7aZmg6vLS0Y0z7T
         v388i9Vdll3q9WplcKwhRVWVdMH3H1J9Wof+nSKl15oUih1Su0EkyK4XNvqeEOvF/v7H
         +BXbI0ArZh3v0Cmi5q7CvmjIn0NkHyEkuaigWlOwXvOnSqFwJATB8PvZdIPpSoEtJC+S
         KKlw==
X-Gm-Message-State: AOAM531EWXuGSB1pw7gHF5JSGgazxcH8iAJvfdAqSepGkcAUZBnOxD0s
        fOdChWDwet8SxbR7BgIl68U=
X-Google-Smtp-Source: ABdhPJzq6mIJdzeGR7PpscKazLC0a0+GeljWRO9npUDAFsvbjAAsjD2jwiPFr4UEIWuK3k51pQoe7A==
X-Received: by 2002:a17:90a:7f94:b0:1cb:1853:da1b with SMTP id m20-20020a17090a7f9400b001cb1853da1bmr1334040pjl.14.1649321705066;
        Thu, 07 Apr 2022 01:55:05 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-43.three.co.id. [116.206.28.43])
        by smtp.gmail.com with ESMTPSA id t38-20020a634626000000b0039cc30b7c93sm1672908pga.82.2022.04.07.01.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 01:55:04 -0700 (PDT)
Message-ID: <7a7fbb50-2f6f-ad99-2bf5-68b2b4028acc@gmail.com>
Date:   Thu, 7 Apr 2022 15:54:58 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 0000/1014] 5.16.19-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133109.570377390@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220406133109.570377390@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1014 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
