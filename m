Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397B1572BDB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiGMDYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGMDYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:24:38 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D623D7A55
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:24:36 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n68so9777018iod.3
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7SU+WxQdFg5lYHEw8ONnDQiCGNzHekCnVU2Y81XHpW8=;
        b=fjIznMGfrjaUk2BKLCf2993jvWQByvgyUbr4v0W5OvKyk6csTqVthrSTfbpm5ciJuF
         fQ9SZ5ctJTLqRbEDEcQBLudlVOwlNp3GYJ2iC9YoF/0rG/sOwnyzMHX/Pm+ay5zCYyZL
         +u7ZQ38wXgSIFZ71CAv7pfHe1kRBp1s0zXXZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7SU+WxQdFg5lYHEw8ONnDQiCGNzHekCnVU2Y81XHpW8=;
        b=xausFQBhnEnxdySCi+vStVSuBIpPOPp23U5rqszBkXGIObqAvLOt2FwNk8BwP3Z7Ap
         5LrbeZmwl2fhGl2DSqtZ3zeVl8MtjWCT8Kie0GlBcTHTtsfd7JbmhPuDjD02EpnMeT9M
         ZSav1uMZ5hqhmNQAVllrRjipm0W9NPuwtE1Bip+jRAeOlnZXUS6FRYz0q4vmI5mJK3IX
         CqwOSBBjUDee9b2DjWIP0rC6wlbX5BwunymumHqFjC1/qWEKEgsWImDZYrQwlf36XfNS
         f7+LQpU6d89h7RocQrvMqvw2Y3dWOW3/wECsng9ussFAwzRynMD25n1xN9KmOEogsYox
         nzWQ==
X-Gm-Message-State: AJIora8YNuIAi2OmHwFWaEhSzAiF8c5Ym+Jl1WfeTcG3KvTmTg/ewjgx
        no41DJIqRtPNrL6gPdKZtPa63w==
X-Google-Smtp-Source: AGRyM1ujq7onlFqKxLVI5SrTZ72jD9pFtgTDUEY25rd4SiOHXTo4qg6CZlt4EhSYuGFQjC/e2bziMg==
X-Received: by 2002:a6b:7b0c:0:b0:67b:7c00:f95e with SMTP id l12-20020a6b7b0c000000b0067b7c00f95emr842309iop.42.1657682675836;
        Tue, 12 Jul 2022 20:24:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b14-20020a05663801ae00b0033f07b375b8sm4809514jaq.52.2022.07.12.20.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 20:24:35 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <92177189-df5f-648a-6245-99debdb8760a@linuxfoundation.org>
Date:   Tue, 12 Jul 2022 21:24:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 12:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc1.gz
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

