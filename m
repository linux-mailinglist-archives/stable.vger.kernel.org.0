Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7229678D13
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjAXBC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 20:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjAXBCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 20:02:55 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FD2301B2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:02:54 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 203so6413253iou.13
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QzXjtHokknNOIo6i/tDT9iY3dlftA7c+qD6KDgI/3xM=;
        b=Ya6DyH/c2FTdfl3jQ1YJUj5Gj+vPmDibNyFtLMocR61+n4mprvIqqG0ILITHWaCZTg
         2ITPjo7yI3ZJQbIBmiY+Chnr1F2iODXnGQDW0aSbNJrLTg9N4bjZI/2Ed0P5JNVIobYF
         nP+fAv8scO5NYmXkEZ5CsCEiETs5Ir+2Y5oG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QzXjtHokknNOIo6i/tDT9iY3dlftA7c+qD6KDgI/3xM=;
        b=lQtfTjTnZBiq8d1ed9HIbiMS4M9wO3iTc2sUPaXfSnhaQExS3RpOmeGUTfb1rE2Wwx
         buNz98YdFr0UO1YiQoXCxsuUwXj1+7sGmK+VGBBchnTggIX8/XN0porTKfFtXg1z25hM
         EKzQv4Hs/fG+yhdlCp0Yr1zv066LuN73GqYhQIfH2UfWmJrUp8zYqkk0OhkWNgdci4/t
         210o9iA0hn1HFUQxSrycSLf0YNOKuh7SA06Ub8uL8TZosEp1M609b0RQIKQdsLTtXoto
         I7YXStt03QXEleIjSU+xUQztCoSyBmCyRz9g0AgSYMsr9GDu7DscB1bYe5vrBCpD/heH
         C+tg==
X-Gm-Message-State: AFqh2kpotdaE0zJBbGlKEw38pFlIdIW/f0pHLrSZ+CuMQCysGCki2fXu
        Aq7es5p8EFyIitYFpeg4jZlUqQ==
X-Google-Smtp-Source: AMrXdXuT7QTYaVhT7eW2ioWfw+txTXicI4WfnHl2vrWE842osIoJlfttp/JuUbxsMP+NGaq8VNAW9g==
X-Received: by 2002:a5d:875a:0:b0:707:d0c0:1bd6 with SMTP id k26-20020a5d875a000000b00707d0c01bd6mr348453iol.1.1674522172688;
        Mon, 23 Jan 2023 17:02:52 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a15-20020a02998f000000b003a53692d6dbsm216336jal.124.2023.01.23.17.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:02:52 -0800 (PST)
Message-ID: <d2902d2b-67db-9670-fe6a-7e4af5f86ad3@linuxfoundation.org>
Date:   Mon, 23 Jan 2023 18:02:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
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
References: <20230123094931.568794202@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
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

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
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
