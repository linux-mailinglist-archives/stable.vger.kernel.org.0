Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17165553E11
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354458AbiFUVrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354895AbiFUVrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:47:11 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A841818391
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:47:10 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id w16so18780712oie.5
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4B7aVbqWFzGCq33NlsEkQcm/jsegAOEwkVb1IKw6lso=;
        b=AgNp04iAHOZAOiJfs5ixkzSdzmxRvKgddI5dpUPe5SR+uEBpkQSirGBFzgnh6QDnFL
         4bvN5ztV1PnHepFE4q9tUXpxmEZY6+p1sze068GCjOmfSkk/X1Jj6yhU2xbMTkUnCFgr
         /zlRPXWhXC8iSz/GGI/tQr0g6dXs2PieZr8N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4B7aVbqWFzGCq33NlsEkQcm/jsegAOEwkVb1IKw6lso=;
        b=FtFDUfXwE28bQq/0/JTNLwLtRsakDg2Xa8iwEC6hZ5o0ajtrsXg7ukjeRKBREuqvJ5
         /MNTs2CCHtVgk1fK6oEV0g/d1tWyAo50IBKhh8yAjtyf96NzvGUFCLtKd4jQjAKq7Qng
         sUjtSrg1XLrMa+IuHtcm5hSYYzah7dsrLnR93aRveakKqx6Ag/vqOFLKcHgwguS/Yjm+
         jUseUufxX7ABI+ciWg/Kwy1IQA+FdoIjDrEJYBtimCKH84F0znE8Q/EEmTllBWUNFxSD
         zxoqH8ipBA4rD00xkQOrKNtyZYGyqPYZhRv38XAjMJLG7apLKLzvweON+vdfd2KZ6pJW
         a9HQ==
X-Gm-Message-State: AOAM5310PQtA4Rx1Pv5ISzz+TR/V5ZI5i9PQcPR1s/5xLypBp8FzwVNP
        Y4NN4NIlPVtC5MswRWBlbyCWtg==
X-Google-Smtp-Source: ABdhPJx4WApb4tVvFpAl3IVaT8gTGCiCAY6M+HpL9AEayoZQWpPPp9vMeqHivLHHHXXPkwqJInndog==
X-Received: by 2002:a05:6808:1999:b0:32f:2fc:aed1 with SMTP id bj25-20020a056808199900b0032f02fcaed1mr20685051oib.255.1655848029871;
        Tue, 21 Jun 2022 14:47:09 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q7-20020a9d6307000000b0060bff068228sm10038190otk.66.2022.06.21.14.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 14:47:09 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <447c09a3-7697-9fe8-b475-d75cfc7bd95e@linuxfoundation.org>
Date:   Tue, 21 Jun 2022 15:47:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/22 6:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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
