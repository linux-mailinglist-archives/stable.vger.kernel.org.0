Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6E8E13B
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 01:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHNXc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 19:32:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50860 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfHNXc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 19:32:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so167666wml.0
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 16:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j9N49Hu58S74QYkHa8i4q62hWdBV0VsqVGriZb+Ahz8=;
        b=BmjfQlgxiroHK/ezX7WHOZCBKU20zhXxBPbP9nSx6V0dgIlOcINaTjgaPaj8hm1INh
         NMfbHflCcTEdkJydDNzZYxkPJ8Rj4/fUkzJGP1x/m/FQ//nM08tzTggrIheO5yucHqBF
         P8hn93wtjN/ulPHEhPUt54X+fq7qS5VuUCH2OuQ4JbB1s3/bTjcuBIP/QapACOmaSX6k
         CCvH7IZYlh+Z0VLo9qPDdDUyhiRP5HolTwTkvwehxnDv1u4EVbepTDV30gYJqNDh24sp
         E3xQusfwbwQFRrXhfsBuvaMg5PhxSxOm3gYyVZER6aFW/lyvcm3peVEL7DcBQFUSceqO
         ufOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j9N49Hu58S74QYkHa8i4q62hWdBV0VsqVGriZb+Ahz8=;
        b=BXL0VVTTiVHqlv1vzJ7PNyezt47tmUID16jeXuVHeqmzaLhrCX31wgxw3mEjmv63aD
         Ldlqi8Q+QR18bvM91CWWTCHT6LJE81L+0WBoc/bbzuO0EVKW/J3cULEc2HtUmiY4Wsb+
         Xc7ylmZCfT9KsyfU+1CTIkm67HAwTppbllERMTKQ8Bxr+bgNzIyaF1ZoGOFkJKK0zLJm
         6SEtpuY+aOyl61KiaIveaxGPgZ53eoHmbknaT9G6Z/M+Hl+rD6fq8fREBlYBQ51jNLAg
         T9/LyMQZPYJzg0sZIrqMP0zBJY608a7EPPrVvSRrFYBO4QRDF8pWItvl+SNi4OTkvN+j
         1Hug==
X-Gm-Message-State: APjAAAWnJYxGFx5uwKC8cHPpcWwmNDTSiDc3B5U25vS8Zmm6z84oUA7I
        +VfECcAfW74tI3hy+ULw3Mz0pGercANFJw==
X-Google-Smtp-Source: APXvYqzaiXqNP9WSE2lgI5L/icnNKbIzLudG3OvRqVtyhurrj4W4U3cz9SV2fcss3L8sac9Gwxmdew==
X-Received: by 2002:a1c:dd43:: with SMTP id u64mr202635wmg.92.1565825546208;
        Wed, 14 Aug 2019 16:32:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h97sm2831665wrh.74.2019.08.14.16.32.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 16:32:25 -0700 (PDT)
Message-ID: <5d549a09.1c69fb81.d5a38.ed1f@mx.google.com>
Date:   Wed, 14 Aug 2019 16:32:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-32-g35ba3146be27
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 104 boots: 3 failed,
 89 passed with 11 offline, 1 conflict (v4.4.189-32-g35ba3146be27)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 104 boots: 3 failed, 89 passed with 11 offline,=
 1 conflict (v4.4.189-32-g35ba3146be27)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-32-g35ba3146be27/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-32-g35ba3146be27/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-32-g35ba3146be27
Git Commit: 35ba3146be274b5b40d6b48da01f74f4f0e7b270
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.4.189)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.4.189)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
