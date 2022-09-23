Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA05E72A0
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 06:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiIWEDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 00:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIWEDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 00:03:16 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78710D69EA;
        Thu, 22 Sep 2022 21:03:15 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id s14so16482831wro.0;
        Thu, 22 Sep 2022 21:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Alu1oPSkviG/26JvXlFCib3+u4Z5kJGm1g/0dV8GJi0=;
        b=OxtDylseu/0Nij2B1MOt8uQmqW+hW2mc8+tfA6/O36fsClQBjWxHjDZ3oYk1KzTcSa
         Rc/4j7plluIYp84wX36jWuppHWnnsIoTtA8BQEzPrxAu63pnPkYcgagF+BviTm7fZ/9P
         hdPpEUgewPAiVEzlxmCz4/HQy9/ug3rip/imIaA03YPLaaeguJQf65+d5/SuUmZUUSiy
         uwF9qepz+RnXl6GdfkAocf8DLsut/oSHVZgtt8nwx8NCnDRf1C0iZQfHD2YBA62G3vAN
         4yqp/FKb7o0DuehGS4CKaeihIiP9oYvLaTVJi3DJUOVOfJI4qRxE8wlw/z4ToDp/r0AZ
         l6pg==
X-Gm-Message-State: ACrzQf0KnDbO+HWQtz59VYph1fh9Twrv8ow/lrQ2EpakbjnbZXXSfT+2
        awhI5Ms4cVsfoOwYAmdhtCk=
X-Google-Smtp-Source: AMsMyM4jTZg07P/B6HdxxLQ9hLAdk8SxXdhiMuEnvVtNDCE4brlg7YPRbUhmlpSyS/4YWoGs2JvmNQ==
X-Received: by 2002:adf:f94b:0:b0:22a:4306:b773 with SMTP id q11-20020adff94b000000b0022a4306b773mr3719514wrr.307.1663905793884;
        Thu, 22 Sep 2022 21:03:13 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id a10-20020a05600c068a00b003b483000583sm1144346wmn.48.2022.09.22.21.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 21:03:13 -0700 (PDT)
Message-ID: <603643ee-1e46-2f06-3e2c-7580a6da8d5c@kernel.org>
Date:   Fri, 23 Sep 2022 06:03:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220921164741.757857192@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 09. 22, 18:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green. x86_64 runs fine.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

