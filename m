Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37213DEB0B
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhHCKhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbhHCKhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 06:37:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1592C06175F;
        Tue,  3 Aug 2021 03:37:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d8so24759080wrm.4;
        Tue, 03 Aug 2021 03:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fpoN7+6ctUN94MZA/0xjA5IQK/DNOyQCV78r073wnrw=;
        b=WMebsYiRmVITT3E3AoVwdUn1GBdEdUBoureKf7Qc7P3/0aSTFflaVfINhUrOICLURP
         cRoI0DbgNtJld2IAAhXOUYNwvt7R5/b1jR/QlzzGvihNM0p/+ZFiUuoUYD23JYfqMZzI
         SJ5r8sS1ArbIh6lMdMkWg3oJpr82W7XexYM+n3N1ckONKgqaNSEdlvvTQ2NPFVVsGU+G
         xyAkZuwlg5ZfTIc0XsECnSxaHiggJ8CPba8f3wn50XNxfqgrMKzeejjUIqST4u0cUwZq
         hkI7/QO+kfsHqaJ6p7i9Y0Xx2s92FY8B9TMSsBC7wyF9/aQZldl2SlTS0uPb2Dh29NAK
         isaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fpoN7+6ctUN94MZA/0xjA5IQK/DNOyQCV78r073wnrw=;
        b=jRvbj4z8swYwvCtqB94JrMfYkolOHuOqjqAtW/5XW6DLdqioq0JwZky4UkzvaLFgVo
         hsP6h9AEvzvC5ubAmkm95TmqiCc5T/LM7lUBdauILL6kUM6IUB3/6oJdScdovysJvqGN
         K8AQ3XxOtGJDwduSSngVSXqxQwzvhfX9yxjHhIFQbgv+gAmvczMHvtKrIBvQLPuTW9An
         PADye3dAEj4oXQw7Jp/Kyr+rOpNiYm9zalslTK36+sej8F6G/m5DxJ1Ocl9O8Z1eQDqM
         KUEQRvV9nUMeTb/PdKPEGZKelrx9cPwqublabmIAsT/9j0KwuRnXIvcPjVFx4PN6J+/W
         2R2g==
X-Gm-Message-State: AOAM533L149pX+/1aQjN8zVkhMBtLjB7y3Rcm1Sd+UnV3g1caM0TElEJ
        +tdlEiYdXqCktUpuYIoRyxU=
X-Google-Smtp-Source: ABdhPJzMMSFNiAmHXWtJE3fDy/V2q6TLj1EF0ulhoJAtSx+zq6TdjPPVLnbkYOqM32/inJ2JqJ8HYA==
X-Received: by 2002:adf:f544:: with SMTP id j4mr22590390wrp.51.1627987043515;
        Tue, 03 Aug 2021 03:37:23 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id c12sm14328305wrm.29.2021.08.03.03.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 03:37:23 -0700 (PDT)
Date:   Tue, 3 Aug 2021 11:37:21 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/30] 4.19.201-rc1 review
Message-ID: <YQkcYYWLKHArXyTC@debian>
References: <20210802134334.081433902@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 02, 2021 at 03:44:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.201 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

