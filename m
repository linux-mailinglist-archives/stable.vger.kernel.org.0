Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEFB505EE4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 22:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiDRUbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 16:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiDRUbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 16:31:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8647230546;
        Mon, 18 Apr 2022 13:29:15 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u2so20888028pgq.10;
        Mon, 18 Apr 2022 13:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=k/abdeQtikDllXMZliiNaxu3T30egp/N7n/c1q2jeho=;
        b=bu4kqdq3VHWRMLr7I/h/TZC4Yw19uxTafRT3cIHkpRFm5D9FAbtj6y0e9xln3kd8n8
         RgMxsIyszGG/zJgvPinizHcA6tN/KB0PAIy0zdEM6gLDsHPiCdq6bzKBZTsKMsc/r0gL
         J0b7ShPeq+4g+uBXqaRy8uswAFx4uWfbXFMpdQwJBlKEtEfKW5KYVTrhZuUw12wbRbVv
         OAa+xVOYqZvoncTyLUsFxR05IbR/n2vz9HNBy/gU+URyT+4Fk7qpLb/+e8aJ0s/R3e8M
         2OmFresFFfrMRvMZUwbnFuNFPlBKBDA6JiDdvLCHr1KzrUTUUewM1kM91PHft6VQZ/fr
         AbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k/abdeQtikDllXMZliiNaxu3T30egp/N7n/c1q2jeho=;
        b=4olzw5/R9FpdzuTzt7cTSyes38g4RrSrRNarlday9c8Nf5/XrbUmJZBhhggtKQz0b9
         IrChTSpgkZXIJscx4EIzqPIiASFTqvDhTUonJlfcQRbNLh7Rkyw3OEHkhXJTI96+torj
         DSHfT/6+i7l0mqqUEMkO1IZStTBZQYaK4VpnNv2f4rqkz61nsNZ9xLP1KchmhFPnLnv/
         9vtDko2rY4dztG33z/wBkickdNNT7C0rJBTKFZ/ZXGRni1mod7TEXULbGOAoGYYycu6f
         bJW8a0rdywQkS0Ddn4kiWFmyICyennR0Psf8YUgVWfy9ScPtATAqj8Lbn55tM3k+HyT4
         emIA==
X-Gm-Message-State: AOAM5331RRVYLp60D1iMWC3YZPxCaxPqrAFicd+//1B7gUK24SF0Bou9
        iDie8iM80N5l8n7jGnZjOYs=
X-Google-Smtp-Source: ABdhPJxDpiiWgelGw7kG+xTCy5WR0yNUZ5uRXVaiikQO+7ICh5SveRXc4grac7bztBqnWzyrzhKA+A==
X-Received: by 2002:a62:17cf:0:b0:50a:4601:36fe with SMTP id 198-20020a6217cf000000b0050a460136femr14196270pfx.4.1650313755010;
        Mon, 18 Apr 2022 13:29:15 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090a7c0800b001cb63a477eesm13989930pjf.12.2022.04.18.13.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 13:29:14 -0700 (PDT)
Message-ID: <f4aea108-b50a-aca2-f118-6f809303d2a0@gmail.com>
Date:   Mon, 18 Apr 2022 13:29:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220418121203.462784814@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2022 5:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
