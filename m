Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC30249B74D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581716AbiAYPMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581480AbiAYPK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:10:28 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288F6C06173B;
        Tue, 25 Jan 2022 07:10:22 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id s18so20468209wrv.7;
        Tue, 25 Jan 2022 07:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b+aJqHjUM6wBLG6fdB9sZHHDOYN7JvFJNs9aC/vUzpc=;
        b=l8o3qd20zXDphPmRbrbOrku69rKa3Gzy6rv5qlG99dQmTNh07FWavpjUsiaTCKDB5o
         +ftfYgrl3DkzZ/RL9aAI46svrvfTsa/kEUB/Harz02ODSbXK90QQuDM9UMe10yDF8tmz
         rw7bQTO+bub05fwf935TsKxMvDAaoxXGzilaX9n1WVF7MjTW6A+HENQ8gS3FeqrC6Dwk
         VhzQ5h7S+7QHt8E9MULDbfHqM9k0ckEVrxIaoNiB2blmHuvjwbvw3a8ySzZbTU07URLV
         /rIuoL1stTJIRGb3FmfxEhxS2AWDDWawSCjJE68kG4H/tdR2lmbGkagGizYNb+MJ+Two
         i6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+aJqHjUM6wBLG6fdB9sZHHDOYN7JvFJNs9aC/vUzpc=;
        b=HUNQIjzMXShbOJd0JI0YHIL9QRftGFWsF+IJVMrxJMBCQaXrsIkGExaUVpPIOH4dgh
         5Zq8E+5xRLV7a4UqtfwfdCLfIIIN5fbWnPKpb5x7JqgX5ZAxF3F2NVC3qIXW167jARB7
         uW5mA8L7uk5WfqnjkmoVJcsxZnVHjM9RQlOACnCo8+lkbQ4oyQPd3VfoapktlLt4rDwG
         7TxNbXoPi3wPIifSuzb0sBSe7CTUl1NZH1CreansBEBGEop8sWmOviVKQut6GUHJuU2y
         Lr2GE+uoe5PyVC0xhu6idxm1LZ24EBn+xp6HFGfKaiZ/MXl2jruR0OYjh8Uskb4PZLtH
         QmkQ==
X-Gm-Message-State: AOAM531LcdybWMR8Lzn4lfRBlKTV9yLEXvcxCXMdLI8M5C4G59bsURvl
        LnQ55fG4SixnC+PFdABMPHjEq4GxADk=
X-Google-Smtp-Source: ABdhPJzyphbfb5sUPiFf0+9NZAbs7VDikz95H6KcIbKpEK6UTiiJYjbTYFH8xzSgjj200JMP4LZO9w==
X-Received: by 2002:a05:6000:1549:: with SMTP id 9mr4997354wry.210.1643123420731;
        Tue, 25 Jan 2022 07:10:20 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id k18sm851349wms.14.2022.01.25.07.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:10:20 -0800 (PST)
Date:   Tue, 25 Jan 2022 15:10:18 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Message-ID: <YfAS2pieDqCH1HnC@debian>
References: <20220124183953.750177707@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 24, 2022 at 07:39:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/652


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

