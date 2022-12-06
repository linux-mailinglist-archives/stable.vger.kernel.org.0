Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86B644E8C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 23:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiLFW2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 17:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLFW2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 17:28:31 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A018047311;
        Tue,  6 Dec 2022 14:28:30 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id k2so8730860qkk.7;
        Tue, 06 Dec 2022 14:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nc/HddoCOojBCoQWm1ZfH4dnQ1g2zzDiDNX4pItMA7M=;
        b=loP02QYRyaxjpU+3gPXXCePFeU5mlanOkmQkS84M81spAdi3gkyuj7yWbevTc59AAW
         P4Y5F49ENGVzq0MVf7lHQfNw7YKaV8TOmKU74NUTczGRrUZmr0SgpgecNZg1J4DHfIAv
         RnvNrxqlhCUO9TKY3281HguHqYqfTySeC2xHgUOolXpMeGddwW5auNaXwuP6gnRLS5A1
         KIbzzB9PLR6ARAbRy4asR0jjh/zQaXHPtaefSlm/N7VxiPfi1EFW3KZgcGPXc8QOCY+t
         76F1Rqx7tf/g63H8wyrYmozLW+3QBW37r4JU/p+WnomCkLOL0NdwnnNr2eNcUqeT469i
         vMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nc/HddoCOojBCoQWm1ZfH4dnQ1g2zzDiDNX4pItMA7M=;
        b=t+Moa4Cs0NhfPqc1X9upmIxRY3Y+K75bIAZ8Z3OfCte/5SHaQvqAplPDVJBVHbzh+y
         tQTo2c+F736jWgDAmwhYKD0kelcA6KSd4HfqD9Go4GADoNRcAf+x+zuOCXj1YY46XoRr
         +G9tvRgKdX8mZ9eF4Fl3hXqjwnmv2TB5bb++ciseML8A1fSBnDXvnRWuPGUalBgMn2i6
         zhfyFHIGIa0ITBsnLQ1Og0mI+5lJs8yXbohb/uLZT6SxH7iIO/gR4QTYWGrBCU9JY131
         7EKTh/hoaYSB2SjVHsGHh90Gy/QTHSx7zjjWrOjcA7EgTK6Cn2XUZSYAOLkD71t8+8zP
         JF5A==
X-Gm-Message-State: ANoB5pmyOoxiV0rArjB3QKINdtZxFT023zoKh78wXEIo+xJw0x3+QME5
        l9JKNdcZK9x0RJoiMO83bFQ=
X-Google-Smtp-Source: AA0mqf5XaXwQlVWUY9uQYY0na59WH9xLANhllfnkOu2zUb1SYr00pbyIbOXfX67FVNKMpKFgHsYXHQ==
X-Received: by 2002:ae9:d846:0:b0:6ec:5332:6ebd with SMTP id u67-20020ae9d846000000b006ec53326ebdmr79698102qkf.0.1670365709677;
        Tue, 06 Dec 2022 14:28:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g13-20020a05620a40cd00b006fc7c5d456asm12952654qko.136.2022.12.06.14.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:28:29 -0800 (PST)
Message-ID: <535422d3-732c-868a-b74a-dc7d806a4dde@gmail.com>
Date:   Tue, 6 Dec 2022 14:28:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206163445.868107856@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/6/2022 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
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

