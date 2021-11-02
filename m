Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58CD442E6E
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhKBMu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhKBMu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:50:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE288C061714;
        Tue,  2 Nov 2021 05:48:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so1984183wmb.5;
        Tue, 02 Nov 2021 05:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=26Js0QFCpt18S+Iid6q78U6UMbGWv/LS7cftt7dxdZQ=;
        b=nVVDC7ILCCDd3jwTEMji8Doj5wRg1+Xk9o4tJ7iCGOtJPmUGfLb2AVmqyol144UXQg
         dB4crI47+d+6qkGOa8LhRw11u7Zx//gl54y2Zu3n0W3AODbxG67XVFYqqtC1/ycPmIkg
         sZ9QDebzHzL5Dc10ioj2yBvd/zr/hFjgLU1K1wfmnpi3toeR+eLAXD+cQ1XHvIS/+Pkk
         4gKnVwzqsDH7p8wjR8r5NUPJaA19WkbDLJ2r93tVB8zFb5gCdQzrksdM4H5h2Q9rCBs9
         OKToIEbryOapGl92iknxIBQWXb+imx2jtPXnFQz9U+rkyKaUB4WnXWVN/ZKgqILycYZG
         GS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=26Js0QFCpt18S+Iid6q78U6UMbGWv/LS7cftt7dxdZQ=;
        b=q8KUwFus5yNHHOBBEQJbvRJ4Bpq1UkaXr/pveqx+hCCy/RXPTUEycTmdI7NDWQjakW
         3JPOC1/e0FNBBtna9gH0+yFq16djsRYooXdV0ulyhYjDLS3QqvHhBzBHPsrVFQTGwamu
         wXjPkLZrzpIiufq7EIGcq8/iRP1+iF2snip7TmQ8/iYzu7mmyayXuiRwczLV00Ll/ZfL
         FGN73/bZUWCgr44kZFpIGJQtxLj2ZHlGUmi0wIxDoL51svBPyM+sVG6DhhzSbBh7FID2
         HuAIN0UsQYQJyJhu9vQoHbbwJkWxdEwDAqCIuJbgPzlyJy9ALwgXD4+daUqw6YCt0qrn
         XzhQ==
X-Gm-Message-State: AOAM532B5eQb1CdGVSAWFZDxiAZeL5JBtwXv8GAT7NE4bH+8p7+H4Q8c
        bwMU2NUIdR9c+wiEl2LWeyM=
X-Google-Smtp-Source: ABdhPJzQ8N+l7k1zGFOJLkN9PMDmaMzmmOeWRCxCW6fhVTh4wtt8xJ2K4LSXlJ+KTbasaYC8TL7OfQ==
X-Received: by 2002:a1c:3504:: with SMTP id c4mr6728703wma.160.1635857302257;
        Tue, 02 Nov 2021 05:48:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id n15sm2596551wmq.38.2021.11.02.05.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:48:21 -0700 (PDT)
Date:   Tue, 2 Nov 2021 12:48:20 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/51] 5.4.157-rc2 review
Message-ID: <YYEzlI3V/+BoODRr@debian>
References: <20211101114235.515637019@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101114235.515637019@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 01, 2021 at 12:43:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.157 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:42:01 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 65 configs -> no new failure
arm (gcc version 11.2.1 20211012): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/328


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

