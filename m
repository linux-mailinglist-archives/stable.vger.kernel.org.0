Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75402970B4
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 06:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfHUEFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 00:05:35 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:36318 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfHUEFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 00:05:34 -0400
Received: by mail-wm1-f43.google.com with SMTP id g67so647214wme.1
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 21:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bCqJrFlPygrYJt1MG5W8JM7FcBSCV1pkMbpyDre0DgI=;
        b=mgQpyKZymB+o8EjKjIKnya98OUqy9x1rlpM7DA0750MG1vyjKSDr8gTvw2wH2cACPu
         TEzzH+y5izpNORG4dMAArZdBXFB3cKhQREALb9gNSpaam34u2LNLzkn3fyYYID4pp/xa
         GcqMFNE6CK7Rz/sHX2W6ZHjblaYLNEOuzb2du4Id2cFhNC93cUYVSj158NRLgi8BaLIE
         iJLl1fqf9lc3gKBXZgS3XN9JdnuX0KAJBxuF/HA8YHgR3kNAGfb2HH46glxhI6Oc2g82
         SGz5nPtdB8Er2qd+jr0TxQVRCfGq7PhJhlDjqaJVrfNGg9Ee5Csi8ro9Yc2Xhwlv4rxk
         JWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bCqJrFlPygrYJt1MG5W8JM7FcBSCV1pkMbpyDre0DgI=;
        b=EOkI2MIDbtwjvbbmsgrAQJT0AQ7wG+zCd3t3nhfvFcUNNTRr0WtBcdoVPNpsBKF8Cn
         cP+8iEd69T5ppm+Eo0lq9XHrDnpS+P0AIZxP6rNrljJeDLZNgmTV0UjRriITIz1lPbgm
         EcPXBTPogudnUoMEri9YpFT5QnnKcTLvUtZnUbm0IoIrEPlJlGkUila/cezZQlSHX7aE
         RZLMvZZ+iWOkckgNW1061LWiBxma9OhW7CJrNDR10GIlN5QY4W1MPrDHvGf/FUyKvT+f
         vyUWLeEU/b8ohTj23zyExnTPwsC7k2gM5Rf0+ZVge7Xso9pJJvgwdixabR4D6eakRw3w
         0ngA==
X-Gm-Message-State: APjAAAXVaOGTAYK4oNJO4BG3NecFTbSDme7B6C1SgqYgUc6oJ+P79Xwf
        GpBqEowJ/Qs5ewjP2mouVxjRu/3CYQ/xIg==
X-Google-Smtp-Source: APXvYqyTqs7B783Uge0bSmTHvZto/AsSJbJdOFxA89u+F9Ue5saU4Z9/vm8vOPgSBoMw/j6rFRtyWA==
X-Received: by 2002:a7b:cb11:: with SMTP id u17mr3228413wmj.17.1566360332899;
        Tue, 20 Aug 2019 21:05:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b136sm5003887wme.18.2019.08.20.21.05.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 21:05:32 -0700 (PDT)
Message-ID: <5d5cc30c.1c69fb81.b7b86.5a1e@mx.google.com>
Date:   Tue, 20 Aug 2019 21:05:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-96-g4cd56b7fcd6f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 102 passed with 8 offline (v4.9.189-96-g4cd56b7fcd6f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 102 passed with 8 offline =
(v4.9.189-96-g4cd56b7fcd6f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-96-g4cd56b7fcd6f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-96-g4cd56b7fcd6f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-96-g4cd56b7fcd6f
Git Commit: 4cd56b7fcd6f91924d73012740fd5ccdf07707fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 21 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
