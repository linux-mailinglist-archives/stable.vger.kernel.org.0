Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D2E6DFDEB
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 20:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLStS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 14:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDLStR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 14:49:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF734EEC;
        Wed, 12 Apr 2023 11:49:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q2so17246831pll.7;
        Wed, 12 Apr 2023 11:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681325354; x=1683917354;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H05k7Cmf7Hi9K1W5Jq5qb2sK9hV84Ca4AOxKRM48YfM=;
        b=HMMUFCvzNjgopc5Thi5lWaxvcqQqa0y+zOdusyhfF6LhmhycxBRa4WffMalNUKl6nr
         S8+V4hy34z8w8YRquFliv2EUopBD2Vi7LdaNMiLtbKlvv+dF30vG4W3Axx/f+h74ow5H
         yar4MBE/aG+ZlOjMxucU3IUBfmsD8xWM2d6eIcECY+Hd82lJ8oClPK601GAjaZjsN5A5
         R2q7JCP35OX8zO11xeIg7kOix1IkOsHI+xW0+WYKjMGwgeHupLJwU12tny1LgP+uq/y4
         Q5XdJyqImEhV4H9DggnyoCrO8lT8+kttl3if0j9tEr+yo+St3BrGVgeMW59YAXPmoP8d
         wgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681325354; x=1683917354;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H05k7Cmf7Hi9K1W5Jq5qb2sK9hV84Ca4AOxKRM48YfM=;
        b=kfKjyCNIZdTYu20aWdRyl1UPSPRbx2SKPqy/OJNkpbka2/n2/tQMSfNn33TkZM6nHs
         3sitnzOHROk/C+DeJalTKDaqYquxKQSRA3G/Yb3FDV3fRtJXm7QLboBrT/F0EWx4NtxL
         uvvdWUtRa/p0eAoCXgQfdENyMzp6bMjWqv18+DhYb2ZmseaxvA92m1/dpdVf/CflKEml
         KeKHC9PJP83yzEElLSJL0zJYkKOiM5+wEx+6KMy6/dk7B+oZCi2J2IGFAnyOTZ69C+cF
         DhI3VC8HcfpYW2BQL6RLJ/SbiyNWPKsti+ZEc+QtdoY56a1a71bDRKrTUTxd4P9ihKSg
         c2lQ==
X-Gm-Message-State: AAQBX9dHJSCNjTNTmHQiVFzN4IvT092pE45lVXQ9fmfczKXEWLnHuWJY
        +cuYE5Zpxd0+f4em3qnuLJc=
X-Google-Smtp-Source: AKy350ZadzBFUD+fa2eWacS3/dkJ9b4jQHhviCVAXcanHlRAilaRUWKYM0yIkKcFtqMUek8Ppt8y8g==
X-Received: by 2002:a05:6a20:8ca7:b0:e7:33df:44f1 with SMTP id k39-20020a056a208ca700b000e733df44f1mr3238521pzh.57.1681325354577;
        Wed, 12 Apr 2023 11:49:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d21-20020aa78155000000b0062e0010c6c1sm11940373pfn.164.2023.04.12.11.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 11:49:14 -0700 (PDT)
Message-ID: <c09adf8e-0760-84b9-8e78-c7223e48a542@gmail.com>
Date:   Wed, 12 Apr 2023 11:49:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082838.125271466@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 01:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

