Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3367E6BA5
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 04:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfJ1D4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 23:56:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37450 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfJ1D4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 23:56:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so8320382wrv.4
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 20:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=0vLsyW8NZdsJrokYW5bbOufgyVkfiUX005e5X8CUSXI=;
        b=hncKEA8qdd0QmUevaWITA2VktUV43rc2uT/rxLwEg6tyOQp/QqEBhGf8sAeeHZUYpp
         WrVTr6LDhPBL8LPncb+rLFxl7Jic2XOShGTXrXXZYarg7x4sdFs6vZ297kv8Bk381LTE
         f3z+wiwp0vus5bZkNdFYQWEtED4X83QbZxV429+V0Ap6RLivzbfxzoURopwp3KLoLGTb
         FqOexhEKxMlWw8gURws8x2+h5lshZLOcNMy7oSbcZJ0Ridp4kK0V/fYpCisKGFxIOFxS
         dOlQpP2Cx6Rf+br4E8YhPkyHyTQTzSC8EVuNGCwa8Y74eU7983x4epV09ETdlY7O/Ma7
         Ubew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=0vLsyW8NZdsJrokYW5bbOufgyVkfiUX005e5X8CUSXI=;
        b=GmqFxeBc+v366JLDKoQcbWyEzQhjTwTjQQ7rCdr7Txw8YoWL1PghyLyeh6OHDlTFpy
         J3MyWAQqZZqqJzl/cCdrMrScYl0rBL5EymB+pKew+bznKzMWItYpnqU8Xx77svIMU4Q3
         N6poty2zBrNTe00nuPKugLTs0iKYAicCRUpyr7BSphImVU6XZ2ufHpIS77gLqlAZ20q4
         j51ZOdcmVfmz65S4qFuwY0JW9mlA+ww4juIZ+M4cRMk0Uu64NeI5d+XRCJ1hblxbDOL3
         jpaTZURYKSsi1IokqPWGRo1F4xCZ8YdqfNCzQnGf6ugtnUwPvmA0rSK+8AwT0qqMJtml
         XXrw==
X-Gm-Message-State: APjAAAWElnZC5Q5iap+0pKoqKZknC9pucUcyq5gUfj7KFdl0YZK3HLD5
        1vTOt+/d3n1nekv6uapHXWdhng==
X-Google-Smtp-Source: APXvYqx9+S7dhRG0S1tGovUu8rBcJzqXF07gAxWW/U8XemmBmXd9xxWQPvuRmUmZe2GJd/CVdPTpzA==
X-Received: by 2002:a5d:44c6:: with SMTP id z6mr12689692wrr.313.1572234960101;
        Sun, 27 Oct 2019 20:56:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h17sm10500158wme.6.2019.10.27.20.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 20:55:59 -0700 (PDT)
Message-ID: <5db666cf.1c69fb81.c005a.46f9@mx.google.com>
Date:   Sun, 27 Oct 2019 20:55:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.197-42-gc1c6537ef129
X-Kernelci-Report-Type: boot
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
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

stable-rc/linux-4.4.y boot: 88 boots: 0 failed, 80 passed with 7 offline, 1=
 conflict (v4.4.197-42-gc1c6537ef129)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.197-42-gc1c6537ef129/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.197-42-gc1c6537ef129/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.197-42-gc1c6537ef129
Git Commit: c1c6537ef129f3034eecbe2f57b332978eae2d2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
