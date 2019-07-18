Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC30B6CAEF
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfGRIbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:31:44 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43473 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbfGRIbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 04:31:44 -0400
Received: by mail-wr1-f42.google.com with SMTP id p13so27645675wru.10
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 01:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZsUEgLrusu+u43hwLZxhDyob1xFy5O0xi3+nZvtcbfg=;
        b=ZlXYoRoGgyYZVAQYoRtrfwRnxrulq9HpSzAO36HmpR9Ek+vBLPAF9O0Yy6U+PrO8bn
         i7+pNPoSfYJMTpiUqR+bqgpyNg3Jpaxg+vXLBU9lyYhepqjTs9dkTzSSYyl0udrCXKj+
         L+Qdwm59RCJQVmjeNXjix1nwr0+wOLmycv3IHV0TjE/AebE3LIm4RjJEUID8VcqC4PJT
         F+fAnZgmlcs41jzvCkMO6MFRgOQd7hCQPVaRt6f8JneN3hgjmR/DO2igMzlgrzC4O0P5
         6RDqzuSHfVyPwYh5IwpG6Hj39J6ASRIrJRHeSsBMUcCLs/eCVm8uUWLYR8RNSFoMJApe
         88MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZsUEgLrusu+u43hwLZxhDyob1xFy5O0xi3+nZvtcbfg=;
        b=AakZSN4OPKAXjzl1/6xDQekH1Q9VjmNBT90WjllOA5HUxlGHnfhpExB8zdpk0aydwh
         3W1HKcK1KwHHwmh/EkzyAcyL7w9sRHkjdM3c3A5fAe5IGOJ05FFlUTzaV1npbbmGF35A
         kJNNooDtsX07Dnf/MLkRrY9rpdlFl26j1VuJ/4jMvYfy63e0FgzF0Wznm1dKDap+quFu
         wBoGJ0LIGVuzIaZgga4txDz3vXBTGZyl7T5gVJGNNYUjdaI1JiLs33XQkq96wK0wtHYA
         IMNBB6qw25zTTXgd/Cv290cU27UvseuB47f1SXlzbMhp0IjRoIpjZ777eLxtCFR4yCMW
         pH6A==
X-Gm-Message-State: APjAAAVz5JpFi9Q59/sFDjZbOdrZrPfzrOmJawRB/sgDsn7eCDezTl5a
        mxj6ATVXpVaHaTyft8L8l9dV7K8q8KY=
X-Google-Smtp-Source: APXvYqywH9yOYH/BLsUnr+Glfo1i2ug+0zkqBbwK95bfnHa2A0hNPMCZqMUJk1ST976qRdfH90x8DQ==
X-Received: by 2002:a5d:48cf:: with SMTP id p15mr30211305wrs.151.1563438702208;
        Thu, 18 Jul 2019 01:31:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h8sm26682950wmf.12.2019.07.18.01.31.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:31:41 -0700 (PDT)
Message-ID: <5d302e6d.1c69fb81.8c392.746f@mx.google.com>
Date:   Thu, 18 Jul 2019 01:31:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.133-79-gdce2fb93b255
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 2 failed,
 120 passed with 1 offline (v4.14.133-79-gdce2fb93b255)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 2 failed, 120 passed with 1 offline=
 (v4.14.133-79-gdce2fb93b255)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.133-79-gdce2fb93b255/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.133-79-gdce2fb93b255/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.133-79-gdce2fb93b255
Git Commit: dce2fb93b2558783bf0740ab72ae8aa22908abe6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
