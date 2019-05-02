Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852AC11A16
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEBNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 09:23:32 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:40139 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBNXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 09:23:32 -0400
Received: by mail-wr1-f47.google.com with SMTP id h4so3343166wre.7
        for <stable@vger.kernel.org>; Thu, 02 May 2019 06:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pWqRDQVb3Girp3Kwe/JPILsIwtMMUAIt+M73H8w8ZB0=;
        b=lY+6+2kJGiWKzONwp3z3jfJOuk8knhk0J17LvSNax9sCxNVZEfv91KrrjPrEfQGhH1
         /BqG6HCp1h+aLW5K6VZy9nHg07eTrTNeQA1yQN/4sDtSi4Pjm0oldJN+ns0D0oCpNYLo
         zB+OY7bVzI/jJ8fVM2UBdHa6GwKswsC5NZ1hKzysWK97ZMWmFjrQhbMguD1EgMRXaRaB
         TT1s/LTDm9FLSOah2oKSB9GMdYbCbZ+lyi++CN8lbkho7jnW0oGNvN26WE893yJhbk/0
         qCy4UDg/suh9tkI3/E8Us3+6N/7II37EEg5U+wVACIVFUce/AlEyBByKFYegj5Pq6pDq
         ZTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pWqRDQVb3Girp3Kwe/JPILsIwtMMUAIt+M73H8w8ZB0=;
        b=Bv1jb9/MLCugHDNV55r44/qYldG4pZxhN57Lt70pJ+EFZnKD7UzSEtVj+dmTyUbyEq
         c+dHGQTkoDKaxhGaTIDlNptcF6GEHNmkete2VvZvZjfDNyx104PQtvqXb7bnpGzukCUT
         90cu2rPHKhpAKN0TAmMOWLmJ9V7gbtQybjGk3bZrSPQ+Ts62NA9kBuxDW0CKKpJPsfdp
         3dhLO3fnuLo6t6vYehnzSwBTjpHJKoqipMGDgMABC97CU5jTIyOIwa/bzPzhK97nOlbr
         OVfEn20beiPD3Qfw23+hubBtKpYcmjibvxCxD6kktQzR4XZKN5y/O+QYEKTfzzmdpTf3
         2Zjg==
X-Gm-Message-State: APjAAAUXqNlXO5MsQVNwMhSeYey3rb94ED3aI7V7Q9I6iSwP1D6Vcxdi
        WrajN29W8djD/5mN9CVCyQ7FUUZpnWQzEQ==
X-Google-Smtp-Source: APXvYqzGc4Q5wiO97rYw0Egx8vcVAEQMnOtOpP94EkGUfqqKMSx5IVXkUHPl62zqZScWE2AFwdUR1Q==
X-Received: by 2002:adf:f68c:: with SMTP id v12mr2909584wrp.40.1556803410213;
        Thu, 02 May 2019 06:23:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v9sm2822259wrg.20.2019.05.02.06.23.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:23:29 -0700 (PDT)
Message-ID: <5ccaef51.1c69fb81.b93f1.fc3e@mx.google.com>
Date:   Thu, 02 May 2019 06:23:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.115
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 120 boots: 1 failed,
 116 passed with 3 offline (v4.14.115)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 1 failed, 116 passed with 3 offline=
 (v4.14.115)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.115/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.115/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.115
Git Commit: 1c046f37313210e0c41b036fcd14c4bdb1581d47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
