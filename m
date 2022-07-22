Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2D757E6A4
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiGVSha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 14:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGVSh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 14:37:29 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFBBA0261;
        Fri, 22 Jul 2022 11:37:28 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q16so5085838pgq.6;
        Fri, 22 Jul 2022 11:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ej2WVkUxUYTDrM6G5icPO6pi2Y+gt8Tz8/iPBFzqldw=;
        b=CxfnBezogJppxJMIB+LqSLSFzQxgDerC24XHnd9HqQSxaxBpe9PPNZI91y7QW+6fWI
         +mGOhejwEy3o1lx5KhZM4ZHMmlTobRm6YP5VyHiEPC1RS3nzLm+E6SqlHyoOpyq9C3EZ
         xhTk8QawpuPnxCyDKizyZ7Dv+ZZMHdBTJx02CscjymrrZOl5+X1/N4pmUUrxyre8bdk4
         KJu3hP69O9rnjQ7nVjUX9iqF9v8nxUTkTi2S4tDVwy6mcEQ9lRgf+Hs7Ndn0MtidXuDE
         TLvCWEvCi0rc0vCAlSrrA0e9MG6jjcs696hVOHiLrCHM9T4D3+J7rDcxbIIOcHABmtWw
         3jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ej2WVkUxUYTDrM6G5icPO6pi2Y+gt8Tz8/iPBFzqldw=;
        b=zv/kBW9viDaNlkYc5K/WVsWdDGCih0LCrNXyQhIHQRIT59Bf+R31M19O+k55j6P62K
         DJC524xkVWS1Bd4z1TgCbDUPIC6KBjy1iAK06IKS5uKM2qnqPdB98tu50SBcUS0iXbnY
         NsyNkj+VRwNhxi3lFUZL/g7diIQDlqUfeYYNOlHR0sU7TTc923y2UNDyXnDLEZGALdxL
         h0YWFwvWpckB0plIMiLkUZaWgumJQfW1ScOz1aPJ04uWOiB9rhoZdNiKwn5e9npu78lT
         9tC6J9YbwD0EwtiGbVhICH7hU7KNxYjC3OmI+TepdaNNWioHEVgH5nQHpb4tieJDof+D
         D/Sg==
X-Gm-Message-State: AJIora/uO0vmDRnOajXoYns12mYGE4PJmgKpEkKxSkHXEKzjFbnU2xbW
        cb3JxszUzTQRYyYnXYsoxpfNcmztc2U=
X-Google-Smtp-Source: AGRyM1tLJEpfCsHPHuL34QdrfslUObK5ir3cH2DWZOUMhWhN1+T6HC6Fa1BR/R0ouWB+Y1S8JbDXpQ==
X-Received: by 2002:a05:6a00:150d:b0:52b:1ffb:503c with SMTP id q13-20020a056a00150d00b0052b1ffb503cmr1270101pfu.44.1658515047808;
        Fri, 22 Jul 2022 11:37:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 13-20020a62170d000000b0052ba782f4cbsm4303613pfx.7.2022.07.22.11.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 11:37:27 -0700 (PDT)
Message-ID: <3b394210-baf8-be77-d84f-aa869f687e74@gmail.com>
Date:   Fri, 22 Jul 2022 11:37:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220722090650.665513668@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
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

On 7/22/22 02:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, and built tested with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
