Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EF1583FB3
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiG1NNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbiG1NNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:13:48 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD861BEBA;
        Thu, 28 Jul 2022 06:13:47 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10e615a36b0so741862fac.1;
        Thu, 28 Jul 2022 06:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fntp37A2ZM1jsqUQe1WOs9WjI9pqp0FHO+6vN3U6LqQ=;
        b=b5w5Cwcx5OFpChR9iMqoHlJh3IwH7nOBr7Jz7dIsSpDXaeg5b/R+xuHTgB0eW+Mxbb
         ymhdjRh1qwqk/QDdIFBtnMiQRSc5OF7ApKptouc1rTOjP1Sl/2xQ43A4Vd75RmdL6U/w
         Nd2Y6SEgEnKqHet7lShrb1iS5osP47SktKgHNmldEnqpAzqpvEY1SKtwvQ6Y1RJZCEnp
         4oD+yPPn9yt9F44wWcolIgnf2Cvkiq4Ie7UbNAu1LIu+2D18es8PtcVgAsLDMMXns/K4
         V5KkVvlyBwn2hAfoplrei/1F4iH8YSoPAkl4I8zLqDbAdGOW7/7ljQeFeXUcXX6z4Ge6
         R2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fntp37A2ZM1jsqUQe1WOs9WjI9pqp0FHO+6vN3U6LqQ=;
        b=gEvl4W5E3JhHUaaAOVMuRw6SlUBM2f0oXNnxeCe+m1cKhdwcyDJ0cKrrGmf2zhv9N6
         hrhd8pb3wmQm1dlvZpD276brT8tLolviIgrayaBfSbyj+Mgh8oq7XW6Zv5XaFhRVlDvX
         lMuZY0JJT9rIMAmVBLv936TrGzXMxO/L5EXGEw8PtWWC72LE3GnzmZb0LJrzvf4RecvU
         9MGZGTIwSwxmS7GdNCN69pkgY75eSZBvxPZhSyOpR2eLnx7gRgZlf8v6uuaiwc9grKlR
         jA8LRVvkmVIKZlNKCwLfrwIbjbdFnajKX+1DCip95qIAwu1q/X6egLOPH9a5EFOOxY75
         pnjA==
X-Gm-Message-State: AJIora84KgXan1v85HZleyLUSsHUR4T9cohTD8nHrhZ4uoxsbfqi93pU
        IQhQbRiJGQMh7v1P262IVjo=
X-Google-Smtp-Source: AGRyM1t2Zl5X7crOLnFNQi+wEs0/Tm3JLWQMclWfAMvhKQDuTS/N+M0+a7PgcOTO2EzAX+TTxwzJhQ==
X-Received: by 2002:a05:6870:d0cd:b0:10e:d6:a10f with SMTP id k13-20020a056870d0cd00b0010e00d6a10fmr4674230oaa.179.1659014026310;
        Thu, 28 Jul 2022 06:13:46 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q22-20020a056870e61600b000f2455e26acsm374808oag.48.2022.07.28.06.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 06:13:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fa5fd00e-d71f-da29-0242-058026f90128@roeck-us.net>
Date:   Thu, 28 Jul 2022 06:13:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161026.977588183@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 09:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Building i386:allyesconfig ... failed
--------------
Error log:
In file included from drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:37,
                  from drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services_types.h:29,
                  from drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:29:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'dm_dmub_outbox1_low_irq':
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:761:51: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'unsigned int'

Needs commit 655c167edc8c26 ("drm/amd/display: Fix wrong format specifier
in amdgpu_dm.c").

Guenter
