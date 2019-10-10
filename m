Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E353D2C4B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfJJOVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:21:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50722 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfJJOVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:21:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so7179853wmg.0
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Kc9kel9sAN4lu/KkWc1RGvUzr/fVXsluYAxKZCMINZY=;
        b=Ts3UwJX8lc3P+CQHn0fX2ii5XLiprD7wazQRMaux4VZHzz8JE8PpoQLP+8x2zp+62p
         fvrah1/B+Vgv6mZh1MHmaqvYr+UEZkbDw1MFLxvnqICZfpfhgM/Mtecxq66WM5qrJufM
         bQS77fxASUMeeaHqJo3k+CL2EZw/lWeZ1rQE0epHmqC7Q6gFNSuONla/kVA5aZpOF+8c
         GQVcpbG/xY7rq2LSK50Wyp04/77OBscQejHafjMkRQEXwIOTI0jVxka7AQ6jkcyFKyH1
         5b6i+QQ0d9r67DwkTicxpmd9oWp4mKOY56Ut2MomZbes4a2AYAvk/J1qqhS7He0ZZD4E
         LcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Kc9kel9sAN4lu/KkWc1RGvUzr/fVXsluYAxKZCMINZY=;
        b=lZQuhtrL1dY+5WVKjhRwxmdcNEov97bYI5VO6GJa9qO+3v/yWKSnwW1CPEdqiFd6JC
         Y+WAZbFFHVdoWC2rXyOyDkGxLB4fx5kCvhtYGToekREvknlzSRkzCZ0bsXQVcIgyVoBs
         cI8j71pvGUdtKI/dBDEetjXO+d43DwTkB46t2TpjpXLKGfFTpFH5MZIH8vY4Pj9rhU0E
         gqj3Xfo4Lyb7SRJVoAHehB+i3pwHPatzBrUEAW2OSi+KydQYYNNYx2Su2eYADdPBFYSv
         r5MN0ogPlDF7OV4sEjT5TEfkExEmn0aRVYs/ERzr6WBmKFSm9fI1IYnRhFaij93T9wiU
         w6Mw==
X-Gm-Message-State: APjAAAUjB7Gr8CXQB/XmJIqls9tNXVOVINyrj3zqoxAn0q1MB5aRv2vJ
        46LL1YZ42YpF+6WcO7oA+6uUPA==
X-Google-Smtp-Source: APXvYqyUlGGNlhkrh+2ZhU5yxNXJLjnUTB4inZR7io42Kp+5j1QjqepM/eM3HPpkuCtWy2XX0gx4MQ==
X-Received: by 2002:a7b:cc01:: with SMTP id f1mr8361649wmh.113.1570717297423;
        Thu, 10 Oct 2019 07:21:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t18sm6654725wmi.44.2019.10.10.07.21.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:21:36 -0700 (PDT)
Message-ID: <5d9f3e70.1c69fb81.5c8a2.06f1@mx.google.com>
Date:   Thu, 10 Oct 2019 07:21:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.148-62-g8952ae7352b2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
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

stable-rc/linux-4.14.y boot: 116 boots: 1 failed, 105 passed with 10 offlin=
e (v4.14.148-62-g8952ae7352b2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.148-62-g8952ae7352b2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.148-62-g8952ae7352b2/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.148-62-g8952ae7352b2
Git Commit: 8952ae7352b2ed94c2a5f3c8ac3f5d1c96b43bb5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 21 SoC families, 15 builds out of 201

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
