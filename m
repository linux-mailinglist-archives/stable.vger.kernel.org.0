Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60E500008
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 22:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiDMUgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 16:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiDMUgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 16:36:23 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F21D40A3A;
        Wed, 13 Apr 2022 13:33:59 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a21so2983550pfv.10;
        Wed, 13 Apr 2022 13:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T+tj8AwxdLMsDrK6Df/frL5bOX0smbrU7i4U3XHQO/I=;
        b=XdXuuFvLCX+ccZWP99VYlC5UO5aRxrl/zgtr24wAwGsolxPUDXdrjGp4CdClMPIq58
         e79K+jkTWAQsRfhZwUwXaqixQqahKoLf/g9Su60UJBBWgVFQpuRKJY5CeSWbz/kP2hox
         nZNeSyuKEBwM8KMlrESU4DsVcrzWFQmpciYcyktuK9Jb1hfArT02RPiwoc3/RNrSTNth
         Elr5Ap1o5hMEGlFIVQ8LNGzhpo3NltSENA1+QD5Hv4L0YYCSncxilpKV1HhMV/lQJXno
         jeTz3ZSFrLEhX7+euVI+s+W7fDjzrH9wFaigQ/mXZ2MECymchQLdb4b3VHOeH549UJhQ
         YdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T+tj8AwxdLMsDrK6Df/frL5bOX0smbrU7i4U3XHQO/I=;
        b=PmM6aUBZUUUbiCdcIOqOuWDfA5Gxmgj6qy+zM0Lapmu7T1EzZfQtcOXK/dRUL5J3ev
         9X2fiX8QK81I7baIEP9GhMRlTlw4yJW3KotkRllNYEYvT/YYCyA2RG9ZHwBMSJ8xonrO
         vz9IuIcYyjTSKZ5/mS9iWNgbpoHdJjIUffH8/jKFJyuYzMbG2N1Uz8DhG7TnGDRN5RIh
         wnYH6TQk/84u982MIEgRylPQrmlZVnjYB00QLYFYke/pyNto/5brg553PMEZtCe/bJ2/
         6OZtmQyRgZ18J+45dRRjX5RpIESMcXpcoCDKwPE9ZC61GnqheNfo34WHaNqCYm6WpDv4
         7L7A==
X-Gm-Message-State: AOAM532uTbhX1Tas8E7MUCFvt2H8DLeG3bjqC3xc8WMIN9OFDj+IvgVq
        n3jPnxvN/oQHIrUuyCeZ7nUxLac/o0E=
X-Google-Smtp-Source: ABdhPJyPcshJbKIEQUvyca/wwtNGaRiFhPjkwnpN7JKh3xSMlTI5YtiFJ6T2Wdw7drBxuSSejdfOcg==
X-Received: by 2002:a65:63cf:0:b0:39d:40ed:ced6 with SMTP id n15-20020a6563cf000000b0039d40edced6mr15960520pgv.77.1649882038511;
        Wed, 13 Apr 2022 13:33:58 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00150f00b004fb28ea8d9fsm45822651pfu.171.2022.04.13.13.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 13:33:57 -0700 (PDT)
Message-ID: <0624f072-3bdf-0e1a-a237-1b7d0bc5162f@gmail.com>
Date:   Wed, 13 Apr 2022 13:33:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220412062951.095765152@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/11/2022 11:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
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
