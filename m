Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EAC5FA78B
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 00:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJJWIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 18:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJJWId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 18:08:33 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8965F74B83;
        Mon, 10 Oct 2022 15:08:27 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id i9so7934549qvo.0;
        Mon, 10 Oct 2022 15:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yA36micw3BB5itFGo+j/ax6sHQQCHHk83ArO+ZpWJBA=;
        b=YL0are/S2uwkPzzcqLaf//Fp312iwfJyPpED0y9zdW8IA0uKX/Nc6tRL1m0vQXt4rt
         Fu+btg4YNvnwfGaec/yVZ4FrHb0e20nqFGRxA410H9mVTnMrJqyzNTJjREkpv1oGNQRA
         Br3ZFRma6/qOkHlMkiu9ussUxajjaiFdCDbHLD90N+tpspPQHB0u5PV2jxJtseVjDoWv
         mwTIZduErYFkNFdG7CEiCshLAPIzV6+HO50oyluzfh30Xmax8PUVLpbt+n0ea0uvPTYK
         Ed59G+E46xX0NPIcTfC47AeE/YZKGSOizt0j9Hgzx3tB8BG10sEoJQB+sxpmuLuc72Jm
         Wfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yA36micw3BB5itFGo+j/ax6sHQQCHHk83ArO+ZpWJBA=;
        b=yXfXczN5OAWRNnX4Wa4rrwEBbFCKPSPZ2EZ7jqsd826UQRLCfvKl7icDb+cH5FgrKh
         xkfk3wp0mQnSLaZxcJH7hFg/K6W6WINX2yhYtbqqk9KODnNMbvK+Qg0LWR13Hi/I518x
         zXtpcHPQ2LG2Mxf+gjWWWqns1fwru7DjOaDPFK5uVbTOvN9kGcfaNTlX76szs6VLcnLf
         wqEZMO7cKJVgWKr8Z5VSRkLfAoj3PUShWgfgTviaqBDwhWGufbX6lWXslXZSK16JaCVQ
         QgZBa8VJzIeF7/5SXnE7KB53QMvoTNPYQwn8ctM8lhvtgy93zrzjarYvyjiM0LR0bR81
         ucMw==
X-Gm-Message-State: ACrzQf3DjXVy6coVIoIzcOvfCR+jGeUyEX6qCSNYUSmg07Ynh0mV5KGR
        Eksu4UTPdmMQYfqfqSQsvB8=
X-Google-Smtp-Source: AMsMyM5YwAOLNaTjardD5q/kZ/Vzp3E2MAqlGyBcDVBU/xpJ65WvSSdpM26tY/eXD/h5Jq3ivlXjqQ==
X-Received: by 2002:ad4:5b8b:0:b0:4b1:cd9a:e1cd with SMTP id 11-20020ad45b8b000000b004b1cd9ae1cdmr16784613qvp.7.1665439706310;
        Mon, 10 Oct 2022 15:08:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y14-20020ac87c8e000000b0035ce8965045sm4581457qtv.42.2022.10.10.15.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 15:08:25 -0700 (PDT)
Message-ID: <0229091b-da13-f386-d0f9-1350adb09d3a@gmail.com>
Date:   Mon, 10 Oct 2022 15:08:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010191226.167997210@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 12:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
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
