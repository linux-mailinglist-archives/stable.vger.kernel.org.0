Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751751A0AE1
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGKOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:14:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38705 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgDGKOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 06:14:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id c21so583169pfo.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 03:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y8y+V1FyIXvjAVTSZ2onrxXu5CRCieoWRaulo3rMdsg=;
        b=AUWqeb1cknOp4rVoAUhFTsyGnzBUexknVgJgfAobt5Nj0hBQWXIPliQCXSVmLeOFtU
         oPBuDzAVeikmKH15bgK1tP3ywk8AblVjsIcog9NQl1FH35KbtGERkfyoXlNh/XwZc5xe
         I7cpPgD7TZxlN+2jiF/YTvA7Ns0BFqet0zazhyylnYElQDE7rN5PkY7J/CaR0UZn6KUV
         IwWFFi+7nZ0sHojLj6Hn0ebwffB1wFBtE4wMZnfM4QN6ys6pftJ1IItu6Gjz46qrz/f1
         VgOLyhpG4xz2Lb3JDjy0uVUuo30+LYPKzF1CDWkcw4uUAeK6t/4rIxgiR2eNMBA22K31
         uFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y8y+V1FyIXvjAVTSZ2onrxXu5CRCieoWRaulo3rMdsg=;
        b=TSzIQu8rUAfmtPwx9FNxUPDtrMZg5XL0LBwX+4LGSOPr7QZckKmnkp31nIxWoMKF4n
         P66XSDSAq2t9HYR/muRuLBB5n4TUrw7zYP4EfXAEpPf4k0P1kQIl6em49WMFMsQpSEFe
         Dy37hq1V+xZfTkO3JjnTQRL1rLyhwY6RKfzlnCFzH7/jololAt/uH3x8HIsT9jqEfBZc
         hBxFSeORnmLHquTtXxVf7rOzb7MO66F2ywi+c1ERNiqOTJoE8hMoARF3hRqaY4za3NCp
         hcwzIAQ5QEieYt8FVxCYZv0IqyP7JxIYJxMcHnFt0CBnGsdO5k5jM80HL4+h+lAtQqKh
         f7bw==
X-Gm-Message-State: AGi0PuawQm9BNe3452tDJ5fRYpcTIBSuGlbMfe8tm5qxgXckGr/WiYwt
        s3CDnxWOTqRvsrz9VsvURsxrkhJetNw=
X-Google-Smtp-Source: APiQypIX35DRuiIVlZ9PcQwRyPZjdQ9ywA5PmT//fBQs9DAKIgBL2lSd7plzQNF9v5ODgpmXlGfDXA==
X-Received: by 2002:a63:ec0b:: with SMTP id j11mr1295948pgh.376.1586254481037;
        Tue, 07 Apr 2020 03:14:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v5sm13616615pfn.105.2020.04.07.03.14.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 03:14:40 -0700 (PDT)
Message-ID: <5e8c5290.1c69fb81.db0d2.f821@mx.google.com>
Date:   Tue, 07 Apr 2020 03:14:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-12-gaf9a53bb4e1a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 112 boots: 2 failed,
 103 passed with 2 offline, 5 untried/unknown (v4.9.218-12-gaf9a53bb4e1a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 2 failed, 103 passed with 2 offline,=
 5 untried/unknown (v4.9.218-12-gaf9a53bb4e1a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-12-gaf9a53bb4e1a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-12-gaf9a53bb4e1a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-12-gaf9a53bb4e1a
Git Commit: af9a53bb4e1a9502329b39b4001ddccd5fc01792
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 58 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-10-g7971bb00a=
c53)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
