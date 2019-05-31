Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A05B316A6
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 23:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfEaVeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 17:34:20 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:51210 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaVeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 17:34:20 -0400
Received: by mail-wm1-f41.google.com with SMTP id f10so6862630wmb.1
        for <stable@vger.kernel.org>; Fri, 31 May 2019 14:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p7dWRd9eoARKANqRMIGqcb1XOBbTvWNDNyS5pEr0FIQ=;
        b=0umHSgXCTSneHpn52F2HXcpO9RCn8g4pyqVC+OVDttAPkWuHIovqqQE/h4rE5LSFE3
         zU9hrjKT2TAZ4tSjsLQyrDC4XX9WWJQQ4En1LiGxH/DqNcxXrYux7cL0nBdgmtOt7KM0
         PzHccYk7wy3sx3I0N2KF3YT4oTVj06HTNkhSTWhwf4jGxAq7tJBXuDwTPKyFBV3i7emY
         DRRBu5QbaqifEkitVbFsrRwlUluIsYXkzwQs3LWJ0cTXBWOcO1/e8Dig2WFsaXS5wHsh
         5d22/sQLJVC683VwHXQAbBifK9IRyV9xmPS7Uvt2k2np8LSulh1MPIldLtPs1fehVziB
         K7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p7dWRd9eoARKANqRMIGqcb1XOBbTvWNDNyS5pEr0FIQ=;
        b=pkHSHdOCnxqFpLiVTj823QR6MgI/yYQ9sr6Wppkx5EjF3GApxG72FojPi8RRVFaTU2
         Kzn0J9zSJgBf6PToiwCGciJ1UW34cmblnyec0bCc5d23gZU94m2b5JFIyEIKi1e9hRjp
         0LyQqwR1Obhq8SxObiEy9n6BoNfJQrjlZlbHOEoTI85RG2HRhnV5eanDSPnBhCDJ59Je
         YcS3levEuVLjyNADu8FKR/FcK/WZxagECADZwQfZZXEP43Kpsm1SWhpC4aRfSVA+9bPr
         a/dUB5C9omdB/Lev+uiw36uYeDa0bt3VhtQN4UG++IhbDVgiNqTzwYbPOAbSwwm8tzsj
         zhgw==
X-Gm-Message-State: APjAAAXBJ/iQDlN4489kfY2I00Ik/6V0xW7vfP43fqZkPEkyzyeIGnin
        zms3loCx1irev83gLndQv3/+MsZuidgF8Q==
X-Google-Smtp-Source: APXvYqzZyYHoe7pRVrcLSg3cnQhqUprYnyZ6Q0IgyeDTrohjJEWlJKZT8VxugOx7MFyxcC5SZ9COdg==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr6999931wmj.155.1559338458148;
        Fri, 31 May 2019 14:34:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s62sm10417082wmf.24.2019.05.31.14.34.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 14:34:17 -0700 (PDT)
Message-ID: <5cf19dd9.1c69fb81.587fc.804a@mx.google.com>
Date:   Fri, 31 May 2019 14:34:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 126 boots: 2 failed,
 123 passed with 1 untried/unknown (v5.1.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 126 boots: 2 failed, 123 passed with 1 untried/=
unknown (v5.1.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.6/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.6
Git Commit: 98e4b991db5ac04be8c23cb2dec277ee31fd22f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 23 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.1.5-406-ge151dd0525b=
9)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
