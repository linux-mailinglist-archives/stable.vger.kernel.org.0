Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC2B6DFBE7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDLQyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 12:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjDLQyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 12:54:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C874206;
        Wed, 12 Apr 2023 09:54:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b2-20020a17090a6e0200b002470b249e59so1124358pjk.4;
        Wed, 12 Apr 2023 09:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681318398; x=1683910398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=svKE2Vd+mVEPF5FMwXkomHu4DRBlZ0ZAxPOWlhr/OIU=;
        b=gk0Le4iV1SfVvzyHk2McZLdrmZlTcuC70+BAG9tJx3Dl99K1N6BOKdKc9hYwRtYaaT
         yuzXMA3xTNfiTHo/6qTW6m5sliFiNSmwYUQtvybF7Q3D8G8Fhf4w09u1K5+/JHmTCD4T
         aDIIyMy/52dsz77dK9zryhdSAXiKR5/oV3fMHuKnB8RFKY5+6z6zFmnuDD59mYY98u+5
         AazhxT7lbTpkwxQXHxaYeYU/u2hkz8lJyTv14NdqxNLUtMRu773n0qrd/6ZjbAs4r+og
         krCn+Cic71gMPA8gmu6H0ARI7JRM1mpSDNG6XyUVa5+ebU2mUexMvzhzFoTlngQeuOKk
         LuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318398; x=1683910398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svKE2Vd+mVEPF5FMwXkomHu4DRBlZ0ZAxPOWlhr/OIU=;
        b=HkTDwHS3Gs4VGjCAV8lO22MO7KT7PILe6hWZICTTISCRUo+WPp70sZbZnyml0JKlbV
         mVblS7YLHOzGvlV/Y/ecexmB8+JPGkqWNJeJks6bBfMAnw7UTLfPJQlSU/3OORg0qgKq
         KcMMRvwYVeGM9r1i1Uay6apHvjMBX3O3D9Wg2txK3HHxR2VLSwH+U+zH9MkdkP8Nbzjf
         2PAhdS3P83FWl+6xGaUxxxmWgG+gSzNoKpqZPCYAgYqBYHjJxptMHE0Lzm/7g+uRytsm
         32+72Z55dtWrq0cTFCMXYRhzvjEt3WEm3s/63nbgZLjrltdYBLpvUoW7U75Wb9PoOVEk
         9L4w==
X-Gm-Message-State: AAQBX9eFCVbmY0B+wAzVVhKvGyba1ErEOdVC3jMPGeq2AXje87QcMIXa
        Dc/FIHwbEeeRE8EbvkO5Dg8=
X-Google-Smtp-Source: AKy350YAciQEkRZtVRmlMlv0UthOqCVxofwPzJcsir6JhllD5+o7/Sa5Sg3UPbTrGGwL7kFNOlJIvQ==
X-Received: by 2002:a17:902:d2cb:b0:1a2:37fc:b591 with SMTP id n11-20020a170902d2cb00b001a237fcb591mr9883195plc.69.1681318398402;
        Wed, 12 Apr 2023 09:53:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iz15-20020a170902ef8f00b001a1dc2be791sm6718454plb.259.2023.04.12.09.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:53:17 -0700 (PDT)
Message-ID: <5d683cd2-c989-c3e5-b55f-cd31aa78c7c8@gmail.com>
Date:   Wed, 12 Apr 2023 09:53:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082823.045155996@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 01:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

