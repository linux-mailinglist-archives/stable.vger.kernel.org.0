Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC63E637078
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKXCgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKXCgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:36:00 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CA25C76C;
        Wed, 23 Nov 2022 18:36:00 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so195881otb.1;
        Wed, 23 Nov 2022 18:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzENcxqlJ1Db1Omk73LOiclX0akFJ9yOT5zKVJea0B0=;
        b=ZDBPhfP+ejhmipudUDHpAJzmXCHef8cUiHqN/cBSpf3dEqVxK5g0aIMh2TIgD/Vaxv
         7/XaoFihno4TNthoD5v3wz6s5ehTWs6auHEJZDb1+YBnIcvcZfrrNDaKaLxZI3BXf4aO
         Q/ut61WBbYgg44rIW1k+Dia7TDW6kAY7fOhw98O06Vt3XkCrnoOolN8frFXCGN0rPKzl
         n9IYl/x0F8swLZJaXu562h8YYErToC/Inv4HPxSGNHshV0L1mfPS1w2GBt2fdT2htEyz
         eoIp9B70FKMp7LR6IjMX3ObAVTEMf6JDDgrq4bZSqWdki73S4LyxCrqRQ8XxUEQvRH9o
         7Rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TzENcxqlJ1Db1Omk73LOiclX0akFJ9yOT5zKVJea0B0=;
        b=pE0k+QjA02QpeRlgBXKlz/9wAXigiABzXcLcrkmgElvZgLN1ceUQAQmpt+J9pOfgpR
         60DwpM6qnhDWvqSaSWCfT51bHXD/pMWbIRI+Swtc0zopDnIQ2MCDQ3g3UoL5eNCeAOFZ
         cFUe4Rs0e9ylT4RP//P2M9ZSDF3ILoWhdOCzR+k50Nsp14HIHjeGMRym3gB9mzwha4bQ
         nFY175Xv0BskUPzgnZtKfvhvJceDGSs4plVgF4tmfvZoObrkg/1mQBzBFwGfaCcBthP6
         Q88wzxrAu7F6sQN5slGOLpkEKN7WqVe1LoLP+XSBLRNC5fUs73CUzVKS/jjBA7kxcx7r
         pHXg==
X-Gm-Message-State: ANoB5pn1RrpRoPi+u31SpmeQv9w/8gr79Yx3A0KGjKsgcbPZSFPjO0Nk
        T69t8lWnuiePTDPX1MFn6ws=
X-Google-Smtp-Source: AA0mqf6ZNdyP7tfEPmkeh48FRnFaU46DvOC3F+Tj6yWuNSYEYEYQnCyfgJF0UndUAnx9VrSKx6e8Lw==
X-Received: by 2002:a9d:1d7:0:b0:668:73ff:e96 with SMTP id e81-20020a9d01d7000000b0066873ff0e96mr5779233ote.256.1669257359477;
        Wed, 23 Nov 2022 18:35:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r14-20020a056870178e00b00130e66a7644sm5506oae.25.2022.11.23.18.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:35:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:35:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/88] 4.14.300-rc1 review
Message-ID: <20221124023558.GB2576375@roeck-us.net>
References: <20221123084548.535439312@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:57AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.300 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
