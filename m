Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F73C658A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 23:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhGLVoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 17:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhGLVoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 17:44:05 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809ECC0613DD;
        Mon, 12 Jul 2021 14:41:15 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k16so24471629ios.10;
        Mon, 12 Jul 2021 14:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=X5i1/kqUZXq4rUGHBXIKFx1uya/lDQJNsM/Vo4wuzkw=;
        b=HfRbaSIcVNjnaBRSMLR/d+1QmuqnGPfdwa3m3aYVdrgFQ02ZhnmbuUGRnNLGljr+RM
         cPXC6vqV2uscjiFEt2apAASHUTt/G7tcQy6HumzLEbGW5nLYRJnCMuFnl4r/zOs44t9I
         lMM2HE80FCxKh2CoD7r/iRr/PFuZHVoo4e0xhkuQtRbc0KJfYC2HHWW9xHWu5PBu9zls
         ABjTQ0bVupHhCpOJlHxy8wG6iTqG+q2WF160rWqT5F5iyfeTA7uN/2gdRNZFFx93WYK1
         tncl29BwzCmoIVYLcTRBZfGGZP9M4YCY2tqYwOkYS/S54OXR6j326GDvwrjPJyAs1jJB
         UCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=X5i1/kqUZXq4rUGHBXIKFx1uya/lDQJNsM/Vo4wuzkw=;
        b=Zun/gaSRIdtqCF4AS5DfVa8Bx/oYdpzrTUti48NNauV6RmMFMBoZac/DHioPUpeRYK
         kbudUuJurIb3d4SR42Ro8/QA1Xw/uOh2eSDbxuSV8OdCwpafqQ6WJ6d9MeuAMOh4VDPN
         TrJVfMMBMsDL+Gc3OLugQcXdkUFKdO4FrX3d5YHm8uTb4+9685bm+N4LdrW/6Vz5aKtC
         w4z03hwNn6oJkPfeNFm6HtGt7eSyC1+Kpz02maAtrWA+Xjido50uYsC+U50BshrBByve
         UgVG4vZGgk6GlD5R1A1tmMlYuDqic4Wpmtqzk+wboEhSSfu1qfi14pQjvVbXSWSqCeCa
         OzYA==
X-Gm-Message-State: AOAM532+QJYmzFCesZI6Vn/vTYBNZ3BLawc1tzWgqZmdm7JZ0azcK51n
        ea6gZ1v8VsovCThPqgNF0m8QompfwlttNbrKJFSAqA==
X-Google-Smtp-Source: ABdhPJwRqbOKfXeF3nxsdXILTxHFJkqj6AOhP8Rfctll8lhv8z+9XRXQrWLSWw4bbINQqXw4RMII7w==
X-Received: by 2002:a02:2b21:: with SMTP id h33mr878237jaa.31.1626126074471;
        Mon, 12 Jul 2021 14:41:14 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n10sm8818223ilk.37.2021.07.12.14.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 14:41:13 -0700 (PDT)
Message-ID: <60ecb6f9.1c69fb81.2bd00.0fce@mx.google.com>
Date:   Mon, 12 Jul 2021 14:41:13 -0700 (PDT)
X-Google-Original-Date: Mon, 12 Jul 2021 21:41:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/598] 5.10.50-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 20:49:35 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.50-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

