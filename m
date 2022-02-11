Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF814B1F6D
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 08:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347717AbiBKHju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 02:39:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbiBKHjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 02:39:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DF31A4;
        Thu, 10 Feb 2022 23:39:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x4so4014220plb.4;
        Thu, 10 Feb 2022 23:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=+ebSMBokgiae6CJ5gH8PB6DHwwDMjURK1ERUiTJclcI=;
        b=cZ+bUsA406+qaEEeJG4Lk3aTkio+IuE+cyQt7Q4Mw4MOtjLFXpMEdj3ETxfEmp0I7V
         FogTLiWVPpjuDCJRE/5RDC8QXkHUdpvvLIiWCnY+a2ScwkOKyGWL+KHSHP6IRoyQG3aF
         /Ju3s8fNTNAn62/ENUdpDpWY7GV2qvUDddu4JKcTwdPMKCraduzMfMRHErg8LuTwKjfh
         lNs1xVBAI6eG3oLpxKywphtujjX3VVOTYriKRl+5d0LlY8q+1PwdrgKst08k5AZeE0WS
         JOmAwOHI6IUfIWjmbAUGvfIO8rMStggFMqqlIs8xuAOKCab+zywRhiw7rDRtwOGpMidy
         qKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=+ebSMBokgiae6CJ5gH8PB6DHwwDMjURK1ERUiTJclcI=;
        b=A5FbCcdjbexi0zDYiEZx+mERzzSQtmSKxt5vqTXEpZqX7bUnIHJWUnKoQCGJXsCxyr
         Ab6uAjkdbgCpIvIf+s1MWeNNHEC3mnedmMPib6DEuRdF9qgV8l5u4maeseTBBFfrl6wB
         uTpmI8f4P/WD3k1xOEParOvm1hrizxiu+CPTKxh85jMyGrp2kpg5rmm/WO6nd8vIaaVJ
         feCWT3KCh3hmMSu8y6rSOdxvxpxe3p1QBnfbi3jIym4b7QxRICS2w+SA39fqckHJ//kR
         KhkEx9tnTsYV8g9500xNTqObzmDrIjoaQrZAhEXd4HLyanvXbvA/+k2/hT+O9oqWi5E0
         rjEw==
X-Gm-Message-State: AOAM531zOnPlXxpyJtKVrokECDZq0pxYwEtqhpdWLiw6yscpB3qwovJ+
        4hRlPeesKQA1wJwmn8epKDE=
X-Google-Smtp-Source: ABdhPJzJzd1ESF/pMfu5F/QYgJD82aXJA2+YgaGQLVxUuJ0UZGChBRe3ZhsrsImca4RRa4AP8aSs+g==
X-Received: by 2002:a17:90a:343:: with SMTP id 3mr484123pjf.224.1644565189125;
        Thu, 10 Feb 2022 23:39:49 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-21.three.co.id. [180.214.232.21])
        by smtp.gmail.com with ESMTPSA id h17sm26288465pfv.198.2022.02.10.23.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 23:39:48 -0800 (PST)
Message-ID: <11d84e6d-bfd0-d82f-6e57-5d7290f354b5@gmail.com>
Date:   Fri, 11 Feb 2022 14:39:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220209191249.887150036@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
