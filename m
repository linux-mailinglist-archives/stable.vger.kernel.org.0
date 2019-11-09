Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F28F5CDB
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 02:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfKIB54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 20:57:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38473 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfKIB5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 20:57:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so2127469wro.5
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 17:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=uVn2qkTljl+tTRkQyCgOVZ3dMV2RafY7lkEdIbVUGTM=;
        b=Qgf10WbIkEM/xHV5iRuiTZScuq9g/a64Sct14/6j+oWydq2mqwGZ31DKcJdoacJXxa
         cP/qfgfvCarIK2onx1Fp4953agNP4vG1Fcfk3Aa5uGTMVI2DOqTBO4zl7YCu/GIW6CjS
         /QSr4s8nnzPv1IoC46N3YgL/ijFoR0V+tmxTrc3Tb2/gUptaxR43RQQkMkKRH+Dfd1C6
         onT/WZW+kXwgpKfTFk5Jkud5vvMqVgPERy4CnxmIMCaR/Gh5ZoM6tNYoC5phTtR36Avc
         zsYSbvWViWWoN4YbpQwym9ukobb2sX4yealHesd6w1cd2xWeuIp1qyXEjZIbnRO3MQpT
         LaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=uVn2qkTljl+tTRkQyCgOVZ3dMV2RafY7lkEdIbVUGTM=;
        b=KL1dRqsksfifUyNC/9RqU2rYGRqD1160HHcIitJTw+E+5P+JKpFpOAwH1Z2SY8hVD2
         D9EnMPEbTlkxZBr5Ubwu9to036zpyuZDdwc23MH7eGPDxihne1e6yfz/BWjIQvG+vjnf
         SS1aNCffi22FTkcSIaNRNhBG0XSUvvCkKKH4DCXcEYci+7sxt7tVUf4aoJ3eWxxrmh9g
         F4WeaXf10ONKktXnmFcqmVhGzGVy7eIboci/Wt7IyYPnuoMII3h+3MnRmqy8qwoLJSHL
         ifRibiNcspMQHsa/X05ub9b975Ubr5viMJ75xWqRSIPyQUJPMW4BNFDn9BjEfXzOACkX
         BUGQ==
X-Gm-Message-State: APjAAAUvKVlFaBJljCjRFd4xTTIpGI7FZy77d+osabORVBzj9rX0yGfH
        MJty9l9qLeNyycnIYkY7Eulh0fZio13Bgw==
X-Google-Smtp-Source: APXvYqwcw4ZifV/oofafu6IRbacOTH+cEGSv0kN1zmRBGAirapoPWw/07jlUDOYgWvwTl4hI1RJjvw==
X-Received: by 2002:adf:e5c5:: with SMTP id a5mr11527422wrn.103.1573264672178;
        Fri, 08 Nov 2019 17:57:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j66sm6835529wma.19.2019.11.08.17.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 17:57:51 -0800 (PST)
Message-ID: <5dc61d1f.1c69fb81.22380.3936@mx.google.com>
Date:   Fri, 08 Nov 2019 17:57:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.152-63-g2cfe0b7bdeef
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/62] 4.14.153-stable review
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

stable-rc/linux-4.14.y boot: 110 boots: 0 failed, 103 passed with 7 offline=
 (v4.14.152-63-g2cfe0b7bdeef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.152-63-g2cfe0b7bdeef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.152-63-g2cfe0b7bdeef/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.152-63-g2cfe0b7bdeef
Git Commit: 2cfe0b7bdeef09a0ffe2895928288ebca332b8be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 21 SoC families, 13 builds out of 201

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
