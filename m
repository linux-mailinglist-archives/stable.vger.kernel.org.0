Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8F5F421A
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJDLj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 07:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJDLj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 07:39:56 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A97D252AA;
        Tue,  4 Oct 2022 04:39:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n40-20020a05600c3ba800b003b49aefc35fso7352766wms.5;
        Tue, 04 Oct 2022 04:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vn+bf9SXsuapxHPXgVQLReNlMrnV25Ulz9V53TTokMw=;
        b=jsopuTzdil3P52JwLjXJvW9FQjFeaW6tmtAALa9C+7hUGYOLvUEwIXCuKSFWVioSmq
         HhwvIuZDmYBxGhYZxd9sVgvRsjvdzbW3wt/oQ73lzE7QbttPd7cYc3gYODeXFnqmknWP
         sq2oBhSZ7wqtssYlK4RiQHarjHL0pkomSXdA9VZcqB8ipfuKQUWM2tZchv6z5mZlj9Ex
         QlOPdGw8ZzmH8eic+PDsQV8f8oMvfa6QzduE5nNVzq+me2cYczpLjhSd3NrGa1HdSd+Z
         AqiGaCOmbMOEwV1mrB7HpUmAGaYNkLP2F+o2R8OYkFBFCxzLfcy/ron2Cu9tbZF6tFjo
         twQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vn+bf9SXsuapxHPXgVQLReNlMrnV25Ulz9V53TTokMw=;
        b=FGTxYtMx3h8Q5rMsMRBQOcXi56p4O7v0bSCQCXNrQA6/E1PxfJ4GoEvnmnjylISy10
         6a8gRasTRfQE1KwJ79TV+RmY1T10IMFytVnUMWEUpZwT2sWjgxIvKrfGvo6eBUUMS5Jo
         osPJKuC44C1LqmjXlkYPEUT0A8NFa+OExRuUzZHDgG8OH0ZIkTyGc7JmB54lZM4WWkcq
         51t/19N+FZ9DXouVEsOQT0jz3PmPoOF4Ysa5I3k7WH7nKgPqqZkljHnuI/D2mJedJ8SH
         OdozVFiduP9XQrcZkZq0fssRGCVNa0yXXnd7qSSWULf9Ui4bcl8Z5+uVfEZvUGqCsiU4
         u8gw==
X-Gm-Message-State: ACrzQf0ZNMzq+8+K9ydyb7FtzYaVBhcKbpOmr58karzytInSees43/Er
        YHbThl9adi0GqwXxgFUakfi/RM8NIwY=
X-Google-Smtp-Source: AMsMyM73q6TdZwqSmQfxz9WFLNPkDWbGjOVjAotIKN9wlnRXwQJP7Ic2sV2Vnuv7k3/3mGznfDyRIQ==
X-Received: by 2002:a05:600c:2241:b0:3b4:88aa:dcba with SMTP id a1-20020a05600c224100b003b488aadcbamr9948550wmm.203.1664883592865;
        Tue, 04 Oct 2022 04:39:52 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id b1-20020a05600003c100b0022762b0e2a2sm13024161wrg.6.2022.10.04.04.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 04:39:52 -0700 (PDT)
Date:   Tue, 4 Oct 2022 12:39:50 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/52] 5.10.147-rc1 review
Message-ID: <YzwbhomiyBSTnKyB@debian>
References: <20221003070718.687440096@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 03, 2022 at 09:11:07AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.147 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1945
[2]. https://openqa.qa.codethink.co.uk/tests/1948


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
