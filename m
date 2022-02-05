Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083B04AA72F
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 07:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiBEGul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 01:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiBEGuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 01:50:40 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3178EC061346;
        Fri,  4 Feb 2022 22:50:40 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id u77so734433uau.6;
        Fri, 04 Feb 2022 22:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Px8MUw3Pm0iazIIvlzDypvxpZRE6aA1tFU73q77K2yo=;
        b=L2XONBwUZbEuYRWJuAiBVC+yxrgMvHUqZiume/SLPIBi+1vcrIyC/GI4VSDN0pePm9
         GOBC9eXUtw2l7afzdj2NJX3lR2picu+C+tgEkdrslgbDFhEUrCLtMAmTLasu7U9QHQkE
         z/Q8QdxO4b1a8t0KYg5N+EBkwC4tPvyqm7yAy7yqbkJj7gFRbze2S6B2KDx8+DLghrDB
         34yV10qpKxiZfyn/88t7xuHddOVRBu3xjImlv+qbe1X1v3W9Rh2S8BNaZTM/IrZ9EoES
         XNgaL0j3HkA/wTItaDeFphe412aFMgj2jobvOHIRSZmUoW/tiDWwsENrp81Zd/8OLmH8
         I5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Px8MUw3Pm0iazIIvlzDypvxpZRE6aA1tFU73q77K2yo=;
        b=E4/buhMEekIh9GiKI8prKcDBgIWrqvkgmGv3Q5ReuK2aw3UoBxonTlfd/02yrEh12V
         PFf9vLRTfkG5hgrdhChmIVeKDUhIO1AIfsMybg8kQqGZ5SQWflPQxZ+nl0qcaGsUzPNh
         o23FoS01lOjfwDYqum4bk1ddWRwJ+Zp0Y9U4zsv5tNzI22JAsiKW+8oxM1gOq9Y2A/AP
         NT5GyhroFZWJ/Ob9zUB8uN8SiqXJ+FNYjO+Qo1cB+lckT8iT7uYkr8tDO2RZN6ReDr5n
         qyzPZsrjYACbIKLn8/2noYdggMCd/Ws8TF9AeDzL5pJT199SE8iKIK8y+igJCnwsAwr+
         KTOQ==
X-Gm-Message-State: AOAM533i5sFu0UUli3Y/jaFJAdsIWSb4Nbpi5osVqthjUuKJP1vn8XX2
        AWTXkhs8xzENUlVASVdgx2xUlGuhtJ4UgmzZ
X-Google-Smtp-Source: ABdhPJzyzUmVV4wZFvHPxSAgCOoSORNSwX4DQG28F4ZF1BOHHWqnvFnPP9n4EiVbAUHfdlxCmOefwQ==
X-Received: by 2002:a05:6102:a88:: with SMTP id n8mr2137594vsg.44.1644043839111;
        Fri, 04 Feb 2022 22:50:39 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id e17sm1398662vsl.21.2022.02.04.22.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 22:50:38 -0800 (PST)
Message-ID: <ce6e39e0-7573-ee67-2e94-7a434d8352f5@gmail.com>
Date:   Fri, 4 Feb 2022 22:50:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220204091917.166033635@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 2/4/22 01:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build, dmesg, desktop use and s0ix suspend all look good on x86_64/Cezanne (ASUS GA503QR.)

Tested-by: Scott Bruce <smbruce@gmail.com>
