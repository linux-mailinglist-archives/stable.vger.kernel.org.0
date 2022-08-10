Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC6A58F3EF
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 23:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiHJVuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 17:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiHJVuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 17:50:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228F7A53B
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 14:50:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 12so15506717pga.1
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=94hXskbsFn3I7O4zj62ll1w/ehjz1EVyvwWf7ej+gJ0=;
        b=gsLQwcNfPa9JisBr1SnYIIW0mdzsnSqnebFosup07k2U4YAoU1Rgfw58vbD15S0yO4
         p/J74A5SG/PW3nwKKbpMq1YfEevKUnJEJwMYPlP/N9NSvHXdpIelVE93mhQovq+Bzpw+
         y50BkuUmx250B+Ck5Cu5eDTmbPDLZTDbDuNOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=94hXskbsFn3I7O4zj62ll1w/ehjz1EVyvwWf7ej+gJ0=;
        b=tOgyBKwTh3ywLRLsBAe1wGB4jeOb8O72ozjsII0EkEJbN1XfDBrr6VnR90F4iyCn5E
         sIdZzPvsEjdoWfzd1GQgImXDoslJ7VtTt8Pd7t44QASw3c4I+WYRIXoYFmbh4zjX4/GY
         iziEgUU3r+sWwLeAm/ZpxL0uXvfl4WZMPluqCwoLCtK+foEZ11pDNUTVGvuecu6rx3fN
         kVw2bbz+cNGNKLSYJjt5eVB2hPFMBxJg9I599cWzEsgkNCguBPPxT3u79Uft1PO+RXDO
         +61rGdqGxwkNG6jW5TD815bEvuimjH6AQn0dF/0yMt36+Bbq01CU6fhj1I95ZKh7IQ1m
         wRWg==
X-Gm-Message-State: ACgBeo0scTOUZW4fVAxuuu417i4B/SFHmetCNTe03mt4g53DSWZfaJee
        5gt8fgmMSyD1JQPCeI06i7Zyqw==
X-Google-Smtp-Source: AA6agR5jpcAtCxBtm8a97EgGKNrVGPIyJSW1iFj4iEPgwE9W+No8v9fu1kwGWCU9bWZRcYFUBdGtOg==
X-Received: by 2002:a63:5b52:0:b0:41c:b80b:4f8 with SMTP id l18-20020a635b52000000b0041cb80b04f8mr25092032pgm.270.1660168203072;
        Wed, 10 Aug 2022 14:50:03 -0700 (PDT)
Received: from 3c18d82cdf97 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id d29-20020a631d5d000000b0041296bca2a8sm10126968pgm.12.2022.08.10.14.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 14:50:02 -0700 (PDT)
Date:   Wed, 10 Aug 2022 21:49:54 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
Message-ID: <20220810214954.GA7@3c18d82cdf97>
References: <20220809175513.345597655@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.19.1-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
