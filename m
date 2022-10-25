Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9560C09B
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiJYBLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiJYBKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:10:48 -0400
Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6499E78BCB
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 17:20:49 -0700 (PDT)
Received: from localhost (001.mia.mailroute.net [127.0.0.1])
        by 001.mia.mailroute.net (Postfix) with ESMTP id 4MxCJm6gS1z2KYGg
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:20:40 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([199.89.3.4])
        by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id 4I8nf9fypHgw for <stable@vger.kernel.org>;
        Tue, 25 Oct 2022 00:20:39 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 001.mia.mailroute.net (Postfix) with ESMTPS id 4MxCJl063kz2KYGZ
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:20:38 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id v1-20020a05620a440100b006eee30cb799so10378753qkp.23
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 17:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y3NlrxVCKFlQ4txlIwCVbcHrW86sdGZpr3Vo1GsX68o=;
        b=dsBYHKRseM8CQ38W6KiwvH5C+/3ILFImsCdASnA0vy0tIkXboeOA3PAp1gkrBCs4Ng
         ML3IXOVLXAe8rrs9TVVYCnlZYhrsDDNjqqpYjoITxAHhPIxs/nWH9dKAPyltMHlM22p+
         gWEm2lV8waDBzAD0+loqN1PZLQH5TAdTxVLYcLZmBql1Uos2rVVaNlCH/lJ97oGSZPOn
         UPCUp2UYxCYlU7FSoZNdaE9+Txl+iCut6y3FoFai1GAFEFiZq+V+Tdxx5N08okzX/tJ6
         sBAZoj0lwpExOCbvEgNIYzpW2VwAOIjYfJ8dDm5zvKT794bmVtZk1pLJYv6EwERn5yBz
         nuVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3NlrxVCKFlQ4txlIwCVbcHrW86sdGZpr3Vo1GsX68o=;
        b=HaPfAnUrr42r5vpnZjpm4MwRcMKLi8rWpL95VZ3XMlVn90aWhsqIc/tp6N+IfVW9TL
         WPNCZZjobDnKEFTda8R/R4VPDsMdgjoF/2N6b+JEH4q3FUgYI8Q5ysgH+OzJwohMU40P
         mvdamEiy+DTP5CUFR0gT6c5CjK+n3DPrtj/E713pK61/9ys1cTGKvCnqd0cU5SIkOOMT
         50rMOGW72qDBmH3ezVuNkWOUqPjSWayZjMy5Y6ym8uc6wrt1X1vht3gs4tKQukxpEyAN
         CSZvh//xnlujIEBmAC0sCzPMtaN0q9BVqpfQ4qIckBnKzGbWVQvXe65sdvqA9otPbwez
         uZKw==
X-Gm-Message-State: ACrzQf2PeiN20EQBIVBoE2tNmjXSgfQOvRQ6LwJgpvc9IDcl0QWgLEzS
        REUzCcbjg0cDgD9PyLTxz7CPUo0dB6t3Fjs2Sqd8AeIRUXTEqucr/HuhOKF4H1e7ZA+Y6KgZh2q
        1Ki1kgXXIwhtkpciJdGYfXMyR69UZ39o=
X-Received: by 2002:a05:622a:196:b0:39c:f517:b9b1 with SMTP id s22-20020a05622a019600b0039cf517b9b1mr29811803qtw.569.1666657238032;
        Mon, 24 Oct 2022 17:20:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63x6KPJUsE2DGKF7dsMd07oSMhVwcCpSrtWYsr3nNN62bTHxD51lwfPfIgjQp57USOYLLLzQ==
X-Received: by 2002:a05:622a:196:b0:39c:f517:b9b1 with SMTP id s22-20020a05622a019600b0039cf517b9b1mr29811789qtw.569.1666657237807;
        Mon, 24 Oct 2022 17:20:37 -0700 (PDT)
Received: from [192.168.1.39] (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id s19-20020ac87593000000b00393c2067ca6sm785582qtq.16.2022.10.24.17.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 17:20:37 -0700 (PDT)
Message-ID: <91e851be-1c3e-69a6-11ef-33c945101c86@sladewatkins.net>
Date:   Mon, 24 Oct 2022 20:20:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20221024112934.415391158@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 7:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.

6.0.4-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,

-srw

