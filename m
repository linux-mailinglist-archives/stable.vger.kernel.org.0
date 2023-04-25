Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC96EE913
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbjDYUaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 16:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjDYUaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 16:30:23 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE07D333;
        Tue, 25 Apr 2023 13:30:19 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3f0596e2c00so14104121cf.3;
        Tue, 25 Apr 2023 13:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682454618; x=1685046618;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RXQsS7DdiSemVpvOd/+IAfNyN39Y2Q7DpC+A5PL+xNA=;
        b=LvmYZzqI9WmhHAK/C0BbetjeKBmdMLaYDLV99Seog7ajhUKTDkWqE6PvrZdOvBvCXN
         oC7VTli22EVS1ikyQt0522xLSWD12OSwHiooP9tL3rg71Aj3Xxon4nzhsTbLqsx5PO9r
         VMgXUQ/GJPYsCCzsO05W/ZKXce93EqsMdOIhlt9B4XkVKAq10tRVyK3T6sP5cqkEPmtt
         lja6E0MQDX094Fla9w69pA169SDGqRHsdf0Quxam31sFtdWwt6eXE9cowOcBHoN/l4Vz
         HpslOs9fc+DSO8BONaDjoqbaAWwq65jBknxlbQbQZeQJ/Xvy2OqnPz+XDhgc9KGpaOnv
         3qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682454618; x=1685046618;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXQsS7DdiSemVpvOd/+IAfNyN39Y2Q7DpC+A5PL+xNA=;
        b=IBLB8AkjL4kbgKdmyWdOvKeo89LJF7ZijuDnYR0oP5ALAEsNQgWfwT0n/FUSKvkpbr
         Hy4tJt4bbhYFONGqBSF66x97t5MFWYNLQqyrey1giOrXxpQcpizD/tP9HFik7K17p9Yu
         lUb3hUDVqJ6d9FXETjSSYrG2iAwgCQiVQTv1hqxYjsxssC/C1hDFwHHP5bsFebPIADAF
         QGJGkkvdPtV3qmFvzDaond2LvMMlZLZZ9EwqumkmUONmHHq2iojFZiEIWL0jLb+jkx6u
         4p4CvK1Vj9zPmdXY0G6bKQmmsIk4aVoPkC+LoDRpInN7M1+WRrlPjB70r+SxhWSubeW1
         Y4UQ==
X-Gm-Message-State: AAQBX9egWEUBcsTMJJ6dWJDMaNW6PMfB2noeRQtamnm/3TRtz4/VdJDy
        O5ljlxBjhdic7EZyUMSWsdA6u+1/oC6HfA==
X-Google-Smtp-Source: AKy350ZE6zOs2gNMe9NE/LoM0KeCVhu1NrakcyKqVddHUGUANhpxJa8T2n3LZWhvQHdJ/Oj5Xgmi6w==
X-Received: by 2002:a05:622a:101:b0:3e4:e8be:c3a4 with SMTP id u1-20020a05622a010100b003e4e8bec3a4mr30445538qtw.56.1682454618432;
        Tue, 25 Apr 2023 13:30:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b2-20020ac812c2000000b003e8160cf93asm4716700qtj.80.2023.04.25.13.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 13:30:17 -0700 (PDT)
Message-ID: <37c7ce6e-4e01-9c5c-1c2f-ac55d06f0ec2@gmail.com>
Date:   Tue, 25 Apr 2023 13:30:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131129.040707961@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/2023 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

