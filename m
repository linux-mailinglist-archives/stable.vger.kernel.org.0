Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A86A8CCB
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 00:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCBXQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 18:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjCBXQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 18:16:55 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FBA584A1
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 15:16:35 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id c3so1091569qtc.8
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 15:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1677798981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mxa28Y7hygfEshTx7Ke4jX3PSusIOBrq9MNBVDF6Qog=;
        b=q7IORdgmqHSkayHK41XbJ+L8Ufh8e3bRUbyZvL/zxxvjCDQ/hFKZ65Ud5mao0IZHEv
         rDQaIxts31qJ9c4PKj+s8UGGy5O0qOZCT2S6ZZNsJpCIy/7DQAwkYsOjYMfPd/YZrQdA
         IXX16Kqi+ESCdBEdsR4qyaPxm4h8DQe82pJpuln71NzD7WEHjJVYnK2+SvmIsD2vbY7N
         kguyhDIiODl/i6678FxwK+2BN77FfsFAL55bqXwLQDTdT8oLVEXo7K8gU55LyuHf0W8C
         5pNrzDBsiPqaGcn40kcDJQAhslfkx2T+xjfC5Ih+/MDOPidFvt+KB/uz365HdaqKABxr
         ekig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677798981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxa28Y7hygfEshTx7Ke4jX3PSusIOBrq9MNBVDF6Qog=;
        b=Yqzj9w1UYlB6kO9cCQ9ADJYF+xMxAuy63p+B39uap7MltGiPop61BL7JEd8pL2C28d
         Ot+e2jAqdqyyq3I7V83G0u1QaYRm/vX256yEgNZyFGBPGk1K8aiTd7j/V1QqyMXyKLrh
         Vjr0YtwSyuiTykQXZ3SCmMM5bXASTcnKI34QWjziC7MsOkNJjZM1CVTGu6cRu7+Qai/r
         xq8HXkLQ586Un3gQAgM8kEbRV0HP+4rl4SmplLAdzDTUgwqbSHLv7IKXDArVCJZZF7IF
         rdLsLDqQAjRgBDwGa0SbdXwaV08IS6QP4ExYZ5zfgA6BvG9KQOBtV66KSbmB+wZCCsPn
         T0nw==
X-Gm-Message-State: AO0yUKWu5Z6zYGf8qfhtzQZa2w7V/l35Zc7C7yQHsgm8clvjNGBO0MzU
        hLI3XR/33mK4ZTFouKmUn+Ih/b3swCKo7B5Q3TUDOKrq+3yIJQHSNfQy7ybwUekuigOQXHa2Z3a
        C0nChT53S2Cpj3R1AeGglb+mWmBQ=
X-Google-Smtp-Source: AK7set+Ri5RAbc1MqQ7n0kSUkhtT9KGhkhT8DJQd1Ii6Na8chdKhNtTMQI8qkrzgOdcLT7TUReq+kg==
X-Received: by 2002:a05:622a:c:b0:3b9:bc8c:c207 with SMTP id x12-20020a05622a000c00b003b9bc8cc207mr7514187qtw.18.1677798981464;
        Thu, 02 Mar 2023 15:16:21 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id t62-20020ae9df41000000b0073b7f2a0bcbsm584665qkf.36.2023.03.02.15.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 15:16:21 -0800 (PST)
Message-ID: <631f1536-ef72-2ff6-98db-02fc5b56eb34@sladewatkins.net>
Date:   Thu, 2 Mar 2023 18:16:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180657.003689969@linuxfoundation.org>
Content-Language: en-US, en-AU
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SWM-Antispam: Scanned by proxmox-gateway.frozen.leviathan.sladewatkins.net
X-SWM-Root-Server: frozen.leviathan.sladewatkins.net
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

6.1.15-rc1 compiled and booted on my x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

