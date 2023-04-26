Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1196EEB77
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbjDZAck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 20:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbjDZAci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 20:32:38 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F0918BBD
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:32:37 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-760dff4b701so37803939f.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682469157; x=1685061157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGmnKlALUJ2FuXl8LL4yqnaL2V8ZihIjJ8FAcXR4jgI=;
        b=RfzSeMIezCBaKoNextZj5mOWxit7FJLkTWcp3emcTWADIIQnTV0gc8LzfXBsGbqjXD
         qN5sSXyK/BjV+RkFUDIecc5Hg3EYIV7cUJDWAsXDx3z/MZkaicMOAhZfq3RtPFfHMdXg
         Z8OfIvhefI1/fL6brjhx7PS7h2P7HUd19m0Ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682469157; x=1685061157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGmnKlALUJ2FuXl8LL4yqnaL2V8ZihIjJ8FAcXR4jgI=;
        b=G2XDLUaK0PPgIlvkcp6G+GBoHFsWAyEKpRV/8lIb6aCnAxUnp5Xj8nsLcBJ4SyJd2Y
         T10cmVcGai8DNZDwYfgWXg9KlU3uur3jIBqHiQoWWmygiftSrZ8DlKYNHK26YZNtMmNe
         2lsyhbFVmGpPf7G1MxsUYC4aEe8nhwrgWKzP/wSug8aYh7mbXWOOsEjHKaiqmCC8hysi
         Ev/tC7jQtERpkeujvOLCb+uXqVOkkMXOGg1q+pbXs40wzCEDtkUxdhGXxBpVmNoM6erP
         1Oh8qHmb/s5KCjzQvJhjnAYwBB8+n6i3ZFAOUTs8Abt3C6YJ5c1T7nvX5XWgFeFDJvEz
         l/tA==
X-Gm-Message-State: AAQBX9eSkXKq3WdmicYG5L81IqCe4wpRbDd7FGD5FqpHjJWFAgaiDcHQ
        jQkNobpIo4ar+nW92T1ca6aZcw==
X-Google-Smtp-Source: AKy350YwZzx60pyQt7+33l4rqaMkc4/liiALxcfiqA+FUrfsoI3Ic71HgZCX8cE49MMI5cL2Q1AKjA==
X-Received: by 2002:a05:6e02:148b:b0:32d:d8b3:c4f8 with SMTP id n11-20020a056e02148b00b0032dd8b3c4f8mr9847944ilk.2.1682469156968;
        Tue, 25 Apr 2023 17:32:36 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o26-20020a02a1da000000b0040bd8fcaa4bsm4097529jah.63.2023.04.25.17.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:32:36 -0700 (PDT)
Message-ID: <78cf373c-1421-b5ec-441e-16026dc248f2@linuxfoundation.org>
Date:   Tue, 25 Apr 2023 18:32:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/23 07:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.282 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.282-rc1.gz
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


