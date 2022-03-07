Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE54D0643
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 19:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiCGSUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 13:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbiCGSUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 13:20:53 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D8D80914;
        Mon,  7 Mar 2022 10:19:58 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s42so2204230pfg.0;
        Mon, 07 Mar 2022 10:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yakVhLqjFy3lUwFMd2yqBjeuHf9I8U2hlEbrIg5muCo=;
        b=ZMuN2j8tF+DTwZvzyNwsFCi+RFYVVEQxHp7NbvBtvb11JBODhK1YmO3dLCczyXEQB9
         GPG6qYFCQkAJ/+2Oo+OsWecmA451HVY+GfRFEK+2cHbU2CCs2WD8hoUWU22uOeAna5wk
         YeOH5hZWMg7gsfeKB26yZhv6uY0ocUpR2oTY24V/ytggknOmHiI+vQifSN7UVcULVMNm
         zolTlvGyjQREdyCu+4F2LU0O4GcAgrYK7LD3l/+wCF4y/yFSXk5M5WWsQDRV3718ZpiR
         MK3NZoaW4Hgy5cjSpda4xbidlj/WUxrK6oNksfjbnBHnqDSHHkZKS6R6ntriihe94ghx
         JxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yakVhLqjFy3lUwFMd2yqBjeuHf9I8U2hlEbrIg5muCo=;
        b=1EMsbakZgiyxioLauh0739uMgPX06WtTKjw4lv9LCrpgyeBEm84YT+1ChjYP7ak39D
         Ys/MMN5eWYDxTJ5A1CMDtXi6vnIxaybubTQCUvdt/CCaLCZTGXAviVmEvZZGEhoQocdM
         yLkQs6Uai5NwbXRFsN2C7xn/Iy2JtRFXXhPkMJI23JbzfHkMsuALY/LUWjvS5C42hzJR
         d8BbE//Sskqd3PDVeQOQydgHpam/ARmRIqnYYeCkJj402crV+EmFZJMLy9F4ZgsZbFmB
         3lNJCpHqUW3QTkf/g7klgpypwvLlzkSlVKJ4Rk+lDjC0rk5z9sZ7YwHuS2ikd39fLiKH
         YBrw==
X-Gm-Message-State: AOAM530djHSl35hil3j4mdSQONTmUTZxwlvfhUurfeUXgzRXEaqrUVFS
        3QbLQxshOSKo8VM15vSL4ShkrAkCbMY=
X-Google-Smtp-Source: ABdhPJy7ZKwMDGxwJp2ni4xmEUO/Sy7LbZKEH9wHfEEWmbnwsnv++PJMMzRv1Pesovq4pE2YVa+d3Q==
X-Received: by 2002:a05:6a00:984:b0:4e1:5e1b:1e9b with SMTP id u4-20020a056a00098400b004e15e1b1e9bmr13914417pfg.71.1646677197835;
        Mon, 07 Mar 2022 10:19:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090a560100b001bf72b5af97sm56904pjf.13.2022.03.07.10.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 10:19:57 -0800 (PST)
Subject: Re: [PATCH 4.9 00/32] 4.9.305-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091634.434478485@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1c025bdf-301f-630d-8a72-36656a29c407@gmail.com>
Date:   Mon, 7 Mar 2022 10:19:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/7/22 1:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.305 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.305-rc1.gz
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
