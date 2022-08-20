Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1EA59AD47
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiHTKoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiHTKoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:44:08 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F64F9D67E;
        Sat, 20 Aug 2022 03:44:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bs25so7786264wrb.2;
        Sat, 20 Aug 2022 03:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=lhEj33ncMqUh0U9l+J9V7iXMTyQbNBRQcykeAFlTozI=;
        b=BI94hik9JabYbgEtuNn2AWiBlCiRdz502hKin5iPjZdD4hFYqmCB6T8zBaUTeQmocf
         M29e0cIDio71uj83HP67F4IeHczD8xdoVsT2/M51B2l1/LkOk0Uf7W58V+JNAn+ycLCR
         DDKURGrLIfBZRIsKm/eiAeQpHAjIZ/nugS8C5ybyJwFzDk5DBGWDiLvCxj0z1CbnCuYG
         VsFplTRKnU2TU2EIA/j2GP/BdqspZVojuPgbE4KopdtPclexvyOb2DyPh4WUci+jnSb1
         2Mp3fPEMXzaAeVr/Dn/9KTW4pd6Wwib9ql+u73jd2gUyoa2Qcb4nUtrtjz9aI1GV5Fby
         KeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lhEj33ncMqUh0U9l+J9V7iXMTyQbNBRQcykeAFlTozI=;
        b=wAGADCyzwBzLEfqwtxutF4d617c0jPJqlUtcP+CNrWwC9NmGqB8cytlEW7wEKykkXa
         K416dA+SgrmJyW4mrR/CovSoz8xgXH/D7H4jXMfTmqIBTeEzkTAub2pa5Sww1KDLpRv/
         e7BwIgCwWtR3liSybIEeg6OCWFEy/xVybhe04z8A6TZS6O1nY2sEKsxYpboHXf6snUts
         o2hlQryxiW3pGThXmwtRsJGYbNS8cqQo/i5eaYGTfDyY/xgz9rWmXcytfkteItvAElgq
         9fgLqWH4IV5PJTKBLHO4uoleuS8Ipb3EeGqcO2YvV8tRni3mgkTDymQ8luItoVa0yB2e
         vXig==
X-Gm-Message-State: ACgBeo0dN/LyDMQgeElhK3v2Hsc9j3nEfG0XvHmBV1EenMGWWmWuwpsq
        Fw0+fkJSW583V2U4+tGuEAkRT0otKLQ=
X-Google-Smtp-Source: AA6agR5tYTCBFNMNYXbcfeORMSLyRg6NzcohHLnv+SPRHm3/MyH9eI8IT5M9K9XLFccwLHnX2EfslA==
X-Received: by 2002:a05:6000:1b92:b0:220:7d86:2e30 with SMTP id r18-20020a0560001b9200b002207d862e30mr6495729wru.530.1660992245765;
        Sat, 20 Aug 2022 03:44:05 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id v8-20020a05600c214800b003a5c244fc13sm12129994wml.2.2022.08.20.03.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:44:05 -0700 (PDT)
Date:   Sat, 20 Aug 2022 11:44:03 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
Message-ID: <YwC686Ee6vtH/i1p@debian>
References: <20220819153829.135562864@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 19, 2022 at 05:36:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 545 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1661


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
