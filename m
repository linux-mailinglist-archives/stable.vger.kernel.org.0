Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E4C46D14A
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhLHKvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 05:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhLHKvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 05:51:13 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8BDC061746;
        Wed,  8 Dec 2021 02:47:41 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t18so3264179wrg.11;
        Wed, 08 Dec 2021 02:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OkWOMCAQHmLJzaA36rEP0QlSHNfBm3OR63s6QhneOPQ=;
        b=RWGRE1/oC5rzYOYeX9g+TpwyA5CE9+UjzYc3h9cVE5/MTED8Q5iyesc9xhgDWcVAzt
         yZoLuRoh3lVQvID2rDSpAZaZHeKci1ge16YTBgXUlpXDzGN2OAJegchbAOW/BwELwYVD
         qa+c5UBl3XCnvH3/Z/w/uF3f2tM6CiM1xWmn1qp1Z9jI3eB8OpapmhWYoGAl6g0T4wjT
         FIHk+fq2XDtkwWLnNXJRAI1/3G6Nq9BjLhpdyFGV0UdqGGvyJdjxzF8mCsQdppzMOjWQ
         I9oFSPZkUY+S9lrB4pxqphjyFknZT5KO+uqGPs77Rdus+sgf3UyZEJrCyexgq7ZHMXdr
         ErCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OkWOMCAQHmLJzaA36rEP0QlSHNfBm3OR63s6QhneOPQ=;
        b=OPzQadFLDxDLba0BmgmVZ1AxFIAz5bII4jtYFEHzJ1X7RQ+IxV2tL0hrCC4HIXiOMk
         PWwySXiLqbSeTmXQ1tuPNOVqcFadlqUjotldrH7sZ10mbTlTsIBaHwAPfoaNcQbcH/nU
         zhr28+r/bWJddR7SbVumPAUtRGJVCNrIu9ymvCSfPYlnw7gSHS+94BYOP9tbXda/js/x
         6IrAhqLA96EIdc/nQds4XLTSwzsm355Qg50kSulKve45rA32oodi1QpHFxzKwe/p67I1
         ZtWH3KGZGBOBoGx0aK/KNIYjVXMolWMNvPVczsdCjqlB3vucJ4B78eEavUfRv/r9ZieR
         GaGQ==
X-Gm-Message-State: AOAM531p7x43U573uC52wHuaNkBivU/7LVadVBMJ9uBCfgwRLT9LTW4K
        NS5HU+5JP6TIW9xlvrsWO+I=
X-Google-Smtp-Source: ABdhPJz6DkaIiwIIVRrUwJBHZOURim/jOwS4l4OIGb4QF45eQc0G4ttVQSu7VgfXPTbo/RaapECcKw==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr58132786wro.461.1638960459898;
        Wed, 08 Dec 2021 02:47:39 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o12sm2614016wmq.12.2021.12.08.02.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 02:47:39 -0800 (PST)
Date:   Wed, 8 Dec 2021 10:47:37 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/125] 5.10.84-rc2 review
Message-ID: <YbCNSU9wnAr6YOdr@debian>
References: <20211207081114.760201765@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207081114.760201765@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Dec 07, 2021 at 09:18:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/483
[2]. https://openqa.qa.codethink.co.uk/tests/480


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

