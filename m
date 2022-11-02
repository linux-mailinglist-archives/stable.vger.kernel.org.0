Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49C616CB2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 19:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiKBSmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 14:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKBSmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 14:42:44 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB32A657E;
        Wed,  2 Nov 2022 11:42:43 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id k26so7862298qkg.2;
        Wed, 02 Nov 2022 11:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UnB/iiYCoj9JxhGUlWNmGFpgfzGIDKnr6BfjYADidfM=;
        b=mgZDbBqMlbMh24yUr68+4lerWRJfeVoKfI2iv82gSDPWwx/LVdWnJStgX/Ka/iotY2
         utIv4j7In63e5ngwgX3ylMqRBSG+ZlS2uXVPIOypL6hIdur3q9FL/OihkE+j6moRJWyp
         h3mLySPrO/cH24MG6TlkusGDAER5WGvxtRfeBHKum718fAxuwjJSx5lUPMbCWhV1yl/R
         sXf+BGqUaR7VNqRYG2vfmkcdEXg2fSDKOWx3l+BLeRhmJVTQqXsAY8M0uy2i3x0O0AsG
         /bnqaJsxFW2IluthjPeY+0Uc0EfJwLkKPRg4lC/evCE73VNe0Lmkl/JUkd0C4Y+PskGz
         CXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnB/iiYCoj9JxhGUlWNmGFpgfzGIDKnr6BfjYADidfM=;
        b=Zp8y5te4Df6eBvbEYvJPBALhI7tPfcfY6sUrDuGBpY3+HGu2xq5/89Ma9loMsbCjDU
         Ocvf2j/HnMStcabFFuowGqAGOXuf1qgPHQ1s2KyXqCtw3+85ui+7oFlT+zIvd1ZzGg7t
         prB9+gK6J4GsRs3sYNMWrkh0IAU8x92o8fnI3W2IQI1L1wRsvMlFiFLfesTJSaucCDdW
         70akcmsdxi/CC77aGVHEkRe8HD5abw9ZvdV5oM7QlorfHHA8xgXOahkWa3Gv21ZJY4Hb
         dYmgB2cfCqV+bYKeDceM8Jo3wMfXkjTxASQUhX4Qzf2xmwa1pl7StQhV36YgPM9+cnOw
         byoQ==
X-Gm-Message-State: ACrzQf3Nv0o0VTEuIgzOdHZ6YkfYAWFT43L7PT7A1KLwy7G0wUwz3V4A
        0/fs9+LnxFdVlkZrBTO1/ZQ=
X-Google-Smtp-Source: AMsMyM4yYZQoPSoricm6jRD97DoXPAV8DxOXgAY0RZ6i0gSA3F4L+U9CDZ/vSWBUORa0fdRnenQX6Q==
X-Received: by 2002:a37:5e41:0:b0:6ce:79e2:68af with SMTP id s62-20020a375e41000000b006ce79e268afmr18698594qkb.239.1667414562785;
        Wed, 02 Nov 2022 11:42:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w10-20020a05620a444a00b006cfc01b4461sm9189729qkp.118.2022.11.02.11.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:42:42 -0700 (PDT)
Message-ID: <2bf50933-802b-8340-4146-cc6c409d372c@gmail.com>
Date:   Wed, 2 Nov 2022 11:42:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022111.398283374@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
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

On 11/1/22 19:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
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

