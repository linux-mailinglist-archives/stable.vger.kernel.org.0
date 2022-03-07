Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D533D4D0C47
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbiCGXub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344048AbiCGXuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:50:05 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EA7237DA
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:49:06 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h7so4637029ile.1
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IFxHMZW1jcxmOestSfe24O+LRM4LBRo6NYcNIr8xI6I=;
        b=T8BeFmXsQnBsuHwFhdAjptUed9xElYgnvA34tLwDz4+s/Ek5Ank54vPC0wGy7tJ9wL
         DmyJkaA/1hZWU3Bsjc0DaA5e40I4RwyMTENWt8rkh/V16Qz9AWKcBkmmcAbcPl3k8dW7
         x0lKeteV6EP0vdkx0V1MeFTU0w1vXOl28Q59g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFxHMZW1jcxmOestSfe24O+LRM4LBRo6NYcNIr8xI6I=;
        b=EatL0p2Hv8stBQxhbke+9SVeVv0A4Fpbc4ODeAC5ljCfM9mFGuoKiuHQFpkLVoPnAJ
         l1fICBP5ZJqKgVlQYKzdfntkhtlqEDAMsKKJV95/9s3/bvJxWJiaPbfm7JfBbVlFv2lA
         Mirk0zxF8h0Rmb6FxeZ9xrl9Abn14aL5zMPrmZvOWfuPaBQNmbfR+w1d+/NmbKO0+bAm
         sn5VwSrZSxubz0fLynIUhhp1fGWBnvBp6CNqWaJfPb1NM595WEPlkSwfy8jRBsMvXwM/
         P/hgKa/8MvdbzwVAllQRRp3apRvP6wef9XzHush/SMHb2alK1F/7IEoo5WoM0ce99x9R
         BGsg==
X-Gm-Message-State: AOAM532L29JZMlWe7kmvZf5ZZUy3fhQohM/JZKzRUMDFic5tNnVl6es7
        TLic4JkoVb9CKunVKFY/4YT/Rw==
X-Google-Smtp-Source: ABdhPJzSn+MwiLZZoa2Y0FhJr+O7pHQk2tkj+g1u8oi4QzEtpGQF6aaNtjCfmQ6bNCrQ699cj1K8TQ==
X-Received: by 2002:a05:6e02:1285:b0:2c6:123f:48b8 with SMTP id y5-20020a056e02128500b002c6123f48b8mr12642122ilq.250.1646696945391;
        Mon, 07 Mar 2022 15:49:05 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id m9-20020a924a09000000b002c623fd69b1sm5532395ilf.75.2022.03.07.15.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 15:49:05 -0800 (PST)
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220307162207.188028559@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <97250f69-cde0-37c1-09d0-845047704bdc@linuxfoundation.org>
Date:   Mon, 7 Mar 2022 16:49:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 9:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
