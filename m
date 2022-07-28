Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46F8584872
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiG1W5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiG1W5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:57:41 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A345071E;
        Thu, 28 Jul 2022 15:57:40 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-10cf9f5b500so4136278fac.2;
        Thu, 28 Jul 2022 15:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NWUQf5zdYXFTyo6mWR0FGWr2J7TaAzUsOb9q4bncJx8=;
        b=hwxs+c2ng2P7dGnzI0g6AWbaQo1jsEFo2iR38d5aKNsf9U+uUtfp/VkT+RRH+4y6BX
         yvkHbVAukxGCRdKCgSabwFL+bHFX/9nEs2r/V5VDkg4qPVfaYL2qzQ1dMj381/3jVaNT
         ICkza9vVd3YYxCfdknf5539lLKtdO5MVZSr+dJRCPeHBx1EchpuSGzO1Yz3Xllss9YOH
         Mm5Y0Xl5vIkkKSWpn1H5UudzhkcOyyIy5yoEh/MUWpmuueOQBT6bGqdL/23YsO+IHoff
         pK2MXQdnOpJw3B3kAf1TJntJpVh9C+8FeGzvX7zhKaH79iar8BS+Hgp9qKNjYFyuVxpf
         XajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NWUQf5zdYXFTyo6mWR0FGWr2J7TaAzUsOb9q4bncJx8=;
        b=2wkZjnFMBwJGP84VFplmwZLoWQkU73qU4tJEqwTjr/4fNMvdN1u2yNCFVDoLVqhePF
         9MSGRP2xv5GG00d/gHSQ8FhfGqGaclc1vVuv4EO0IcqzwG8vL6GGzWno5z1wxi7X3grx
         lx7AR5yaxrbOs5W3HA5OQ+xGiSLoD1iD6zgEALuPXgzKxij9LxSCsr1ztSpJh+YCHu6t
         jJw7LFAXKn1IveZfct5vbiXfczUajls4u/T/1cwXYyo3f1IkJUNR/S42hUsl/TlG8Xxk
         vXIrcAkeoD5YJo16/GrOU8yqaI3BcNML6yUojp/BNsmDjn8SSiF4eT01k1rqXclkgeX2
         rUSw==
X-Gm-Message-State: AJIora+hogolcP8FIHF/NhVd7zCPlKlK2kxn1pF5KQPl1bsrvMW4YJMk
        D3oKW/2ovcXdYEQCHbQoEKRwh5jZV7IPWw==
X-Google-Smtp-Source: AGRyM1sMA0d2xx/u7tly4d/2ifx7T+xASqUtwuDbgX3EHvfpDdQxi/T8+0PodoG//EQrv5OzemW+bg==
X-Received: by 2002:a05:6871:80b:b0:10d:7a42:bd21 with SMTP id q11-20020a056871080b00b0010d7a42bd21mr452390oap.186.1659049059468;
        Thu, 28 Jul 2022 15:57:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a056830100900b0061c309b1dc2sm824914otp.39.2022.07.28.15.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:57:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:57:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/37] 4.14.290-rc1 review
Message-ID: <20220728225737.GB1979085@roeck-us.net>
References: <20220727161000.822869853@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:10:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.290 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
