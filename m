Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D483DBD4
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 22:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406518AbfFKU3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 16:29:25 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:35333 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405476AbfFKU3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 16:29:25 -0400
Received: by mail-wm1-f41.google.com with SMTP id c6so4289950wml.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 13:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LEVv/yECw8h0ZA6xNLFVLXsl9Nj0YqZ+vOreIFoM0QM=;
        b=zNeLqqdtsH83gX96gFa5Ykcwtxa977WsePm5+dEC0j3ZsPCrG4xVaRiJaVGb9NuMej
         aLoORlRzzVZroPzkJ+bQjeiv4nLtRMwlRV+hwz9q3TBnSY5UEw9yu5tcAt2An4FwAv06
         VqWjsKSFQtlgBuMDrQ1O5jAxM8daeOekmvxqb/mOkQOXpiLkNGUDSuFUelxvEJ1Fv8wO
         L5je0p/Tj5CXNVpH2LHbejVX8sGu8FC+llfFlQp5Xsdo/cKMvxWjDCv05M1gORy+eVAq
         fxW7gwOPsomZeKVVzT6zWnwM4/hQ+kzxQdVuRJNs9r74kEDmIa+qHjHXtlerUWiqvx78
         bbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LEVv/yECw8h0ZA6xNLFVLXsl9Nj0YqZ+vOreIFoM0QM=;
        b=cpuxkgCe5m8Y0k95DRbk98W6VQUoalkT4krxwfH8QLB0eWf2+xkr/nkDKBUdIgcswZ
         3bbnAmus2wQi2sqHpsrktXVA/VypH75/vFQoeeSSG7FZe2WeCljQVQuhW2il2DkGsTmC
         nA2LzREkQQ0RBJvp4yPsTvS00ewau05TNL39lb5WQWmV5I6sUOyxGPqHltQlCR9x17u7
         nqsKqWO7tEHSB7VJvcCunbikxKLqYgncMUlFMYTJ4Qe1c/OA8DEB9YZuzkkO5pgwMu2o
         GlT6lX3xooZNVfRvmnohe2yqUZcqVxjNvvFNzC8KGtX0vZprXTaQFGQGUhavc7OPTmaP
         5Xag==
X-Gm-Message-State: APjAAAUFNczcAgDovKwbpcdlufheEe7w6+uSaDDDy2ICytohrS4MUPut
        BleFR4J2U3MpFsjRJrbtP1ICCTXgW4GcJA==
X-Google-Smtp-Source: APXvYqzfTnVIi+B5jcRpMYkU4R5KFhap4VEt99YpcAofPfCuedKHbt3RlRX2HNXzukyCYfSbUpfKvQ==
X-Received: by 2002:a05:600c:228f:: with SMTP id 15mr20227334wmf.31.1560284963890;
        Tue, 11 Jun 2019 13:29:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s7sm230927wmc.2.2019.06.11.13.29.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 13:29:23 -0700 (PDT)
Message-ID: <5d000f23.1c69fb81.c7be2.17c5@mx.google.com>
Date:   Tue, 11 Jun 2019 13:29:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.181
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 103 boots: 0 failed, 103 passed (v4.9.181)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 0 failed, 103 passed (v4.9.181)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.181/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.181/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.181
Git Commit: 3ffb2407c545c389a872c3eb12e09eab34432b12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 23 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
