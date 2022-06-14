Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25CB54A749
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiFNDFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiFNDFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:05:00 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B0D289A9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:04:59 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e93bbb54f9so10881880fac.12
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIKXrMJmK00F2CPu/hqVjErFk5SVKd7uP4hFKJeSK5M=;
        b=AR3QW2VBjJ1hctByyReQYTrPKto4Kki50p5CahepMNg1xyVf3gdjcJy5AYOMbYXJ/R
         VE98vpMaoXFKdeqZzG0vuy9sycyvsx0KdmgimxHctcDjQfxXriqlXRzyshBlXGVKjfyq
         esDPDfoiisYhSzGgAoSEEBIbKb7WtCKa/52JM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIKXrMJmK00F2CPu/hqVjErFk5SVKd7uP4hFKJeSK5M=;
        b=7QlH2lUHJIsVUIRiBs+xrm3NfuMy1meTWOnKw9geF/6BMzSbk6YVIXFmik4lwMjPPE
         S1GxfI5Yv0FYfa8rtxinaXe1KSETfdbEHWDe757uXZTQBXmEvmUv0fIyCLxVzTFDz4AH
         h2ghOiDv5pR8qpGSG+BmS4hBHFPvSDFmGRMZezwV3g5XSKS1VgR4lqhvjduH5meJRPbT
         +fuV9E82b7uxY7VSlM9K37Oem7FpqTuYlTv66lxnyNaLkn1BwreaT2PaY2OeJV5T08dk
         kdRmvgw2bXKRiLs8n+x/6tvS68NUDGSXrVHoLwpMARwISiZV6qQnctqzq76QP1pUinW9
         tW9Q==
X-Gm-Message-State: AJIora8Vw21+vAhL787SBYnZcBkSSjBvx7FJ3ijgF7C4j7eEMLsi1NaO
        jLLX29lsjzH+yxlUrYzGvgWRcg==
X-Google-Smtp-Source: AGRyM1tSQ5vOq7VAoa9DToonIuS86X5DP0QuTUvLINlwWPLN61oD4Qf8sRP0owt3eyRwU+NwCE6Bdg==
X-Received: by 2002:a05:6870:961b:b0:e2:ffb9:f526 with SMTP id d27-20020a056870961b00b000e2ffb9f526mr1191635oaq.146.1655175898263;
        Mon, 13 Jun 2022 20:04:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p7-20020a05683019c700b0060c0c6e9186sm4215355otp.15.2022.06.13.20.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 20:04:57 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220613181233.078148768@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0cd002c0-c3a7-7df9-7ccb-e41881ceb94c@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 21:04:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 12:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
