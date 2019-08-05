Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B588A824EE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 20:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHESf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 14:35:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51634 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729962AbfHESfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 14:35:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so75720188wma.1
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 11:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=zonXc3/aq46YHRaoY/iCK1+k43XKTgCzmG0UQJgG+z8=;
        b=hthEXQoYYgY0fhTSkH9Vx7nvNA+llRLzD3MI+F6sx1jO3yWhb4QIbJ6b1Xy4q8uDlK
         QOHE46t5saknXTiu0fP5G+gDVyXwapBG0t0lPXY/FR0YeguEmP31ykEERyRaNvFUQ8Mv
         T6/Gi6gXw4R6+N2Xo1rdjZhK10vO5rVD9Kvc5Y28C3OE2/XE/EGNADw5iDL88iEP9s/p
         Hvwtd7KsP6+rZxkmMvVHMS/KUhPCgg86ExfyINSR+8ZURNw+zLSbou9dok6I0aA7OInZ
         b6TfNOowwBWEFq8BlzBjhHM4ZoW51WfIgWIsee1kmOy7QGNnsauUwhZJKmdFmIXm7zBA
         UmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=zonXc3/aq46YHRaoY/iCK1+k43XKTgCzmG0UQJgG+z8=;
        b=tGjIN/4YkrBY5z4P2Jt7x8CEhClk2zkuP8ThAd21LsOwDm06phKnqWb3gsSd8EPIsM
         br4wtpVWQdDC0uiyACeNn0LQfo0NHHIKJSOAPMyA6yFHItkXlryvDF0V29ER19bPGa0c
         D2Hw64MPBdk0Qj6GHgC0qg/6P96oEFSnU17onwx/Q4fttsNqo2a7+qRnJnRg5MO1udx5
         fukHHZnbr5XsdpFYgHJuCKK8MshAeua2zZbXOGPL7bL8Qu5TGz38uQ3XoBg59usZofvU
         farxdshc5TsC+VFEq46BFLE0xUhRcnxDtKOS8dBvtmsS2uNuMg9UoPZyvBV4Jwmga8cn
         sIUw==
X-Gm-Message-State: APjAAAWoOZKVzodESlWkWhe+mLUUG8X+utNoGWHslezQkD2I44ukpqPI
        GQcpFgpv3J4rliXjLhShi14=
X-Google-Smtp-Source: APXvYqzY7OsNmwIWSX5CYlp0IZgujoGvomN+1R7UBPB67LukyzF6bYH9pKxjYThhPzxOh6dW8/uSSw==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr18768406wme.99.1565030120160;
        Mon, 05 Aug 2019 11:35:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v65sm100331874wme.31.2019.08.05.11.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 11:35:18 -0700 (PDT)
Message-ID: <5d4876e6.1c69fb81.24541.29fa@mx.google.com>
Date:   Mon, 05 Aug 2019 11:35:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.64-75-g27e5d9acda64
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/74] 4.19.65-stable review
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

stable-rc/linux-4.19.y boot: 65 boots: 1 failed, 64 passed (v4.19.64-75-g27=
e5d9acda64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.64-75-g27e5d9acda64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.64-75-g27e5d9acda64/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.64-75-g27e5d9acda64
Git Commit: 27e5d9acda64f19f64a7db74e3bff765c11248bf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 17 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.19.64)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

---
For more info write to <info@kernelci.org>
