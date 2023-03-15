Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8B36BB614
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjCOOc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjCOOc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:32:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277F21F5EB;
        Wed, 15 Mar 2023 07:32:20 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h5so6411990ile.13;
        Wed, 15 Mar 2023 07:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+sa882HWJ4UleFPTHPmttlCN7M6tCbr8bt+aCQ/0MVE=;
        b=Xy+ZeuOcdxzn1KvLO5FU8ZXKFUpQ2kieKEO5CQiZqguVWdo6eju6697yhHtMB14xjN
         iIGuqm0oRUvag+ZqaF07MbjJh8SEFIwAp8DSfStWJ6KNcUzDt7NDLBmVIlTM47Y6zHnv
         sW1fPZrv6Qub9xQPVgx2qtlF5Lkpu0AIeIherdwRfHBLOplxj6Rfcl8tq32aDx4IUtNE
         6n/JY+4zPlamkh7hGo+pcarPOWrnqw1/gHH4+5NNSe2QvkA2kA/KEEzqaDp0qDe7rNGd
         PK90PM0sb1U7YTtQ8zkYaYiRubY7fEg+Q8dUzoFiyWVOD00GUev7NmDcZvWZRCpbogFC
         amFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sa882HWJ4UleFPTHPmttlCN7M6tCbr8bt+aCQ/0MVE=;
        b=j/sPIFXywbyXOp2TzGOa9FbXC1Jc4hiSr+N8s82WjKhL7IcEeavKQO88gZ5wgxw3SN
         2mIwa229r43/O3LA8vbf1ah9yELLX19o7d+YPEAjsTstop7FGEZDdQ7a+S1UNvWTm4UV
         4hAxhJqbkr3QzU57jHiCsgIw8wDKNXMlaOzE5YEuxEfyy+o1i1Sti481/ct0bHxwmPvN
         mOlIntPR9KgMbBBCIGGNnmMcd9eDwjl5B9dFabKkPqZnT7An3jJFf0vae8oWI2uktgEV
         ae9RooBkezar4tbHnIjh2JW/HNxCU8AMpWNitDFoEA9W1UuTuRt+W302TFzervDRifJR
         Z3EA==
X-Gm-Message-State: AO0yUKUQC/6wLqtDz3gYZVxN6ZmHAizsArn8sY7DOIiUK8RFFSuxpnSq
        pYctZpEm1lzOWUHzMuqvHFQ=
X-Google-Smtp-Source: AK7set9/WSLL7bvG5rGW/c3DlwOa0kidp25js0YUNkQWc0Xt2Uxfp4+N4cxtgiYyWk4g15BlI8/08Q==
X-Received: by 2002:a05:6e02:1c47:b0:315:4a48:aaf with SMTP id d7-20020a056e021c4700b003154a480aafmr5058655ilg.14.1678890739490;
        Wed, 15 Mar 2023 07:32:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o16-20020a02b810000000b003eb3be5601csm1682421jam.174.2023.03.15.07.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:32:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9dad73af-ce00-9c83-24ed-ffecaf9cae28@roeck-us.net>
Date:   Wed, 15 Mar 2023 07:32:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115721.234756306@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Building arm64:defconfig ... failed
--------------
Error log:
kernel/cgroup/cgroup.c: In function 'cgroup_attach_lock':
kernel/cgroup/cgroup.c:2237:9: error: implicit declaration of function 'get_online_cpus'; did you mean 'get_online_mems'? [-Werror=implicit-function-declaration]
  2237 |         get_online_cpus();
       |         ^~~~~~~~~~~~~~~
       |         get_online_mems
kernel/cgroup/cgroup.c: In function 'cgroup_attach_unlock':
kernel/cgroup/cgroup.c:2248:9: error: implicit declaration of function 'put_online_cpus'; did you mean 'num_online_cpus'? [-Werror=implicit-function-declaration]
  2248 |         put_online_cpus();
       |         ^~~~~~~~~~~~~~~
       |         num_online_cpus

This affects other architectures as well. Builds are not complete
so I don't see the full impact yet.

Guenter

