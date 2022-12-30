Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5F659C5E
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 22:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiL3VIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 16:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3VIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 16:08:22 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFA01C90A;
        Fri, 30 Dec 2022 13:08:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id b12so14846276pgj.6;
        Fri, 30 Dec 2022 13:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ic0AXUw3MCdzMrW0RbkiFUyTuGBRbgMe+O6/43feEp0=;
        b=T6G7cOwOt1KhxaDMljPtvd2StT20nU/9O2AHgIZP97vjW3Qs31222FFJVtvcDQmIrz
         n75qysMtM6Obg2cU/0ufPie2Yf1MgoDwDUM20KD1A1NEIQAeWzL5qpgCWrjc+ESNp7dz
         E+/JGsLsiRXKTFHl+OPUL4hxYPX424xHTZYyY8xC26xzYlDooDl2Z5wpPLpfEd/UnC92
         xB8UTleVfmfisbx83JXBi0POgplHYHMlXBcJfg4V1cS2daONg0sy/zpd9Na/xexHwLlJ
         ZX9Ry43difzL6YdiZ2B0h4wnzQfuNhUeNXDslzyaIJYl310r/1/YPnofU40iHpWPw0iQ
         g5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ic0AXUw3MCdzMrW0RbkiFUyTuGBRbgMe+O6/43feEp0=;
        b=QDcrDWwk95s/ko7Y1F5ZRfqHYardrbKPifaYFZhcfyJe3Lb3CnlpIc6w1+oM4npyZ9
         cNz13FkuU4/Q62runZvN0tA+HZTQdrKncsic9mRmuuRS2eWlPFbFun15NGp+EZwZnSNK
         hDeZ+AAcqCZ5L3/eaCFTuLdanNXr13aO0enKq/Uz+LW1PWe6os6iDDE1L5tjpPs0j0LQ
         WEWrdE51f5kTcaxxOYlGH6ejnTb8pY8TJ2atM/AXl5Psmw6g5655A9KpbHtnR+/zvSeG
         RAqlO6058pAbhjPqAoaZPp0NIZCHfaorzbiRjkbGo4rNwmkwy/fEUUB5kw8+6ajGMH6b
         Idyg==
X-Gm-Message-State: AFqh2krP/o3feU7ywIY2n5go6oDfDl5Q6rJ9FthJfjKs+FKFb4ZCu2T2
        dC+0d9ONnUGMUNOvukjGsP4=
X-Google-Smtp-Source: AMrXdXu0EWEJDPgv/7O+2mjq88z2DpgfoJIq6geqgEy0pvaGLmmRUMP8bVw5ouo0rvAaN63E6BG2yg==
X-Received: by 2002:a62:f20f:0:b0:566:900d:5ae8 with SMTP id m15-20020a62f20f000000b00566900d5ae8mr29091318pfh.24.1672434501069;
        Fri, 30 Dec 2022 13:08:21 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s5-20020aa78bc5000000b00581e0b5ad8dsm2706289pfd.107.2022.12.30.13.08.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 13:08:20 -0800 (PST)
Message-ID: <6fccfd56-a6da-ef1e-81e7-e6891071f697@gmail.com>
Date:   Fri, 30 Dec 2022 13:08:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094107.317705320@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
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



On 12/30/2022 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
