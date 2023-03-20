Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1CE6C2067
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCTSyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCTSxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:53:33 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0E82A998;
        Mon, 20 Mar 2023 11:46:22 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id o44so5324169qvo.4;
        Mon, 20 Mar 2023 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679337980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+RShZ8p+aI8MWYtzRRoHovg73jJS5tT17zWwyUiRKBg=;
        b=AdYh29yhxX2LnJVV4iSRS2+f790HSBw8GTy7h32d+XHzqyIPbUg4NzySglRKPi5sK2
         UE8LTjkPiak7/FYlibjUZTNyRH9Cv0EB37awpbklMRZMaIzovuouRNR52E/ilX7b9Hjv
         6jTTFK3ZR8z6RbOeLhlvDiLxjFuACy0Elc0hhBGUUQc12au0i8RNpezgg8+wTBEJIElh
         KFDkFTJX9K4qtvH461wlQ+b++gmTsq/dUYXbPC9kHUdzPnvK2+vJa3/GLumVkT7xRdpq
         w4CkiNrFuwwMM5BohoWTGQJzRwI/GSw358ZUPuhvBv9T0Rkj1VX0ftV4Yyl86mFjdjsn
         u6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RShZ8p+aI8MWYtzRRoHovg73jJS5tT17zWwyUiRKBg=;
        b=1EB4EqUpckBn7FpKR5m9JfZetK25Ue1ZGYKu1bfHPllpg+IUJZRmQcS4xpQarTZ6EQ
         7GPT/reQxVPcGM/ucubKLHEsk4vsgVAU6BsqQhabu005F/w0nRGX+hpgErOR/qIy3QdI
         Zh/ajUNHwvijgD7S3rfOsTqKgwua9noCPFeUxWgU4jgUZHu4Ilot32E//b7DCUaw2zm+
         vY7uDSN26JfnMI0S5NbDKTXOqNN2etDzE50m18vEw8fv0HYThfW8l0+pdM02S8yesYIy
         2MtX8t62wZhYNUp/OC4BEsE3VEhf15gKSO010dehhYsk3uDXtuRmJdL8o/QycY1P+KuD
         b+Hg==
X-Gm-Message-State: AO0yUKXvW5hQTrNTKugWTAVdCx09euJ0wKMEvU4D5JlanN534e3kkfFR
        zf7BRJu4BhR4ktXF5+NkHao=
X-Google-Smtp-Source: AK7set86mJscNIKpO56iUVpE2Bev9qfcrYuodovS1xmS18TZGQeLF3JW7KI+30VqIjREV4VGXJQzuw==
X-Received: by 2002:ad4:5fce:0:b0:56b:377e:88a7 with SMTP id jq14-20020ad45fce000000b0056b377e88a7mr60390492qvb.21.1679337979776;
        Mon, 20 Mar 2023 11:46:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o10-20020a05620a0d4a00b0074281812276sm1355188qkl.97.2023.03.20.11.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 11:46:19 -0700 (PDT)
Message-ID: <4cadd4de-3f4b-50ed-5bc7-c0ecfdfed668@gmail.com>
Date:   Mon, 20 Mar 2023 11:46:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145430.861072439@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
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

On 3/20/23 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
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

