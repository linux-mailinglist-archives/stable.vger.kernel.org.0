Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C275A7604
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 07:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiHaFyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 01:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHaFx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 01:53:59 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085EB72EDB;
        Tue, 30 Aug 2022 22:53:59 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id u9so26279751ejy.5;
        Tue, 30 Aug 2022 22:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RfU7lsDmmfAjFJAeAr5W5jIPgnbHnTsbqehO/GDS314=;
        b=LYtSUCfIKVE7hUxbrsENPiMOAxTVoEvlHBUglhPs7Zmd0M9LMzU78oPIt+lfEc7VAh
         ewmmwXT7XxenmAge2hOtitiDSgaXZ66TqiCg0NsgrSoEAbULumsRVVbytxjnXmTMWsIN
         sVZIv5ZxeTDK5/OhxYssOMzsNhN3ERdiYPWXUmX/xTBGs8nm7b/N7K7313+qM3ZFqfoD
         1CAMShQfP/rQ1rNWcFz+8aMXm5ks5RPht9YXD+8VPDNUt7z0C+9oIUSD85KX8GqpddtM
         vXLAv7oE6varJJU4t48BRzIHQW8dTzQ87HoIvEzdwokQ4sxBzQFw2qYhi9ggu323qJAh
         3W7g==
X-Gm-Message-State: ACgBeo1frpn20FCSOLI/YSFsmkhxaA2AuH7u6E/0p8ESpEmxaK0JRme4
        ITCsKbBlCszdT9FSXbJP3gY=
X-Google-Smtp-Source: AA6agR7fF/uAJxU45HbH0NEMNHIEwlmac3AtGBLOZLw1iBXTgBUNxv9F2cxNQOOEQdv47A5gxy9o+w==
X-Received: by 2002:a17:907:6d11:b0:730:a382:d5ba with SMTP id sa17-20020a1709076d1100b00730a382d5bamr19002264ejc.371.1661925237530;
        Tue, 30 Aug 2022 22:53:57 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id dk1-20020a0564021d8100b0043bea0a48d0sm8436599edb.22.2022.08.30.22.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 22:53:57 -0700 (PDT)
Message-ID: <3537055d-7341-fe58-938f-06975c515cee@kernel.org>
Date:   Wed, 31 Aug 2022 07:53:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220829105808.828227973@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29. 08. 22, 12:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

