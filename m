Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD65872FB
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiHAVUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiHAVUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:20:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356C32DDF;
        Mon,  1 Aug 2022 14:20:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id iw1so11624518plb.6;
        Mon, 01 Aug 2022 14:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=A/aNXaWz42+Te8imfEyxce8tSCY7PxmGSISl5ue8ov0=;
        b=CkA3ZXrqp94B6h0iXj7jminwN2u59wyreML5tHHXfWT5/7yJmkFoMZR3K3mMUJzgvw
         hs05pWmwO1S/WkniXs4qNNx5Q6C6UotR6sTnzdsIx49sQPj9hQJ6tp3PbRW0HW8ivyLN
         PWda5F/myC6+u6c3yFQgyuxocphKBvUtKzQFkzJbRiAq4bEER9EXWh/5REMrcLjkGhLJ
         4f2FJ7wnOeYLBwy7y7PGarv1bmRvO+QrRJrspatWahndeaHNttLXR7IqFLVQP9bEX19c
         YiedHQUUiW9iRc7+3n1VvC2ZTDmjHvXVzyyVi2nQn2XZv9ny4raA930z1TKYn8UZ4Xd1
         LvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=A/aNXaWz42+Te8imfEyxce8tSCY7PxmGSISl5ue8ov0=;
        b=uUIdBpKKLBXGj9VSpAfKGJPDsSKOYIoUl2OEnbUptTPAMn5mdZiX6+aiDsQKo0A4kB
         sF5E/8UBTfZdAB2GtBYz/DOWXPIdAT31tWr5d5oih1Zlq6ybl0n7J0wPE8fQU+unmHDC
         RxIy9ki7ncD2w63+Hr0G3E+T4/OPfs36kjhA4l9N7OZj6jZ2AOeScU+dKKWp6B+jysDJ
         S8XPDkPP/TYe1biYYdaQx2K5MDWWCNxSrzhK5YAsNrg83XexneU5F+FX6Qn0SNEIMLrX
         hRAh+uuUdPhR3ll0QbaZKz7xZaKB2lChLuOEzEvTNzIK4Sr4m/DMdIINJrkabdIjKwRT
         lJfw==
X-Gm-Message-State: ACgBeo28WoKlQPCOtK3NSjOmzgEAsVyLwE/x+tVnP/ih5K3MbiHOZ2lw
        f9pe+twMcdL/Tk7K5BxOUQk=
X-Google-Smtp-Source: AA6agR5MfNj9zU68+zilCs+LDnQslOlC38xmMkyk+3wchHRxJ4jgiSSr6rCpqPMx1o8gTdIiBXNoSg==
X-Received: by 2002:a17:902:ea0b:b0:16d:d268:e4c5 with SMTP id s11-20020a170902ea0b00b0016dd268e4c5mr17321878plg.152.1659388799626;
        Mon, 01 Aug 2022 14:19:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qe6-20020a17090b4f8600b001df264610c4sm534121pjb.0.2022.08.01.14.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 14:19:59 -0700 (PDT)
Message-ID: <737e98a6-ad6b-0970-0d4f-e6560937e7eb@gmail.com>
Date:   Mon, 1 Aug 2022 14:19:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220801114134.468284027@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/22 04:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
