Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE657374A
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiGMNWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiGMNWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:22:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B10BC99;
        Wed, 13 Jul 2022 06:22:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso3608102pjh.1;
        Wed, 13 Jul 2022 06:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WgP6JmhlTBXnp8LdpSNo2p7kSUJQrR/c1T7k5abOpok=;
        b=cv/VVc/nhGsW467n2i7tEYLLMLnw0GKWc51ng3fVDmSYOXOL0eeNCDU0vSXK0CeFbt
         JeIIVAMVDEXjUbmfsRYETWI2GWTrgeOJFEsCqWjtkRCh8AgXL8Cig6YCZXCsjEc0MUWm
         C3dGc08NJTdZorqfav6oKS1w5pgfUCtDiGguO7c/0VYMpLi1q+gE8DfOFdSsM0wwe7bq
         pIRaRIW9LHAhGXd0iOg6WXUWkgf2gPaFKeoEPNguLLeOryvaFyP00f6JZdckf3p0Xiv4
         rblHmAUagjz/nteegLeLpG7gVuPtQaMVvfm0jT5t8MWBuJtr924iLJCxT1BYY+5o+Xwa
         yZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WgP6JmhlTBXnp8LdpSNo2p7kSUJQrR/c1T7k5abOpok=;
        b=TWTmyG3jcP4LZRM+s/S9Sm5br2OcSfsFJ2aJWAprgeAdgEMoLE2uiEnhT3Vhc5YFOq
         Jhq3QXAXtTUO9bzSbOOxCkMiCFd8w0b1w5Vvux6Reh+yY60j7vsGtTb0ftpVH8zzy0wj
         vxLh82coAlujYx86zCvhEoRIl8xfea8EHJNqG80r/jWka70b/Q49Td3fnDqE6jz88k2H
         6d1ksDA8bqxOeCqXZSEkp0aXzE8QsCck3m2IIUwnPhqf1m2cB9q1aYqZNQyQc5YoYHJK
         dMdKu/sJhzbyjOZWLOKLLJ1poEwhSKVtfU0yzYHfmXyw1OuaWMpBAyx0GHO7edBjlx2a
         9GQg==
X-Gm-Message-State: AJIora/xndcPSkxChAlK2gWzOZ6w31qNY9aci5zqQJcjhLzcomRX26uZ
        QbOhF14vTMRtuFlqyaG0DO8=
X-Google-Smtp-Source: AGRyM1uOfEvUGqfxJcc+znkL4Hv/2sWIBn4ILjV509l1BztgppSk/1dlhERRpwdIvbLPRzSRGZHHYQ==
X-Received: by 2002:a17:90b:268f:b0:1ef:ba7e:3fe4 with SMTP id pl15-20020a17090b268f00b001efba7e3fe4mr3912130pjb.23.1657718566895;
        Wed, 13 Jul 2022 06:22:46 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t11-20020a62d14b000000b0050dc762819bsm8746830pfl.117.2022.07.13.06.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 06:22:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8ffe278b-bb23-772d-e4a1-47f172580818@roeck-us.net>
Date:   Wed, 13 Jul 2022 06:22:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220713094820.698453505@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/13/22 06:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.
> 

I see this in all branches, including mainline.

Building um:defconfig ... failed
--------------
Error log:
/opt/kernel/gcc-11.3.0-2.38-nolibc/x86_64-linux/bin/../lib/gcc/x86_64-linux/11.3.0/../../../../x86_64-linux/bin/ld: arch/x86/um/../kernel/module.o: in function `module_finalize':
arch/x86/um/../kernel/module.c:292: undefined reference to `apply_returns'

Guenter
