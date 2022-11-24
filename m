Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E266376BF
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 11:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKXKrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 05:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiKXKrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 05:47:01 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F2D15BB19;
        Thu, 24 Nov 2022 02:46:58 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v1so1849652wrt.11;
        Thu, 24 Nov 2022 02:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBGmEKa1taT9s2f+pNmogNOTs2QhvuGYkyttP/ZEg0A=;
        b=KKtTGM+Wqckv6yNTN+FgPmssH6e7pdpSBKoiOULlqzOxZBpTZBCo4H2RgwsARjGXhF
         pkjtIEdbSQpTqeYO9z28dL2X1A5lZ6j2P/uBTS60gjVtKoEbwlI6uozq+Zdj4t+LpBk7
         b4lgDw9wCtGeJ8IpNZBXWoErkXKWRatXAauILRhdTmWxzRLnhvJxfpuRsluSPnF7Bx/1
         Ymg8+VOpEz27ldGZUgIpL/EQK477UCLbO733OVwrVCkzIAdPIGGted9+T55HSiamS448
         tjkhHYBrwfKQ/OMFAXNnGZQ6kVCDvA2tTwB/JyJFirF/9D1bYe4wOrp3vY1OUbrpnzHm
         SpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBGmEKa1taT9s2f+pNmogNOTs2QhvuGYkyttP/ZEg0A=;
        b=qwHWyh//nAKtRG1e9lMEvpWpZccE2R1mo4F9caaGJnGTWkz1RaUyo9PYabSYJvrXqv
         PwNqfd4120TUqTU7q0tS4Jr/cF1mqMN8QDGnYo48QeK5ETlsJ37uk9B5RTEpJIUg2gsY
         T94iiDT+jtXA510TemKd0y2nTOZGeyYTRiqnF6UNz3g7kne6A/4J6TgKFSZepdttXvfr
         iuHkz+MyWabB5aI/XATO2zbNsmpmluh8sraiwEEpm5x9BT9Ua9F4NrZxMEbelS28eeiQ
         99fFP1xFHh0SbiyjExxO8VscoT+g5tsUMGpYc9/C1HExzhAr7TGBz6LRwfDJksG8H4GT
         OFVg==
X-Gm-Message-State: ANoB5pnANGeSU5rkOuRw2tcWDL06IUbV6qYxdwsj3l/zsH2txUQAYN0F
        aToJIua0usF7bXiAmuoy2sE=
X-Google-Smtp-Source: AA0mqf5AI018JjORniXqYKxttL5b+uUMhffATkG37fVLAjeMp4v0yTlOp1Jqv7OBhtJLBOOzUaPd0w==
X-Received: by 2002:adf:f782:0:b0:236:73fa:c56e with SMTP id q2-20020adff782000000b0023673fac56emr13767852wrp.432.1669286817360;
        Thu, 24 Nov 2022 02:46:57 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k1-20020a7bc401000000b003cfbe1da539sm1298992wmi.36.2022.11.24.02.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:46:56 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:46:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <Y39Ln9u9gwH2aO3c@debian>
References: <20221123084557.945845710@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2208
[2]. https://openqa.qa.codethink.co.uk/tests/2212


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
