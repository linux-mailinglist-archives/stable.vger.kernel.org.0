Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC23510A1F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354355AbiDZUSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348904AbiDZUS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:18:29 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8EA1EAE9
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:15:08 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z26so3573221iot.8
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k64Y769BttAz0xSqWU1vdMeqH/nO91npCdgj2qYsDAc=;
        b=IVttxp2FCFwrivfKzF4u8T9pYTrkwh41YtDeVrqpZGCRrMeXHnMAZrJwMqGPYcTkGv
         M2Cg420veVWdfvilInQCFj++mFMYvRszk6KWQlj4Ihnb8+eV2YoA1hE7cvDfsruEmuFd
         qexeEQ50gDhV8m6B2EtQ51kzBkm7ROvDv0TtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k64Y769BttAz0xSqWU1vdMeqH/nO91npCdgj2qYsDAc=;
        b=GPQa7ErrHyqLpsa0k1NMnVHveVPFCiC1jf7RDcWj8xgw6EPBWDs+QCcEezeg+cGgR6
         1nqYcmBlHATOGRsgEUrsLky2HbveQ02rcLGum+jI3ZpiY1rhr2Ma2P1fUjOaIuStHn3P
         mrZjSYngnoLEIxSWHQJYAvZ+re7/qcNJ6thzXMxH1X6wam8IwxDH8m3ez8Bu50H1c9nl
         JE+oMPXMD8qZGiwHJ9l9A6kYMtYgN6tyqvQkfg8ZHJptX4T1VhlbBDDd13ImMigUaFAD
         2RzDKslUQA/cZPIis7fZOm4go9fkJtHRtBeTLonD0Cgu6HIPIrKWp3fHCE8YZ76nZmUh
         j6Sg==
X-Gm-Message-State: AOAM532yIXg2Fu/TbmI9GHXrmwhyVlVIe+gFsNaovbkGH10qsZao1XPA
        EcYOSy5GPHtgZXqxCjJYKl0bRg==
X-Google-Smtp-Source: ABdhPJzPwZI9oMbC74p9mInj4gkU2bT0zay20x3/Nkmf9NDmqe1juG9tOw0LPlA4VBBXtAMB+GjNxw==
X-Received: by 2002:a5d:96d0:0:b0:654:91d3:97b7 with SMTP id r16-20020a5d96d0000000b0065491d397b7mr9910447iol.164.1651004108119;
        Tue, 26 Apr 2022 13:15:08 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id x5-20020a6bfe05000000b006572a49d97fsm10361689ioh.49.2022.04.26.13.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 13:15:07 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/62] 5.4.191-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f174f8c-d7f1-0c48-214d-eb08855b3616@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 14:15:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 2:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.191 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
