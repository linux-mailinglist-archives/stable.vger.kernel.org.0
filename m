Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5858F4D9A30
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 12:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348053AbiCOLSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 07:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347935AbiCOLR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 07:17:58 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7764FC48;
        Tue, 15 Mar 2022 04:16:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s8so19072254pfk.12;
        Tue, 15 Mar 2022 04:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AAkE7SxftAfpvES/fDnH9bGKGtxk3gDXiZ/9FkRestw=;
        b=D9ZZQPHHiKEaIeKTdYsJAqn35qZ16PfsixcHx5xFjv48ZBFypa8/C6pfnAWzlJ8ni2
         FmkpntlcbOqBammXerT1azupg45uFvRgkbM+sjRaFh2Qh/mnbClCG48HolUBluzvzrcf
         pzIycnd/Uw0/HR6c0VoMXOVHTNAzt+d7EoimnuVSkT83z8Zc3Tp3l7AxXKbhUUpQwZ5x
         WXZi/TdYY32IHI1sYl9rL8X4yyIF9wt5BLxUX1b2BxWVdzSUjymphoci0gd6FxW4wt2v
         +m7MMAe9wo2PghXaYVOX3Bqjam2IOezbFYAObZNNG+1GZb65dPEhqtriAmrW210F0zQ7
         uf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AAkE7SxftAfpvES/fDnH9bGKGtxk3gDXiZ/9FkRestw=;
        b=m3tdNJM7nsIFG1sbQZNaE7l7oXgYLuar88gf38XBrUb49OWf8+7b0ADTwPWYZOIiI6
         GUYDAdBBhCfIZWdbfBTQKLDt49WiAP0Iph6YZ/tYRhaMusb2UZgSdnAIy4ZVb4pMl4dv
         4iAoj8VbCFtZIDH9xrZJXWg5ZWzfc4ixMS6gqyYdr+1FRJNInIMUe+n2dU03wVFzjDtO
         63/NNs7/VMzReBWXewmpxxPryEN9CYUQ8xBkM7YJaz24uDhWSAuwBmGCj5ppctHJVExw
         qagKGXNf+Fq4BZ53eW5n5bl1AxhUgzJPC4mQVfrB46JuUtPwnnMmlCkiksH89gSzImZz
         +jnw==
X-Gm-Message-State: AOAM533rrP+55vq+mkIBwB9BaZ7Npb4G6+iviyVIoiXtMhX/CMiYSoT3
        k70AguVBy5K1XJgdl9Se0oQ=
X-Google-Smtp-Source: ABdhPJyv3EGVr7ESkHPJeXerNP7DwA2YOyixhtm7IUDDtGO/9IwMDnnlymyRHsry7symUmuGUKUkXg==
X-Received: by 2002:a63:10c:0:b0:36c:6dd0:44af with SMTP id 12-20020a63010c000000b0036c6dd044afmr23371203pgb.41.1647343005769;
        Tue, 15 Mar 2022 04:16:45 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-1.three.co.id. [180.214.233.1])
        by smtp.gmail.com with ESMTPSA id na8-20020a17090b4c0800b001bf191ee347sm2862660pjb.27.2022.03.15.04.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 04:16:45 -0700 (PDT)
Message-ID: <14882244-3ec4-7185-c872-143db25b2165@gmail.com>
Date:   Tue, 15 Mar 2022 18:16:39 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220314112744.120491875@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
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

On 14/03/22 18.53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
