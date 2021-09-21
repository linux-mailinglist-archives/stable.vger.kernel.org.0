Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBD5413A7F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 21:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhIUTHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 15:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhIUTHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 15:07:18 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39579C061574;
        Tue, 21 Sep 2021 12:05:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d6so42050277wrc.11;
        Tue, 21 Sep 2021 12:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=64fr42rRlj4ybtHs591h1vo2dWJufqwPjl8GwuWC/N8=;
        b=FlhuH+N5bqAndS4e+VTPBSc7kdXaTk79EE0dQAfARW3KdHZC903kU4a9eAR6rcKmKy
         RoEOwEOujDEzU81TI/P9vS0YcKYz7eoLxStVzpEY84qGM6HqqSJX7C798+wYs5OZc75F
         DQLBKlt4L03XCiTTTw2zdGIfc3L/wjNMxCvYUXkP518gVplb0iJvL/mgolf4Wv7uU/hF
         9xXiP1TcSCA8Pf4tEU1Y3Fn7qSnkIfX4mVHE8RHsFgiPeyDKFg3139kwo/dXJfuxInx/
         ht+BbMb0b8/iiLP7nwix6iQc8g1lW6ncyNhpA9HGZSf7CKpXOaP703Ct8oSiecq6Us+6
         mnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=64fr42rRlj4ybtHs591h1vo2dWJufqwPjl8GwuWC/N8=;
        b=HePC18+9I7jHfjeHD/nx5cziWfaMkJmZQoc7bC6sH77rPzwFOHJLdyi30wjLOocVP3
         yEzGYeI+oz5S3p1EQDCFQY+xfwXhR06ZNMgFfdvJhWrAPpJam2ZljaH3Oz1vqjdCeoEu
         dO8xCuagmZO5RnYM0MJ3QLLkjy0Xddr7zjKl+8ZaLGQOvc3+m4wtxBSnlFM2Ze3H/xIk
         WbrC7OsWLJEy1tSmqgU4rV3FJvp2qvh1UDQog7BBgSU+wG9X4l2ff9gcQB1XFoKE0/X3
         wMW/r6bhHGI/eD0C7D7CbhM+Jd/9cXZ+vj2ygMzwbTZ9K/fjnC0Ra3mPaoJ5BVr5togU
         RJVg==
X-Gm-Message-State: AOAM530DCYNeLVdAN6ZjFeL/Q/Brho83jTeVEPrYoCasXh3EOHwGhOaE
        SQYpmNPXRLfKAgiAR/nNEVA=
X-Google-Smtp-Source: ABdhPJxs9pTj/cc3dczcSPm5RKjKJ20FgtLHfolgWy8NQpOW5j1MDKYmZaj2riZ7C+t9opMIfdUgJA==
X-Received: by 2002:adf:e74b:: with SMTP id c11mr37645980wrn.101.1632251147855;
        Tue, 21 Sep 2021 12:05:47 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id 10sm3490472wmi.1.2021.09.21.12.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 12:05:47 -0700 (PDT)
Date:   Tue, 21 Sep 2021 20:05:45 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
Message-ID: <YUotCVz8sjwnO32J@debian>
References: <20210920163933.258815435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 20, 2021 at 06:39:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 63 configs -> no failure
arm (gcc version 11.2.1 20210911): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/163


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

