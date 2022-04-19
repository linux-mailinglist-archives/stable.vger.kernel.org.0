Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5797D5060B8
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiDSANb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239123AbiDSAM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:12:56 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C5A614E
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:10:16 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id o127so10685887iof.12
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=56KN/I5pWur3ZvlLwEA2HDSysSU3jSyQBVJpYPIOJi0=;
        b=bHuCxmQKcrxrh1bDgnDjvY2800IrAchNkbyuDl7VhJMCy50hv7R8foVp7bAM9wb5Su
         wDlpy6gloFhdKbqblBaMqWIQohnPvSmdQOvKwwdUXPpAmTJV/E33TfRgAEX+tLxXPGfd
         9iX6J+MKlFajtbYbYsbsZ2kmXpvUTehW978nU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=56KN/I5pWur3ZvlLwEA2HDSysSU3jSyQBVJpYPIOJi0=;
        b=tVDe4gjX4lCryV5qqAKn6b9z5j3I81sNv3/9bCx5yLOcOgsP3NvYM5KIcx8+jIJOk+
         QpcGKqv4xWIKfRkejdDVQcIKdfHHLz87eiUn5RNYHsCKx8eqAp53j9eN7rLDvFLA6wU/
         2GPcUitN6EhBhTazjnl1jKqY6BgXVWlOFUf6NRH+BGyk2wCLP/V3nIRKaGrHa1+Ir/RY
         rQER6zC/uWh79Wdyr8Ve4jHHKrvgjR5HfOK6u3KTw5iXKFuObjE5X8Vy5O7zlkgNf/A4
         T8f7D5XzqBM6Eh/Ru3MrGtjfE67ok8F8d8zULc1d+7Yva8MWXQOkiAvspIMynQ2P2jme
         Pv3A==
X-Gm-Message-State: AOAM530CejciR18XbDruTx7fmiGsffZNWqiotIYsubqf7OVBfLMMjyD8
        zU/cGCAmPBBtM3XfclbKhAM8Ww==
X-Google-Smtp-Source: ABdhPJykD2R6cVuH1dM84VNrTlFUHNqATRFQM5k6ua/7Wvk0pwmCsjc6KI11BaPLG4oXK1Gy0s/JKw==
X-Received: by 2002:a05:6638:1408:b0:328:6a0d:b98f with SMTP id k8-20020a056638140800b003286a0db98fmr5499971jad.119.1650327015763;
        Mon, 18 Apr 2022 17:10:15 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id q7-20020a92d407000000b002cabbe6e295sm8032241ilm.4.2022.04.18.17.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 17:10:15 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/218] 4.9.311-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2b2db111-baae-db78-5c11-0d93092ac906@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 18:10:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 6:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.311 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.311-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
