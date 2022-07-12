Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25405571071
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiGLCq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGLCq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:46:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C95B7BA
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:46:25 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v1so4095947ilg.11
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c2zqwrilwWJFn1MWS5NC3zRRQytleqfbDvTL79CoEkU=;
        b=XOoynbLzAi8cKMnaqQs/QtLT2Y0dn13yeuv+LcJK7jUeLYM62Ik9+RnVY6f/zJxKgr
         Nr3mH1WSr3KFn6YUY5Azw0jBxqRxuOd/xqFSQltBorldtYERB4L8f32keSxNA7d9hZV4
         lsuohj/fb9WLlpNEzho+09tMcvBVIsijOaaJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c2zqwrilwWJFn1MWS5NC3zRRQytleqfbDvTL79CoEkU=;
        b=fEjNxfDlrU0H+qpY+1af3uPm8QtK0R8DPdUaT6+2NCytHoZnw+6Pxq4BPnCsuFQtQm
         6ygBl3Xwvh2/5zq0kOa2mRMjdKlKcqEMsFgn8/oPPet08fcop4eA1WU4fSnStDBhezGA
         V29vzyCuFa+UklXieweD7r8EFjZfDBYka37MuD1xxPqcNcwldMcz/73dz6YE1HxeIJlt
         rTUp7Aht358l9xAbjeS9TBghhh4VALs6QpKmI41rKge+gGOXhVd/EriopnJHk44bxlw0
         y39hTLrcfBqD9ntGNENzLerHvhJCflMMWXFqCKFLeDFDBsNmvsZ02eydIcolZ+vtayNG
         8VLg==
X-Gm-Message-State: AJIora/+LCtsGOgVB2kyA9xeyC4gOLtIS7gwb5+mK64C9TomY3KplYcQ
        k/8FFLFMhrLmNKXIJf1//BRnAw==
X-Google-Smtp-Source: AGRyM1uZNnkjwp3gD5E60dyah5H3ZffEInP/mP8aQ29pg3Nnn7qB/enz6kjunR2PDKn786LAijZaLg==
X-Received: by 2002:a05:6e02:12e9:b0:2dc:4e72:120a with SMTP id l9-20020a056e0212e900b002dc4e72120amr11335770iln.14.1657593985235;
        Mon, 11 Jul 2022 19:46:25 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g38-20020a028529000000b0033f1e23ab20sm3604724jai.125.2022.07.11.19.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:46:24 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.323-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <370bef86-9c35-d2e2-bd40-13b7546ed7e5@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 20:46:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
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

On 7/11/22 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.323 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.323-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
