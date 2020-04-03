Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6019DC69
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 19:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgDCRKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 13:10:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41568 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgDCRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 13:10:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id d24so2935792pll.8
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 10:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bIN6QgmUegrokGjCCSKHNhVGicSGJvhH6t3NaqBpDr4=;
        b=gzCO+HIo1yhrscAZWuwdsackiO2s3r8O0x0CYbA2zsxYYu1114AGmZ9E/Mu6J21fGw
         DsifANeDSp5HAAiG/sxu6h+vYBnhjhR+zrxozvlngYi4/taVFf5YFoB4Feflfjkd7yFy
         l993ajJSP8tDleMWv4YSEHv0zkVAD3ch2CFGoazDX9m/GgkrygzE1MRaTMksy6jKm9gJ
         PZsmUOy2vURAfWyZ9jdbTvwLKyiGsIj1aTTOjcyCF5+cnTcygRWqq5eFh8KR8zolu2a5
         l7qX+zdBZ9RBUQQ8YrkR3S62RjIv1gtO2TGPTYFHeOT1QQZtn2mimRlAdDYymH3OCHjK
         TcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bIN6QgmUegrokGjCCSKHNhVGicSGJvhH6t3NaqBpDr4=;
        b=c2LWLk5Ozbm/x3zBfeit1qc+nvlMkB+I5IUYt3QtnlxH7G+z7kYN/QJRXrxdoMAMSI
         FvCodau+8O1fw5px2/uW2lo1VdOsm84aOqFCQQTqFKueqEFbZ+gyaMogURNcPc5fpQOz
         7xFF4Eq7c7IT9g0dzKzrMNlDH/PjrLHzmSffQH8OAGfA4a7gds91ZhhMENxQWCpKzGXj
         z5XIbwWBs4RbZF+O0AY9KqaNepficu0keLmiUTxAskNE1J3IeMyeCI5S1eXi0y2o4qSO
         Pqpm59H09U2ss0X3KyHcqzxcmdUe10v3JxrAt3wRqXZxbj3+qN5lczHwM7ynkwW6WtnH
         wNog==
X-Gm-Message-State: AGi0PuaIWH/uXaUjAIEPCd9+HWgYCXOHhYpx7jFLnPDeeNeUpqnryur/
        0BuVUtFkkxn1SujTEp8UYR7F7Tb3vGc=
X-Google-Smtp-Source: APiQypLxPFExragQCkk2ZhLYrVLbIxEC6v10DvZOCy3k2zwjVIWtbhXIkcS3VklKcNpdyt8BwhXaMw==
X-Received: by 2002:a17:902:aa88:: with SMTP id d8mr8635981plr.201.1585933804587;
        Fri, 03 Apr 2020 10:10:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s98sm6115430pjb.46.2020.04.03.10.10.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:10:03 -0700 (PDT)
Message-ID: <5e876deb.1c69fb81.b7256.bd9e@mx.google.com>
Date:   Fri, 03 Apr 2020 10:10:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-10-g7971bb00ac53
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 107 passed with 2 offline, 5 untried/unknown (v4.9.218-10-g7971bb00ac53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 107 passed with 2 offline,=
 5 untried/unknown (v4.9.218-10-g7971bb00ac53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-10-g7971bb00ac53/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-10-g7971bb00ac53/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-10-g7971bb00ac53
Git Commit: 7971bb00ac53ca61eebd562e3493e9d38d4bba5e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 55 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

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
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
