Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACD5596829
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 06:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiHQEZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 00:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHQEZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 00:25:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD9A71725;
        Tue, 16 Aug 2022 21:25:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c2so2632791plo.3;
        Tue, 16 Aug 2022 21:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=9Pvvh7ZFksGno78fJjPdTDMkWN/2EeN419rdtQuIO8Q=;
        b=N9BgsAwyb8gS9hF4GmQ2l6tmX3YhX9MrFP00wcrUvibVS0pIjqfMlosWKoHVTOhy2d
         zH+NEwj/FBts81dZev+xRduL2HkRGMLDVtuTfh3bYaTW+tJQsA9AMVaCd5xAYpAZEmUz
         2HDQRhHqM2+DILjZymid+WIH6Ailp7eSRmHHVk4XqRGM4m+LEMnvv5F0vqZNx2aifED0
         QfN+6oYzuuejawXMd7Fb+wior8Dy9Vo+Gwj/U1VxDEo7ChxkW/mNFQQnkz6yq4i42/CT
         6GFO+mUWcLVvfOjaYpAAmKJuo+6n96YJ9vHA/E3AL9/sPkSckvYGgzLitSEVFK10nlBN
         5Weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=9Pvvh7ZFksGno78fJjPdTDMkWN/2EeN419rdtQuIO8Q=;
        b=CbgqvIz/QVfY/0uvHLYkbt8qao9OE9a/ja7EaYVulRo4xKuiXAkrwQy4R3z22nnhHS
         2pvso2kDHEroSuwfdUDFk2UTzK50vTCZS3PqoeuZY3fhw3WMRZbzGc1iao8tUddCLBa0
         GkFqaVstTk45ZYnxlnJUUsMqI5slx+AcJQen+v92O3xC91tBEhzvte7RTqVlJClY2cz4
         1vZZJtHpix9JOOJkQz52Zs5AQw0Rmr4d+CBPSVMnAJnMIBCIbB7OG6TTnW5I9ewtD5+w
         box/8+etXUHOFcYO17MiDZnnD4sW+9KW34GpWkjO3E16dIEKsV0Qn8rIG4EprqABDvuD
         Zv1g==
X-Gm-Message-State: ACgBeo2+mhffhNbMkx2/aY6VWEu8XGgjZFpYXqA9n1Cnd/7JSEH6JDo4
        Xd3bwK0qyfxQec8n2/9UigtjkcqMdK4=
X-Google-Smtp-Source: AA6agR50sDEMONVNKuq1O/UHqMl5Nmq5P0MxWaXQOkpRVpBEuvIiY4qzU2/DDv0IdBxDR/AkqXL/Wg==
X-Received: by 2002:a17:903:228f:b0:172:657b:b8a8 with SMTP id b15-20020a170903228f00b00172657bb8a8mr15871396plh.29.1660710323092;
        Tue, 16 Aug 2022 21:25:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902ce1100b0016d150c6c6dsm260758plg.45.2022.08.16.21.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 21:25:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Aug 2022 21:25:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc2 review
Message-ID: <20220817042521.GD1880847@roeck-us.net>
References: <20220816124610.393032991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816124610.393032991@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:59:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Aug 2022 12:43:10 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 483 pass: 483 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
