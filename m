Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED7D5FA7B5
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 00:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJJWfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 18:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiJJWfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 18:35:44 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD3014007;
        Mon, 10 Oct 2022 15:35:38 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id y1so7513628qky.12;
        Mon, 10 Oct 2022 15:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lm1EuqHI/W0amZ0o6PgC0dOXiiWcgPqjfHx4X2Ub+EA=;
        b=JWOMCYilMPzpplWJiXbI0v+9rD6Iv9Qr7laNFwtGWkNxDyltWCEEoFfBmHNjwqgLki
         qXnnjkV6XGSU1QoTLgu84WYJLL7Hk/gset/oINCqFoVKuVD5SSwBwn/NioGXslcv4RJ8
         NgKBMZfe+cj8wtUEP1Szo2JNILefn7uRnvfasBfZm1i5JzvDJPxTdK9codcpVZskgzCu
         Xtsas4/RezH14JFXmyxaa2j0/euY9d3qfh+jxEiEoTJOn9DzHXaKsN1O74vMhxoj/paE
         QJmgB76ODJsuM/8Qw5lCGbuohhkGot1GG1PKpbDLOVJopXPAVAip+hmXwpowIkAaOepq
         2ZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lm1EuqHI/W0amZ0o6PgC0dOXiiWcgPqjfHx4X2Ub+EA=;
        b=moPMirMIqoYOu9JzjRWvAeI/gXcGWk4GXV2MvOXSTU+98ueejiA+joi5CboIKyA0Gw
         zgIvr31sKQz/UNDHRBa1y1NoA0Asz4dddhmmZTb6P7ResoNnYRhice+1NaprcTHLH28a
         m3fbB2pw6vEG0KVQk4xWCBatyyd7kUJlj1X95HjwG0SjeJe8K3t8OyUmCNZYJYhHkLC3
         Pxnywiy5Jgofv+cW/v613s1P17ABM66/3ck0V7cWW4gUSz5G59/t9cDq80xon69HtCmz
         QWCuZu+WsqdwbIDbm76TRdPlyab4kDmBwbhBQJWR+dlPpagYanXqkRYQhAQJy62HVeWy
         VUuA==
X-Gm-Message-State: ACrzQf0BUN/aHksKxZvlZy96925SmaHMbI3t2uV/LDqNJ/MIr/0sddnK
        kFzU2TXWX3GAXGk8tPlUlqE=
X-Google-Smtp-Source: AMsMyM4C8Gn0RQ/vuWsu6S6P4u5rCxi0zGAAUpeDK4DkLjK/aCIJUqKnduGx/x+GQlICVfg6sTnCYw==
X-Received: by 2002:a05:620a:440a:b0:6ec:d931:652d with SMTP id v10-20020a05620a440a00b006ecd931652dmr4886190qkp.344.1665441337306;
        Mon, 10 Oct 2022 15:35:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u21-20020ac87515000000b00391d15f13f9sm9257789qtq.11.2022.10.10.15.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 15:35:36 -0700 (PDT)
Message-ID: <81411582-d114-c931-12ec-f1c80ee6d4e7@gmail.com>
Date:   Mon, 10 Oct 2022 15:35:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010191212.200768859@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 12:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
