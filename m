Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEADD4C8195
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 04:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiCADSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 22:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiCADSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 22:18:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D51532980;
        Mon, 28 Feb 2022 19:17:44 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bx5so12933258pjb.3;
        Mon, 28 Feb 2022 19:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AJ7R/Jj8gxzGwrAPIYC49qFbHxRTMayv2ytYu3k0VX8=;
        b=OL2gDU/NG8XYqWsX6E05XeCPhqQ01F6MR53UpP/4WOtQmZc7JPoYlLq4UpJTsgxJAn
         e7f8NoNh1xgITnEMFVvmaDNprpwuTziAkbdDTj9rAI4Lu2b51+55CrM9NKj+guqsuCmX
         +ZblvnXoh4S+F6w8JAdStv5a5wUJ3tFGIHTMwfCVv56/bKhywcroWFvQ8G88hmZQtNCh
         H6Mp8P24djLRZK22kiQnD5Ii+l3KZjnclGmNMPTl1jdtcc1aYzrzW8HBlhGurdNrJKfq
         DK5oLpA9GzHNo9VeVcHHiqmA2fZ7QHQKfguU7NUIHOzZUQok0ysISS++5XfG6fqbgRTA
         sDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AJ7R/Jj8gxzGwrAPIYC49qFbHxRTMayv2ytYu3k0VX8=;
        b=vYPLMG8DzTnuUGzXVZQD7FstgRb7Mtu0/B86MWHU6WI/tYBYMAPh94Gs+Xf0T8UYri
         yzBrGZMaNcjUkfAQoY2KRejXOhVgcKVVSeBVjgjTubBZDe9JmdyiOqBazPqtHt/hNZ9s
         TWjwJfUdSAYkmlBYaq87kN5DK8E6rT/9CUKK8RRKeLzmokPi54aLqV/opZsWFRGNtK/4
         MwYn/zx4YH+iG2Ie26IWVSh0JGHhd2L9bW0GLnKyBM1mjIJliGL0x9VwsFroYaep8gu+
         IyxdqTuBdOxS19B+vL93mLtz5U8Cz5IxTbyqfb0eoxdKsja+84lbrJkcplLspHBOtQFI
         hDLw==
X-Gm-Message-State: AOAM533XiymTuy2EYR24jorHVJhA0WrpPZI51oltjrRSeUwmiwFvNJOh
        1spQjrzaoVrmcFRn9dHVvUA=
X-Google-Smtp-Source: ABdhPJyNoW3877/0hsD8r6iIvMM82FOaX9YHXzvRZyd1u4ktR7gdGzkwsERXQfCbnHyk8YAfzYMaBw==
X-Received: by 2002:a17:90a:ff85:b0:1bc:8062:ac5f with SMTP id hf5-20020a17090aff8500b001bc8062ac5fmr19564392pjb.157.1646104663741;
        Mon, 28 Feb 2022 19:17:43 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p34-20020a056a000a2200b004cd49fc15e5sm15738402pfh.59.2022.02.28.19.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 19:17:42 -0800 (PST)
Message-ID: <6d647c70-2559-7c58-16ea-53cea942bab8@gmail.com>
Date:   Mon, 28 Feb 2022 19:17:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220228172347.614588246@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
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



On 2/28/2022 9:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
