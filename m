Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4716779FA
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjAWLRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjAWLR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:17:29 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349A51E9EC;
        Mon, 23 Jan 2023 03:17:24 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so8292914wmq.0;
        Mon, 23 Jan 2023 03:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8RXJKIpZAzsImUbnBlvk5rvp70BYcaKy5ZQ6jEsvD4=;
        b=eUK0LougOfbiaHnGbcLlkrz5wPfXRYEySvHvSFGeWQnCGq39xT3/khprk8GhhXGXrn
         kn7rtvfzf0NUhMTZmPyREGuJ7LtEoZLx0VJbk9Oyspf554j7TtKtNYe2ZCrACSvAiwxE
         nTDlNDOSfHSkH3kMtizM+H+27K0Q5lv4jJcwf/HHN2oO+32/3VkgZ7T9ThULvbkGfFXa
         1HL0HshWPIyIsdTfjLmPMJPKS+YkIYi8HY/L8LW/6iCWxLYs4dVzuTNa3HGaSdKKpe1X
         mXAo5GZfeTQsGGMOcif+fDZv0NbxOJ6ScYgnJBy+4OPFsHZGV9JUt801qTGK10aZuAjR
         PRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8RXJKIpZAzsImUbnBlvk5rvp70BYcaKy5ZQ6jEsvD4=;
        b=y0/PV2sModCdlIHHhC05AKCooYhIYjDdNiZRvvJFIPXbtG3k9Rm8f1Q7OdjpbYdPJD
         R+p4B2P5wpx5Ca4S1gsOyNYtppuWnRmLDdi4D41pWM2UR0ISPbf4jN6/4YUltXRkPy5Z
         vQ1RR8SYn4Ofe2vKOquXDbxzf7kn+aUr4DNXRRYpi3plAcy4Kjs9Gp1byCnA0gIOrb2v
         EV940rAAUvJLZO3k2QdWtfsoRoPuWDwTCQzWwf7tvrutRFJGu4sDF64M/gBFYOpP2nu4
         fxDWKLl4JhVjtfkuHyJH4Ru+nXvybXiCJd2X0NKMKhQYh3BTYrVp9vG8OLfbtybJsoEu
         Z+Nw==
X-Gm-Message-State: AFqh2kpvREBragO13oVUooSTphmAoLS1qoXcDLo0gCbopS946XlCvzC8
        fIlRsUeJbvWNH0tBmHfLIOAoYfEbAjA=
X-Google-Smtp-Source: AMrXdXsahbcKmGCEM+1XFhaWI84GK5PfbdpvjTupPmlH0P6XjBqopMsJSGNYRRJ8/6DPf4HpS9Oldw==
X-Received: by 2002:a05:600c:214f:b0:3cf:7197:e67c with SMTP id v15-20020a05600c214f00b003cf7197e67cmr23612873wml.25.1674472642640;
        Mon, 23 Jan 2023 03:17:22 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p7-20020a05600c468700b003db0bb81b6asm10969686wmo.1.2023.01.23.03.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:17:22 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:17:20 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
Message-ID: <Y85swG8b0cYmALky@debian>
References: <20230122150232.736358800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
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

On Sun, Jan 22, 2023 at 04:03:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2697
[2]. https://openqa.qa.codethink.co.uk/tests/2702
[3]. https://openqa.qa.codethink.co.uk/tests/2707

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
