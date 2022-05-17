Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D0529FEE
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 13:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbiEQLCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 07:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiEQLB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 07:01:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC22E1A39F;
        Tue, 17 May 2022 04:01:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n6-20020a05600c3b8600b0039492b44ce7so1048314wms.5;
        Tue, 17 May 2022 04:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T2NaD0aBW5bIPc5N03p+AdDSLqYVwX81nDcuNpz7RY0=;
        b=ky0vpFLHk+RtRtKyrfJ1uP5pwmf3E7URo4h+90VZWOMWa2bP4Zhwq9lEDXVD3wV6ai
         xCFH8djSYHHDB3eAI2p2i4KlrqAXTSYY6Nrr1x3K/UgkdwR++AjZyV30jHTumWJTNoYY
         GAFXzTe0i/O+Q3zf23BAydDJpCFUlNHOmjBVrzH9/qLZWRNhKKuYvVN6f+LpbiSfC7gE
         Usii7vQwgoDwNiS7EWpiqAmeVS5R+DdBET+IQ9TqaEcJ1qljpE4mJnI9J7bTQhx8Gc/h
         VCCLL2NbClxB/aZNJDZ2CpmrPoaVYrdX9QOFsBl61p2O/+Y40EBOzNAW8qp0q5oBdcUD
         Vw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T2NaD0aBW5bIPc5N03p+AdDSLqYVwX81nDcuNpz7RY0=;
        b=H033GDed9pKomzW0gYuPrlJ75/9cSnG/2S7o4rJMUz/hsUOdJDoeE0StGf6sREn3mS
         aTcNPPm4i5gfnEJ9dQEMqEk19jSE7pEaYapIIBOEHXM9AH2G4Dnj7bR6a5GDiTg6HTEq
         aOuDyQ1gJFvWuek/HOHSg8TYspoiZqufbFG8VQcfdXtmfprPsozTAiD+rtrJ9H6rsfT4
         A7ZqMMrj4AK4W4L5ruwOjTy6LuBgHWnsykBR1k7Rpy0M/LuAvRa4+tigRB2m0pliIy5C
         ecqtfA4PfcYSDnCO8dGanMByvhuRzDyreUrPDrbIPhNPzvuzN9cXeGAgA54Fp4DqZxqQ
         WlEA==
X-Gm-Message-State: AOAM531AY/XC7V+s6LnS1FH/KdiXLoMHCxyqsMUO9ZmRRaLNiEvfflIP
        zcju18Jsiv1kwsqP712l5iw=
X-Google-Smtp-Source: ABdhPJw1J4YM/7stv+AeQqEbQhauu+I0Wdjk4FGEzRCe5IwhMzrtiKPyN1TVudHq+Fn/JXL4GHexvw==
X-Received: by 2002:a1c:3587:0:b0:381:50ff:cbd with SMTP id c129-20020a1c3587000000b0038150ff0cbdmr31554750wma.140.1652785317408;
        Tue, 17 May 2022 04:01:57 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id f25-20020a1c6a19000000b003942a244f45sm1552037wmc.30.2022.05.17.04.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:01:56 -0700 (PDT)
Date:   Tue, 17 May 2022 12:01:55 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/43] 5.4.195-rc1 review
Message-ID: <YoOAoyHpbUy+J58h@debian>
References: <20220516193614.714657361@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 16, 2022 at 09:36:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.195 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 65 configs -> no failure
arm (gcc version 11.2.1 20220408): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1155


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

