Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336B0184521
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 11:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCMKpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 06:45:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39003 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgCMKpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 06:45:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id s2so4763815pgv.6
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 03:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QAWndd6b19FjVj2mjhAiVKExFKAX34UyfX4HsuMaXVg=;
        b=xZ/ne4IkT2/Ff4mFy11AyTgKfd1iQ9SWQ0wRr61rrOR61KhhM+AHxz0MKjTmpDAlT6
         Wei2IzVzW8HVYVxHK7jidl6Dju2Xy/ivC08eizZpd2sNFzDxz7WeL5cfsdsZ8wsEVhVC
         rJpHNQeobJ/HRaiOgvh3JXfHgRMso2+PHqGhgfEnWOW8HZu70lnMMCkI8uk2NICEHaTr
         3SjueaUr89OUxyJvCxh+uFEGDKTYo9pc0CDNrQJ4K2tGjezxwg4NgR0Rd3ywC8b0OaXb
         y6Ot3QF+/INk/Yns/ogLPCtMS7mBwoR23A7gwBD+eM5IgpnyaqcvF/O6ms/sUmVoY/Wt
         r+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QAWndd6b19FjVj2mjhAiVKExFKAX34UyfX4HsuMaXVg=;
        b=FbTYVFmdEOCnoWGgshMyI8IZ4t/b1vXsOVkoSmLz5Xk9/OSpwM7N/BaLZB94OBh6qG
         gWqyLDKn/6Ie+fsoYm69M4Hucu3nfvJTmRi3vylnh+jE9pndJ1fBRn/Q4cBN/8dCtOqc
         s6rgx00gvff5UgqyUYqPB/YvpCX6CtT0fO+SkAOe9OjJuOxhRg8pa1HNUXUEz3YMpN2t
         lpi3OFyjsbXwsos3yfVxW+ItqshwNOOjqQadKYZrGpgg1rIeJI5e9wcD8h/Euoi7M8fj
         YKXZ7I4Z+vGSFzRCLmftOgJIH3sxveflDekX7geK9gT66Y1kfkUmBAia0I1xs+TkD9hA
         ClmQ==
X-Gm-Message-State: ANhLgQ1INNK4bLHWEfBWpElEcPhIcEs2aN9qeqMyTFlOsS13uxbU6OWU
        q7dtBlxoQllxhtdE4Or+u45QP0DH1fU=
X-Google-Smtp-Source: ADFU+vt+uKylVDM2y1rFqtIDQZigRRXqNMKd9fqzr1cyjsUsvAyRLn3vXPAm1xhRrjT8D0O4UxcZeA==
X-Received: by 2002:aa7:83d7:: with SMTP id j23mr12365489pfn.77.1584096314624;
        Fri, 13 Mar 2020 03:45:14 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m26sm10956763pgc.77.2020.03.13.03.45.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 03:45:13 -0700 (PDT)
Message-ID: <5e6b6439.1c69fb81.1296.1780@mx.google.com>
Date:   Fri, 13 Mar 2020 03:45:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 121 boots: 0 failed,
 118 passed with 2 offline, 1 untried/unknown (v5.4.25)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 121 boots: 0 failed, 118 passed with 2 offline,=
 1 untried/unknown (v5.4.25)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25
Git Commit: 18fe53f6dfbc5ad4ff2164bff841b56d61b22720
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 23 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 33 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
