Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD33C3425
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhGJKi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhGJKi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:38:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A46DC0613DD;
        Sat, 10 Jul 2021 03:35:42 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k32so4625248wms.4;
        Sat, 10 Jul 2021 03:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dcSyZFSEG0loDKLZubZ5JAFm+UMtmBmBucKpxAj96Ws=;
        b=QfH4mxIgzc36vzXrac+w8nFN6pAtw4HRe8kGuKYq3cX7j8PZT1WOdUCejCJZIvR6Aa
         JbCyueYqTAW+6yifJFWZPXDbCBJQ8rZK72zHQ8mout/N8wVNwLN6O2fwLbaDvKbsF5KR
         WxvFWcJJvzx4oGIebzLy9Siz27pT0TJNzV8DiYImUf4RtSAn/rwSvo/0F0p+r5V1UfyO
         cuUiQu0DYNHmqB+wmfQYWPbrXFjGV+BeJfHPA3uYuZiQSK7Zkw5qWhpGiBT3QNGTr1IB
         xF37mxcotUbev4/7IjsVDa7R8OWRswj7c+AgYw9NyOAonRzWSlXkqTMAA/2/DLwkfeno
         LWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dcSyZFSEG0loDKLZubZ5JAFm+UMtmBmBucKpxAj96Ws=;
        b=tasBW4M9HgCLBUaRIB91dEQBE6o6yEls78/vS0au0Pi5J/ooS5q2oxSnq3BrUSFQ8X
         OplVBVpfZq3ropGwZvTkyS94TQKDu+MB5Nz5MQsQmunTPUfX6D5/xOP+SHPWEC07OVnK
         y1xKH9pm+xizMcd3KLbZGSI8F01+gVDL0pT2fmgDMnpFrxWiBM9+FbiXALIucsNIFqnI
         CCoATOhjO4Jy8Iar9mL5q/BexE3V5cFY7MlaUQNdWJ48pfUuA0SFYDb2k39lmGDSEgZP
         DevMVsh8Or59Q8+/uX5woRg9OCt17Sli0EcYc14jqQJPFadflV6R3wqKhxs9HxM3Dc21
         47WA==
X-Gm-Message-State: AOAM530+efK/JXYYP2g4x7WAe5zq/Oqy9YSHZ6maKt99fEtvFIE7Flxi
        ZLwa/0+HvMJG6PD46lkcWXQ=
X-Google-Smtp-Source: ABdhPJyqt13w+hypjmmawCwLRMu8eaCl6VeQkvRjpRT04Ku7tfQZh7TyGcl9lqvRXk9MRka113rJsw==
X-Received: by 2002:a7b:c113:: with SMTP id w19mr3869916wmi.44.1625913340822;
        Sat, 10 Jul 2021 03:35:40 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id j10sm7828166wrt.35.2021.07.10.03.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 03:35:40 -0700 (PDT)
Date:   Sat, 10 Jul 2021 11:35:38 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
Message-ID: <YOl3+sfdmTK+1M8g@debian>
References: <20210709131537.035851348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 09, 2021 at 03:21:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
