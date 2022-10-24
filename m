Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B480E60BDB5
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiJXWpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJXWol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:44:41 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8B91213F8
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:07:23 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q196so8786372iod.8
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMKtE2hhzgHv2HBqWzucHUcm8HcwpCie3qJsbROuUfw=;
        b=Jr5Wt5vmvv2Zdl+HFMM33eNpfJdKz8kO3X7cAPWdxTkr3HViwI8493JrbXE8z+aRj+
         8u973BuRIVS+8hxnqxv2xgiIMXtaCqsFnPE+0R55MLl2WlH2IAhJbQ82SJL+VGP68Mdt
         HeL4WEoZHU2sYxsUBV2P1wNF54JMyLIC8MnzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMKtE2hhzgHv2HBqWzucHUcm8HcwpCie3qJsbROuUfw=;
        b=EGh9kFZBnZDwMsoXIPWUVwt7vopFnasIgxMOVdtaSYwkxaXVD7sC2wvRi4PL0YT5O4
         U1+XOVy/xPGPcik0W1ltW1w9BELr5BMsX9FBdOYEkppCClFeMKogZrCA4aqodAErjeU0
         FRcDLKquPAJl1qJnsI5Pp9eqqGMVtZf+mE7ELU46cgHt0+tRT588CkIQarCkhBvM8Th6
         7z5DgxzgnHf3IVds/NFKChfoVOE6g0PnMqbx73n9O0GrPpBH8rRpQIvV/K6iBF3a1y8Q
         Yu/tx+t39cGgTZqmY6jTOzZUi0AossZ1ryqKYaer69J2ixJ8fqSWeiauDLu7G9AzxRcg
         r+mA==
X-Gm-Message-State: ACrzQf3J20JUEPOvejDp0Qmci+MfP8tl9g1/B1H4f1fE/V391smtxrZw
        OJqJv9Q4BJxqiTp97RDWo6Qpgg==
X-Google-Smtp-Source: AMsMyM776wszyJv/RICW1tRtaLUxtDNvqlaMUeVsn4WSM2T6jSfqQlYHVfL/mkDe8ywursZPbzFQ3A==
X-Received: by 2002:a05:6638:4810:b0:374:f69f:fd51 with SMTP id cp16-20020a056638481000b00374f69ffd51mr2523467jab.152.1666645577250;
        Mon, 24 Oct 2022 14:06:17 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s13-20020a92cc0d000000b002f966e3900bsm315326ilp.80.2022.10.24.14.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 14:06:16 -0700 (PDT)
Message-ID: <5bfc0604-550d-9c9f-933b-f9b07349a4d8@linuxfoundation.org>
Date:   Mon, 24 Oct 2022 15:06:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
