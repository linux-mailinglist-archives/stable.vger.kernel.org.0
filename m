Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF6E622251
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiKIC5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKIC5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:57:38 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2AE2A414;
        Tue,  8 Nov 2022 18:57:38 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id r76so17493836oie.13;
        Tue, 08 Nov 2022 18:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJErdUK5o9mibyZrEQBlebD3V73lwZxdQmiFFeKypDc=;
        b=cxvE645d6ZevrZLbmZvMxsjd3cqTz0o/iXXcdie78CwwBRqdqRpI1zOwcPg5/v4rT8
         XVliTnezXrjNxL1BHaj1GGsLCJ2gK+Hq86RP9r5X+v/49OXPp5NWUfBXGGmppqgbhpl1
         1AXLKRfUYgx4Q9doEWINs/n15qZHVYLxMkDTbPEl+Af+sEEyvAByyXwDXD1sG4Hf8wiL
         lfrQzhVOnfuPjn9Ya7hCmnQZT5wWpwi4zOA12qKqnugztK1HXPY1V1WyLnMYdXuAtpW4
         Y0g9aJPUcPlF0yLyOtbyjOz0QXuucifi3MSZiROprYEnND3pgIt6M/hV9mNIglBPJdlT
         eJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJErdUK5o9mibyZrEQBlebD3V73lwZxdQmiFFeKypDc=;
        b=wxkkn79tjs8S8RXjeQXaWst+IiSaAVQVIDwf/1x4E5hczyo45f3wPokx2tUpa4X+uV
         /+eFIgs0s5RgRV95C6oNe9gIefVVMtmWOPIXrlDeDW4TCTxgqrjgDf4nT5xirpR/8ydr
         32KZMaFlGrluT9MHeD/rDtQ4lVDQbN6llvrBi3BL6wjppyDFjCs7l41cOeqjFePpNVmE
         DoxdUdYWO7zGr26p29uvEp7pEBlu1t9VmrJe9Wst/2Z0GX44OpKx+rX2se0+LGQX8fSw
         Avtl6d9Bl3W6aXNLA+eJeNzx+1kCs2ch/lQc1MneY+o2AlriOOEQE/0Rejzbo3W351Bf
         OJkA==
X-Gm-Message-State: ACrzQf2P6m6hvthlBuccQYIe/BGLD1nrEq1/EXLVFDxbCi7448IaIYhz
        y2vfydVS6EFCC2rrOfaTi6o=
X-Google-Smtp-Source: AMsMyM5/aajF9t2757MwPaWryHE7aggFsXua3cSEN2e7XoZSTua0L7ZWwOdXQ7txykN4CzYIXxjHtA==
X-Received: by 2002:a05:6808:1a85:b0:359:b07f:4f7a with SMTP id bm5-20020a0568081a8500b00359b07f4f7amr31159881oib.166.1667962657484;
        Tue, 08 Nov 2022 18:57:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m6-20020a4a9506000000b0049201e2b8f4sm3810626ooi.4.2022.11.08.18.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:57:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:57:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Message-ID: <20221109025736.GE2033086@roeck-us.net>
References: <20221108133329.533809494@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
