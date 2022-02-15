Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4074B73AA
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbiBOPp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:45:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbiBOPpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:45:40 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C47B250C;
        Tue, 15 Feb 2022 07:42:37 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v129so11578870wme.2;
        Tue, 15 Feb 2022 07:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y+bDBcR0c7hXTx1K3Rg+9ZhzPuyWp38ngyyjtP3qjek=;
        b=gxbu+Cbr/yPt9Wjr3BEE1hIdQA9g/qHkFZNkOR+9Sh63WS+YisL/YE98ncV5IgXR8b
         /GwFcW+uoi88TzXeU3fjg4I+HCECR5hbsaknN2/hriRa3YvYa+c6tgbw4FZnbjhONUZx
         JQrVsvbCpAWNUJxZvIoIr7wB+BDmOu8F+Sx3BMQA7ruAhVu2Olkmqk684Xh/WkidLTeh
         w7jAjz8UqaWIZZqHgnIiR2Mn/0+wna1K5cf03gj+yQ5KzkqvhHpsqjeDrqj/WMPIog4l
         Sp4zUsTNs7iiynwce3UiEbCxkqhSDdWS3385J7KwmA3vBMr5wNltao6YGsVZgy5PdZbM
         iyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+bDBcR0c7hXTx1K3Rg+9ZhzPuyWp38ngyyjtP3qjek=;
        b=3gThKW/iNqX+n/4K96sWNteM+ZrrR/HKybl7f/LwBdC5YH6QJHmqnV6jE59txe8BDk
         tcRBNR3phcN6TSo0fMesz5y1Wu7zJFVpdRN3mOpx/BsbyvG648Rcn2AkgtXagLKuVESf
         ql1arz+IKlrlq0NjVA8x0ql/VEUoDdgZiwdo4HgTTSblLeyb+Vl7QZgEo66V/jHsa7CA
         3u1Q2IrnPG+nop/Hd4fntQDzygruyZf90b3M8iOSujSnDgBM3dkgqHjGGaDaTDLCToza
         MzIqlHqGkKbqq/DNp+uE4W1IFFkEuvpMN8XG7+xGuafg+EjiftGurnq9z0i3JcJ9s76H
         Hhdw==
X-Gm-Message-State: AOAM530o4Yg3DZrqFDGl9OlW9gKATkVO0tuUVFuIWlyNnOmaN8rdOYBA
        +uJd1zbg27QTQM/A9Oq3rhc=
X-Google-Smtp-Source: ABdhPJyhEWW2p5tjCHxFPrbLpNe6DQ1lIp8aOpR92m4Pd0ZBfU8WztlyZTGyoLsHkYCuCRzTR4z7ww==
X-Received: by 2002:a05:600c:2e53:: with SMTP id q19mr3485312wmf.189.1644939755764;
        Tue, 15 Feb 2022 07:42:35 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id z10sm15167469wmi.31.2022.02.15.07.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:42:35 -0800 (PST)
Date:   Tue, 15 Feb 2022 15:42:33 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
Message-ID: <YgvJ6YMPja1dQbmx@debian>
References: <20220214092448.285381753@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:25:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no failure
arm (gcc version 11.2.1 20220213): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/759


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

