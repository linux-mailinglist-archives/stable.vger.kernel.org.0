Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB76BDC19
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCPWzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjCPWzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:55:08 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EDD7ED4;
        Thu, 16 Mar 2023 15:55:06 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id f14so1521285iow.5;
        Thu, 16 Mar 2023 15:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PDqnB+25WEIFzAeTWsEfLXtQkDLmmzfSU2WMJi3b5vk=;
        b=SjD6DQTFYTR8eR/RCg2fEP58wOpRuZc7For4KxoDsGPwcUe0vdW1gn3piLoecF/aJr
         6V0W60hwXJzc0dPTomk8bP31xuybjTM/zyH6KmI0P/hnXTV2hWhxh4oCJqhxAiDtsgiR
         xBRg9hYy0xRc9/wyx760qNYMRSeLClt/4RfgAt+zano+3c/RJJW7lcwVAtFALAMXxre6
         933GXFqkKeaQDw0REjOlbxJ2MgZr8dMTivYKVL69oZY4xz8E/iM9vFW7VgszuFtNIJ2G
         PmnFtLFtAimwQkNigmop6Fj8CV2sRH3VwokTV2xPXZiXgNeIDfGwyvdbgo2gpUBkmFe/
         t9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDqnB+25WEIFzAeTWsEfLXtQkDLmmzfSU2WMJi3b5vk=;
        b=McVFZAjlIeMiyTxo7xQUfwV+t/5k0KyDtjBB4Y+zYy4My5EGakwWBWQNT22u6AG74I
         k5EFJiuVEo3yrV1V/iFEL75ZxuggwUPV6g1H4OjauqDBZy5iii/nmiQLtuGPd1qY0Uvf
         npnjqxpf2bwOQY10Uvnz7CD5i2WKwc9pllmZO3LZsAdyjZHh+0dzkT8JKSVYtIrYp39N
         G2bl2f0PWwzqkMRQfw4o1+vRanaTzu12FvEO4b2oWI5Hf2EvLq9mzsPJ2t9tc+UjwVcN
         GeHTO1zUTkKw0puKzBVG2Uct6OjuBzG5ia2WxHDbX26DwZ1tq1NmojqHjuIvmhlneWUi
         OArg==
X-Gm-Message-State: AO0yUKVBu+T08hrx/GTwzfxHRLAc0Tvfy5ueaqn9+R98ZvIjsdp5lzs+
        +tKj/hJlYsOu2nfHWyJiEq0=
X-Google-Smtp-Source: AK7set9HjK+eyqNRseAzK7Inyl24iZVywoa1PB8Z42F9aFHg0OvQgLdrN5eis1t1z7rBakYHol6SdQ==
X-Received: by 2002:a5d:9a91:0:b0:753:876:5bf9 with SMTP id c17-20020a5d9a91000000b0075308765bf9mr380727iom.6.1679007306041;
        Thu, 16 Mar 2023 15:55:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p66-20020a022945000000b00402e2521635sm157695jap.163.2023.03.16.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:55:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:55:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <fe42245e-7f7e-4506-812d-e128bccbe3f9@roeck-us.net>
References: <20230316083443.411936182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
