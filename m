Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6B54C47E
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiFOJU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 05:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243069AbiFOJU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 05:20:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53D827CFD;
        Wed, 15 Jun 2022 02:20:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c21so14529374wrb.1;
        Wed, 15 Jun 2022 02:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=elQAkg5DB8T8H3RqJKmnGCMYC116uCjBBNaxjM3AwoE=;
        b=kuBjqGZT+jKPREEWOlkCxbIBo9MH3VihqYlrX9oyCeZBIriJqRoW5dVfdKalPnmZPV
         qqvHi7f9NxKHzsJ92oiIXehiLADFgoiFrHvQ2Gy12rnMJyXq4nEM9kGjujyGMwKYY5i8
         M5+W75eDlvJuVF2WL9LKendHVg5e+03Mi3/nOa4AXwV6aKnJ+dNHRqbuLQNeCOixdN16
         Kt/ZiV3zXVlp7bL9W5dhHam7/CjPTnKyvatbkwfz7/uyPxUC5H+Q3t5FZFBJHRhsz/cP
         ofHhoN3NripA/TWivaruv6F+Z8HoPMDGDemB7dE3JMXIgniiZcBrhMtrdnYcz1vyfJlw
         MRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=elQAkg5DB8T8H3RqJKmnGCMYC116uCjBBNaxjM3AwoE=;
        b=gc2v6VWIuwZyz8X+kL9vLDnnloxOBEBsajWwyrW7QSHrn7RbEhFfRZfTKA6BfFk/K/
         1kKY2/vnKHEo60Z4EuLAom0OIL5c/qDIqdLq13qVPh+4axVPnPnf+FxAlk4jUumPc6uh
         bAOwhYk+JMhloWct85x0n6XDJCXwplayV0ljguOvSLTXSVR6mrfgB4csiPHHXs/gHm+X
         jd1LQtl8B5rBqiAt10tvNI/0X2BYlW9hvWoS+5lZ8YzRsrArJT3gkd58qCWG092lMsu0
         0xK1chyjU6sRuF2v7DeH9+dSvjtjU9M1GV7tZnZNn2+NTlR78lrpEjhmjlWXcadMzgiB
         tTRQ==
X-Gm-Message-State: AJIora8CScRZtAbpqEIF9yv2i3LcjOCvz3OuVmAspWuKSKzPC3ogGaVZ
        ZGV8/g6c/mmegur6xqqBi1Fymi0au1U=
X-Google-Smtp-Source: AGRyM1sqaV7qINy6u59+1oSk7Vh+IKdIWUoRPG6plzryQyxoWEJdFVUe+Lj/oGM6VQCqXSqT3o6lyA==
X-Received: by 2002:a5d:5c08:0:b0:219:e5de:72af with SMTP id cc8-20020a5d5c08000000b00219e5de72afmr8458080wrb.513.1655284820358;
        Wed, 15 Jun 2022 02:20:20 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 184-20020a1c02c1000000b0039db31f6372sm1888764wmc.2.2022.06.15.02.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 02:20:20 -0700 (PDT)
Date:   Wed, 15 Jun 2022 10:20:18 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Message-ID: <YqmkUkUtmHtSMEN7@debian>
References: <20220614183719.878453780@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1339
[2]. https://openqa.qa.codethink.co.uk/tests/1343


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
