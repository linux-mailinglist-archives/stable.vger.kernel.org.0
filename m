Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0845FE30F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJMUFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 16:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJMUFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 16:05:03 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC311CB14;
        Thu, 13 Oct 2022 13:04:56 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id s3so2433293qtn.12;
        Thu, 13 Oct 2022 13:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+N09+g97ddbadojmbqmFpp9Vxo4lxqN+8OXKYgMC3o0=;
        b=LltYoJbsO5bzLe42vsxGa5lOL73xDPsn4gBK4q836y6qUekAz1Cl5khhgATcc23Zn/
         0gOSkOrVR0Zjqkp5d5pqsknkke2y/Gub3erfBj/ZrTu4wVk1pDrqRYsql7TGojeM4FWJ
         1qlCeQac+Z9ohWeO8yinXK6uy60cxX/lH2bl/CvWk1P31fU5yxtu1GvR/FP3PtVgUbMi
         wwSF7H+yP2OH7Oz1nmaC/JC9o4IBCuD/M6XOEuV3qyMPvpfsFpURD0jMBafMZW//bfPt
         7C7Ashy3PJS0rSsw1r4LfGZ2oQLU89qmExQijnYkhNYSvj3pV0ZIMHUKnccVKuJVS8iq
         uZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+N09+g97ddbadojmbqmFpp9Vxo4lxqN+8OXKYgMC3o0=;
        b=mWr+eH5KF79SXLkC3RuVqqFpcvTIdg2Vl40URhUvbUN3Qn7qc+5T401j4K59FnsXdb
         qzvb6SDV5zA/kyOMFWOc2amdJVGJW9ngda7SwbOioXdpchqW2Tt6hLxqojXKSJObZl7R
         2QJlbXnOhBV6MA9qXRJpd8oxVQt8U9X742+3DDIwEFw78Ankt1t4tJCusBDILD6UR/m5
         gQt7MZp6RuvULQeroOCDzAgzAMOVuIkprYRdI6weuEldtk5T8NTfL2HjU4PVR6bM5bwS
         +oInRWzaVr3+5bJu73O4NasjHiApMsVaINfC1ixsTXLtdtnrinmyL994ZRUU+sIa/4uJ
         MGWQ==
X-Gm-Message-State: ACrzQf0+Vs8k84PoVxuenP3K+z/HUizeZ+/APvq/eub6BuvgAN00lmd6
        VVfLudKFXpTK3ntMwt+toTg=
X-Google-Smtp-Source: AMsMyM6WtfN8J5MSZFXrDoWxi6r0fwjvoF988Ki5mFwFI9xh61AQY507D3cgiGU4OjyKEyPbJs6xTg==
X-Received: by 2002:ac8:5f0f:0:b0:394:4be9:54b2 with SMTP id x15-20020ac85f0f000000b003944be954b2mr1473978qta.238.1665691495975;
        Thu, 13 Oct 2022 13:04:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r9-20020a05620a298900b006b953a7929csm639244qkp.73.2022.10.13.13.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 13:04:55 -0700 (PDT)
Message-ID: <c8d1afca-899c-3af4-d4d3-a474949be54c@gmail.com>
Date:   Thu, 13 Oct 2022 13:04:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221013175144.245431424@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
