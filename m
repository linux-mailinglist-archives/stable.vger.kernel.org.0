Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04B01B3477
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 03:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgDVBYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 21:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgDVBYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 21:24:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DDCC0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 18:24:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 7so1835035pjo.0
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 18:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A+/WEW12COx8HRpYzkblkGOJZQGdiayt3lQeQ0bDlzE=;
        b=GiHem2ESqS9q6kFvI0E5HtP8Yy2gJc0W4vFR4Nr43fv/nr1hPsX1pwXpWHrhHJi4IR
         Y9Dxe2Y1wyXw+e40+exywMUB6QJF6pY1q1fgmahm1ntCyQ2X5tO0dj6ff4tc7+SmsdGR
         4dLsB0HZIlyopT2ShLkRDWBRFnDHqM168/cnDRG71aixTZlHyZEivjejK4DF7B72PGWb
         KoK7lgmbIOWKyuGQTqQCJUBeL3er1CNmuVdYrOxfnw7uv+dDkjI6nQoGpSi4VGx071fW
         8xUqFk70rFuLo6pAPKPjmza7cp2TfKIXPS1Qa3sL8lUdCaw6cxzNRGWWQs7K8gje+Vqz
         8pRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A+/WEW12COx8HRpYzkblkGOJZQGdiayt3lQeQ0bDlzE=;
        b=l0toaQ4hsmMN6fA7GO/N2eWC73bPqYIkPG9yonniQI7zl400dDBzLb20yYZtI4mBmH
         grUS68dipNtdpe0Upy0qj31WxuSb9SBJtGMthsBp8hzX4VLiEP5sRKyyoDxGJW/nkGyb
         I+RPKtFYTygpCP5dxBk4T9QZGDQIYucv2iERcdwSIkODE/zhPNIjlTPH6UCwwT3k9SUt
         1ssh0G7ZNPm3cKcK6B8W6TPmAfMAKK2kflplFi51VDn8A658LXkISFg9d/bzMyy5RCoa
         J0AGi0yVnCcnpQPf4tKN/ZSsgf1FtYna665BzM9Lt08+9TLvhZn0anKcECbEcufBwDlq
         hcJw==
X-Gm-Message-State: AGi0PubxNUJqjqna6nOxJLMNy5+kQPmxwUNEL0p9Tcqb/ww0lNZRPXE8
        TFn2g+fDVU6Mx48girb2Ruc4h53HRtg=
X-Google-Smtp-Source: APiQypJgMtYye9HyU1Md72njC2f9cEFQZppdfXXOdr7H1fRMOhyez5jB/0YWgzdsXRzFpUoUqGw05w==
X-Received: by 2002:a17:902:8608:: with SMTP id f8mr24264917plo.110.1587518689312;
        Tue, 21 Apr 2020 18:24:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22sm3718313pfg.169.2020.04.21.18.24.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 18:24:48 -0700 (PDT)
Message-ID: <5e9f9ce0.1c69fb81.7e584.d45e@mx.google.com>
Date:   Tue, 21 Apr 2020 18:24:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.6
Subject: stable-rc/linux-5.6.y boot: 47 boots: 1 failed,
 43 passed with 3 untried/unknown (v5.6.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 47 boots: 1 failed, 43 passed with 3 untried/un=
known (v5.6.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.6/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.6
Git Commit: 7c57270321607353f2bc2f1a866b96fcb3454386
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 9 SoC families, 14 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.5-72-g906ecc0031e=
d)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

---
For more info write to <info@kernelci.org>
