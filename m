Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9495627E3
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGAA4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiGAA4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:56:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE2A57251;
        Thu, 30 Jun 2022 17:56:13 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q140so953651pgq.6;
        Thu, 30 Jun 2022 17:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4/qiBDTLPrBJsSYW11R1PMZ1QPGc9WLTzd+xZVyoUmc=;
        b=drsHGSD5rLLYTrP+VyAgLLWJjh/UhonnZIOEZHx3a+h6gYWLltnqvkFnnRGXImWKD8
         ho2DeT+ze8JDDm35RL6we/tWCFAUB2I+Ous9q/eYQWbN6RASfhWhehr94rhz6axG06lL
         doLgB0SVAM+ke8SLFuqCLogZ967FR57dbjMgSFIANKJXweZF77xknnPQEoL2d/tSmBzq
         UqwXHimBddghD9P1wikn0BxyWO+PFfi5Pz6NB1SAqzcFfsX1Rcfv/6r3P1/djoJStxpI
         UxK6UhVKszsU05R+iy2j0Ayc8PfSjI24Vlv+1FNEFx6AVqugzn8MYL26n3BRtdTq3qBo
         C9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4/qiBDTLPrBJsSYW11R1PMZ1QPGc9WLTzd+xZVyoUmc=;
        b=uJMW/+35p+m0aU5uccjhKI/eCbkVZlw/7zO3ztNaD/UVuqIwecz1AOVuhgIn2s1ylE
         NzhFM3eRJVOEcHqgcBEbcVnyxy8aVbJaTIQ0DaQXk+SV1ZX+ztCz0NtGe1BXIFx97GPz
         LmQvAyHyBaY9H5nndICEx5QZ2nxCugGPkV33t2C/p2C0PoZCOJmZZT1YBNck0R6d/jz8
         8/35oRvYu44BjYbyEs1ABHgu0MJ73RSuzqtnMQtOESlKuNa34LDFBbUajwGbUE6wBMfr
         xwW0H9GmLksR9rHi3h+nwnTx976Oy1Kn+gx/vJZZP+Qz5QDjn3eRvnPc3ZurVi1FQs/P
         9i9g==
X-Gm-Message-State: AJIora+VtTNl9OJsJRQ0ZNZQXO47iT4Ahv7nb7LRmQ3+1C5uJ4XpEXNR
        t1316SaVyqNP4FGbcR/NoyPEzUz0Afk=
X-Google-Smtp-Source: AGRyM1uRBoyZofpuxja4dBuulH81BdDPwTpmZk//6DhJ8tG3mmk7eoPZgBOYs98vq/ShIpuf4PKMEg==
X-Received: by 2002:a05:6a00:1803:b0:525:6ed7:cdc4 with SMTP id y3-20020a056a00180300b005256ed7cdc4mr18113978pfa.15.1656636972480;
        Thu, 30 Jun 2022 17:56:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ml22-20020a17090b361600b001ecb29de3e4sm2639538pjb.49.2022.06.30.17.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:56:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:56:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/29] 4.9.321-rc1 review
Message-ID: <20220701005608.GA3104033@roeck-us.net>
References: <20220630133231.200642128@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.321 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
