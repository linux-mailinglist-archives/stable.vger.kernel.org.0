Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B365DFC5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbjADWSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbjADWSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:18:32 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B830710577
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:18:31 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id o13so20225153ilc.7
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 14:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KKo5fPMRdKGz/7RZcIbHkPKTsudmAdqtb3BfDvd7eiI=;
        b=NOAn4CM7EZnxg3vagPtncIfpjpLv7OC9gil6WAGwp8N2XaJWrEdp+HZFRLePILULVv
         NWPB+VDRTb6xuZWPoa+qdI+fle9KwJVqkUGeL3AxCQVlZoQPgaCzwywxV3QAY8PeaIqN
         EmtZuaa1i3nk7xK4U1RdRqiA7MglylS9tYiKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKo5fPMRdKGz/7RZcIbHkPKTsudmAdqtb3BfDvd7eiI=;
        b=rnDBTaIA+wZq3vNDUi16YFPodqJE/hx5ln2rDqAlkqSVrdXvU7ikJfzU+zaqV0WmOq
         aByd6UYINKGOJLBgSuOw7vHpL6DK3sl9FOCFKfZYDAsEKAUsBzb8IfiPuca7eJpl1EGv
         xlMNCGZlQhhxId8WQp7uaMzjSpih40b+coCSUk/XjXrYPMGibM6Vyz3panr+XTG32BdH
         pQ9lWths0TGXBqmqFTX0PDZKOKPG/Ha49wvrwfPdv4HbHOUDbAJAoexG9zW1hoqD2QtN
         Di4FfflauLv86tGxvlBdPRigBgRYaT4nADbuzD8LpkaD4FKIyx9aiQRLj4sOfth/giWB
         KTuQ==
X-Gm-Message-State: AFqh2koElbePRA8eZg5lyf90gS+YIhX8bknAoL7zOm1C6WypPw+8l0Be
        DLtWu7vCa9bjtGuFt1TUCvOmdg==
X-Google-Smtp-Source: AMrXdXthTw+Kow5gRYahz4F8OuHqi2IEJEDJjoJn0MD/pP0jU50f21tl3vta1TAJAkv9LbSf5y8SBA==
X-Received: by 2002:a92:d307:0:b0:30b:d947:6bc8 with SMTP id x7-20020a92d307000000b0030bd9476bc8mr6730778ila.1.1672870711036;
        Wed, 04 Jan 2023 14:18:31 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g62-20020a028544000000b003781331d909sm10977580jai.9.2023.01.04.14.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 14:18:29 -0800 (PST)
Message-ID: <b7bb6c30-7f6f-80f3-cd10-b68659f6e0bc@linuxfoundation.org>
Date:   Wed, 4 Jan 2023 15:18:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
Content-Language: en-US
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/23 09:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
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
