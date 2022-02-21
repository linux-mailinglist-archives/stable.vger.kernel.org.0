Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36E94BECBA
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiBUVks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:40:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiBUVkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:40:46 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BCD22BD3
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:40:21 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso14903956ooi.1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lj4QpMhoTxKeml52Gwrqh1QLzBHO7GWaH2K2h1uJeMY=;
        b=dQIWHSLD4C6T5JiDzjtNO79WLpdfjOGPEaSfacznWeILew8uqeZ0MLEAtXDt/H3yLH
         3AnzZBjFxoBquhua56FGLbmVeTxBTFmzHOLV0ug7t3ai84H0x5fJbtBcwFEOvmqg6voj
         H8DGnKSF9NPkKZyAWNSgRr/WtCS476QR5B4GA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lj4QpMhoTxKeml52Gwrqh1QLzBHO7GWaH2K2h1uJeMY=;
        b=l00WlhEzsFJSckjb5HetrOEd7tOc3h5p8tWY49y/qN5fH/FFVZnpCuOtgzVmQOgGCA
         JFS70dYQak+5UtDKonJflqMMMzTd2W/4YSFj+gTTwnR6EwLE6QRZFS3/NCWWEYNWqtvs
         GsTggzjl+fT5OtThEIYYfPwUzShDlla79A+YmaieMZiDUMGmvUncGBsjiitmU/4sYRBX
         Qe4VRUfZlrstwMp8gIdmQTWH4+NabnTY/ae0slvJ2hXf2BEdiActcaxnmRfKAl+RhJPy
         HFPb7Z1HVLmVDmp8YPmeXz9dr7H9AZWLJeBcUmmqMzRKFVm59vPsqgkciZAEK/uiTlyZ
         T+dA==
X-Gm-Message-State: AOAM531Z3bSQ7OasVewoUzjK5fKQvE4uz1KXBX67cHKq2FeYozneAOF4
        0WeJ+R507hStGiIAsevfY60VzQ==
X-Google-Smtp-Source: ABdhPJzUBUXigmGKK00f+oy5m89boNXFlfZajOLZyHBl0MmqKyDlje2OUcveRrUqqaLEoBv/KmlXNQ==
X-Received: by 2002:a05:6870:1210:b0:d3:7b95:b1a2 with SMTP id 16-20020a056870121000b000d37b95b1a2mr345406oan.291.1645479621163;
        Mon, 21 Feb 2022 13:40:21 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id d2sm5418028ook.33.2022.02.21.13.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 13:40:20 -0800 (PST)
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5623938f-18f9-b3d9-22fe-61843c1a2397@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 14:40:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/22 1:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
