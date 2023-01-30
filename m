Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C136819F8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbjA3TJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 14:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbjA3TJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 14:09:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA73C66B;
        Mon, 30 Jan 2023 11:09:40 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h9so4086210plf.9;
        Mon, 30 Jan 2023 11:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ort/gBdj1vdteBB8Y2X65MVVB8dvR1Pgw/FQaZkcyXI=;
        b=aVZNKi70t5hY8u5qYrUNfmWf31V9R0KhD3SEynrGNjMtgovQGSXaS40tqH+SBH1d7H
         q4OELhukPtKeRDvYEmYNFSWRpUuh5ModCuENHIeKb2lDkrQpaI6OHo6x/a/PqjRl21wt
         GPRlp7QuUZyEukuHOGAHxf+e17YiEDMv9+HWkDAy07zHf5caE0tTjEqtlxhkuqRkvAnY
         wgYX2yTGEPpF92q30TDfcX29cfjxPLtlVJ8HR5fuhUYpjvjMZe/UdMRMPZQcgs53F+lx
         XyY0Cyc1gB3BR2+US0vknICJgGesKg/o/jt7VQABGfLfS4itY/cEV5H4DYXnbjceAMp6
         nsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ort/gBdj1vdteBB8Y2X65MVVB8dvR1Pgw/FQaZkcyXI=;
        b=N9aJfOxlNyo414KQzYrnQwVf27iJ+4SJLwYZKMDGQQPx8GvPAqFlyBFSVXqyd9yWj0
         tf2KFJvpdU1+Ckym86dYaG/yrI0wRP3ZeuDRjq5I0RgHKATTE2GyClONLrDfsYoB7M12
         djFDjzLyQVjyOQSEEdHKAAOgPjhC36JnBAI5ylnLXDlGiBd7zE6VrqfZ+1rKx7XYnNCZ
         g2hGl8+OQpKnhnmJGmb+bv9FxXYAvgRxYE698vFFXyPvQlnS5r+0HXDHmwpUQcTnOyUn
         LvHEH9bD3VEYo73rgEwBX/L4wAX+NVcoD3j24rdo9IB06eL5a424sFTOVCNBA+kDJi++
         N6gQ==
X-Gm-Message-State: AO0yUKURsdBAeAPZ/rVpcVoDX8EgPPxu8vj6vClLOZ4bm+7R1L+gycuT
        OjLUpperLrTzt3se5+3pNUI=
X-Google-Smtp-Source: AK7set+hyHexHpct2JSs9hZ/I1lSdj5nzs2zz7B3Fh9+LxbLsXziB8PpYJA1JYoeBgK1Zpo8hkxikA==
X-Received: by 2002:a17:90b:1e4e:b0:22b:f834:3fac with SMTP id pi14-20020a17090b1e4e00b0022bf8343facmr24623937pjb.11.1675105779842;
        Mon, 30 Jan 2023 11:09:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o7-20020a17090ad24700b00229b17bb1e8sm7446192pjw.34.2023.01.30.11.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:09:39 -0800 (PST)
Message-ID: <2e2b117c-bdcd-2714-2116-8565e10795c9@gmail.com>
Date:   Mon, 30 Jan 2023 11:09:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134316.327556078@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 05:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

