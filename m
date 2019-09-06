Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA0AB972
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbfIFNkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:40:17 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:37957 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387994AbfIFNkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 09:40:16 -0400
Received: by mail-wm1-f48.google.com with SMTP id o184so7149928wme.3
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wd/yGH7Om1b0L2g4W/Ne83gpbvDfpXEmDeYa6BeXoOM=;
        b=zmtNMeqNzx25aMoKFiA8j3aL9vz5cGmIr6Qa01t73b/YYeO1RSYP8S0MKHl6I5bsBq
         /wjD0YLj61IBpnJTwsqkgG/JNdr9MwqohQMSw40sDavlXzhZ2RPjZ0heAhh728cJszFu
         m8SFXCJ2Pl/NzaV1GD67/MVOmY03H25gOzKlIND+Xa9ySq0UYikEnAZBC4UQMoIM5LRE
         Rdn8h1/We1fLKyF9j84TcbAgzX26droIOSek9+5i9wyIP9TzUDIswnGLGp/N6rOUw4W+
         gxPdY7MEHZXVLDonkSj+j2m96gVSaJqhOOe8GYvHl8V3qUv/x6tpjB/0l+NywvWF6nLa
         hDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wd/yGH7Om1b0L2g4W/Ne83gpbvDfpXEmDeYa6BeXoOM=;
        b=m4iSmBjrAxHz6msnu+0Ujn1PfgChv1o564F8w4fabu0VG/SfcVyGVUF3SgEpsr/RBW
         CXeN0hP2ePaG6wjqEhdQOF0HmqyM6WBFotSHSbGbmLFLyZaZisUX+sJKTA1Mf6lPjjh9
         nAzFsMg9RFbNJFp72NJEOlBDxu5AlmI4QZDiHntWUUjv8nxiGzZPwIQaU85A9r9fQ0Sy
         iuwEGoi0CI22d4jQtm7G9vg/V1wY4ng6W7nngKa6+GGHiivXouW386GJrx067VqgghUs
         CPIIShL5HvUttT58aM2NrmnuHcSIFM38OS0gxpNzsKje9ZrJFhgG+s5uMFh0vaSOrIng
         8M4A==
X-Gm-Message-State: APjAAAW4GNkvMRzDxJ3NUW9L7zGw12xmC7AQlCY+Pd0zZdkxcweo+1Lv
        s4Z7KMv0IqDNDlowX2dxK9xBU1vdwEB3BA==
X-Google-Smtp-Source: APXvYqzgUc4aZFJOac6KalQgRp1n6LnwjWP21cFT0Z8o3F1ibX2MbKTJbd+XbjhpFHZCl6Ka8E3nnA==
X-Received: by 2002:a1c:1f10:: with SMTP id f16mr7582773wmf.176.1567777213872;
        Fri, 06 Sep 2019 06:40:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm9098657wme.36.2019.09.06.06.40.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 06:40:13 -0700 (PDT)
Message-ID: <5d7261bd.1c69fb81.e0a92.cb55@mx.google.com>
Date:   Fri, 06 Sep 2019 06:40:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 94 boots: 6 failed, 88 passed (v4.14.142)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 94 boots: 6 failed, 88 passed (v4.14.142)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.142/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.142/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.142
Git Commit: 414510bc00a5fc954d8340c170083f518d09aa55
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 16 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v4.14.141)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            hip07-d05: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

---
For more info write to <info@kernelci.org>
