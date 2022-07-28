Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFC584210
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiG1Ooo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiG1Ool (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:44:41 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0062A11A28;
        Thu, 28 Jul 2022 07:44:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id i10-20020a1c3b0a000000b003a2fa488efdso431009wma.4;
        Thu, 28 Jul 2022 07:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IRQ8c2L3JLJa8KExAV2T24apu/+2cMu4sYdyXBwjm6Q=;
        b=MShn1kAzWvQyrXokQ5UMfU98wJPbQAQOZRvkMOOAMcxhaTQ2y66w9EqEc8UV+/RFWc
         ++60fhi1xF9A6DEx2+62tRNTQ2ORT3O+Z3CWxD3AxEtDpXpxgkEMSZx5AFrpPOYmMbNK
         lsFRw/1XT2jl5Yo0Jqc4V+xGLys+Ds/D4J7US3i2Fdcu92yWOAHvxRJaG3pprC4iWh0Z
         R8Km9l0bcD94GNFl8oc51gGE02VMbKG7TRJmDNuFxvHM81gpVxf/vbKffydzgwA48hiP
         1SxlM/BGZ0pS5V58+EKO3mJiCFI2Cb6QvFeCydBdxbl1e1w1CvCInvvYq6GAxpYTJIvH
         lhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IRQ8c2L3JLJa8KExAV2T24apu/+2cMu4sYdyXBwjm6Q=;
        b=skMSjVf38wn7ey9xguYhy7mZzF895fV3EegSOB1v7Jn2BwLjc2at6zu3/l7iX7Vzg6
         zqWdLrxuJmTGaa7b5FTLG9mEUX2XkAq8uLbAv+lN8teSAYoNibiBfuZSYGcuDaEzx9eK
         OS6VcsvgKPKFhYwL0tvB/xP5qH0un/vi/JYNdecGam4Yy8AemKtgPN4bn9ySn/xK3ehE
         UQyNldqU6eUKo7Ge2OZ0oAeKKXoqhqwYqWmdwv4hQvSIXg7DV6fKnWGE+bptz2+HhVuI
         mgui/qH1/k7pVRxzAhNhUFy9AQVp38DOE+sxA/PWsZySxirKJd2WsKdU6sWeHBDnZ4tt
         IAiA==
X-Gm-Message-State: AJIora/BXo4xgguM53gBuit4kw4IsGgYPUJf+ZL5A4RB4jbjbtNZQGHK
        tB79MH9igh7TL0Q66okCNwqM4c1hPbntsg==
X-Google-Smtp-Source: AGRyM1tdc7tnAm1dZA+USXTn1cunrkVm9kUW/8+R8wD+fU+vJ9+qs1qaXNWkn+ustZVXxUHQl7Gglg==
X-Received: by 2002:a05:600c:1986:b0:3a3:490b:1fd4 with SMTP id t6-20020a05600c198600b003a3490b1fd4mr6546981wmq.140.1659019478460;
        Thu, 28 Jul 2022 07:44:38 -0700 (PDT)
Received: from debian ([2402:3a80:196b:933a:553c:d695:8a60:6d86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b003a3170a7af9sm1675939wmq.4.2022.07.28.07.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 07:44:38 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:44:27 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
Message-ID: <YuKgy+5Me9LRxc0i@debian>
References: <20220727161012.056867467@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:09:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1572
[2]. https://openqa.qa.codethink.co.uk/tests/1576


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
