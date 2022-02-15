Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468524B6714
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiBOJLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:11:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbiBOJL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:11:29 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531313DDF;
        Tue, 15 Feb 2022 01:11:19 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e17so14325424pfv.5;
        Tue, 15 Feb 2022 01:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=CENX30cS1AwqRdGdR2LGQaXDhJCf//o48FSLd1tc1dM=;
        b=EXpVWUDmG/suSPOYNy4mBNNV+Gq7GkpSFYiuNKXihpliObBZlZeaj+oh24WJxQz8F5
         tp095SeKWhqL8MegSIxzs2lmJW56ohOJuRdLlXZZH7kFB7ih2L3685C580np9GeealHA
         sV1ev7aZ8mOJTZe9nmcpiPbaZOj9bCafUvpwImMAKkjJNVWgcGxJIO74ziKY8n8AWUaq
         GkaCpOkdUSzE9yP4YpxOucpy9dL7qSs+S0XVUjoE0pVMs53JEVEjJcF40qyI3zVedz6l
         Ps37MnFNGXuZQuIj7LfLLEIgDaJogZdojdasL0l1xONhSyCc21ErThIkivZrTGn+3etv
         4c5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=CENX30cS1AwqRdGdR2LGQaXDhJCf//o48FSLd1tc1dM=;
        b=bBYnVlna7yAdx2i7JZOhl4wIfzl2CBzHjA/Qvzti3N6z5XpfaIWn0YfduBewCiKuDA
         u4Lh2qS3qJoWu835ld3Ac7zLXU+t+P7SWQ+gLIfzn3q6DSnhPIBcbkyqjf4vawjThoeZ
         TW8d5kH5TSfZ1Yyll/biFNwbxoaIJKYh/MabZLDQJAVShFXt3RjP0KUNVdXI+wFkz07Z
         ztNxfj+2Hwzp22FtzA83Ykw8GqXw8DOAGQOAlPoCFJ9KiQYJL3ZGjx2UA/PmDMQE3vAs
         dC/08jYMIBkoRPHPnJhcdSAzNdXTMwPfZXmpUo3X9K20HjAw1xHQFZucqr9evbQTbkvd
         IY0g==
X-Gm-Message-State: AOAM5330XELfHBQ/BZCn1xQP5SwibIX1pbD845YPO7gR8tR2z832Ckyh
        nCYctVh89rLEboToBPnDHXw=
X-Google-Smtp-Source: ABdhPJxgbzmTCJqIiTWlG5h2H7sIuaDs6lIwJVhjipJPrxaUDEMZTFJppnHGmXxUScH8x6CrkI+Mrg==
X-Received: by 2002:a63:8549:: with SMTP id u70mr2785919pgd.266.1644916278530;
        Tue, 15 Feb 2022 01:11:18 -0800 (PST)
Received: from [192.168.43.80] (subs28-116-206-12-52.three.co.id. [116.206.12.52])
        by smtp.gmail.com with ESMTPSA id j2sm39099118pfc.209.2022.02.15.01.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 01:11:18 -0800 (PST)
Message-ID: <d82db5a9-ec38-28cd-831f-cb8755fb5a77@gmail.com>
Date:   Tue, 15 Feb 2022 16:11:13 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220214092510.221474733@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
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

On 14/02/22 16.24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
