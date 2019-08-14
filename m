Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1104F8E102
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 00:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfHNW4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 18:56:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54675 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfHNW4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 18:56:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so111745wme.4
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 15:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=oj0hiMpymPXol1ueA+RVPbGRQRBHE7nRWC8Jc3SIHJQ=;
        b=TFrhjp76KvhcPhVTK2TfGWaxGV4sXpTjcbT9q7BQxzt5MoIPR1+gjOy3Gf6ZIWXj5q
         nKuVjh5sGmHcu5otL1t4DJJrNZtTRrbaS16GpURlrVA3mzYfql+BTs5/C9EUd2sQmMWg
         pHudRsqRyNKcRpryQrk/f00JrGzFQyj4UKDpGbHMhlEy3ekEGjn3l7Ul8QdsNsDPnADE
         a0hGM5/8rC6HQsidUisOCLSjovoRgnYgzi1C0xFazhku1REsa1Qcn+/1vW+vC7HfzGzt
         uCqz9WKKHBoXkTu74vlHUuhsVl7pjhrNbbgZDLCD/MjgXvfDqO5Kyw6S+Rm1E3bGHtSO
         BzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=oj0hiMpymPXol1ueA+RVPbGRQRBHE7nRWC8Jc3SIHJQ=;
        b=m3OU7lye38NStXkFYi6zNLx8ooQnP9GKQ+lMTLL6M1qI81FDieZk2hhd2VZ5q37Tc6
         +xj7m5X1yZcsxolOZp42eZVCD/4Mo8JiqJJlrRbaz2uLnhvr0oYQ5PLkaqoRk+99wcAI
         Bn1XS3oPwIoZHLW44dwRASOhNWuGW6x4KLtGrVOZipO2pypHfwKuxcR/ly+W4Fr7ZGDZ
         Idym2CHQLCK+NRortwUDGkOiVptINH5I44SFxP8uCKkRCHGiVrGq/y4onu3BtseIR53s
         MP9oT4xo0qdTMTFHXuebWj/9U2GRijhlSwXyKgnwWSY65inzb0Mk8jR05BDYKt5AXV3w
         QksQ==
X-Gm-Message-State: APjAAAVCOQ3P7jjYgMyZC6PczIWJCWnBxw+AhprSVVTYzzY0HqxqFM9+
        banKTjAzrtpXqOdnFdbuWEKEBw==
X-Google-Smtp-Source: APXvYqxsU8yqp02nrnZwlAkGgRcMTC2zlmhzGqITndHZpKMA4JwdUhVqOJy9irnnPQCs0DCtze21NQ==
X-Received: by 2002:a1c:a909:: with SMTP id s9mr150134wme.20.1565823377815;
        Wed, 14 Aug 2019 15:56:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm1135644wrs.37.2019.08.14.15.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 15:56:16 -0700 (PDT)
Message-ID: <5d549190.1c69fb81.186a2.5bd1@mx.google.com>
Date:   Wed, 14 Aug 2019 15:56:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-70-g736c2f07319a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
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

stable-rc/linux-4.14.y boot: 132 boots: 2 failed, 117 passed with 12 offlin=
e, 1 untried/unknown (v4.14.138-70-g736c2f07319a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-70-g736c2f07319a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-70-g736c2f07319a/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-70-g736c2f07319a
Git Commit: 736c2f07319a323c55007bcf8fca70481e9c7175
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.138)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.14.138)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
