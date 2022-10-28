Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08973611D14
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 00:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJ1WBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 18:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ1WBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 18:01:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA2B226E4A;
        Fri, 28 Oct 2022 15:01:29 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id z6so4358500qtv.5;
        Fri, 28 Oct 2022 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DJMZPHVTJnFr33kcUUeOBhHNHfNHRBfcq5bdTAYqszQ=;
        b=dSwF0cYukDaPvmbFrNBBPzHX8vR8DHxft5aDidoyQOCak61NDEn9WmEoeISvCDdbMJ
         A+zZzHBAko7IW+yqo97Wjlr5KDigVv9+OwX/q6QgsyCJwJRyG71Xux4MXpIfACYYDiGr
         OkFgYAeGOvg3EqxfE1CpDKCIKKGFv0ToX1Ccy0DTzPGp1qtL6zvjOM1hb2GqepLzxBmL
         D6k5jFHIOXhARxvSqwtSgpZb4Y4O5awIF18oVgAbmkF0hhlvcCVC5FonoChhYX2tJlLK
         VVpWI36knkRzxZhmUOXL25cKGqb+eCm/Xc1voUh8aOINa4LPGTRa6hWzzaAUc30+wN41
         xK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJMZPHVTJnFr33kcUUeOBhHNHfNHRBfcq5bdTAYqszQ=;
        b=GclXzHJ5zn2LY1iD2HX7FWJTB0M60tQC9bXkxCnJWDMsvbyBPHlV0To8tIQIFVlSjt
         O6nchfXLL//4Foxmm3Joe2oEYdfOl9NZc/hckzyw+baUS5OPYEZn1HMMAPK0nehtMOeM
         ektneYFjiJdJWxa+PLcj2BwL6JbmnwPEZxMridkJpWECcc4OzUHq/OkufeClOfVoPt0X
         sJuJi8546cwJxVUswJblMgH6d2F7N1rkl8rh15OjIlg2SSK212nXk9Yg1hf4k2gFD8K4
         NQn+juEACfZLK6oZpIcnjOc/mddFXtg97dXlpxAsOa+rjV0sX4mr9qF7DZImGpx9txBi
         w8CQ==
X-Gm-Message-State: ACrzQf1VAXIB++2v7smD6dCjYHjoEW3uWFaLxV/hgxjrIQE/6nB0Dimm
        9xVi2rp4MjbSGa6klFsW48TZxtPiWRA0VQ==
X-Google-Smtp-Source: AMsMyM5z7TnalClyLz/r/L2LC0f5nKSGHK9GEBBHZiIv+u4dnDnbwWnT4BJDbU8JnTxhyMxfHy5wag==
X-Received: by 2002:a05:622a:1710:b0:39a:cc1d:1daf with SMTP id h16-20020a05622a171000b0039acc1d1dafmr1517035qtk.394.1666994489025;
        Fri, 28 Oct 2022 15:01:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t11-20020a37ea0b000000b006cfaee39ccesm3676635qkj.114.2022.10.28.15.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 15:01:28 -0700 (PDT)
Message-ID: <b048a478-32a7-6d3f-a104-c7123c93826e@gmail.com>
Date:   Fri, 28 Oct 2022 15:01:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165057.208202132@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

