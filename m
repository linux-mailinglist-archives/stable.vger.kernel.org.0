Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1A4D0C35
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiCGXsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbiCGXsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:48:12 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F33DC6
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:47:17 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o12so3445323ilg.5
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wFI4DZsbiFLf2t6++MBx1IBuCREEkX/q6J/ztKUGRdI=;
        b=HhqkIChgQpNGmcVBzHkWtI2K/7fL83X3uu6Uf4i0sfmSOuhxx630YepyB6TkORM1LJ
         3+8CtL+v5wdP/X11j5LMHqkmawm45k3vW2BjYBy/IzK0cj9nm1iSgQ5J2ZcZ26pef7lF
         fGfd1Qqw38MQ/jimyS84q7VfpqyheqPpRqsFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wFI4DZsbiFLf2t6++MBx1IBuCREEkX/q6J/ztKUGRdI=;
        b=T6f1DaSOy3BjjJdINruxqozcPFs+CIpDPFqNzOUzqIyIyZyID36U8VtNC+u8Or7KAw
         595gs9qT0Jp9GkALawLOY/lwoHaVWhPdolNB3AyISpGsbwBRSSw7RRdPMpiszp5PhLod
         SuEZ1yOtBEe5Ps4okXhJfVEkqHc+c8iHcBrW8aJkQRzvPlifpqCi4kQtHbUICxQm/kWl
         faeIJFOIKQTl8IFKKhOoxVCTt6YGLs8GslpsjuAqpNVoIhKHrKpWDeuf3D7LHYuCOeDu
         TkSxPZfecaoklcsmpXgrMcPaYKo1f55VFdxXERTJ0So55ogdqTvcuRGK3h2FCll2Tu6u
         Qocg==
X-Gm-Message-State: AOAM530vdBrVU+ENzkyLwhpkojqjXssNSjhjeqTwJ9q5612oeWyn87Wv
        flY454eatggcIHHpTJqRgVGhHQ==
X-Google-Smtp-Source: ABdhPJwwolXGb75vS9X70gUsgWoCStgI7Pu7MWGNLGYoxLPKoX5Zi0zeas8E45KotCBpO5eJW6LrpA==
X-Received: by 2002:a92:c268:0:b0:2c2:8f59:1cb1 with SMTP id h8-20020a92c268000000b002c28f591cb1mr13287386ild.241.1646696836563;
        Mon, 07 Mar 2022 15:47:16 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id p10-20020a92c10a000000b002c64b46cd94sm1588709ile.52.2022.03.07.15.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 15:47:16 -0800 (PST)
Subject: Re: [PATCH 4.19 00/51] 4.19.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <065e085e-2761-a39c-1b37-cb3f9f62ef2c@linuxfoundation.org>
Date:   Mon, 7 Mar 2022 16:47:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 2:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.233 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
