Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8E4E2F05
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 18:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345862AbiCUR10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 13:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351739AbiCUR1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 13:27:25 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E8183832;
        Mon, 21 Mar 2022 10:26:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n15so13369007plh.2;
        Mon, 21 Mar 2022 10:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lcBucpc3ZUGCjvl3pj650bWNhpmxqULXqAxJwZYyxwI=;
        b=OaJnjzOrvKRUuxEsiML2uftTT4NiDdMzGPjL2qIJEg+p7JXn+u+lPkKkH14eCBPEiJ
         lyrwoZVMsF3zjEqYgRBTj52aLmVTgkTYW7p2UKLSgBA8Zm4n7/xMmBa7omEz9ucrJxPs
         dKGjagfJwBSiSaA1AApmWHfiKHx+W+IOqVZ7Mhs5boVdLHW9cC6ZVZOrGiD8wjHI4h/V
         WinjVmLPEEsxbYLpbrjBlL7+QL3liT4J7LONGuft1WGm0xUVvNwt+cYMFlgvvcQVxjsZ
         6TCvPHkjFE0XaI1MT2lXQju1GUB6aOgs2F3xm1EzYwnB9vxRrh1lu/SQN0KwmQLMoAH8
         2uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lcBucpc3ZUGCjvl3pj650bWNhpmxqULXqAxJwZYyxwI=;
        b=xpXjDprVE+1bFlMeWCRZ9i0v1AN8V/Z/Sg83tgWfIXg+GUm4o+1t+kUfLGSUlm+iFf
         Wk/9xf/0p9zqVstmHs7OU1yHB1ZYoi4Zq5mPEfIMVz5kCTbPD9WlpbhCJQFwgCapD1RU
         aGmn9iXPqO7UkrouX8ufoQWJHf3q/Fdo7Q3PzTVixUoSIu7Kgr6BNTnFae0B7fi4n9Mx
         r5N8B4fPm8RfnxtajY6C0EDCg2qnQ4rFJQj4A057DuN+GJupiFA/bTjfjFvbgdJ5GRtC
         PqjiydtI1SLnlVz3W13VswSo2pNX24is0NiqjpY1aXP+YGB8lGYIDpKPdVS5BI1/QJOL
         4+4A==
X-Gm-Message-State: AOAM533gBTLK/ZoXjKO4sWiskQJgo1S29he6Fr/7fnt+ecWTbdcRmTY4
        rVlEUibD2ExqXqXP/zqZ0vI=
X-Google-Smtp-Source: ABdhPJxDQDem21pyBzTcZ0MmRX7MdRC6hkW3xkuui0BdaI+DOIJKAeaIn0oxCz/ykh8zAHnsWnwfrQ==
X-Received: by 2002:a17:902:ab01:b0:153:2dec:6761 with SMTP id ik1-20020a170902ab0100b001532dec6761mr13985632plb.71.1647883559827;
        Mon, 21 Mar 2022 10:25:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm5470775pfj.55.2022.03.21.10.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 10:25:59 -0700 (PDT)
Message-ID: <b2223192-cd6f-a75a-5ba0-ee15f7bedf40@gmail.com>
Date:   Mon, 21 Mar 2022 10:25:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220321133217.148831184@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
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

On 3/21/22 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
