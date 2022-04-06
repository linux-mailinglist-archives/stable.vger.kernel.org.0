Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6ED4F5CFF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiDFL7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 07:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiDFL6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 07:58:22 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5662F5282C3;
        Wed,  6 Apr 2022 00:29:14 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id c42so1549052edf.3;
        Wed, 06 Apr 2022 00:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z2ezFCGSgEKTPnQs0DP8kH2hHy8925AWGsEZVjbFb28=;
        b=QmN9XOVXxNyOG2DMKazonMak7I6SnD2Zf73bGetw0HJ4yxHcETL6R/6nGH9SxC7a/5
         l1BzXOYhI4TzHpsrit+gN2WPO+Vo+INTt+ZdtGnUhHsdXIwzfuPtbbrzk8Rp4OYxrHhg
         D+P1MKfzQlcMjisOU4i1+Irxfe0ELQuZ50L/6YaC+PrlPvzjBx9JSbixbcMVDPVsxgcX
         xZRJ/Bj03l74Wdvfn0VrXmHcFPdfv96U97Rh2Q78MAW+FdHWbYIy7pfxx5Lnu20viUJh
         ywMhtIKklqxt9F9SNN/VNobcsKvguVTEoBWhoypHpI29Kis65HKWROocCZYURXkb9nzF
         qdPQ==
X-Gm-Message-State: AOAM531gNvqxX8pboHGhp40b4MSDnNPpZuVETviWASnT/XSO1SnKj9N0
        TzcMOexoEML/x+4+tr+IDtU=
X-Google-Smtp-Source: ABdhPJxJShJKSQPDE3igoNzaaijVwWVNhBe249ZbL2htOyfxK8Nzl3j2yHZRzom190k1LuYuNsRkNw==
X-Received: by 2002:aa7:de93:0:b0:418:d700:662a with SMTP id j19-20020aa7de93000000b00418d700662amr7335334edv.107.1649230152714;
        Wed, 06 Apr 2022 00:29:12 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id w22-20020a056402269600b004194f4eb3e7sm7815060edd.19.2022.04.06.00.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 00:29:11 -0700 (PDT)
Message-ID: <8ea245ed-eac9-1cd5-31bd-150a06378872@kernel.org>
Date:   Wed, 6 Apr 2022 09:29:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220405070407.513532867@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05. 04. 22, 9:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
...
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>      ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP

Fails to build w/ suse x86_64 default config [1] (and x86_32 too):
 > sound/soc/intel/boards/sof_es8336.c: In function ‘sof_es8336_probe’:
 > sound/soc/intel/boards/sof_es8336.c:482:32: error: ‘struct 
snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
mean ‘link_mask’?
 >   482 |         if (!mach->mach_params.i2s_link_mask) {
 >       |                                ^~~~~~~~~~~~~
 >       |                                link_mask
 > sound/soc/intel/boards/sof_es8336.c:494:39: error: ‘struct 
snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
mean ‘link_mask’?
 >   494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
 >       |                                       ^~~~~~~~~~~~~
 >       |                                       link_mask
 > sound/soc/intel/boards/sof_es8336.c:496:44: error: ‘struct 
snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
mean ‘link_mask’?
 >   496 |                 else if (mach->mach_params.i2s_link_mask & 
BIT(1))
 >       |                                            ^~~~~~~~~~~~~
 >       |                                            link_mask
 > sound/soc/intel/boards/sof_es8336.c:498:45: error: ‘struct 
snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you 
mean ‘link_mask’?
 >   498 |                 else  if (mach->mach_params.i2s_link_mask & 
BIT(0))
 >       |                                             ^~~~~~~~~~~~~
 >       |                                             link_mask

So 679aa83a0fb70dcbf9e97c is missing -- but likely more is needed.

[1] 
https://raw.githubusercontent.com/SUSE/kernel-source/stable/config/x86_64/default

regards,
-- 
js
suse labs
