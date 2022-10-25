Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75D60C2A9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJYEbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiJYEbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:31:04 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D627A511;
        Mon, 24 Oct 2022 21:31:03 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46-20020a9d0631000000b00666823da25fso104244otn.0;
        Mon, 24 Oct 2022 21:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PXuddeN1DhRBHk8sB7OaD60L8zXlTHZ1LGfYY20fwQU=;
        b=ni5hVnXf7N54zaLbsdiB4/+SuXpNR8D+x7mG0kdB36x3dY7IKghe3nBHWjJ1QdQnw0
         UXQlVXLLyG3C/NcTv0wT94gzq6kXMdfwMWIcUWPIzNTzm9yVYNyvLlGgaNC/+sx4dkJD
         o1ezRxhYPQmPnwjizzU3IbNuc/ZPhElhyVF7TL8Cpl5/BE4P2X5RbW0lyOP7xfPfXkUG
         xZlLxw4JyX8XLitfb0ZSbif9+zfOhkpbmPd33RZNSM6v0kWqGQMcBfWe4i/c+KheC2wR
         mZSXfqhcA+QsQsn+HJvcnqKjl+i5C8JNHYBzCePVGcKyfDrPAZOuPPKYFknhXb42WPmh
         4Z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXuddeN1DhRBHk8sB7OaD60L8zXlTHZ1LGfYY20fwQU=;
        b=WcpwN48qaSSFyMZaYxp3qDGyr1ClvZ78TpVAGSNr6ABiFAn67Af/xO7cE31ja8K1S/
         jdmMy5azAAe1f9tytFqzLY/ovTCavfg+nACW+Be5VZUznGbEGUz+NMM+ToCwuQPUJKRt
         93oftuo6AYWMJjamoGsHs4r4EGb2TLkdjRtwf3n4QQqxjhGLwf9xN7TUcjrRHv+rqetz
         0t/ByM0cacRJWLc6vFTKH//eeScP3NZFO719ZNyPHyaBdBRjp7OwHm/uSWxhbTEB/Zzt
         MsB1XNMf5GVJ8bTStnoUnn17wc9hCM2vFPac1wClikJpuY9ZH2TX2uqSehJl6n+TtAOc
         y6IQ==
X-Gm-Message-State: ACrzQf0dxydMPLGjk3WkZVrlDuVJ5vTXVeMUGEtfciUEkQw1D3nM6E6C
        xkNrnA3zMY6tBDQP+tQdui3IeI0vqqk=
X-Google-Smtp-Source: AMsMyM6FhIigxlyJIE1u8H1UUAkhX7H5txH8EHIJd93detlwRhs6iqq5YD0ftpBHH+G2un8/k/6e6Q==
X-Received: by 2002:a05:6830:43aa:b0:661:ae26:53eb with SMTP id s42-20020a05683043aa00b00661ae2653ebmr18202302otv.221.1666672262992;
        Mon, 24 Oct 2022 21:31:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x6-20020a05680801c600b0035173c2fddasm584365oic.51.2022.10.24.21.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:31:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:31:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/390] 5.10.150-rc1 review
Message-ID: <20221025043100.GE4152986@roeck-us.net>
References: <20221024113022.510008560@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:26:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.150 release.
> There are 390 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
