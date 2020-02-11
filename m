Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57590159485
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgBKQMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 11:12:31 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56019 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbgBKQMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 11:12:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so4254327wmj.5
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 08:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cucSq+WIuD5CmwCFHJoUNQHqXoQedS4p2N8loyiWKWE=;
        b=EGDAH5kLc8lAZgz7/neG/4/dP6OM/POpDzTNnM7PCAFg3MdXVzRIb/YVUiln0pm2Lx
         9zbWxFThEVCshksVIMFB6k+1t+sK1cW/SiO5tbb+rtHxJg2RDiEli4G3Tmbor8Wf5Ut7
         jJ7ByL/B9ygks0A2ufTEh6aAjWnOA2nNIzBTnzqZ8PVvRPheRl829E5mTsTnj+pFZ19Q
         WcZNMqm3ln/Gcvm2wEDoli+QqMs3SU3FovM2cNhH6K/v1RfNlOlzLQcMdmjaAUJuOSjo
         Xtq4hyW9FudJdU6TMGI0zu0aKGbl4xxXzAbi5yLfutNDkv/bgBwjVTYPDWLtEzcNBc06
         fBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cucSq+WIuD5CmwCFHJoUNQHqXoQedS4p2N8loyiWKWE=;
        b=DQcCCgGWIW02bgPXG6kA7crxPl8aoI5tXKUgUFwI42PlmlZir12r53OKp5p1bkbR7U
         MXzfH37mjkI6fGKdUuQ1tMKJXCxSRozyLy9CZAosxXmLv/YjMInDXLqKIeI/EWM23KzY
         0HfcI6H1MRXouM8hg3JKGakzqVRo1JebAHsxgoOJDZght77quGVI0hbtUEZtG2ayb7A5
         h752hbomRkkGATwro9qshHZsslQAX2wvL8dKEbssRpq2193imCDqi+Aru3rJ50X1uBsx
         ETWRyDTMmSwQSfLdU8g1SKJz2wGKpkIVCosEP3WmBSya0k8Jc1qhlboscJYaSAFhmmMo
         t7sA==
X-Gm-Message-State: APjAAAVT1CzyKkqDvh1G8P81Q4H3tQ2YAOuPZJrvYAtp+iJfNmhroOF8
        3ghwnbhofNoWMKwaA1vsmsRbSxzIkcp2gA==
X-Google-Smtp-Source: APXvYqxhrdVF575OIrgtPrruwp6cFeRQDUhZ96HIL640DH2+csBIeK5zSaSs1fsJfsSQgZIXGc/a2g==
X-Received: by 2002:a1c:ba83:: with SMTP id k125mr6378187wmf.106.1581437549765;
        Tue, 11 Feb 2020 08:12:29 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm5790855wrv.39.2020.02.11.08.12.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 08:12:29 -0800 (PST)
Message-ID: <5e42d26d.1c69fb81.ca0ef.c4f4@mx.google.com>
Date:   Tue, 11 Feb 2020 08:12:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213-80-gc93242186b91
Subject: stable-rc/linux-4.4.y boot: 8 boots: 2 failed,
 6 passed (v4.4.213-80-gc93242186b91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 8 boots: 2 failed, 6 passed (v4.4.213-80-gc9324=
2186b91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213-80-gc93242186b91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213-80-gc93242186b91/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213-80-gc93242186b91
Git Commit: c93242186b9196ca754dda98aca7edb1b734dfd9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 7 unique boards, 6 SoC families, 6 builds out of 117

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.213-80-g5e=
b5593c7143)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
