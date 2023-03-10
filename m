Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825EF6B527D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 22:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjCJVDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 16:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjCJVCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 16:02:48 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B827DD33;
        Fri, 10 Mar 2023 13:02:38 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1763e201bb4so7302014fac.1;
        Fri, 10 Mar 2023 13:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678482158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uNCf0p/OxNkXhVGTn1gmXHIJuyHGde9FheDas3x21Z4=;
        b=DyYvUHHEPXN/ZJoVZntBBAEO8/voZRsXZmZed3MoiD2XY12tlMMgMCFg3c74Q+V5XR
         DKsQnvM36We2j82RhKgTye++/72xp14D/n+C3tO3bXreqVRFNRD6UcTDq7NptnJ1ykhh
         An6mC6LFAFOkaTiePEJJCDAm0yBvaf6Nejfe7SVwq6khqQxqv1SrtaZkGxPZyRvF455W
         CEachZIQXGf6+MncS6J5kcr3cXAqTw6U6TXMF+flZqXrvfODGz02kjU+ystBZM3jBWY+
         AVdr9Hm5yn7PEmEITAIUCLQMb/IBDuDE4GM4aNGt6aMQP43cDyh8zpQYhnFwu7FyLkNj
         fL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678482158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNCf0p/OxNkXhVGTn1gmXHIJuyHGde9FheDas3x21Z4=;
        b=H5P9I/oFkg5hOsjduD5Gl5b+ZyYTpC9fDLnu2bSXoI0pvSaJhkU2x8u4jbZ6Zd1tDd
         Z7/smGBLrZ4CJMdYf0m4JcWtFtRIu8CkWJfMJ4vuUSlODqjbvfknLfYTbnRI8Y/3XJ1L
         Z6c11NzyNFLRLAKEKtjR5YVBleeLEUloiYOehJTlzdRJ8czaw2atJTZC0fmkKDc7hK75
         cAsxWzmYQQn0TzTQQh4QTCHQS7FnY11YtfGcz/ffX+ESPbXYaFmIUmzd+auv1xmLqIEF
         DF3SR4riJ4qFPIXlykdMf31PUbjX12bpAHHWzqQr/L0tan5Wcgv9chYAQ/AQUcfVLOHU
         gGhA==
X-Gm-Message-State: AO0yUKVTxbg7UILDvFe7fxkORb9KY4UGPX0S9GPihe3t1vrC6ixss9tj
        KYNGgx2Ne5aBC47AQ+6UIyE=
X-Google-Smtp-Source: AK7set9sDHtIeZ0zmP0d8H6D0hxiogGVVaj+uGRiBCLi9j/ogBVX0lW97t7gEn59+9YMSMiZFEfijw==
X-Received: by 2002:a05:6870:a110:b0:176:3f89:3940 with SMTP id m16-20020a056870a11000b001763f893940mr17042469oae.5.1678482158118;
        Fri, 10 Mar 2023 13:02:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2-20020a4ae542000000b00524f381f681sm357469oot.27.2023.03.10.13.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:02:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 13:02:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <7c6de5b8-dbc2-41b3-9e1f-5edb2876337b@roeck-us.net>
References: <20230310133804.978589368@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

s390:

drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  656 |         .pe_handler = dasd_diag_pe_handler,

This problem affects the v5.4.y and v5.10.y release candidates.

Guenter
