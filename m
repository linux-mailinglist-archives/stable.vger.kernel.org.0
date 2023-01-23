Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6F66779FE
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjAWLSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAWLSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:18:33 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2D7C173;
        Mon, 23 Jan 2023 03:18:32 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so8275009wms.2;
        Mon, 23 Jan 2023 03:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DazFximn7GhayZRclUHvazRiYgiu+ilAdGVHp8MR6CA=;
        b=bA0bgyR0lRDzu6nk1tsLirtdVqJOHQtr4QxqFroJVkoTnz1EcZbQ95USRefy7GQ4Cm
         ELoAu0RR/KqA+ztS1PRjL0oOue+H446d2j6YHc5e7U/CjsmS1P+FK1QBiPcXtk7qYJ/o
         hT1GhQpy2rEdNM8+XCVi16NWrnTU+0yvfnPMWjUpm1Gd2XU8EaspygIc5qHdCp7u15Ko
         CqRCSQ5RaJqnwmFqLz6Q1z/tmwzY2rAB7si4xaCv9kF/wFRPDcmqpD/6YNsQiAwkpHkj
         FxKNHNVv49cNoS8UfDN22nC0mMYMR/McL1sh6zYKW5CHHuMQwDHdqTCzrX0PIqdJ+bFj
         htNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DazFximn7GhayZRclUHvazRiYgiu+ilAdGVHp8MR6CA=;
        b=OBYsgBOUcejZhSx6Za2rdDVLT+w0BrG9Q/l4c17lGW9xcLx1q7jsVMQcYhEgzsIZTn
         orsYSXpeQLrHyzrHk3hidAHu3NH3c7eSv+ko5x8K1QDOGRHDK82ocCXmKRP7DqljUgpX
         u2FxKuzEzj3BwReKwYL/9ZzXbHrFdkU0qcvChKcsU97uVzMVjbqxXlQ17OIGQxZN6F6o
         SgeXPU7XnXBhaeVENyan77tA7sAsUGbV4JSGLCQrlexhNPDoyotcV4PAlT1D0PuhO8rf
         T2mUbXjab94YtgpPsIXkXjCh6XYGSf7pOQqyUYBGC/zFpOaNt29PY7MNOuITp+LqakN8
         nVBw==
X-Gm-Message-State: AFqh2kr8jnxnqyS5b14hT7b/n9zsXSLInL0prZWnPf5wGhfRArkF2+eq
        zvFwA9gXt3B5N8gu12qySSk=
X-Google-Smtp-Source: AMrXdXvc/DLUDDsnAF10BfJgZnTtmr9DwugCbLSsoqkVfPKvl4zXiHLOLaLPeldEIP6M5oqX6RJq0w==
X-Received: by 2002:a05:600c:3555:b0:3c6:e63d:fcfc with SMTP id i21-20020a05600c355500b003c6e63dfcfcmr23392889wmq.35.1674472711209;
        Mon, 23 Jan 2023 03:18:31 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f18-20020a7bcd12000000b003db0659c454sm12223651wmj.32.2023.01.23.03.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:18:30 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:18:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85tBSksGZK9QvkI@debian>
References: <20230122150229.351631432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
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

On Sun, Jan 22, 2023 at 04:03:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2696
[2]. https://openqa.qa.codethink.co.uk/tests/2704


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
