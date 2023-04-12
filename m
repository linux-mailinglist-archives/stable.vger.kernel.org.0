Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6761B6DFED4
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDLTja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 15:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDLTj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 15:39:29 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51468E65
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:39:26 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-329451cab02so163805ab.1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fcgOS+OKSCDO8NzRjq8eZKuY5z5xA1+GHktFaJ0VUuo=;
        b=K+THEKrRDwroGrTQQOzJx3ru0btMd/QcNESrSF+0jeNwdifIzNatRJaajfOTJyZs1r
         vDc+AYWrf0o9tP3IlheEUurV5e89oDuzzhce418KxSJaJv40cAkVflI7DN2at1c/gotJ
         DMKEeDBwDFR7zwL6nB6RZET5jHncL+yLxGD3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcgOS+OKSCDO8NzRjq8eZKuY5z5xA1+GHktFaJ0VUuo=;
        b=fTU64PhW5BKk3a1vzSpZej+GdQbWOCzAIQF287bEZmzToQM6HLpfYDiXk2U8FKIlBh
         TWtBoWJmKvNpthomDtnc3pLc4x8sJMUwKDELaE+N3p0thQdGsa/NdiUXRFaBNIfSRSL9
         AfVJD0qyecWIhgVit74SVnbLKskm65ph7y4E3JAf7+aA0YNBk17QCXlljf+5WRz6SuFV
         jlsXH5nWT74mdY9IRcz5x2eLIqnzgIN8/uHBLiEUk4h93c9IgwrcS+qSc/lfP6sOCHpT
         TjOXaBn9sety9eE2O6+zkPX6RXfwzXR+cM+zjtQRU2/xjWU02slgtUE6jX7UESTSDIC9
         tVwg==
X-Gm-Message-State: AAQBX9eNCc0kU3V52wJ5eOyvpHE/cko3MZ/80YZ972vugsUMPw3qYXj4
        g7uaC1C0MDx9vFYjV6UeelGepw==
X-Google-Smtp-Source: AKy350YbbFMakOATb9v3PBISR7YtOBKNcGKFoPiIsoYlJstGgeU78BZ4LCWB8aagUoy2LY9Pbx6Eog==
X-Received: by 2002:a05:6602:70a:b0:758:6ae8:8e92 with SMTP id f10-20020a056602070a00b007586ae88e92mr1457619iox.1.1681328365635;
        Wed, 12 Apr 2023 12:39:25 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y32-20020a029523000000b0040bd91e4803sm1922883jah.155.2023.04.12.12.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 12:39:25 -0700 (PDT)
Message-ID: <276effcd-c83d-92a7-7cac-24fabf7aff35@linuxfoundation.org>
Date:   Wed, 12 Apr 2023 13:39:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
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
References: <20230412082836.695875037@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 02:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
