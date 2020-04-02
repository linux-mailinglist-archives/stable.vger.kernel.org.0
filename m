Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D9219C984
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbgDBTL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39071 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389163AbgDBTL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id k15so2209430pfh.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OsUyv0n+aFOOgHR3viRP0mmEGS8ng/lgXBO73177fUA=;
        b=s38MIG7kZHDSvx8o/MMIkbo8Xtr6IQPW4MD0I79dYaZUvAAApYVVYISjC8my8zirPP
         0c4MbHznxO84XU4a8xLD8Ae2LwxmMHBV4+yzVUKZ4nOmos4HEU9EsFGag67k+p+dK/q6
         xn7B2bVed3rjTlQcipviwg3yTlktA2JOEk165zFn5xlgbJVnVj+0A8BqO4kMhdzPSWcj
         kKVoAV9tY9PUdfb2xOptlAFOzpZ1nsUwXPUyanIx/iQzBghsoekAbyt8iGC/muRejdT+
         Y6d7mr1oyxCHP7Ti1tY8kk9fh6DoEDWoL9S0YTAq7QV26n1KCFaXbuuvi7V+4jPguwzv
         Hrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OsUyv0n+aFOOgHR3viRP0mmEGS8ng/lgXBO73177fUA=;
        b=VzlxF88yzb3+Ci75eouIJ1qZZgnarAUCZXH7GR4UamKQvvtNsbDygHNpCI8wRog5hX
         BdrRqG5bC3ipU38+giDlomzL1WlhJBHEOeTirVOwFh7mlZnvTx5oHRFNlRdHnb6wQcs2
         RklQqZzvSF0Wo41POBprcY46mZkAP/DUS3nDxuYEObxjXtDDYuRYYF7Zfu38S1ePi3Jn
         mzfsdub90Ni7QYjOdkgWTKzU732j2SJy3F27L/NOpCsUo5MXlAC2ZL7EwnaqXrjX1ttf
         rD8nJQAFKk9PO6ct3WafbPmz+yScdbsXQxVWrS/kRMjl+3GHG0Okokl5lyAtYg85ngjp
         OAAw==
X-Gm-Message-State: AGi0PuZQtHoIFQfS2Tsv5tqTqrNxb0vyUrJ8WuELdOawZW/uTgDM7RQu
        XnvA0FXjVgW8ys06SIVCt0Bogb6epvg=
X-Google-Smtp-Source: APiQypIrt/ka0hEA1iltKDqyonqjCOw+ARuVd0DvDhAfAXj0VqcdzM6NIn4O0Ji3Tr462RN3yIR8ug==
X-Received: by 2002:a63:4f64:: with SMTP id p36mr4662753pgl.330.1585854713682;
        Thu, 02 Apr 2020 12:11:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 184sm3916779pge.71.2020.04.02.12.11.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:53 -0700 (PDT)
Message-ID: <5e8638f9.1c69fb81.20dcc.1237@mx.google.com>
Date:   Thu, 02 Apr 2020 12:11:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 105 boots: 1 failed,
 99 passed with 5 untried/unknown (v5.4.30)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 105 boots: 1 failed, 99 passed with 5 untried/unkn=
own (v5.4.30)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.30/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.30/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.30
Git Commit: ad13e142e024aa194016a32de8b9ba058fe9a6af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 65 unique boards, 18 SoC families, 18 builds out of 200

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
