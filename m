Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12F74A604A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiBAPj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiBAPj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:39:59 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5AAC061714;
        Tue,  1 Feb 2022 07:39:59 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h7so1044114wrc.5;
        Tue, 01 Feb 2022 07:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2URJrPu/e3Nm6PXx/HVm9E6NvPD3qyIMT6b1uCjGL60=;
        b=UTEATwhtC1TNhFJX+d5clvxusq/DMr7Y+HLCSbLNgpt7naTHqIPZ4oK5JYHbzWqllx
         ZiCq1uC2SwDSuW40mmCp+xXYD3g6MqkXsUC2HPRYPBaw2pJ59YoP+UjwlUB5n9WPZ3Ay
         bizbLEYqnH8M7F2G9LHtUaq7O61zq7mbO587hzBLPVdUuB5lSe/xZFSriNk8YWxf0hTS
         Hwt+oJ3X+i16M/CRKVR6x4MQ7dCBZwpoP1QlBUD/EoB1ykbLxhR8Vbwkv+E79agy8t1l
         oGJAqZwpHprJl9IgABfYJvF6MjliRAegsyqMkUSdDdkFN/v11O72usAEq8JVdtloPwRv
         PwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2URJrPu/e3Nm6PXx/HVm9E6NvPD3qyIMT6b1uCjGL60=;
        b=acKnBy68r7FmLERHIgzGaVM23RrItkVX9+/5SMcIFg7uGzxhJABRyfw1eHSoGDGeXM
         WFcr41tI8SLIOCpUj+GucGu+wJdayZOtznog2vbJNBMdb61sry8nOA9M/k7bxautxUqQ
         b0DONQV2t63pqdBe6vPP+GWdBbTaCXhXoxVU8gKcA0q9n2lmy+iYQuAee+fJY3AKjEtV
         y0w0YGG8I5GJzOanSnxXatrAj1LD/M1qDNrizInrsy20fPIanfbixEKj+ZJ5LS+HTAoJ
         6Ki5Yj2ndAixsMSkDGMhddSWKIsOs2okaFDX+WY21c7/neo2xXi8xv/09m/WrLkSX780
         VVMQ==
X-Gm-Message-State: AOAM5319Ca1WWKWcPpaGyR2CnUaECojT39pnpNWLFlf+X0+/QjG+zhTs
        B8Y3oD2LPnfGCnq023X8Qx8=
X-Google-Smtp-Source: ABdhPJy0ID4VxWvcMiDln8+Lz2J9iQ4QPzTvISwf8/Z0rnEUX3KzaUFYfZmc596TRAVo7wnOYpG+Bw==
X-Received: by 2002:a5d:47cb:: with SMTP id o11mr22053351wrc.138.1643729997528;
        Tue, 01 Feb 2022 07:39:57 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id i2sm2951531wmq.23.2022.02.01.07.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:39:57 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:39:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.4 00/64] 5.4.176-rc1 review
Message-ID: <YflUS0P0O0wV/dpE@debian>
References: <20220131105215.644174521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 31, 2022 at 11:55:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.176 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/686


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

