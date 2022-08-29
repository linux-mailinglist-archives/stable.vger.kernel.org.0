Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED22B5A52FC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiH2RUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiH2RT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:19:59 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BADF51;
        Mon, 29 Aug 2022 10:19:56 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id h21so6665858qta.3;
        Mon, 29 Aug 2022 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WVwojOfpbU3ZWFPUDfRDkq9+aL+8zLwFug1ZZrW5dX0=;
        b=T8xFkLIDCeUPGDB+9bZRM3uJWq5YWPDImyfUhgmiUdsFSRtIIi/jz4INGslHyr2SHZ
         T+/7NVW1FjnheAa/o+zYBnaIeAZgZJy2QxvNDNnb+dmncTcr87F8MF3mlIqd4rP3PGP8
         J9LdQMNcPW+TasKZdGUA95cUP0Q+fqzjaf2sZw9Bz7RbI5X4stasGwBoqsZSfSZEZNHv
         JP56OFXg1X/wUtASYSgtF8bk8xSc6fT8oPW3uV+4sNbjg63lrU1ZQe0/Ed8MKM6jPMBT
         ZXw+ZWIxCs2FpaDBXzzg7B3SZIjqHXXm970eyXNYBFXlRedkceue3dqunzuxFMJqHeA5
         yFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WVwojOfpbU3ZWFPUDfRDkq9+aL+8zLwFug1ZZrW5dX0=;
        b=SDAlNx7ZJE1sUsqYS2p2zPSrmZ3I2d2NiXTPOwoEIP5P2Pg97NyvvQf2ydP0JSofGo
         O8AwtYv2cGqop6iEn0+xJS3Hva17HGIEgV2QtVMAfdtMfbhICv82+hP9ey/pCj7wyflQ
         rtYm6F6JYfYrAtvJ0PWFHI9T4Vv27fLcil7eqx5ZG6R4eoJn3Z6joj4+a6zWaAAzgUMy
         oPKJ1i7aQ/1KJZSo8A4+wsnjLZnDgfOWBh4k40owllEZl6BEO5ieGrFDXohmUhSxDC4p
         8dVBNYwYRJefulkzV/EFxQP+naqbJf0jkXMOP5rrMwTxWqG3FmOXnnWLQk5XD4w8N1tH
         jTPQ==
X-Gm-Message-State: ACgBeo2hMUvPxaTUwT5p/aa2uHEjKwhCM/0aj+i+2S5qZcmceLy/TcUj
        AF5aOqtBSrS3gpamgp0csJg=
X-Google-Smtp-Source: AA6agR5DA85StQSxQRPWxX6B6a/OS9cpLxiZxUArgaPS5Qk97tH+FkkUKSN+RB9nMiZGKW0aIAjdXQ==
X-Received: by 2002:ac8:5f10:0:b0:343:7a81:e89b with SMTP id x16-20020ac85f10000000b003437a81e89bmr10978565qta.527.1661793595210;
        Mon, 29 Aug 2022 10:19:55 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bm2-20020a05620a198200b006b5f06186aesm6348724qkb.65.2022.08.29.10.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 10:19:54 -0700 (PDT)
Message-ID: <6f6eea4e-67c0-7410-4705-3fbe9c72ba9d@gmail.com>
Date:   Mon, 29 Aug 2022 10:19:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220829105756.500128871@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
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



On 8/29/2022 3:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
