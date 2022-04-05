Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19C64F47C4
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiDEVUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452239AbiDEPyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:54:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4560CCD;
        Tue,  5 Apr 2022 07:51:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h19so12324502pfv.1;
        Tue, 05 Apr 2022 07:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q+15Oawdm+s4IbChY8Qhyeh/dopVPtV/8IyA3nSGdqc=;
        b=br+1UKd3iP8/h3pi8B267stHZwGSECHyUjToTb4xSF6sJ8ITrZNGuEld7tOA4x+kAk
         TOtiwQBmyt/VV00wBE6EGSpluZpLMs0COncJEQE0fUiixo094sBc5ErDPbt3kpIg2zH8
         4aBzDK5CtKt1euYVRp3soMX0oXg43GARrWrY6s/L7PKGjw9IA/aQn2MzH3IeYjZcm0H5
         TWDB9onOg4mExGPS+iiA7XluM8/5TrfE/4M+cOCiAMVdGhMukgAP8DlhXXPop2e/jpdd
         eYzbcEjRbPcpYWfMTyA/6VlTJyId9/YzC/iEe0AosU+2cutD80lWTiWt55V5ANoT9kU7
         awIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q+15Oawdm+s4IbChY8Qhyeh/dopVPtV/8IyA3nSGdqc=;
        b=iYS+3KS8qLB35D5knWKggS6pPF/JwryW6bl/oaB45tavB15kzDRamPeECcrEH070kC
         h82pkitGE9B4N0iOWdw2Ybajro7dyXNLeidSN+AVd1TdH74rNS9liq3ouyPojY0ik+ER
         gs3yNZdDkZigmjTasOo1bWqcyAvG08L6cLuZFwEC056uZkQqkpp2jUpKrBwcQMX4ZgrV
         9XvOr1scs99cNRBV8ly6Dlg+aH4odd5NOwRTHRDZ4MVqL4vVlGnJcjLFWPhN1U276YW6
         qU5LnbcbFQCP2gIgeLJkiUbbzLauc6v4Dwq36hdXtWGvsd7D1zjRNWo+ZCkW9qy7cEPf
         qOZw==
X-Gm-Message-State: AOAM530dcHkjeYzgKgZzFn5Swcu/+Ds96oinEEKJBq2MBrGFkjfMKWzy
        HxNjVd4g7A6Dt73fSNAb9YM=
X-Google-Smtp-Source: ABdhPJz11ti+4wlG2/u+BVt7lhWyMOCDEaK9wUqU1ciZmcGl6lq6OEnK95hxlzJP+oFnZ7gRyIKm7A==
X-Received: by 2002:a63:ed45:0:b0:399:5116:312a with SMTP id m5-20020a63ed45000000b003995116312amr3084061pgk.611.1649170269609;
        Tue, 05 Apr 2022 07:51:09 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u15-20020a056a00098f00b004faa58d44eesm17487493pfg.145.2022.04.05.07.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:51:08 -0700 (PDT)
Message-ID: <2c3809ad-4302-a8b2-1282-74efff2f77ff@gmail.com>
Date:   Tue, 5 Apr 2022 07:51:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070258.802373272@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2022 12:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc1.gz
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
