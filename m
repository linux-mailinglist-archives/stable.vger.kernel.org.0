Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117C16BDC15
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCPWyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCPWyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:54:17 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE9DBC5;
        Thu, 16 Mar 2023 15:54:01 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j6so1855152ilr.7;
        Thu, 16 Mar 2023 15:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CpyWpvKljiVZEIVgcwRsLc95PJlS+8X6+ZGw5mu8AUg=;
        b=NjQwuoo0l9k0MYmSvcOqbBoYtEvnCX3yIPogpYJboOjxeATLJ2LJDf6VyuIu+czA67
         lzgvg9HaLp4aDkdiOPLe2fm1Ft/K47j7wLwd00PD74lWZ2eXxLM4rgvqUiXQaSOTibtD
         G7F8rMyDLW1w9QYNDxxsYMze0FYSD/t3Prq6yWX/mUKJrdW/Jxc0RBsAA0K6eBiMdoCQ
         775Bly9svOi4a3PLmriTcC4uPEb9OqdfHhU4EZ/a1rSiWPOz14LpgKXoJ/DFhODNDJXM
         iINArsAk3/ftlxWs4WZGIubFgn8DC5nvJz7NceaOJa+tKT/QJqTbcGtqniFNxthKO1u6
         EX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CpyWpvKljiVZEIVgcwRsLc95PJlS+8X6+ZGw5mu8AUg=;
        b=xpUaKOLDgqmRghMHMd2dcB4vyTdq9HeCXKSQ/fwyhcxiW+G7cQGAPwnbyiXn52+vV9
         cBPQG7IGo/hV0wib/exmeVt2rkWaGqSqay+s9uJapnaWmxr4MkhxVmnuC6erj/UWsPwC
         GwQj25cegSibfNMKfpViATAJViMnLo5meBvFOevLBqD0wTX1gFRyjQ93QLJ3nOniAldP
         261wephiEMVBbWj8CPj1OsHr3r0nQ2PbWdPLEX5XdZeBjpf1fdU6il2dqP1ILxqyVfvJ
         Lm+HOQCVkP+fHw52JXDUaU1nW2B8yMhXZCq9C5FUVXUaHrB1uPBzvAbKsw8qWnmCjte5
         p8CQ==
X-Gm-Message-State: AO0yUKU6A1C9qC3BB0rliavi7wFHUj2gcz7mqTPiTd7l6VUvWutQTwUp
        cAh5aLykffQOklAeCHBuY2M=
X-Google-Smtp-Source: AK7set+b1pq/XWEVekjZWaW6wNiqyaQos0i6Xgr+WpN3rNn4hIq9CP5YeN4FPVnSAPnTAPlJK8FM5g==
X-Received: by 2002:a92:908:0:b0:318:6d32:b12a with SMTP id y8-20020a920908000000b003186d32b12amr8336879ilg.13.1679007239362;
        Thu, 16 Mar 2023 15:53:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c13-20020a928e0d000000b003157b2c504bsm165097ild.24.2023.03.16.15.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:53:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:53:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <f2a79523-b35b-45fc-9680-e7d0271d21d0@roeck-us.net>
References: <20230316094129.846802350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316094129.846802350@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
