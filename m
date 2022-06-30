Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30C1562778
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiF3X5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiF3X5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:57:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC2E5C963;
        Thu, 30 Jun 2022 16:57:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so4762097pjj.3;
        Thu, 30 Jun 2022 16:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qcLhJvC+D5OYRf7ogI/k7y7Pg+pS0lzqiVdPO7nMHQI=;
        b=O5z7gHCsEatU8qrG/83UTjMD8BAbJEAgOJe4wMok2mVEUqIe0Xa8VKhYLg3+vj+qvM
         6qzoUXXI4+mnbtszs3xpekXAcFJ1DwVx4hfDRS6QV3OiqsPA2D24vKLHAdly5XO4U/sn
         l9074KDxKsPA8M8LqqS5tAAPSQawui41HFSrOq98TolPcK7UGN6Tv9ELGKSW+aYMWAog
         7UBTPmUAMfRQRUbWINV7jsrPfn+ShbkoYvMVU+0fGBENmxq9se9XFbG+iNOk106Z6Kw7
         JusIzDa+iShlz1CTHQduWA3NLcLgHJo9Cla0Ktf4LhNq9hLgXkfe6Pe1e/E613M81psR
         JT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qcLhJvC+D5OYRf7ogI/k7y7Pg+pS0lzqiVdPO7nMHQI=;
        b=XVLXpTcI37/staJ18g0B9Tr4epshmg2jVlHUSSMp2imSZ1r4kPSHVEKaCK+eKQJHiV
         3Y5ecg3yYx8oTbowlS7kbs/9wrkE1noHYacZYaIvNzgyp2cL1XcLz7abV4raEYqqq1bt
         QnnDRnA/nhImufXWPQHMfxdwhcHdBxAtoBjykaV6o9pz5TQGFYdUL6sKqdAR3zYFlq2q
         fBE7OPewb5w80Lk0rcIXP1LF4APP390euqj8KwLc/vg5KqQ6vfZMqTwalnTgjfMkA4du
         61ruvk0vV3R2MoohyZBc2K9ArHEyksH/yi9kda/ccmqSxWStfOEO1d1EqFKIgvjfQD+x
         fDsg==
X-Gm-Message-State: AJIora/XVn2nFGFJ3Ndv0eIKk+zTDnYDz7A69TbsLAMhIgS2GKtBmpGz
        B9nZSkt6V2TupnQ2GjB/nQ4=
X-Google-Smtp-Source: AGRyM1vfohPqMrsdhkq/NcfqV7O+aXYkH6To0fd/SdyqpzR6uskDP2U7u6zNEU6QugJM8EXLo/EqRw==
X-Received: by 2002:a17:902:e74c:b0:16a:5b5c:dc4d with SMTP id p12-20020a170902e74c00b0016a5b5cdc4dmr17993862plf.123.1656633450709;
        Thu, 30 Jun 2022 16:57:30 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u17-20020a17090341d100b0016909678e2csm14165172ple.292.2022.06.30.16.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 16:57:30 -0700 (PDT)
Message-ID: <e53abf8e-8405-9049-08d3-c2651937e58f@gmail.com>
Date:   Thu, 30 Jun 2022 16:57:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/29] 4.9.321-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220630133231.200642128@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
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



On 6/30/2022 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.321 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.321-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
