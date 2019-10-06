Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBF8CD9A9
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 01:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfJFXiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 19:38:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52397 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfJFXiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 19:38:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so10635885wmh.2
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 16:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2AVVZuP6kRpkgBFdGu0/PBs/Zxs8/JTnpS/uTskY5hQ=;
        b=y698TBInYTFE/R40gSscvTxJJK0eRli/A6PDZ4EAVtidYLzwtM1KXLtWpGdwvvvAwG
         rUR7E59KIY4V83CnXsLl/aWJElm1UurSbhuPDLSnVV0egqEKwI14WOtyg2yCm3UIGlqU
         9K6EcCOn3RTz5vjPVDodxBIIdGkZlTqo7mhn9eiM/6gRsd/XZ1tzTDEBFakGpmSJhN3L
         Q8WoOtJp2EuAM1PzrU7s7TmFZw9XK8NcHpw1EyAYQYfnGUmSd4KFIqmgudSPzO0UqIHu
         siH5q64Yh/kEvbCmYGDDh1f3rHBhpXHdPvwHy92MbZOI/3yvilZZt5kW6H5A6KECJrRe
         jZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2AVVZuP6kRpkgBFdGu0/PBs/Zxs8/JTnpS/uTskY5hQ=;
        b=uaqcRy674a53wQ+qNoWMDgSGNd1C43C/uKxmcJ8oeJnmsaDxlbixssJ/u1XkLVu6QU
         96AA7HhCiHcFqzOX/DU+RYgsN1QsgrmcCPxa7sAz3hUgYDZtKy2006M/Qd7XZMGCjqy+
         pG0uf/OU9PpwqBT9cI6nWLTSC0rB+MssSItTkIj+To6jHiUh3+h7jOxRuhEjm5OjYFBG
         RlCiraEWJTzl2NdYxBMkjTt9k6vN9ifCdK+4CDpEogg8pamS6C0UDaPk2HWkqv55KaXm
         Xl+PIJPsa+WF0nR+SWYLb0uL+hx2UrxBjEggWYCjRGuhMzFGRxA37rSEwFsu1kAVjsbZ
         Rxog==
X-Gm-Message-State: APjAAAV5GgL/QJtJfntq8CoZG1Fgyw4C83REBZQbLX6jAdSueNIEjVIf
        3uP57LC4PRgANYoFahCF7CJn4sV5M0I=
X-Google-Smtp-Source: APXvYqxh9KoqGeuyuPo7oFGXRx1m2bNcrmQhi4uF+OEDoYx7qsO+Z8WHcFjqI9ZPy0ZoMOJ27Fi2qw==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr18986552wml.52.1570405087063;
        Sun, 06 Oct 2019 16:38:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m7sm10361259wrv.40.2019.10.06.16.38.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 16:38:06 -0700 (PDT)
Message-ID: <5d9a7ade.1c69fb81.5aa5b.d5a3@mx.google.com>
Date:   Sun, 06 Oct 2019 16:38:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.19-138-gc7a8121be8ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 62 boots: 0 failed,
 61 passed with 1 untried/unknown (v5.2.19-138-gc7a8121be8ef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 62 boots: 0 failed, 61 passed with 1 untried/un=
known (v5.2.19-138-gc7a8121be8ef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.19-138-gc7a8121be8ef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.19-138-gc7a8121be8ef/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.19-138-gc7a8121be8ef
Git Commit: c7a8121be8ef67066e07c79b2204dea12511b17b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 16 SoC families, 12 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.2.19-133-ga4c5f9f597=
86)

---
For more info write to <info@kernelci.org>
