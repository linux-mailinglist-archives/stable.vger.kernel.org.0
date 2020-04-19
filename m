Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE86C1AF670
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 05:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSD23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 23:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgDSD23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 23:28:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AADCC061A0C
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 20:28:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q16so3621642pje.1
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 20:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=85kVsE20ZSNnSFuwOGztHc5Schvylx6CaBhUcihYG/A=;
        b=LWv75MGQ3HcRRz1R6XAEEs4h63TwtajkJXy37CNPxaC6KxGeq+XBGytwtXuNjBdHGx
         JRWyd3OK9zI/73nbW/9EYKafbxMZa7RLJoPrfSbfW7n43+dlrQ7XFj1YngDtJkcY9Qcg
         Lyu1YIA1t3eBrPmcrTZGFmCv64AlP1bpCnXG52xJI6d+Qlweep6LfQm+wQMMhcFCu4T2
         iXy4RxQLHkM8c/Pt5Tn4eXzwSu2zetZ1P4huwKy8OBICvzNfobWT4qmj6LaTps1pySyx
         jN9nEQCwL1WuwXyL1DyEKOE04og14TiFpAGc+Fi8rNYEgcZJV9krwYYsPNXo51y4jTFV
         AEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=85kVsE20ZSNnSFuwOGztHc5Schvylx6CaBhUcihYG/A=;
        b=FQWiq5Mfmet1sxfmZ22/K4zdGSatBo0Y7CwCmRdMIF22EqZto80QlLxwYAPGLwCu8d
         0b4gijI/eY4v39pPo0H8JcEn/fFccCFRYM9Y4fKtwLJY9T9GkIkYe6epjEV3MFbNTQzu
         en2y4mPKqCKeuTG1s35E6QaHrVbziZh7TlrMEKbGPBFZhg0dLa//TSrYq40SeNvtL4mW
         6gayYhCimetmmh3gniCJJHEVpYinnvCMcGVkH2mu2Ee5z/VZ4RN4gLqr7Z5GYEHKZsek
         vtQf9fhY9W9woSZ1CMIgK4+DAyXg2TpCyN8LzgXpLmXjPMx2G/iPCmQD/5oRFntcpDQV
         j23Q==
X-Gm-Message-State: AGi0PuaZS7ANsH2M7v8Um9W1XAbC0YNH6pL7Ql0gAm8fhyzEehxpTuQY
        kvKqGxeykErW9MCyOOjF7nYZwoLiPAY=
X-Google-Smtp-Source: APiQypI9g9VhJujgIzlKwUvsvbr48uxGmve3a5I8XwDGSujfi8BFGd59YwFkE/JHPz8Lq+19jJdR3A==
X-Received: by 2002:a17:902:a70b:: with SMTP id w11mr11262198plq.59.1587266908223;
        Sat, 18 Apr 2020 20:28:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ep21sm9482405pjb.24.2020.04.18.20.28.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 20:28:27 -0700 (PDT)
Message-ID: <5e9bc55b.1c69fb81.f546c.4ebe@mx.google.com>
Date:   Sat, 18 Apr 2020 20:28:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.116
Subject: stable/linux-4.19.y boot: 110 boots: 1 failed,
 104 passed with 5 untried/unknown (v4.19.116)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 110 boots: 1 failed, 104 passed with 5 untried/un=
known (v4.19.116)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.116/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.116/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.116
Git Commit: 8488c3f3bc867e4422bf00b303d7d1fbe829d528
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 64 unique boards, 17 SoC families, 19 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.114)

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-56-g6dd0e326=
65e5)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
