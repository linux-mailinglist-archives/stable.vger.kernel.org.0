Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41097156E77
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 05:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgBJEg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 23:36:59 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39805 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJEg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 23:36:59 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so5794437wrt.6
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 20:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A1ogBSolD9uA6j0CI/Y7wHAH95Qzkk1MjskbVPBsZXg=;
        b=ddfUV3MO4c8SD0VbDb1x7x4Mfu9ZXah4QBklwhmR1dbeXYesDc6C4cXpTDmj0dY8lp
         pzg6Z9TvHdTJp/VQEJpKoBdsQx66Gw+wXyGbe2LSLU3r5wF0/9BvxQRd+uqIhArAXH+r
         2hWlj0w9/YaLnEpLS/zb2PVgpDCid4n8MXDsvaw70VRo3xT0TVjzeJHB8H4WkLFFX41D
         CEJmVM4F5lMUH2BQt8vS+YfXlHQLLbEhnk4MyEZmdvM/2J3qVHeu8nZAZdBhsX77SCwV
         ExDXcC1gdKaaq/Sdqo2HsYqI2MJOtaVoHmtf53pCl8TidAqpNscUHJGnv6F4qJ7Cd2xd
         h3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A1ogBSolD9uA6j0CI/Y7wHAH95Qzkk1MjskbVPBsZXg=;
        b=T2DoS1O54NXntjB99B/ISkkt4N0TKR2sZ+rwWjep0CFl/tuiKALRR58IEzsiMt3RfF
         chHALWNZa9Qz2r+4uaNm3LsOwSV4cHq51bRoUbP4tQZ3PKgYVm/cH/MroiTCFqq/iEiM
         d6FFlkzYhCbeSfQla6K1NkqFcC2W2ysEfQbgg18KP2YQ1a+EWVMrJoEJlWYiS/WUW2Ou
         w+CFIKNL1DzH0VxDDG/7TPfCHTtsvVeElvhROzoXyAhO8rtV8pUkBFLVeoyOHo+C6zvg
         RHdcm/2nEZwamlLThuH4JynyEnuyb4VltoprZ/HewWdfPvxo+OruclgcVPly5XkWiY0B
         6PgQ==
X-Gm-Message-State: APjAAAWfEmo1zdb1n4oC4NjbqHRmDAyttxjmjZ2Gyv+oDgxwnCwphIGk
        1adojiaspDv1Qr3kZN9RSGMNuw7/Jq4=
X-Google-Smtp-Source: APXvYqw5ScieRQPbLM4bmZTSejl5ac95W+QuiHzg16HZI9cb7lCtjdog/NVkxYO0LCzYU7h9rDsfVw==
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr14308801wrt.70.1581309417061;
        Sun, 09 Feb 2020 20:36:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c13sm15201359wrx.9.2020.02.09.20.36.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 20:36:56 -0800 (PST)
Message-ID: <5e40dde8.1c69fb81.a9591.1063@mx.google.com>
Date:   Sun, 09 Feb 2020 20:36:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-96-gdf211f742718
Subject: stable-rc/linux-4.9.y boot: 41 boots: 0 failed,
 39 passed with 2 offline (v4.9.213-96-gdf211f742718)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 41 boots: 0 failed, 39 passed with 2 offline (v=
4.9.213-96-gdf211f742718)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-96-gdf211f742718/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-96-gdf211f742718/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-96-gdf211f742718
Git Commit: df211f742718e6fa80aa3689fd04182f5bfdd748
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 15 SoC families, 13 builds out of 145

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.21=
3 - first fail: v4.9.213-37-g860ec95da9ad)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
