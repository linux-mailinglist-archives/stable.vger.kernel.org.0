Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E9BF87C1
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfKLFTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:19:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32811 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfKLFTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 00:19:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so10225451wrr.0
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 21:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=jb4O7IJ2ILRQfgZLEEcp8zvE57bJfU4NqztKtxInz5k=;
        b=OLGJ62ryDZ7jxHPLxs6GcUbX9/RvgLLpfLr3hrVq3OH7muf0iNFSqZAKwVfGnNcxAX
         WJoqRWUag4BAnkvqxrxm27tMBm+MA/ydBiN9fCQq8aWz54ySvXf2VsWDI6FBpQ62/2cp
         7nH7aRY0qG5lfXGR4DgLXexpV5Z4Zn3ZqFFaunEwiJdgM44LpfBcm9ME84VXK+c2NoUX
         mUgwQ/2Qfqsrt2KoKGc7XZpVl4OkQoOuc6Rzo6bPFuyH7WRSq3sdWiYJIFdpw4QJj1dc
         Rcflt9Bq1w8wsIzFNZzWxKT+kB1kIxtDzRsLzbeoCFmQ4dzW8B/J9EOdOUlCvtD6I7S1
         OZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=jb4O7IJ2ILRQfgZLEEcp8zvE57bJfU4NqztKtxInz5k=;
        b=BJ0oqCiXStj9ILhg1EI9DbMAtWEnVhIm3Ku85Cfd2xxk7BJojoh+DBknj7I0q1lMEH
         bztAhXeO1C934VWjJMFW0XU19oMctoSzgw4bpX3CoYL0rS+mkF4d2zQUbBkajkFKShsL
         plXGgrRYAa+tCoezKOr6TfiBe4VE8zgbkGL+tFVTcjdpMN9cInwuBcyb1GYbawQNagSW
         9LOTsHOCufIcTdFP+QGPVAmNGU9kaGt62Rytb1NI5yMnKk9s4h1pg35fets2JtNKLn6R
         8239KIN/g2dQJRfEhomVYQJPf4qNx17R7GLHIYM8a8n4ZNQ2pj4etu84SzGTMI22RHb7
         wtWA==
X-Gm-Message-State: APjAAAVJmCz6CMlwKAtzcE8IBE5V4v4/hOvH+ocHJg3cL2tHIJa0VgIs
        iH4L8nbILKR+VW6pAs2RDojEMw==
X-Google-Smtp-Source: APXvYqySZmu6+OcTAA/QeAENc4gF5PNNeMExpdQJ1G7thYs0OHbMrb49h51v+zC3AAHdMXG64L1rZw==
X-Received: by 2002:adf:afef:: with SMTP id y47mr23318476wrd.190.1573535957996;
        Mon, 11 Nov 2019 21:19:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o189sm2851511wmo.23.2019.11.11.21.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 21:19:17 -0800 (PST)
Message-ID: <5dca40d5.1c69fb81.9907.bb13@mx.google.com>
Date:   Mon, 11 Nov 2019 21:19:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83-126-g0f8b6b0b5b94
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/125] 4.19.84-stable review
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

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 112 passed with 8 offline=
 (v4.19.83-126-g0f8b6b0b5b94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83-126-g0f8b6b0b5b94/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83-126-g0f8b6b0b5b94/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83-126-g0f8b6b0b5b94
Git Commit: 0f8b6b0b5b946b33f5b60e9de252afb809a17e6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 22 SoC families, 14 builds out of 206

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
