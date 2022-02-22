Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698984BF053
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbiBVD0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:26:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiBVD0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:26:21 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C51D0F9;
        Mon, 21 Feb 2022 19:25:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso1045344pjb.2;
        Mon, 21 Feb 2022 19:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4vYdnua+bzkPHJp+AykVXaq5kKq5CFq7WPf6pD5XIeU=;
        b=jNqblX4dKSPE1rX5AoY3UMfFWHSYvb4LA/Y33J+uggWSnVTzgpCcLoe9wcoXWDxnXE
         iWSFTbL5wYVHUebVeZ7WPxB/AlWErV45PDOW7kJXtT3gGZ7rziCHdiIvuawhHvvS0IKm
         5GIGhEwRLd6634xP5LwJhDD7HRIfgnHn5m9iGOxq2y2SnP6xSCVg8SIzVJJd5/5V2JON
         nTnNad2VqsPL1ngIsoYUug0tcpR2RRHsvPsjfs/4wUFNyAmakyMy5ZdxVUy/5Bd18Csg
         aKIsDI7JAlFzFOcXCelIb1xGSi5jNXyR0Czwj+di3dWBg0QQA5psHF1BfBxawvzQPL/G
         J2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4vYdnua+bzkPHJp+AykVXaq5kKq5CFq7WPf6pD5XIeU=;
        b=WGlb/rirSHJ/4bTNw3yJUePPIm/IWm6SNP3iSfc+7JN535mmbhha2qnf9nv1J3b1Vk
         vFqpRWXVu2pB6ex6e4c4QWK5JDuu2B/9O6INDKHnPwni+se1+VKPt7mtD+vutGplOCjL
         jBl5/XO25TEARLPOrbkPPD3Qwa18iKsjdMnQl1nh7ZAGYAwM7uGeVgmxnxnrbQVXtIwN
         l48BGbPUA1CiM40KJJ4BQrlmVbQCPb/tAUBrAXX6s8nI35XOx7LvEDVbxbUHcYhAoiXZ
         MLYLCkqHNxvG7AGq+SPxMDxFzjatX+tDvUaGNQWhAr10uICc2MggGCwdj7Wikev3ubnO
         Hdxg==
X-Gm-Message-State: AOAM532sUS85zYtegMlRsWjXlFC2S9xIGfIvZQ8uD+jJ8bSG5bvXd9Rw
        Ro8oFLVDtgzWQMeYja3knvU=
X-Google-Smtp-Source: ABdhPJxZ87yA+bNjrTdMW9gkvqRlabKKfeGJ4+eLga5Ki3XDwJPDeODAYk9HcSztOeAWqwoTPXzc/g==
X-Received: by 2002:a17:90a:2f41:b0:1bc:46ce:6364 with SMTP id s59-20020a17090a2f4100b001bc46ce6364mr1994677pjd.159.1645500355434;
        Mon, 21 Feb 2022 19:25:55 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g12sm13789515pfm.119.2022.02.21.19.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:25:54 -0800 (PST)
Message-ID: <f82a843a-65af-0450-5326-f6795e4d7da0@gmail.com>
Date:   Mon, 21 Feb 2022 19:25:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084915.554151737@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
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



On 2/21/2022 12:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.181-rc1.gz
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
