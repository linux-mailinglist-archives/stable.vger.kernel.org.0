Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947088DFFC
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfHNVgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 17:36:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37737 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfHNVgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 17:36:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so1211wmf.2
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 14:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=XWwAylDLr1ewfARUebkjg//6gCYbw06NtLYokdWmek0=;
        b=KSGPqM76DveV79q1yTio02HLMvbtGr9oo/BtXzHUK+aso46xCrKV67SmkjxzbisiE9
         sGu/lbFIU/QlmxGAX3YpnZUyJx3C6+r+FUyqbetev+q4OyOjAaZ1WH6FoM2m+AWHVefL
         4rCOl0MWVzfgjFl2dgtxQufU8602yfwGcKUyTLmKHS/UcxA7+oCeRhMf9/qw6Y0ZW8kU
         Qn4Gc6GxNFBb7u4tA5HQvOfi3Xsla5kqVM7Rvcm/8I/etSeYynlsM9o5O/NflrNE2+L+
         seloSevQeozaOfD4j1Aci8tOsCC5uleWTCsbqH9HWtKLilVWxAYERgF6e3MuCnZswHlE
         0UyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=XWwAylDLr1ewfARUebkjg//6gCYbw06NtLYokdWmek0=;
        b=eOB3nTBWkVj9BKoJVTvMzy3BAnRw8r9WJVBUiUseLTIZS0/+WcR79HJpskN9QZILt9
         34wZ1U9H/bP+g7SVbbg01IsMpyGUSkXGhXZJQDs5OU0PA08BWDXRe+Z6YsQr+bOaLq49
         dBiWzmwPMCEwJsmHrUF2LP9E2KR7ShVQPHdzDBKOFuXjLHqosMd8526OL1Fui5XDmaGu
         e5ZNsx9PfqnNZtpyJO05ST5HnmFhaM6nCFdfOjBcsVkyVKy3BNFYMiE8dD0JNSYnKxtr
         wxoYwCUOtgmelnx66CYL1HI2SMcp58/0RfEpDS3Oyq7MWr/Z4s+kr7FQgi1jQlxd3rdW
         9xfw==
X-Gm-Message-State: APjAAAX7OzpjM0cpKQy1A1znaLNh4VjgkOP0O06NQ7FtbJEEd9W4JPpv
        0usKTFUixkR0BHFsnytWDkxBGQ==
X-Google-Smtp-Source: APXvYqwP4DtXoYWeVm/3r36krjGhXKkjcp6Hm5I7BClJcBTppUcOxX5xSkXAWroLNI/EGGvh/iXoqg==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr6576wmc.6.1565818576956;
        Wed, 14 Aug 2019 14:36:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f70sm806504wme.22.2019.08.14.14.36.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 14:36:16 -0700 (PDT)
Message-ID: <5d547ed0.1c69fb81.14f04.42bf@mx.google.com>
Date:   Wed, 14 Aug 2019 14:36:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-92-gf777613d3df0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
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

stable-rc/linux-4.19.y boot: 138 boots: 0 failed, 126 passed with 12 offlin=
e (v4.19.66-92-gf777613d3df0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-92-gf777613d3df0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-92-gf777613d3df0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-92-gf777613d3df0
Git Commit: f777613d3df0e7226d30d0e0ba97e9419e3064f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.19.66)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.19.66)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
