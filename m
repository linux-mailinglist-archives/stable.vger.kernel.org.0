Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74702669783
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbjAMMkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241699AbjAMMjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:39:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D215C80AD0;
        Fri, 13 Jan 2023 04:34:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d2so802810wrp.8;
        Fri, 13 Jan 2023 04:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X38tpZ+1CXOR8qiFEphyCxAvJQdynmpy7DlHdAXUfhU=;
        b=S+LESxdEcTgwaXx6q7qU315zb26Q9b2DxAX9z4EOQ2YQVADUQlXXtOS/cT0MIkC4FR
         T/QWpes0Dw9nuoVyMu+AfcLm5Kl2WT2rX+VbQbJrIafJBEH1pELr1dicyt+MQicsFDSP
         WE0oZnHS65aAafTUAKuuVEc0bPZBWPAsZ4KOsjp+9jxh6fpCjuw/z69XaLS6KMPHx87H
         7pUhgMkyjDlp16i6XEKDkY8onbDjKSyz5IsrfvcBN2ZSaCgrfb6tgncRqPBOHEho2dai
         sgeCeBhJ4ItIH+5wC6sVvqNaTrSKFu63J0zQuZGhq4yjIAZDG0Tjg8oKqUZ/QpmnzJVv
         BjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X38tpZ+1CXOR8qiFEphyCxAvJQdynmpy7DlHdAXUfhU=;
        b=ppBmiKVo/C+lPZUqXyKqmO676kTNf/nshuTKYsyCWDQY7mN2qktKrxEqlRkcWWsQzv
         RW7S/1CNa7ITJoSVjkpz6SwVJfEKeAPGX2x07rOxo+pyAJRd8fppElksC8DU4vwnSmDx
         AWOfjJlYTFZNs8rzLfKpcNUN+XBqAjOgjXXNloApvaanIKd2nxTmaGuUo0TLqQ8xCoAI
         vt3d7k/RFsmXN8LgLfzc+oVm6QEv7rSI5EyxlYY2nIckD7kCnfg0pNDCB1xoDAb8b6Kx
         xyY50XAMKc1aLWHxgi+nNiuWe3r78q1khl3UqcLMOzKupnPLtIkviVtdVBOCsice74N6
         kk7Q==
X-Gm-Message-State: AFqh2krZbHxDxTIRkQihbu2CWSqpz3PZcofP/z7yLV4UsiS4efPQlpwq
        KDdn6rOizpSXIgA3GBOPriA=
X-Google-Smtp-Source: AMrXdXubpLWkRf+lswxGs0k3JkM9S73EMzF7ncZhP8lepyen0bywxN7MJAdwcHMMcA3viZsH2X3eIQ==
X-Received: by 2002:a5d:6d0f:0:b0:28b:456c:1b6d with SMTP id e15-20020a5d6d0f000000b0028b456c1b6dmr53397805wrq.55.1673613236084;
        Fri, 13 Jan 2023 04:33:56 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id k5-20020adfd845000000b002bdd96d88b4sm3345963wrl.75.2023.01.13.04.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:33:55 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:33:53 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Message-ID: <Y8FPsXOMYDbKT9fF@debian>
References: <20230112135524.143670746@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
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

On Thu, Jan 12, 2023 at 02:45:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2628
[2]. https://openqa.qa.codethink.co.uk/tests/2633


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
