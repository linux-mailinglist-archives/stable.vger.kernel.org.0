Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F0161000E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ0SSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ0SSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:18:46 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8719CDBC;
        Thu, 27 Oct 2022 11:18:45 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13b6c1c89bdso3209355fac.13;
        Thu, 27 Oct 2022 11:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ft3GsmDHQiijtAgXFeKZ1FHd0R2eTHzEp0HfUcjSdV0=;
        b=CrJ0sen4en7UihQrzYnp7HiMgQeI5bm4cbFdXytRjD1hoYJpLaSObCuo07OO0cdYng
         3ollvA0sYMffet//jaysZNA00QeSOSOGb07OXjTys0fiooO7Kg3A1z40SKsT8Dh//oUE
         Jn6eb7c/P4CMrBsaFfd0tybt+8Lslypa05BY1zA/3FWTPbBOCOaoLvXiRHGCWMdoHkJz
         znkeL8KurHUaC2FBopuGZA4jcy+5q2NkZCCqSSnbJzS2sKUhB56N0ABXKnj0n2CIJLmw
         8MT0OTf7vE9R3niBBtGPdn4JOG9Co9+jgHFJEjYn7N3PhKgliLgDrdxd54LO345ZkAOY
         2LmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ft3GsmDHQiijtAgXFeKZ1FHd0R2eTHzEp0HfUcjSdV0=;
        b=m7I0+lNMLJKcyrB1i84vbz3JcNon0PT1G0AX0ikRYx3vqIwY+/yoodbF7j/zwJEqPW
         i1ngbTDK6ojwaySn0EO5LbXa3ET+7HuKL3bIpM4alhN4crI2smvbZy7vsoM9JYOcA3Xp
         q914WOWktTyKK3RBoGExONJpo7Y1ARtnqAuBeLCs1OFfDbrbdvbyYapmBYHvF0TbbSbw
         PJv1O4aXqTteX80gSwlNf169+CBGTuxUhnijMiTtebVxycTzD+I3TIxeW8VO4TIh7nJv
         DVpcKaLb8pARly0Wrv1QgsZ/DBjzy++IjhN9GnvKHfSPXsMUJnVS1iaNhgas3p/2kvkE
         fu4g==
X-Gm-Message-State: ACrzQf17ZIVztt4GVecmF4o6z4Gg2K8N7qI3j4eD7K2dfiPbtVaa39TF
        OWafQ92pSHJJe0qb02Ek2Dc=
X-Google-Smtp-Source: AMsMyM6r6WNeVGs7k+7AXoc8GPNNntZhYhBTanwDXW9sHPSF3iwAqQMDq55wUsp/p7hjY2QZq3aUvA==
X-Received: by 2002:a05:6870:c0d1:b0:13b:a5f:e17a with SMTP id e17-20020a056870c0d100b0013b0a5fe17amr6222481oad.274.1666894724885;
        Thu, 27 Oct 2022 11:18:44 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t23-20020a05680800d700b00359b83e3df1sm683336oic.9.2022.10.27.11.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 11:18:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>
Date:   Thu, 27 Oct 2022 11:18:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221027165054.917467648@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
Building arm64:allmodconfig ... failed
--------------
Error log:
In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
drivers/cpufreq/tegra194-cpufreq.c:282:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/module.h:244:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |               ^~~~
include/linux/module.h:244:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:417:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
   417 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       | ^~~~~~~~~~~~~~~~~~~
include/linux/module.h:244:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:282:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       | ^~~~~~~~~~~~~~~~~~~
make[3]: [scripts/Makefile.build:289: drivers/cpufreq/tegra194-cpufreq.o] Error 1 (ignored)
ERROR: modpost: missing MODULE_LICENSE() in drivers/cpufreq/tegra194-cpufreq.o
make[2]: [scripts/Makefile.modpost:133: modules-only.symvers] Error 1 (ignored)

I don't know what exactly happened, but commit b281adc68db8 ("cpufreq:
tegra194: Fix module loading") introduces a second MODULE_DEVICE_TABLE
at the wrong location, causing the build failure.

Guenter

