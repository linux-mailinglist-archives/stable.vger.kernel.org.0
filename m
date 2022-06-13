Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B624954A1F3
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 00:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiFMWNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 18:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbiFMWNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 18:13:16 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFDC2C120
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 15:13:14 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-f2a4c51c45so10237721fac.9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 15:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lc4K8RsLGk18u69XSrrdslpuv+fN2QSu71JhQ9oZTW4=;
        b=JmybJk1YgjlaeU2ap54ZIJrl853//femtoqOLhzR46grQe6ZYs60dVf8s/NmdUVelf
         n3ytIo2DN/BCgVyUUJpSY4ma9b0RYcmm8VGY29U1Ds3e49Ua/RXiAYCjFMqW1+3ZUSg6
         9rfzZpQtBpyC6VDaJCDk1XVkudKOLUDiaNrR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Lc4K8RsLGk18u69XSrrdslpuv+fN2QSu71JhQ9oZTW4=;
        b=8RHcc69EmerPEYzXw9xAiwL5odY7cej339XQ8iLxN9T3cCA6Q/aQVtumfnGH8RMd1q
         w9Do9NFblTnkjRG3tKbZ/p6JMjCgN7qpX8l84zJzDxitw6WR5TRbUsPzLsvtchYv8zTd
         LMceP+i2DtAnYEgFS3UkaOCfoXc6pmdkj5yqPV4SJSvr+wHq1pWLDB7nfOD7cEWjh+ne
         sKlRNxv2lSYTaOGT9QIxwSqIH5pc8aV4y4ZPSjiVBrl1o4zeXqaVcMPdvCnBFtb/hfuk
         kgmaGHnK43TOSfcswrZs8WBK16A7fR551a3k/ODP8akuC6SfCc3SEpLKej75Nk+Te7Lv
         EAmQ==
X-Gm-Message-State: AJIora/Vn0bvvpc4VFYeHZl5ZC4pfpzPHSQHXfSsGbukJds3dKwkXG/+
        x/QmNKnBU3V32waW1pRnCsCwXg==
X-Google-Smtp-Source: AGRyM1uh3y5oZl+9eZeXsgSG9KmAC+HxwrO4t4/KqDGhylry+qZYX9Vrsi9olNqpwINlAjzfmppkaw==
X-Received: by 2002:a05:6870:b48a:b0:101:40eb:63a3 with SMTP id y10-20020a056870b48a00b0010140eb63a3mr537578oap.193.1655158393346;
        Mon, 13 Jun 2022 15:13:13 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id n9-20020a056870558900b000f318ad4957sm4626032oao.11.2022.06.13.15.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 15:13:12 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 13 Jun 2022 17:13:11 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
Message-ID: <Yqe2dz80Juzd4+PU@fedora64.linuxtx.org>
References: <20220613181529.324450680@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:18:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
