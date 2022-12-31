Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2D659F64
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 01:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiLaARx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 19:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiLaARw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 19:17:52 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DCED2FB;
        Fri, 30 Dec 2022 16:17:52 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-14fb3809eaeso20358403fac.1;
        Fri, 30 Dec 2022 16:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=naU9FPp37XrnNa1LOC35fGfJk80sHKGQCuzXDNRYqJXgI1kVhvEP309ieCEzfPyTla
         cnyM6S1EhgpJL2Is1X9OPvDnCirALAPvmjRa0ull3F7uhgzDf73J3ZFg6MQV905EBljF
         30afWCE9plt0QpWPrGygfk9QFCsJGfgVBfVSa9ndoOij1YenmFJXOPTiALviGFasnCZc
         0hUSucO2ERDG6bJxbVDt518wAo2SyWEcwPXxXCTe4O/ErDsFaKFWXgi0xQBz0yOTO/3/
         6JIsssM8a6i0vWTQazva+9JgiwqrjnmZVsCLSRfrdOE7y2zB9QEbdir8NOlJf4xYQHK8
         /ySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=DtbY6RLkl4rL2Vqptf/T97svjPLYK5+HnJNr+TOnRAe1DQ/MW3Kk9qh/bApUiFtLXu
         4ylx8FkloPzQIok3kwxcbQnt9VMQgD4T26lukfSG74XMsxytxLcAhYABiBCT6sCYS7Kb
         pzEFMwqkZCZkGqT3awdDXQpdt83Got7HpbnTOyt2493iU8rfqT8G5TGwslYU8CL8LaHs
         mlZ5JtFvvbip0l6umqUIqI/gJ4WbH2zvtYTskbDlI/CVyTHvHomA6Ti+O5+Tlu3Ccl5H
         OyM36ti+FvgtLnazJHpv9R0pQCwGSJdiRaNd87aWUTqbpnf+aCxvDcPcPt8ZF1YBW0nr
         uuEg==
X-Gm-Message-State: AFqh2kroTh0B+nFKN3CXfIdVwWGQTLz3KTQmvs9pkFzN5CS997Vt4WPQ
        cqk8ScWPfhNe/sb7SBbbN2I=
X-Google-Smtp-Source: AMrXdXvh5c6ArRE4hrT8wtp4YdQBLc8YF1onZBgvBw65Z0PgjH0Lio4pTH+xarRBf+MVDtEy/kGqAg==
X-Received: by 2002:a05:6870:3c0f:b0:14f:7a46:74f6 with SMTP id gk15-20020a0568703c0f00b0014f7a4674f6mr15625758oab.33.1672445871378;
        Fri, 30 Dec 2022 16:17:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z13-20020a05687041cd00b001431bf4e5a0sm10407602oac.38.2022.12.30.16.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:17:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Dec 2022 16:17:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231001749.GA2916712@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
