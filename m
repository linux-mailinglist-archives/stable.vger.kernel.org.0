Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C4E6D7D71
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 15:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbjDENKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 09:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbjDENKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 09:10:43 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E47271C;
        Wed,  5 Apr 2023 06:10:41 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c18so34337110ple.11;
        Wed, 05 Apr 2023 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680700241; x=1683292241;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VtodILvQ2ZMMlQviiIR+jJTYn+DhiSUAYYkxKahJV3E=;
        b=ggCDlh67old4Wkj7U8Xwno8MC/kO4SkXOblBCvDt9kFG9v2sdYQESfxZLEmPnPdtNG
         OJBOohulVFZIASbj3NL7CFupbP+jc9yRP4ht4QCyFhgimVu/BqWnrgc5lfgT2yYRdNUq
         qW8lh+CsnB4Oj5uoqqlnJEI1zfWII7fa0Nre5xYhqH9FDrJ5q7RjXz/fJe7F2QhyJrsH
         1O4TGb31QZ31/4xJ5ybx/TO+hJP86nkJuIpZEAiR5DKL7r2GRSG/140XbcGfoY8SNEsf
         CpZmjcHzjMeZ/eXc9aCRpOtrdv829DWm3sp339ddYNW0S9d/FxVUCgeJgtIcQFIbLsr/
         UfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680700241; x=1683292241;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VtodILvQ2ZMMlQviiIR+jJTYn+DhiSUAYYkxKahJV3E=;
        b=vAyVRpOr83iSPsLofc0tkkx0wAdYdXDgUqFTEFd09s1S/wbImuU0EUwyxBnenuqKUt
         o7yS7BVKboXje6zSbPU9nFqAtCgG3AnvmS6NemHK9vzQRadL97ji1Qipui8vQTU94k8v
         9WAtMzjY5WeQtl3g3W4IDhEyjl20/TkdfE5+IeVf8EowL1tTCt9ogzYh5QP1z6WuJWPK
         p/l5qhEwYRLihGdfzJnan/aIu5A3jsU4smxogQTy4yEC2X85vgWQwErYEUb8MCaDTOnY
         Ls4UOgprFRDffJAPpe0n/VyxVg14uJnZ/hb62YQ4+AD0PQD+qcxjlu6NYpzqaoD/5NnV
         XSAA==
X-Gm-Message-State: AAQBX9e9qi8KuMuCjHcNbt5N9V1mJwnGAnqD9DKh3ryZrxjOu2lcUmg0
        TtdKB6aHLxZ7PLG8S/xMZiQ=
X-Google-Smtp-Source: AKy350Y78GB5qsViRCXJ2kOADdulfOaU/53okcrylJp8k7Da2LwyAVBtU9ZjdYg6bmzyh9d1Gzo7Vw==
X-Received: by 2002:a17:90b:1c8d:b0:234:b964:5703 with SMTP id oo13-20020a17090b1c8d00b00234b9645703mr6584614pjb.18.1680700240841;
        Wed, 05 Apr 2023 06:10:40 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t23-20020a17090a5d9700b0023d0290afbdsm1383910pji.4.2023.04.05.06.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 06:10:40 -0700 (PDT)
Message-ID: <df2fd045-daef-246f-8f44-5c2a301b4804@gmail.com>
Date:   Wed, 5 Apr 2023 06:10:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230405100309.298748790@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2023 3:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
