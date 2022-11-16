Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6397D62CBC3
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiKPU7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 15:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiKPU7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 15:59:39 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731ED686B3;
        Wed, 16 Nov 2022 12:56:31 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id v8so12535214qkg.12;
        Wed, 16 Nov 2022 12:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zy7OuB/i0g5N8OKRO3fubXKgptPvlvXmoLmFRS8NTW8=;
        b=j6HBmryqK8UClOg/NS2PiSDE3d0BOoNDUsw5wVvkdE0wr9OTpHZALel85g70S45O2f
         fCSJeao726reXsNBDQL50RLxInJb23XC4joKUCS5oCuSxdDVH70QY61xrpF8iwIxlM1b
         IbjifGFRl9t+kbRs76zJ0i6usxyt+x5tpNxG/BtFcqzhMYu1c5ps/uouSq/k2sBzotyr
         6fDi80j/8vI8rrHYMAVFo0cLQwCo8XRKXT9tZAgpGZ+jO8io5GuVvnZHY6+tkdZNPiqp
         ZL624rkRCsm+8G4CJLCB+6okz9qpVMZsNwgCDrq+oWdpIfUaZulVeJ7ybBaZ6QdZfYTi
         1unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zy7OuB/i0g5N8OKRO3fubXKgptPvlvXmoLmFRS8NTW8=;
        b=dlTb6I8JesZHi1oKUy062mNSKy8FOxLV/f/2pg2u4dyjHVodHCrkjP0wgPjzy9u2mY
         XBgEobQO60TNI71se/FHBsTnx66IgMJR/13pUmFgcVnjMLoqNFuUd2uwwihkXlMlwUI9
         CyxMDA5z9nXnZrmYB5afSbFYTzIZRrWaR8XEJlSFRObnXc4+Tp6gOYKUNdCkGS4MTySd
         OjIyfY27pDPvqKG0LTj08K/qA56JrroYufL1t4+smhesY5EkFT3sm30yqUEpfqu195+a
         QuNEnfHuFIz/mN0Tiux7L/sZTx4SnXXilbnRcLF/wy8UdnL9lVRlbCgS5eFcOkhaKieQ
         dZrQ==
X-Gm-Message-State: ANoB5pn1topIykAhLUn9pTNvQwS9doJnyFxUSoFpdyUIZEL2zWI/5QI1
        uo0w1kmPOqV2qLplYAlafcZHGhkaRDY=
X-Google-Smtp-Source: AA0mqf7FqMZWHCQ9PQ4tImKAUuWMnFGM1yghpJiRtIoziRTs/wLppTh+C+I9D1YmCueKME7UEYWpTQ==
X-Received: by 2002:a37:aa53:0:b0:6fa:4b0b:d08f with SMTP id t80-20020a37aa53000000b006fa4b0bd08fmr21387495qke.488.1668632190553;
        Wed, 16 Nov 2022 12:56:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05620a084c00b006bc192d277csm10482915qku.10.2022.11.16.12.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 12:56:29 -0800 (PST)
Message-ID: <f12edc46-0fed-654b-62da-9e6866f6b607@gmail.com>
Date:   Wed, 16 Nov 2022 12:56:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221115140300.534663914@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/15/2022 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

