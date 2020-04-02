Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D1419C9F6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389963AbgDBTXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:23:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33648 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732484AbgDBTXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:23:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id d17so2309996pgo.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IUgM9FY2AkCkhd39DaOUYF74PHpYg+kkbbyR59VtFow=;
        b=yFaFz9V0Hnh8NkwJGYZlqAYKHJ+nPDk9ZtXbKDoo/fFF3l3PdFjYqttoAHpv5ru6rm
         JKjS3HSM6nGGJ8Ya3ZogG2+hgzkWvBXEWUxGA5cY1+17lApMaqYWl9oEIvryUen8wXpx
         EF4u4Z7ZRm8XWxaAayioETb1dHp4ht7RJk9TvyLmECL1k8sc2Bmle7we84O+KJxgmNFy
         dHfHejIh/3hDDH5lbZ1a7CbwB7/wnlKZmIO6R2KsvWauh7IL4jr9um54PDL8JxNEC0ea
         LrNF9sULW/E++trtGLjYPIoxXwyY4qZEwFiMD1H4cUNrQidEQGqgluTRLQrBncN04rbJ
         8GiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IUgM9FY2AkCkhd39DaOUYF74PHpYg+kkbbyR59VtFow=;
        b=YJcpGsIDfEsX61/e7hlqImeyrm6WCvlqlHhT5XuQQU9WfQzA8xahV3jogiYXKChNGv
         GBKicKij2IvxFbe1pP2hDO6CEx1qM+s53cVVUBFtQPOKfN5rBLZgbtQjDOsGS1ERolnj
         Nnmqkw4WXig6xKDNrlMsA3jSpGWNkHfaLtU/IAo1TSF0lU+Dn3SUz9jm+9xbS5rxy5HU
         4BWV9CSB3qiXoT9n7nMdcqjD0IH9bCxgupdCqdrvEjnHxQ+AmVk3Y4dfCyqKQBWxHBuk
         tJj8VxxtK71fyhKATEYQaPt0lUBvbFwynsV7bnVSUQ0f96gShnAZL4GB+bpTXOVcNnPX
         0LVQ==
X-Gm-Message-State: AGi0Pub4G6x9uYL+OPmuyQVNM5MVJv8byuqipYm2B/H+t6EaQmhKvzlw
        Y5bYVf+8Mzio06w6RZFxdFRnfeXMJ0Q=
X-Google-Smtp-Source: APiQypJ5Y5pdkeiF0JBjM/5ZhrQBtWfeK2v1hM80L/FMI2lMzQx+qXBPLThHTDS5/XSNKL32jHGKsg==
X-Received: by 2002:a63:2542:: with SMTP id l63mr4612553pgl.312.1585855386056;
        Thu, 02 Apr 2020 12:23:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v185sm4236393pfv.32.2020.04.02.12.23.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:23:05 -0700 (PDT)
Message-ID: <5e863b99.1c69fb81.9a63e.31d4@mx.google.com>
Date:   Thu, 02 Apr 2020 12:23:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 94 boots: 1 failed,
 87 passed with 6 untried/unknown (v4.19.114)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 94 boots: 1 failed, 87 passed with 6 untried/unkn=
own (v4.19.114)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.114/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.114/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.114
Git Commit: dda0e2920330128e0dbdeb11c8f25031aa40b11c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 55 unique boards, 16 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.113)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.113)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
