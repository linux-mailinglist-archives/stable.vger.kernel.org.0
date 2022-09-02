Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85445AB729
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiIBRHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 13:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiIBRHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 13:07:32 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2867C1BEA9;
        Fri,  2 Sep 2022 10:07:32 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id x5so1938433qtv.9;
        Fri, 02 Sep 2022 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=m4EPxjWBFRmumP1Ktw5mgebEJ5Np/Pz2BxFkNM4nyMI=;
        b=OBktR1HYmcBKnWREU0l1kqjaZwnywMAMGZlQyXzjuB4Mq/JEUHp3C/SSPy21PYnrt3
         AEjVDYgmV3a33605b4NQcPPabfPq+Hydu9Vj8h0BtAC8voBm8OREJIWdxu58fYTL3d+V
         0U7VjlYkKF+as7Jp/pkkNHvqcUAxKul3p7VFv8a7jAqHkl/SIVliKtptkU3Pj+YzfFdr
         Hhpv4z5vYvqL0EixBI2nQ285ZJ4fCWiu6RfSOIjy42UMXOiPW2turiST2nPjKm5dApca
         tkkxu1uWhOudncDzBlZGb7CHc3+cQHy5N5k5yFr+1oNbYTOG5i777IjxwzXrARm1sqUY
         2/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=m4EPxjWBFRmumP1Ktw5mgebEJ5Np/Pz2BxFkNM4nyMI=;
        b=HGdjt3iRNjTF6ishWo/jARCnQfZnUdB0BleBZGN9EB2nEKdVW2fNtIGUsMwP4XM7ib
         ikSa1jY0/E9NYHx2fu3lFlx/v0EjMn7RoCoOtOJ5v115DzygpA5HcF7eP2OofSPNhhhG
         YT63aSarz552TKfUWbPPpVQVSrOSihjOm8tqQqfp9Y/ldrxwkl3oc+aWoolbuHG9zRf9
         U9AAxmMbmOQvzUYPh9JVzn9cKH90hbeH+kJpKlnsZu5StmEE0LN4FHUcJ9PlzoIrgEqy
         axnuh+pZdFqsDG/wI9tRR+egRqIjjsfgxTxf4/ek1iRznJ8auE56gWdvFpMzUK1/2zO4
         gUiw==
X-Gm-Message-State: ACgBeo2svdrHYkqlShW6yh4J9PwXE2UDAW1szpLGuwh863eRyIZj+BDS
        0A8zlEwOGX6Z/jU7JXZw8q4=
X-Google-Smtp-Source: AA6agR4aNalAA/xlccc86wGslGAgCVrnDguKp+IKt2N3xAqzN5NhKadnDl2DebzdoLwJNVDrHeZr2Q==
X-Received: by 2002:ac8:7d4a:0:b0:344:6f12:1543 with SMTP id h10-20020ac87d4a000000b003446f121543mr28996394qtb.426.1662138451228;
        Fri, 02 Sep 2022 10:07:31 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id dt46-20020a05620a47ae00b006a793bde241sm1854867qkb.63.2022.09.02.10.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 10:07:30 -0700 (PDT)
Message-ID: <278eeeb0-5324-8808-cb5e-1ffd70fe8f34@gmail.com>
Date:   Fri, 2 Sep 2022 10:07:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.4 00/77] 5.4.212-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220902121403.569927325@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
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



On 9/2/2022 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
