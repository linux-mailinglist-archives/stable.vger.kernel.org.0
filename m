Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02536516B0
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 00:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiLSXWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 18:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLSXWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 18:22:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3720E5FA0;
        Mon, 19 Dec 2022 15:22:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so10367651pjd.5;
        Mon, 19 Dec 2022 15:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=92qNU0Pb2An2LZWcMglNNqJebkSusC9umdTJ4WDVykw=;
        b=pjzTUfJ46fLQi4dWC9vri+3Yn1OAC9s266Yv9Ns5Bxwtfw2TtPg6AABhb6JZcbvYam
         18ZqgY9J+IxnxZMKpU/HJlUB80YQP5ewnR2boqsMCy5lfaaAXnwiPdapfoNRCLfcL1rv
         zSsy8zNgp3094o3iwciKyFFe/mFKza5jdJE5v3lwn+9EZJN0FyUckgYevwlbc87wW2E0
         x8Yi3zbOrvxUNe6KXt/9KsHMp2mN7sNM0AN7Kr0Wk7gIRo1PqEuNNnt+TsWY0V1eDZx+
         8/jWt5ycHQ1TlhFuJ54l4BG2EB4jiPT5PCnriVT6CnGSSN0gmBeIu8xbFu4HXRrggXbu
         9rSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92qNU0Pb2An2LZWcMglNNqJebkSusC9umdTJ4WDVykw=;
        b=NVCrGl/R+F/SriHgD1MsIqE7GEEoMaQahLV3Ct8IVasI7zd56ZPTayKHpJatW/Bq8D
         1S+bJH325lKuKoz/iI4tlfjuQuzvifisc14YVsEFNgn4l0uOjjq3kgFlqstxeNHJlqmV
         emiJUkNno1fRt2KhsqFxkcsZGBJ2KDda/uzZL1MbmBp5A2hJ8WA487VEJv61tNLpZdHb
         2FNwsVbBwKQsanqVy+Cnlr0+DKEgBFqBTjbSagGcdu03lc5bajElVkqxOc7PLnO/yNQB
         F2hH0pBwv+2neCHm+MrozjSd+GqkRQGWZnFnkFTbJ1XA3+1+5m7P/UKXY/XjRhwjcVMM
         OdbA==
X-Gm-Message-State: AFqh2kpo/8cNOpDgrPwwXJebrz46rHymTLmUF7EO9Ome5em6eFXm378v
        8/WCQQHj1HD+rMn1Ocrhgtg=
X-Google-Smtp-Source: AMrXdXsUNtrXcUDFBBp/ETSAt1qfFRJ2Ev7+yfubKUCERURB2rFZdvhPppebIcm2RnanK6C8hX+1yg==
X-Received: by 2002:a17:902:f648:b0:191:327d:ddc0 with SMTP id m8-20020a170902f64800b00191327dddc0mr857547plg.21.1671492128605;
        Mon, 19 Dec 2022 15:22:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b12-20020a170903228c00b00177faf558b5sm7677791plh.250.2022.12.19.15.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 15:22:08 -0800 (PST)
Message-ID: <af80e9fe-2929-d909-4c11-4fdcffd74780@gmail.com>
Date:   Mon, 19 Dec 2022 15:21:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182940.701087296@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
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

On 12/19/22 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

