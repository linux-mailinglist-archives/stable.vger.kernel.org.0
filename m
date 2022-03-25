Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595CD4E7DBB
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiCYVwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiCYVwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 17:52:49 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E034433A0;
        Fri, 25 Mar 2022 14:51:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t4so4397537pgc.1;
        Fri, 25 Mar 2022 14:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HfXDJ1r4N/UDqXR8w1mXfzphxxVpxxNJFaUCSkIvH/0=;
        b=LZO3WIPV2tj9Hmwuls5ijA8/DaBJpUer5ynxoIg7XnGvRhbNIQoY5CukGj2lvdWRUg
         NzPYHFlZtaZxQ8j+Ah9PAz6taUlIcTYH257Esb1c7Ls7MFCLfb9TvJa66CP9un6jE6rW
         Whs9+H93sRhpr0vYwCeC5Lx8Nt4DbhAbbmz3umvoqLYYCn7qs3L5g7G4fP980RlGRAo7
         aEd5RTxwfbH/UgKX4zvciILrfpdVlh2k4Pt5T9bsSjJDpTJtxZVlAmKA6dF7A0qfdI8Q
         VJIPy8ndEgKilqdnxBxkndlB56CL4113UBxwT1jtGaia3Ar+ut3I3mZ5WsQ9g70eTIYF
         9Zyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HfXDJ1r4N/UDqXR8w1mXfzphxxVpxxNJFaUCSkIvH/0=;
        b=Tyn0bINM+gSZVeA5xEhDzTQCpqjXbjD+rvNWpBeu0hujh25j11i3sBt6lGQBYx+1E7
         noSoinEZJTxNLj45y7lmLyQCoDhYeUhKo0b9m10zCewF3JnoeV6o6uBFRZHTX39/eZyr
         D/d4o47nlNTFB097uxPCBYmMMpmFmafO/yf9RZNEFkYZX2aw0NsqzpqtY2UFzMxl9u5F
         ZOQfmCDe6+uoyfNWe64/lwrXRdPdd/3OqdS/oBVus9sFTxiq1AayiwyTY0OzBrNwwYah
         SzTg/c76uiDpzBxhEkGfowwpoYku6ciaWAl2Hm3q7svSee49M5IvmSdGVFDKwez6mbtI
         DNiA==
X-Gm-Message-State: AOAM530xysAz10OgJOqkWmNDlcdDdGWX8Zm0gcxWU2Z93WL3Piu7+qnU
        Awx6aPEvPPx7qaoMfnbzEBA=
X-Google-Smtp-Source: ABdhPJw2poOw0U8PW13Hx9Dc/46U0XKxtnJyJwrLXNRVJS+OaopXjbUyvJwvm/hdFi+WP8GjKTPAIg==
X-Received: by 2002:a05:6a00:10cb:b0:4f7:942:6a22 with SMTP id d11-20020a056a0010cb00b004f709426a22mr12385536pfu.84.1648245073935;
        Fri, 25 Mar 2022 14:51:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm12343959pjb.2.2022.03.25.14.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 14:51:13 -0700 (PDT)
Message-ID: <05da2d45-cbb0-aaa9-248c-d99214dc7581@gmail.com>
Date:   Fri, 25 Mar 2022 14:51:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150418.585286754@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
