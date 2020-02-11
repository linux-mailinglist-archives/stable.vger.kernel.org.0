Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53215963F
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgBKRfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 12:35:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34229 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgBKRfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 12:35:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so13501451wrr.1
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 09:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vuxlg6W2gcVsZQlXejj3dWPwvJawRCodH8pnfVz203Q=;
        b=SuFUNtsEec56ojpVK/G+XDXikcmlgJqLSWwtRvGU1BxbIpfCFJXqxAn1BZjonlm2t4
         maRiWE/zDAOOcraAmKtSlMcmRssIjq6vcba+oa8m4AoCbLNvIHoXyXh8ffzEoUbev/po
         NasBYQTzSqe92J+017hnmiW6dYanOp0KB3z96t/3jYUfPXbPwN4SCqD4ilU/YQD/TvMG
         ce4gjX9cjzs/E/zhOrDt8ELOyQFoJpojiiyFqV65kJDa8cC2uw5FRJdkzBBaqBm4a4ov
         lMPR6mTC9yRHM/txc2dGRjpnd4Umi5xApDhH2z+jgS7jMXBYfHj/yPqoYvfrklBn9mH8
         rtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vuxlg6W2gcVsZQlXejj3dWPwvJawRCodH8pnfVz203Q=;
        b=l9UZmfNVINKKwFx/z2OLQ30S5MRC0SGKkPtJ0JCetJaDnt/NfrsoWqrb7Cg60aQjb2
         qqY4x74WvYjUFc1OMUUKPyFiFn+XpBWLxpldpgJxK/nex2Y/zTrocXUUvfIJ0XaRQJlI
         RSfA532M/l4HIGsLYcj6wrheVcXMxNv3Tt3O9zL+lURbr9vkQ45dy49VXrQDdyYqzB+G
         H9iqoxGKxXOwwnoEshBNfea7y9Llhoh6MFvSnbvnsBrd+f/Jy4OGABI4+1BfRFzAIF/s
         EOJ6pds5LBZL8ZKvElfiS/vFYJD7pSgDcHD/rRwr3lBI/4LdroJNuxOF74fO1FzkaqBi
         IwYQ==
X-Gm-Message-State: APjAAAVv3dssrD3xAL79/+9hDCnYFnfx0jDs7rs48dHvihf7DZSsxC06
        vZjdozX6lIaKGy6Lg21L1zUmTKngXM0lTQ==
X-Google-Smtp-Source: APXvYqx5MaxqVLgRZAlUJWqbjDL3934Vtw5Wa1RPRyNoMVgLGKmtumoxgU6bB8jd6QwgljyFJu3wpw==
X-Received: by 2002:adf:dc86:: with SMTP id r6mr9671957wrj.68.1581442500126;
        Tue, 11 Feb 2020 09:35:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x6sm6323897wrr.6.2020.02.11.09.34.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 09:34:59 -0800 (PST)
Message-ID: <5e42e5c3.1c69fb81.7ce21.f284@mx.google.com>
Date:   Tue, 11 Feb 2020 09:34:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.18-310-ga28430b8529b
Subject: stable-rc/linux-5.4.y boot: 111 boots: 1 failed,
 106 passed with 4 offline (v5.4.18-310-ga28430b8529b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 111 boots: 1 failed, 106 passed with 4 offline =
(v5.4.18-310-ga28430b8529b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.18-310-ga28430b8529b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.18-310-ga28430b8529b/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.18-310-ga28430b8529b
Git Commit: a28430b8529be97d763450b3af54c3958cf9308c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 22 SoC families, 12 builds out of 146

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v5.4.1=
7-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.18-310-g0b=
7e0557aabf)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
