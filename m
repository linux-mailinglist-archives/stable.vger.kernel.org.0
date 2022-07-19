Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC057A8C1
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 23:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbiGSVFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 17:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiGSVFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 17:05:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CAB2E6BF;
        Tue, 19 Jul 2022 14:05:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b9so14727417pfp.10;
        Tue, 19 Jul 2022 14:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2ZrOgFASjagYZ4odYgHkyul4cvC1DeA9O9rfOmRB2F0=;
        b=h0uCCzo7buj+6Z9GyuEKnHMnOIBIaQxxdqKvgGdPiUbeFg1l/OOn/URJELDGJdkeEC
         pNfqOWZYSL57CNe3UFi+SfR7au1UyDGURozuriur6ZLHR/kzZ95TTVVBbtlQZhbS3E+e
         y/uHW/l8t1BmtkhZM7rX6e70Xp4tgBVG85VXdJ88+QGhhgiGAiKF1FqTCP75ArZgJJxC
         j0n3VLUJND1wLKQAInGfy6Uu+fvxhBfYZv3igTDjiXALYMwjUAfqJ/yeOj/f17r6zf+O
         4tv+8U9pHZNrBbfhcD9g8va0QrdRn1zF/JO4c5YsInwUoZk4FYm65DfuHwX6YzKJXYu3
         sZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ZrOgFASjagYZ4odYgHkyul4cvC1DeA9O9rfOmRB2F0=;
        b=bWSyYwTqV8cpH5sloA7NTxPzk3vO7xF9Xez2HSb9X1XdlvHdADUxfNhWwBwwhOp2vW
         w81AM5CMccqmExTY3Ndc0cCfQEj00zY5kVTeDFLE32TUIcggGTT4ZOJh9b3pSqLwGBgu
         l+2mNZKS1HV248Lj0CNoidSGdAuAm11GLmm2o17YEEFlkCZbBnxU0W2mnvqdQCpQzViI
         f7yUwqEF1iKAa6QcjhApdz69szRlLw3D0Ow0IdAcWnjKFoJcSPDAl60Q4VPYRix9AIP9
         xlgu3MOqRfHqJQYSVqiOaS7QyfheaIAPdddWTziqzIqnhqekE212VWwmGtCjBa+qnWEd
         yEsA==
X-Gm-Message-State: AJIora8WfwESs4QCl81rfh7ffAV3mjckqKDPIOoXBC4QrbRpkjJtnstF
        ZiQmk1iuvhilemo7vchBk7M=
X-Google-Smtp-Source: AGRyM1vLzxBtbNnhjaIMiRwxnDXP4sxra5Wn8IejeBFZ8uQ62Zshbv72qKLm14UkQZjNbN7nheeD0Q==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr35600417pfm.37.1658264730955;
        Tue, 19 Jul 2022 14:05:30 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902f64500b0016a3248376esm12056059plg.181.2022.07.19.14.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 14:05:30 -0700 (PDT)
Message-ID: <bb0d87a4-5cff-2b30-db5c-1e5c4fd192f1@gmail.com>
Date:   Tue, 19 Jul 2022 14:05:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220719114714.247441733@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
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



On 7/19/2022 4:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and built tested 
with BMIPS_GENERIC (bmips_stb_defconfig):

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
