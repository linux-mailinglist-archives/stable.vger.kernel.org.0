Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5246AAD039
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbfIHRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 13:39:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43621 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfIHRjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 13:39:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id q17so6649432wrx.10
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 10:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5kQ6HXuzPDYWwcW6LGTETllbdFh0hY2sa8z5UoJzSYA=;
        b=M0gMAUkrGtIdVBEQzo35SqaZPqL+6X/229ctOF8FFSfkFIYOzkQE7xtMyoiRtAPt8d
         yysbvi7qDzMjmmh+dqAOHn6DYz05SrT4jkNQHeEES/2odVQNyAvDXnJrcyE6Gyii1ee7
         /gqwvn81EEXVilt70SDSCnYggk+hEkzdJUr9lEznxlTNp/pkoIMI7UkeFD5aPN7I8I9+
         BY1eDaHvkjfDPZsSLQpiGeW3uVboXYowVRprwEGeGUflYqKUds4lZ2f97K/LUH3MqKby
         JluZ4V5pL122pqbrMHcvG3UVv4TLm2K5Wz3kxcTof3SLpCaXMfhRZg/2YeNWizYl18XX
         zssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5kQ6HXuzPDYWwcW6LGTETllbdFh0hY2sa8z5UoJzSYA=;
        b=SqtnCArHuvIT2Pia42WDIXLF1Fnq74XJtvKXihcK57NzfhXg1tgmcXrvl3V/vtFCOT
         aEuD/Tn5dPQcnjTqMpJB6eadhw77FmIcvWqpCvjpSGGO75dJXhYHsDuqtFedT/P9mKH/
         Q67iVznVT2cCHAza7vXN2MrDxmPQpij3jlbVyGdmbK6U9wLDKdVV8YlwO5p2opuQ4v+u
         Y71KEMeDnZIOtWvp0I1G940M7GLzdiGjrOCc4SI5fthBuEzefouFD04LPQgaKNU4iXeZ
         vZcHS9pmYrsnDsw13ZXqwAQnF++/+NLl0cg+Rb+pi+OwrFJcvQNw0xn0pDywJWbnq6u8
         yEvg==
X-Gm-Message-State: APjAAAXpvoQcyerI6LF6Ms2GSV7OoFrcgCRfOf+d8RheeD2JW5wzBWln
        RK0dr99NogAeDrvCGL1jnOfI8sw+r8U=
X-Google-Smtp-Source: APXvYqycq1FZQC2mqd8y1lab1YNS5/txYhiRMmxLpapx96I3gZ0wOV8I6g8cbTo565EpdMNkO1EsXg==
X-Received: by 2002:adf:db47:: with SMTP id f7mr15311350wrj.1.1567964350915;
        Sun, 08 Sep 2019 10:39:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s3sm8170769wmh.37.2019.09.08.10.39.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 10:39:10 -0700 (PDT)
Message-ID: <5d753cbe.1c69fb81.625ab.494c@mx.google.com>
Date:   Sun, 08 Sep 2019 10:39:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70-60-g20f1e9f54416
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 86 boots: 1 failed,
 85 passed (v4.19.70-60-g20f1e9f54416)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 86 boots: 1 failed, 85 passed (v4.19.70-60-g20=
f1e9f54416)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.70-60-g20f1e9f54416/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.70-60-g20f1e9f54416/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.70-60-g20f1e9f54416
Git Commit: 20f1e9f544166cca04c111f8719286155a5b9b09
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 18 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v4.19.70-59-g131247eaf9=
e6)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

---
For more info write to <info@kernelci.org>
