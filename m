Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2B55060B7
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiDSAN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbiDSAM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:12:29 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F402BE
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:09:47 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y11so4064742ilp.4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJVnJRZKQ+FYL2/tSMJjFui5I5MjA0tDoA9qCH3pMK4=;
        b=N1VkSMdUADE8q38QRJFAHwd+OzCE64LWT6t5oXBRpn54yA08SVL1HMUb6gd29j0JpB
         p1xrH9VJYXoto3v6Aq/H+5fak24mQgEhR14LeGBSzrxjJpvrwsHCJYOhzh3HN8SopA08
         frUydCqeFRXCzAbStvDn61ew4Kvv/rNSiOxLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJVnJRZKQ+FYL2/tSMJjFui5I5MjA0tDoA9qCH3pMK4=;
        b=v2+aN6NlYVH+49dCc48Xx09hE1f0hKx0xKYU2YSQAL2wvs/0e//IPCAn5ufN8BHx8E
         skWVyWm5xcf7G0wHuA4C14UrLapHi45x6QnkzowsSehuFym1YvXWJqDliSJ+TQoMiO4c
         j/9XiYmZaKTffd9wiwrk6gjT+vr0DziOFTJkGQQ/jZ1NARJQHmNPQpaJ5axMyamE21Pe
         Uo1nw0LwgcC7MINZJX7iOzNLaWNMThQHPJXm+47EsmKz4Xsm6iod8C5IpDWcC5JV1i4k
         B5MUbVc3pvnUWcHikeDo/2ytmExkh7A9xOM5E9Cd2e40LD3RBalSgmfoCEVShbatPTxo
         pMaQ==
X-Gm-Message-State: AOAM530yTh4NrjEzV7TJeRcI6lClxYnEpDK6xVSToKyp0dFlst/vp0vn
        wwqFSMTB2DDsuFIuXIGl3LykuA==
X-Google-Smtp-Source: ABdhPJwC0hqgOREjxgixgnwWFragfjuntU0NjRMmrN8eldYxyjPa9tXBZPR1fK0pSO3n5xKks5W4qw==
X-Received: by 2002:a92:7d02:0:b0:2ca:4447:c1fb with SMTP id y2-20020a927d02000000b002ca4447c1fbmr5434148ilc.275.1650326986651;
        Mon, 18 Apr 2022 17:09:46 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id d16-20020a056e020bf000b002ca51236f60sm8083359ilu.9.2022.04.18.17.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 17:09:46 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a2fb1868-999b-4618-b54a-b78bfba3f675@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 18:09:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.239-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
