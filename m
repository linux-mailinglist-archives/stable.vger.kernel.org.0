Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8538B506D63
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiDSN27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 09:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239761AbiDSN24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 09:28:56 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D9D21E19;
        Tue, 19 Apr 2022 06:26:14 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e2afb80550so17476256fac.1;
        Tue, 19 Apr 2022 06:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=luBr1xSCGoCbhSjWtwlU/G7MaEflGQoKcEEDFnq129A=;
        b=POp824OWPw/M3WzXfW43JkSKaaTXbZ2YLgkLtQjzo4c8YiuBq/nRdSi9FggDzB61cx
         W9wmhg22twzq3CNyui5KDI7tbT+icX17E+0ibvKrqJX0hlosGgdiJhkLg8q9CFAbeZ7B
         kwlhCmpSMJIG+2yG4ej0rmMAPCL6Vcz5/PrWyUK+9Qvmeq/qK3y2yRwA6veVOr4zZjTn
         CjEdfFaVLlh0/73mRUByjyCKKL5QEH9zFMg6Gzd3aAnz8loKKvzIYrLk3ol34x4P6K5z
         NFGXOJYisO0Z+tSh8RWnc2wnKbjwpr9nk75ch9sfYphJZ31MsQcKM65b+jdnI6OBCKts
         xfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=luBr1xSCGoCbhSjWtwlU/G7MaEflGQoKcEEDFnq129A=;
        b=tWhwHFEDbLY5sxRM+tdPzIQBAGu61IpBLAxGTcozxRkluPg4E2PNafeWSvci5yB3J4
         RaLNkK8/15CRZBf/VnHlSLkok83d6e2NVYIyXZ1UTsP32vQaXQZNA4KmHfrlfl46yr5R
         +9eRxKClRbbixATevK6vvI13+VQGnKOKsVC7yCZ4fwOSfduesM52IyQ5zWFI38uy0LOP
         DtqUpi9WTDZHr9IKeMhGv3GPFcXmtxeG9StPojgUTShgRfiuUL5/9ecyg7Gy3j3uaDtp
         BxH0g3M1blzc95HqT2tWCFckqIn7IDh1n2YUDHNojxalWxBF5WcLe/uiJG/82qKU42dh
         FysQ==
X-Gm-Message-State: AOAM533FeRAfL+zCtVGqaSqsecHonfGLfDSFEKfu4fuiXQVYeyiQcKXB
        SJKBAHRQZpTKr3uXKsJeNMc=
X-Google-Smtp-Source: ABdhPJw3BmUO4t9P7pZqCqph0AOAgJrVVXFte7LbbgUPib1uqBTWoNVIfAzY9W6JG97WXEc+2TKrgg==
X-Received: by 2002:a05:6870:818a:b0:e5:b9b5:6340 with SMTP id k10-20020a056870818a00b000e5b9b56340mr5687227oae.127.1650374773603;
        Tue, 19 Apr 2022 06:26:13 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y22-20020a4aea36000000b0033914f661a2sm4358795ood.33.2022.04.19.06.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 06:26:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <66221f7a-7d5c-2891-a882-3c3e397dbf0b@roeck-us.net>
Date:   Tue, 19 Apr 2022 06:26:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220419073048.315594917@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/22 00:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.
> 


Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
