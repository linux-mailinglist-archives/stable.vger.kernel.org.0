Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C052A7CD
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350862AbiEQQWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiEQQWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 12:22:49 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D63AA52;
        Tue, 17 May 2022 09:22:48 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id bo5so17324452pfb.4;
        Tue, 17 May 2022 09:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Yhb3WErHrmOFWHGszdbPVKejMq8kZztuL4yq8HDl1Ug=;
        b=hOGzhDujpEd7P86BYpziCdlIATt8jcgjuCt+fGGQDfTcDcRDkgBTE7Mtojx1W/6YKD
         F2R0bc4TUtIG4i7f32ecFgMVq7NuL5W19bTThkDr1gQUZPS5gjS/oi0mADUQVxDQgXaT
         bF4DgxrYJtm9AXXTSa4Yc3eDIkiZXOUISBWDdPqCWO6TDXqhLKpSaVCZpOas9V2Ducrp
         A9Bp66VKhReaeHSVk1xy1FqhMaeV6RdSx+F9HtxiLxT2ylVY0CyRn4C/dD34C4Ov4mvU
         7kDOF+JdtMkPDIoAV4ZU09GZ24XpQrFEhgiPu7658QroJZlOloF6mhBgUZsT9HQflrV0
         yBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Yhb3WErHrmOFWHGszdbPVKejMq8kZztuL4yq8HDl1Ug=;
        b=0CaHYSPmarbwB/CKbwuWA907vHAVHp/1zRQCXB1jZeyBpA3+RrcDrZ2DllDoACi+MM
         g+uyY0Ypb4yeLtqB1dmRb1dQWKPaVo/ipB47zUBbzSRwD0nU4CNCA67r4uUxolOfJIb5
         +Uni0WGtlPJ9SSlEGKJHcvyiJuJOLgJjnDt7r9dD+AeJ9i1/Z/fedDkck/F//C/9z/RW
         KTtG3q1xfEokFOb6OnTije7uYQvUAa4RJJEptDI/DEimPL+Ox/JuVGKSqyigQAO1MOke
         KNUv4U8id22XTM+Dgc3DYMZuV+uC2w7qKlRD1fElyPJX+XMxXXk0fZQpl3O17WbRb8dP
         ZOfA==
X-Gm-Message-State: AOAM531bkHfEhYhcqMS9pNx423SlQg0zrJ4LXPYNh0cQBcFbmlDsw2x9
        KPhne2ieJ+DvtB4YfTpoHnA=
X-Google-Smtp-Source: ABdhPJzZ1O8uBFfp+Jhby6TKO6auMiPULqRHvLh5ace3A5VLpeaImfGTO4kJxrIJYIKJAoD36m2X6Q==
X-Received: by 2002:a05:6a00:2310:b0:505:a8ac:40e7 with SMTP id h16-20020a056a00231000b00505a8ac40e7mr23402260pfh.11.1652804567715;
        Tue, 17 May 2022 09:22:47 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w133-20020a62828b000000b0050dc762815asm7385pfd.52.2022.05.17.09.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 09:22:47 -0700 (PDT)
Message-ID: <6494ece8-7c56-0420-f3d9-eb2392ef576d@gmail.com>
Date:   Tue, 17 May 2022 09:22:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220516193625.489108457@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/16/2022 12:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
