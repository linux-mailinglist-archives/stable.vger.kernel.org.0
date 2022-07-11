Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB45709D4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiGKSVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:21:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969FB5D0E0;
        Mon, 11 Jul 2022 11:21:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id r6so2696026plg.3;
        Mon, 11 Jul 2022 11:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IEhXinuEzpmvFUBM70vs9k4IkheO/2JqCVe0yT+x34U=;
        b=nGL8giCRxgSDzuQiJApnh6wMNBfkjFf/yaAc5m94gkgTmzetH3npWlRzLtBLctkykS
         Ywl0GTFZzQ30dzZYOklyG+wyJfjvL3TLsfMYy8kshNQd0gv9yHZctkAkWQuNAurVk8Lw
         nvoK4VjsLJIfbZmZ0l5yoG3XtFXzmkBiBEYcUoIiZIG/XONd6piuiLmcj4oCJm1/SkRX
         eCQpoZGFat3/iyVgNptOR4q55v6dKpF8sCfzrK5stROjTRgsblgPmclTrIC2AqmhcDY2
         4zApFR89tjyexR4tmGCJnu3DErxRXMau0Sy0BOCuonLyVGCV+oPWEpao2mgT2MTy6e+n
         0/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IEhXinuEzpmvFUBM70vs9k4IkheO/2JqCVe0yT+x34U=;
        b=oDMLbZyeQYrdd0BrOkhqGhyNmyELle7HKcqchhWXvDVmSA7WCtuMmLlGunjWcjHEnI
         Hb37Zk4EIfIzbCCCi9+uwKFAfWS5V0/cffGXULNoNIlTRdTLbwgId1WvptgJ1hOg1J8B
         Ov/mmEaZRQ/S6j+oSecibwE3dqxUo1GIflhshiobUppd9hvPWnrJaab7PDX3RHvUV9XF
         ARumBL6jw0YBCAuywbjvSnJ4KvIuXDZHMjQXrIHuyjwK1EKeUspA3QojUdY1qtVtWsEP
         f+Y3EpcmegqrnadhkSRXHv4qmAtnwbIkX42/t1gsW/IOa/1duqFWtz/EGW2DtB9kQvkz
         4mlQ==
X-Gm-Message-State: AJIora+37VqMp9VU90Q18YeaT27RuknV36wjT1bEodLgJsJBm8nkLlve
        E5a/rvSoAlB9gK9yfgxcpHY=
X-Google-Smtp-Source: AGRyM1tHheKKocOba0CKrsfbDYdVbHNdbz+fAkJ+drBAZKLIcv2sc+rsi3UwpNQosftErrwi51ZRJg==
X-Received: by 2002:a17:903:244d:b0:16c:52f1:d12 with SMTP id l13-20020a170903244d00b0016c52f10d12mr2909632pls.44.1657563702085;
        Mon, 11 Jul 2022 11:21:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o13-20020a170902d4cd00b0016c438b233bsm2953403plg.277.2022.07.11.11.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:21:41 -0700 (PDT)
Message-ID: <9152b47b-a75c-57b9-d56d-2cfda3502f05@gmail.com>
Date:   Mon, 11 Jul 2022 11:20:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/55] 5.10.130-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711090541.764895984@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 02:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.130 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.130-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
