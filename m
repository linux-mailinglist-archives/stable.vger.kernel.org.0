Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720CB6DFD35
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDLSGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 14:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLSGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 14:06:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81864E41;
        Wed, 12 Apr 2023 11:06:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j8so10816926pjy.4;
        Wed, 12 Apr 2023 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681322792; x=1683914792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gm3/ETzCMqkiwfcEp3WUrrhX4jWWK8xsRn2G76zJNaM=;
        b=oLCDuBQE/kD8GVPu/3oo4c19DM3uXs75rXuoa00FgdX2qMW8b9YB837IeJvenTFZrw
         Uq5JFjYMaWTURbayIIN5NWTNmkIzQHkIGBHjrArhXVhRk2WIVej1yXuqd8wkfBUbKIwi
         mMQEzgqQUL44xM+Q+ammgqk/T6St/pvapC40MxLdqKFoLE1TaEfyQfzmQLZ7uT1FuJTw
         Dreo9a19jXKNC1v2qbSV5y+Kd5i8opXOmvWnxkxI4Ja9ZMbHiEIkBU35yanGAdpif7r6
         PfZGoa2JRhyVQh0OvwGaBhEoQ1AWrfD0jDMYjyGrLz/y/I4wVNUOb8s1yMlwYZMUuE7J
         gDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681322792; x=1683914792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gm3/ETzCMqkiwfcEp3WUrrhX4jWWK8xsRn2G76zJNaM=;
        b=ScRbJr9EILMr1CcmxRY/HKUUgQ9qzAOqVrWq3vIJfF8lC7pAyTAvpsbYrl9d2twuZr
         NBdocjW1YGBk0VM81HPgxgaYECukYwTlgidmOl9qJgncWlGToGawaRt6BiXpBDCFw92o
         WiX77/MeJWF70nI+roerUDU80SSm+uuYPiPPBJmCu2++0WeuwWvjuyRR7VP8gLqQ7ZNK
         3W4JHcFm2YOn3a45a8ogtGt4EwQvlsLCLkzlSHIjjMFsKXfkccTNwA2zqV8bmFcF+rGn
         dvtdHr5tsUakX1DCmGmfb+vY/bait1bg+puZiEd/RLszwsk/FogPI1dO7SaMdgSg9Dug
         gLFA==
X-Gm-Message-State: AAQBX9dGTczzDHAdgXgrq4xFmGLYp9iTINmpDw0RqMtPhqFUXAELwegr
        t5rNZ1wZ/tMaezN0po/qQwc=
X-Google-Smtp-Source: AKy350b7qj9vz4EK69M2mBRkYZT9b9Q/qehdpqTVJFlkw07wOdwU0ujbLyHJtrnckc+0J36lT2UKVQ==
X-Received: by 2002:a17:90b:4f4a:b0:23a:6be8:9446 with SMTP id pj10-20020a17090b4f4a00b0023a6be89446mr21903465pjb.48.1681322791977;
        Wed, 12 Apr 2023 11:06:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t21-20020a17090aae1500b00246952877d8sm1771754pjq.34.2023.04.12.11.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 11:06:31 -0700 (PDT)
Message-ID: <461b00bb-4f1d-d457-72aa-5ff2dfe828f6@gmail.com>
Date:   Wed, 12 Apr 2023 11:06:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082836.695875037@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

