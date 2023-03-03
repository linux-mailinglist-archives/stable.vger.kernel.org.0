Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315136A8EC1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCCBbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCCBbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:31:04 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD69325E12;
        Thu,  2 Mar 2023 17:31:03 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id bf15so399063iob.7;
        Thu, 02 Mar 2023 17:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzspCeKzatS2dHlJS5xRfrp0ZIPDqDnXUo+766wH1rE=;
        b=XT9w7CcZfVj9rg7ZLOcQvEjGva+TrPPYpJpX/2m8Zl8Y92EVMumVKXW7RC00gX5hFl
         WYaH+ttWrcDq5gwRho6aNBYLJhUmS/cNYipiOj1kAtu64ygpf/bCleAH37o+fvBVZUc3
         06E7IrK/zOcWJ2qU/t2PnGxuZsBJGO/N9N5t1Jg6qyVqfpm0PFErecdMezoYcnDC0G1o
         wsrAMaS0RH4qYFfmWu723yW+ubGp+kNL6XUv01s23xqGMUfhgjrTPtfBCZ6Xc0ujwwnK
         0DBFlyYCo6yQDwaEdfcf/y9ZuNHDZPD+OPap7Bzxxxh1UUjJ8V/vRxXHmIqPRjkFFUEd
         MBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzspCeKzatS2dHlJS5xRfrp0ZIPDqDnXUo+766wH1rE=;
        b=uuj7VxAvqK4c4tjiaGxGba32oG9/lb6roqo2AdUi/BIbmQimmueSCu+nS/7v+3TUc1
         IjNB0uCr7iUQnCO2A9eSSAr9lZQfLDzFj7Hd8ARP6jlh1Gqv2g0Gr/L4Nft5HNubiyHx
         BEpdVO+4h0ZZ2wg/FqoekL4K7lrX2d31Mdznbl31mN/pRw7KzdrsK3c+0uNczEgzx7aM
         OglwSAe1TIWP8j0AXD9jWD3e1VwN/gvr0ZO6i8/IG3I/Pqg3F8QH+QKJrMNb8NEhLQKR
         KnSxf42XtsWd9z4eY9WyDdQqpau3JD3PzqgvyEUmjCJXUqLLW3QGLiZ1E2RpUH/yNYNJ
         m44w==
X-Gm-Message-State: AO0yUKULm+AgF4Oejx6i0rCnc4QykqPx/crWeeUxBRyexl3fXELQw4WM
        4pp/7IvWF093ecQe5uRxzAI=
X-Google-Smtp-Source: AK7set+9h3VwScmqEgiAbGgNbIv534jlg8DPGcX8occWqWb75za9S8xYv/exhE9KTWugE3Z1RXcsDA==
X-Received: by 2002:a6b:ee14:0:b0:74c:91c2:cb05 with SMTP id i20-20020a6bee14000000b0074c91c2cb05mr7573825ioh.9.1677807063309;
        Thu, 02 Mar 2023 17:31:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s4-20020a5d9a04000000b0074578972b86sm296978iol.30.2023.03.02.17.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:31:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Mar 2023 17:31:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ae047122-bc72-491c-bbef-089e0d70ab10@roeck-us.net>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
