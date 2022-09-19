Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8625BC0E7
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 03:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiISBGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 21:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISBGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 21:06:47 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E405815A2C;
        Sun, 18 Sep 2022 18:06:46 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h21so19735663qta.3;
        Sun, 18 Sep 2022 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=F1vce9JNB51xNusHDMYQfyU/s8n7VsYT+MqpGpuJVtg=;
        b=lTQu121cJwwrkQzhfA1VbGcV9O0i0Z2f8b8maden85vwhjjYjBSZLGcRG19wX5JvJn
         iXT+U/0UpTGzfxLKm+X4NnpkMofs2Fny3HQRJofmmALNtyMIogWjyDdpLAAshlkzU/V1
         h08Ms48DIn16L2OT7v2fyi7iX+tj4GgDrnyyR5bTSiENiRuLFe4UEwf6TmE+1+4Czu0b
         IXgvs4RpgLHtiQTacdK38IvfcTGzFDZjmC75XjYshbBH/2xil8cMn2iCT8B138l2VIcQ
         c8F1GEuZJDaGWR8YcM4kWC+o4K7kMQjCP5xCAriJQfIAMGNRW2eiQBgd8+e3+0xBihwB
         mQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=F1vce9JNB51xNusHDMYQfyU/s8n7VsYT+MqpGpuJVtg=;
        b=TYsrCyQnNMMEfGzSY0fudA1/Uf1HodAxFbzotSPxwWicqsCoEW+YuJwwNAm94fg8kg
         Xw8j4bOL1JQt0HwKvMwuiTfhLUxPabmyiaUdibaH6TqrNKPuP7VJtBFEiyEz1ga1YBw/
         ockpEP949wOUBncX46u3EJvOLM3aPYiB8oh+lU6qW4Xj5Qy8MsJ5kwakLgwW9sgTy5D4
         p6r9upypYCgkVcL4W82Jr90gVxshu7hZKYyDFSVQEIm5EaR8g7AKjUDlh7z52d9Y5Vlk
         jqUk255+YfH5Q8g6g2JiuTEatw+pAbA0B+tXQ0V9HDYtF6TAzMFhZfopN5dFJfZYSoAG
         TCeg==
X-Gm-Message-State: ACrzQf1Zfm8abStP/u+S+xOt9MDY6tVRB6TjhIv3h8cpXwo/dklvW7t7
        X3M4zhgVQHXV+xV+OkWwlkQ=
X-Google-Smtp-Source: AMsMyM7kti+wO7l0SI1TOJ2GHOVppqxVSd+g3iwiidGom+Bpx2wsu2jzcIu0CZowKeM/3qJDsWV+OQ==
X-Received: by 2002:a05:622a:11c2:b0:343:69d:65b2 with SMTP id n2-20020a05622a11c200b00343069d65b2mr13278756qtk.491.1663549605959;
        Sun, 18 Sep 2022 18:06:45 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a5-20020ac81085000000b0031ef0081d77sm9396706qtj.79.2022.09.18.18.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 18:06:45 -0700 (PDT)
Message-ID: <9176d96c-93f3-7581-127a-42de5a220f9d@gmail.com>
Date:   Sun, 18 Sep 2022 18:06:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.19 00/38] 5.19.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100448.431016349@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/2022 3:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.10 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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

