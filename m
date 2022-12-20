Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E965171C
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 01:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiLTARB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 19:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiLTARA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 19:17:00 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A9814D02
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:16:57 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d14so5578055ilq.11
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C/RaklnAfUfx6edHmjpBynJ3wYo4WviqyTuTdW1L/E8=;
        b=WtpMRvgIvChEqw0Nzb/Z+uxAbZjxr/zODgoyWaUiXFV0TNATKe1omN/COXMQDnRp/A
         HF3hKDY4l2C9HzDO0rWrJzqEwovOhv3i/7YsKleyJOP69U3+7IzsUXBX5AFZ1Zj6qVtg
         fdLspl/xVxlWij9yBHcgXI120mdWE8fqPr4Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/RaklnAfUfx6edHmjpBynJ3wYo4WviqyTuTdW1L/E8=;
        b=NpYcN76WVTNvl87hoGqKJDff8Am41B4UVIKW5db51yvqUu7/DxF8lgBD71b4ivS1Bx
         LZSkQzXsadcbDYhkQvT+3u8FkOdH9oNU9xjUNAftKZdNgXgC4pmxNsV6ro6H3qG9DxSX
         UF5Z4HDQPp9jgqKdXTFFn6ysHKx1bVm9K2+2unK7BA+wrSsVjDhtfsWA9UiSzf5jkeMS
         LpsjGVAk5xG/YQKBi0htChOv6tk6uI4rl1PsFBugvXafpaKQPftW9iJbZawffKhc7buP
         gsd06Gi08ugDbln6zkeegVxpjCNXRBQGJSwLdWvbBVzdlOYXYgWOIegQPTm46kr+KFKz
         tDMA==
X-Gm-Message-State: ANoB5pmo1/ejuSktsQKkDl2xjZKVu9rcWfOUcQLQ3Xp++y2ZqmkCzl0P
        kZWU+q4IPKoksE8y8hezcvoxa4soHYCPyQ3y
X-Google-Smtp-Source: AA0mqf48fLGl9MyVH+EY0ECIuj3ElIASjyO+JHfQSTdtV5EP1km3HGz289tir9wgfqxrmfUnpEV0SQ==
X-Received: by 2002:a92:680d:0:b0:303:8174:ba2d with SMTP id d13-20020a92680d000000b003038174ba2dmr4500476ilc.1.1671495416763;
        Mon, 19 Dec 2022 16:16:56 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f12-20020a056638118c00b0038a0c2ae99bsm4030059jas.18.2022.12.19.16.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:16:56 -0800 (PST)
Message-ID: <f1cd38c9-5f37-4dcf-894f-d912ca235074@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 17:16:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
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
References: <20221219182944.179389009@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
