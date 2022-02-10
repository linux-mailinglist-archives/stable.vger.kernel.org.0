Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EED4B0234
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiBJB0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:26:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiBJB0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:26:23 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6D72018E
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:26:00 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id p11so3218638ils.1
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A35d84x2RjqXZMuXIh1+LhfLe5xvwKrwrfaFHZgGn+M=;
        b=Sz64oWEOx47m4qz9qh2q5Be8Mi3cJum77EB69wkj1gey18WALnDxtKbNl+hzP3W715
         1kcQlj9cP/GhALn4dtv3YLhqit4T4CaN3eOU5mAWTaNu7SOY5knoFk/rUZvpSQA05cpH
         Jmj+hk5pzTJxNFsmc9MuZKX76sSXHhi4NHSDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A35d84x2RjqXZMuXIh1+LhfLe5xvwKrwrfaFHZgGn+M=;
        b=OWa09l5JpVmLjPD7BZh7QfMBszwGytDmGR/sr07SDpYnsH7F3gHFexr/SLos446ELI
         gm6luVHap7aJK2RwyrQljd++G/qmw5sf7wR7JgpuQCWzrXOpAzg6u0WJqZmFLgB9U3/J
         oGwWGCCzoKC3v+LK9mh7iYhsIFm9Gdnxsbt5jZgZ/dnEKJcReGO3ul72D0WS3Royhb5Z
         4+Kvtq67/CWOCYCB2Gh5vkDf3FFVAamoL+B1GNL0g09fN5QQkfnjvDtAkmvdgqMPnFNn
         /tu+U3G7BDcB5S4b1fR1Xk0n1vScEfj8zZnO9BLZl/VG/xybRB3QjVJLonYrO2m1kP5o
         SfqQ==
X-Gm-Message-State: AOAM530/LTXtfNZ2HSNopErNQxmznM/hfGcU823BkBv8/VUhSHzOVSyY
        Ph0vxMvluJRtIrnZHIb+jte0Iz0etdwt2Q==
X-Google-Smtp-Source: ABdhPJx1sbc1R/43gF7IVmIX7xhceSUFycsDS5GrDoO4IRwDL1skZbzPGIOwoKX4+MOsQRRl0QTTYA==
X-Received: by 2002:a05:6e02:1584:: with SMTP id m4mr2617644ilu.174.1644454725775;
        Wed, 09 Feb 2022 16:58:45 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id v4sm7366619ilc.21.2022.02.09.16.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 16:58:45 -0800 (PST)
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220209191248.892853405@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d959cb7b-8b06-0858-7744-b8f6eea09240@linuxfoundation.org>
Date:   Wed, 9 Feb 2022 17:58:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 12:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

