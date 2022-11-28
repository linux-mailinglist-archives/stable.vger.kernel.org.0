Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD863B3BB
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 21:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiK1Uzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 15:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiK1Uzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 15:55:44 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698622F037;
        Mon, 28 Nov 2022 12:55:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g10so11377368plo.11;
        Mon, 28 Nov 2022 12:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aq/k14hHxyqv+R/E0+ZIRLUsEK+p2/petQlrLB89kfU=;
        b=K6bgp2Ndbt8cB0g+NYsOVuj9p8BADh8negD17Pb9B7vzIIu4nezQjaxRFY87IeZZVw
         vJ7lsGhQBj6fb/UGdc+NY09xBP2tZ1u/KX6Xs7yz5V7JMEC90rlNP/VREF4ke0jMTNTz
         BaJO9SeUFy6GD4Bq8pQcuXFfYDnZUbwpmQezqqslq0TRlaiWeGzDa9FBwsa22rYBdBxt
         dkhQ63wrfvhHdGfSdXB2omz1Pex/ChXOcL23SV+bK+vAla/CG8e3RZ5kYptqN7MZLcFo
         Pw+vouFfmW5itJtz0EiIAJQ4wkI0J21NZMWjDhfMn+cs2VRC3Vo/RLLVX5LzymLJi+Nv
         wUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq/k14hHxyqv+R/E0+ZIRLUsEK+p2/petQlrLB89kfU=;
        b=bGdWoH8iN4HZmlrg5NvBeOJdInP3F36+nqN62mJQ2i7kIJ4HdoOGUDjnSkxW0i5Xg5
         WC9lBnGLcZHgCyaCMak64cmiPAYJOx93Il/m7zinx1RaWoUD1pjBRxl8kbIYZeGNcNrD
         Em75nVzYfGLhPRnXk5McydMuzclb0uu4fJPwqwl8uiCu/UZ4YNEuCMycwsjo9K/U4pp7
         LsHhvlW0W3KRy1HvJ7xyOVKTvNtrhG/hicVtYLaPKOAZTfmTfW3kUlVu3O4QZdc6K418
         lGOvfKQZ4rmRPVPkLUtqTXVxIYzYpdpmrMK/IZJtnrYDzOSwTbfJDXlwGx08JdBLCZyB
         nLfg==
X-Gm-Message-State: ANoB5plGWPo/Mgacx8z8KfzjZyNzOy/yx4bThjtdraceqQLOsvCn+FRg
        uZvpWrQL0XKQo6RPMhFI9RcW+mHe+i8=
X-Google-Smtp-Source: AA0mqf4EmPJGQk9BL0tECBExCJGFn+d7sIW8KY71HLgIBfLHHjRTd0PRGwlA6xERrn4SCcY3sBVliA==
X-Received: by 2002:a17:90a:5c85:b0:20a:92d2:226a with SMTP id r5-20020a17090a5c8500b0020a92d2226amr45039647pji.155.1669668938878;
        Mon, 28 Nov 2022 12:55:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b13-20020a170902d50d00b0017f73caf588sm9260002plg.218.2022.11.28.12.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:55:38 -0800 (PST)
Message-ID: <1e5d85a0-6edc-bde4-6493-c2b2ac25c760@gmail.com>
Date:   Mon, 28 Nov 2022 12:55:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221125075804.064161337@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/22 23:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

