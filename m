Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12BF6A63
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfKJQ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:58:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41381 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJQ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 11:58:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so12088292wrm.8
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 08:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yvbNMkXdALI8POpmOlZsGojz1d4yNgSez82IC788SnI=;
        b=KDwwtqYQSXlQCX3e8ZTUjaaDkWWnh5lOa3mrgHDTVMMmMpGd02iZAhmEIqoGNOxgoN
         ji9OqNk9q35zL6CXiWqw2hkVPd44xMk5+HMMYmMzpQdmm9GtEIAlFKqUv83KYJ95RHr+
         dPvc75TJArro9LgN5IumEqFMfU78FAC805JNO/olWXntec2oYerNbsIaw47Vg8HXvNJc
         iyOC/yXkd2EUqbb3/rYBDQ5z3tdu+bMgqx5qjgEnrYQ3mqNZkt7kIlV8fQiqIePB7q6m
         0hgXVtbUhS17BPD98tDrflYTCmxETYjClN4QW3Aq8vcqs5JCe+jjd3WhJs6AY9e7Qqid
         wE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yvbNMkXdALI8POpmOlZsGojz1d4yNgSez82IC788SnI=;
        b=fNEdi8VKMchfOvdpAEmew4zSRwVftnuZ2KDb8tpfoh/Q+3C38aCca/HJeqgh3JJ3E5
         AzIO9i9f2tjdNmCh0cpZ5f9Vncs4TaGeSGekeAGpGb3l6nkMBpHhtISOR+D5cNXXRLr3
         N9WTusBrnTxX7FMLP5cgwsEQsBQhCbAzgsfcyOAwt0VpPu1PJDtumu2VSczRid7WnEoB
         XmN86EHtk2iOLEl2TTyMwkxoCrpDuKtHwvqhseCouWXZm8UMLsH7GoTW+r63bfNZA3Mj
         m/hDwnkuSstKlBg5iZmtKSKPidYd1GoZTxrUjrMzP2Fz7GwH7j6z4jClM+JlUEEFja1M
         EjYA==
X-Gm-Message-State: APjAAAUb4A+Zo+nEMiXovrqMDsIBJb5OxkXnoKCrLDjPxW0/vNjwz8dQ
        XZgLZW20zZUEeSN1lZrxZNVXI1itRIc=
X-Google-Smtp-Source: APXvYqx146HTRMMi0wkCZnv0udwy3f7lmAzmkf9BOPh7xYQeokSb6hs9mxOKsV4GmceXAgo/HkKAfA==
X-Received: by 2002:adf:db41:: with SMTP id f1mr16447207wrj.351.1573405108026;
        Sun, 10 Nov 2019 08:58:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w10sm11046018wmd.26.2019.11.10.08.58.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 08:58:27 -0800 (PST)
Message-ID: <5dc841b3.1c69fb81.a5fbc.44a6@mx.google.com>
Date:   Sun, 10 Nov 2019 08:58:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83
Subject: stable-rc/linux-4.19.y boot: 70 boots: 0 failed,
 69 passed with 1 untried/unknown (v4.19.83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 70 boots: 0 failed, 69 passed with 1 untried/u=
nknown (v4.19.83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83
Git Commit: 7d8dbefc22ff71c12c5f63ab0c6de7f70d1f044a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 14 SoC families, 10 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.82)

---
For more info write to <info@kernelci.org>
