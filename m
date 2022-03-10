Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757924D405A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbiCJEkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCJEkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:40:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01E9FBA56;
        Wed,  9 Mar 2022 20:39:35 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r12so3815109pla.1;
        Wed, 09 Mar 2022 20:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a8muQvZwPBVR4Om9BDcvXjc+/opWxljURQCaJ7P/grw=;
        b=e8me8YBOrrYdonpQitDroywqvABWtM6u4Gy+PCtpQJ3gQKKOmqbwyyuksjT9JZftbU
         MvC/eJ4gBjqALhgcfvESjFsYo/FxLAuE5zRWxgE7MFKDzngUX7DPLl1mEQ+rtjp1caUo
         RTMRfsX0j1h5ZZLrLTR0bbfg0Q9MOk48gHMyoFwKRSeojWfGakqkju1FM2v4U1j9zM02
         Y5AyURB+hdeJDN7q3wIWUOUS2wQPw/JuFLGulhf4fAnU+7kOqnfWWsCWSAONsZFGxrna
         lok4uu006AlQQ7XvfVSjKLi4vqGj5nVtz4F6i+6hjNWTm19Gq2PgfIO9KASdjLE8TrtI
         PKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a8muQvZwPBVR4Om9BDcvXjc+/opWxljURQCaJ7P/grw=;
        b=ouvhMptNZlWvXNNNjkI1FbY4BcD1Kuaa2955SeyHARVUTP0UYCwr50450Mc75ok/i8
         BuZmFZ2rVj2gBAGx+JURwjnxS8R/uzVZM0As5tB5pT5PmX2NcMC/p5Ui+k2TZZxVCAT5
         tblvbdrLZtdeOYzhaMcM8cExKvI0vCLwXtcrS2Fyx0R0ewAl6RorBuZ2NZ4Tw/A1mOuy
         lCjeahartN79UdbJb4lk8Bw3ocRayyK3AW7ojlpog/0rStVsVzdSLmJZidVUfE6mDRhP
         eY0b/OwXjOY/2NjXbLENvfrm9hp1//PNN5bSxKE+fcnwuUWWp4N3XKLjQyBw5JaeFpgF
         NsMA==
X-Gm-Message-State: AOAM5302kny/pVgPDe0fykLAiIIBVCfwvMb+3whucf771GQRDbtez03r
        wkfI0yIUgEWTMhc2bfGdqxQNB5YFUlQ=
X-Google-Smtp-Source: ABdhPJx+cNClR/LRJp8d1mNaSQwA4lbIVurtH6brlUPM11CxtMmyl9+jk4Ttwsa/UeaS8aVXGSNERg==
X-Received: by 2002:a17:902:b945:b0:14e:e5c4:7bcd with SMTP id h5-20020a170902b94500b0014ee5c47bcdmr3082955pls.48.1646887175154;
        Wed, 09 Mar 2022 20:39:35 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a00229400b004f74434eae4sm4886499pfe.153.2022.03.09.20.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 20:39:34 -0800 (PST)
Message-ID: <0983e5e1-858b-da3f-b585-ee459ca4301b@gmail.com>
Date:   Wed, 9 Mar 2022 20:39:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155859.734715884@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
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



On 3/9/2022 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
