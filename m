Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B2DD2CB5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfJJOlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:41:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42078 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJOlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:41:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so8197564wrw.9
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 07:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Fh9Hx1P0eMv8gyvLKexMkSz9TuiAbke7YyXoM+kWNOg=;
        b=nK5FjrP59K3ng3P4YgO4vwC29jLdqnTV9mf3lSlsePV+NVlvd8YucDdl801ZoFZQTE
         fAOupa/LOixBAsraAohUxD/QStkkAORLlpB4o30gxyctPMaEPeQDS0fxGufxqyI+44gW
         6xAGaB+cbylH3VD8cRUQwmjtGpdgL6irg3mbK7hb3TKJowYTCwT9ZkIwJ3uqG29f/EEo
         zznElOF/ieoTWJCdp54ab1JU2FtaAavHW9O2Yx52A/XYgYcoiaE57qp7/t2dnoXSI4R8
         OCAkssVyDYSt+llB04JQ4IqfSGchRNNYpSQn+zOfRNMmdc3/g9YT3Iq2L6xsCMYH76mW
         U3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Fh9Hx1P0eMv8gyvLKexMkSz9TuiAbke7YyXoM+kWNOg=;
        b=FYkrPQsymUltbEHI+JzesA1dvfbVWur2g5LWDbLEGWQHq6hd7Fnd0ckFbc2Txutdr0
         VOwIueZ3KId0GMBFXqZk+KqQV61xEALYHLGTY0SEVp5g4o2Kz57lsAQ614MFNd6phJoI
         86K4UC0wXl9pu0jlPM6R+UxDYLXRpZ8jzLrtFgqHMVvhlAczs3SLuFtrB6jDglNR+3VF
         rDbvjHqtjxmkzSByFCJKzdzyDm+N989vx23C7PtPalpNTWUd05oiy4Oz3SbjKsg+leB0
         s9p+RSbpXxuSS9D+pVwydo48VTBuQmjtaUR6/lVLr+6I2NkY4PHNHczOP1ig4iqAlUVV
         6UXg==
X-Gm-Message-State: APjAAAWJCS8fZYwf2mh85sSmO8WkuJIvL3TFgOj0nvSsxLJPhdDmTyVu
        aTTArUqDfue9TIsi5SE16r4DCg==
X-Google-Smtp-Source: APXvYqywYXNqUtCUh1tqSRXS8kHXQuLkQpAdFExNwTdpQwA7rofQc7epbkiz4NVdCOPT2aWJQj7FVQ==
X-Received: by 2002:adf:f452:: with SMTP id f18mr8619268wrp.187.1570718496848;
        Thu, 10 Oct 2019 07:41:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c17sm7118509wrc.60.2019.10.10.07.41.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 07:41:36 -0700 (PDT)
Message-ID: <5d9f4320.1c69fb81.f0ef.24cf@mx.google.com>
Date:   Thu, 10 Oct 2019 07:41:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.5-149-ge863f125e178
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
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

stable-rc/linux-5.3.y boot: 130 boots: 4 failed, 116 passed with 10 offline=
 (v5.3.5-149-ge863f125e178)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.5-149-ge863f125e178/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.5-149-ge863f125e178/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.5-149-ge863f125e178
Git Commit: e863f125e178f8d2edf7a3a03e7fc144d3af82c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 24 SoC families, 18 builds out of 208

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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
