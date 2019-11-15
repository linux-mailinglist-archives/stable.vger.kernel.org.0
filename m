Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430C4FDCD5
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 13:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKOMAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 07:00:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45246 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfKOMAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 07:00:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id z10so10673570wrs.12
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 04:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=xswx1TYcTCN/R8BEco33f7ioZ6ZLAVd47u0UZeI2jCk=;
        b=MUMcguYJF8ajnQ3y7i1PjDdTyM+BQ2KMNnYfE1qxTk2qXijwX+4CN6nCI8Cgsutns8
         Uzi+Zbxlm2231OvJMmIkO6dj8PkMI+acnr8gaPIh85xqikCPKOZ+NH1zvwPWxEAYrlkg
         dDi+5IwLYwFU6X7ODSHQ0MaTD/dw2Gzj/5CnutAqBXUkgLR4oxNao3Evtrj4fkXdgZZB
         vxpZzjUPqWn0D0TeY3FLRUM0T46rggV73MXPD0BbBUAwTwKe+UcVCVjtV5gRZB90B9lM
         wUhW54SVL/o1ZXfrL5y9sXoX4K/WqYlrCBZKkEHg74bvMEINce/LnOq1cFdKMNi+WHDa
         PY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=xswx1TYcTCN/R8BEco33f7ioZ6ZLAVd47u0UZeI2jCk=;
        b=TCoHTlWulL0hk4zegbWXvkeJ4ZFoU8NKGUBWZBtmGFgqgMvy/eI4ClAVxMzL+VIzAy
         Pzc/fyMEJH8+HPTyQw8eDAv/ufgKLwCgTHHY0oIAFN+RTb4qSrF1iEy4st0oTYFH9q/B
         8PvCnB61C/zKholLpshz+sSjwyDcRilWdzjr1NueFxWbeCPY0YddQUlc3pMwN+04i+7A
         sWEtsABUbBOgLweYBzNqwE5o6AIdrTWve5hznZDby01Rwqx6onXkXzP60/9tN6kaLvkh
         I0vfEHj3mtR3HUrc6v4yE2r7g4bFfQcq6s2CZxqOqSfpzPx23+VJWE45myRqa1WZMt2d
         5jwg==
X-Gm-Message-State: APjAAAW0e1vrC0sff7KlihtLR/24Qq5G6a4T0r+mSDNtnAS1jng5LXVr
        qy82bbMj27ms9zvKRRVqKO/nhA==
X-Google-Smtp-Source: APXvYqzzIgy/syrF3JnQEqeoEyHU6giJHzqN+5y+DMC43YNF5J1SmtmtN2HDN0/nAsrvn036HOXSWA==
X-Received: by 2002:adf:9d88:: with SMTP id p8mr15426058wre.286.1573819203903;
        Fri, 15 Nov 2019 04:00:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g4sm10390750wru.75.2019.11.15.04.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:00:03 -0800 (PST)
Message-ID: <5dce9343.1c69fb81.322d4.273d@mx.google.com>
Date:   Fri, 15 Nov 2019 04:00:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201-32-gd7f83e4f45e8
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 89 passed with 3 offline, 1=
 conflict (v4.9.201-32-gd7f83e4f45e8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.201-32-gd7f83e4f45e8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.201-32-gd7f83e4f45e8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.201-32-gd7f83e4f45e8
Git Commit: d7f83e4f45e886d919bc985bd225b8355ddd9284
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
