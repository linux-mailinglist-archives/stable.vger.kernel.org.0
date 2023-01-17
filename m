Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9F66D388
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 01:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbjAQACF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 19:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjAQACE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 19:02:04 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E341D22DE5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:00 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id v6so5155854ilq.3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uy3JXCyJNRbRAP9AGSSvge444xueLj6DcpPi55/gq98=;
        b=DMUuXe/HBraCZA7qiMZcmw5kjMkx9qnb3nl1/gtcaul/8ZWWWov2amWEgU7Jxl2da4
         mbVVh31y5jKNFYTIv0aihPu4+zD75rRVZenH8V7otyqXdLVfgo+J02FWtocq0J8GhLa+
         NMfW/A73oCpEqyS6Rl69sf5X7SP2EaLuq8pc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy3JXCyJNRbRAP9AGSSvge444xueLj6DcpPi55/gq98=;
        b=dEa5S+4+O7nViXyvaRtT7oupQlZ3RRYjczmDs+JQQ9zHFXWl2HfdO26FIYAvz4Yq8Z
         JzhlnkfqQmuQG2pGbq9/02jUu7U9PDmn2Yy11lNRwOh1QTPXMuoIS2RGZHZhwy2rnU7q
         uW+LlfRAdc/xexGwfKrV6dpSOXD8eD0z+sLz1HreJtd16sexATxSPSDqLjSMg3h1N+Mj
         oUFsFh1aVKlQCZhrEQGmW36q/iG09THBqGyZI7pgIdHqgszX4bANjjk5FaLzTxhakzvW
         nppOxVziQ8GBRcTZjZngD5s9tfoTnY63oJFRrhBq0UyF6NhmQS10Qlf2X9ioallC96kn
         rmZA==
X-Gm-Message-State: AFqh2kqywISt+7nkeXgji+11SOfST49FI6ZrA/fAfjj3z0paPWZgoHi9
        6uhMjOgft3dEIhfUYlPK/CDOkQ==
X-Google-Smtp-Source: AMrXdXt/6Nzv8x8gsJ22K/ptSP3NfW209hyQ2Qre2Hf7EkTI7joB/0pNhzCgGsdHDJ7x1gBXX/8kbg==
X-Received: by 2002:a92:6e11:0:b0:304:c683:3c8a with SMTP id j17-20020a926e11000000b00304c6833c8amr169573ilc.3.1673913720229;
        Mon, 16 Jan 2023 16:02:00 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j10-20020a926e0a000000b0030d8089011esm8618515ilc.54.2023.01.16.16.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 16:01:59 -0800 (PST)
Message-ID: <e447ea5f-8309-48e4-b1fd-5bd8d431a9c1@linuxfoundation.org>
Date:   Mon, 16 Jan 2023 17:01:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 000/521] 4.19.270-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 521 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
