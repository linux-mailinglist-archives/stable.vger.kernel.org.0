Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F54C1EC27F
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 21:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgFBTOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 15:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBTOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 15:14:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB011C08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 12:14:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bh7so1767327plb.11
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BTVdFcewQ8/ApKsSBz4bGTGE2/wobJsk4baQbOspjuQ=;
        b=Lo8R+D0qKLT823Sg8BC7Tl1nKCPWU+jwN8xEymubFp+gdFmigdrCMAuffFIamfuxS1
         8F264EOcBeW3YudYzO629h+fQC52h34+G4i/a7FQdyCrIXQJMbcIsq8upZsxpdyIEK3b
         TUEREsYDHlACu27TH0pjrEM7nfZDXJ9NAnYUTcQOjPFkBZzQbvFYOwUsIWiz5aKq+ILB
         X40iCk1zTT/5MQullE7GvWGQ82QJd+qBmqtxM3jI4ILKnmrNu6RxTWKdX0+BJuZMLVt6
         KbTCEJ9g8vdnUY+gMYqCxamPRsz+GwnNQIW3raAz8MbmNhWGiJ3ztz58KJgfP89DBTRP
         EbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BTVdFcewQ8/ApKsSBz4bGTGE2/wobJsk4baQbOspjuQ=;
        b=Y4zhwNCQfafSzjkJHveEk2/RR+6UeimB0R6tVtiQehNKjYquwWRQi7K6I9JSD9OHtj
         hEThaOtG/OMuJgfUlBNB8MKofu0rxU9GAGekuwim6I8Csfvb/pBl6+WC9XiD8fiLr4+W
         r9XXHOE935XUqix9oJ0vS3V7NBy1hbOisx8JTZTdp/G9cruznUREeJiEwP4gtJEDvrRe
         AYa8//QBvRMqePi7FZRA1ZuPsrEYKR6HkFPYWKwjoMT3qzXTkCqK9WZpeNvnxkiDA9yO
         zCpZ5UuUIY0lO+fwHWrmG58rZJ7OXOZWIvS8Yn34dpFwvYMQrHTHB0YdoclTVB/6rg3S
         2KAg==
X-Gm-Message-State: AOAM532/ttgE3FOsxFnkSHF0nRieFNSR384Xm6XDMrlhQOAXlQIQJ8md
        IpBpN8zbvj1Ma6R5EWIUz6pbFqDGZfU=
X-Google-Smtp-Source: ABdhPJxZRP0ZFOemWGSf88XGyhNYPsgvVCiQVcxpuFBeLbuQh+8z58lXSLpi4jysJV6TMxn9K6CXUw==
X-Received: by 2002:a17:902:9f93:: with SMTP id g19mr984576plq.314.1591125292925;
        Tue, 02 Jun 2020 12:14:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm2886196pff.159.2020.06.02.12.14.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 12:14:51 -0700 (PDT)
Message-ID: <5ed6a52b.1c69fb81.57c8e.d7bb@mx.google.com>
Date:   Tue, 02 Jun 2020 12:14:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.225-48-gd147737ac3ba
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 63 boots: 4 failed,
 54 passed with 3 offline, 2 untried/unknown (v4.4.225-48-gd147737ac3ba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.225-=
48-gd147737ac3ba/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 63 boots: 4 failed, 54 passed with 3 offline, 2=
 untried/unknown (v4.4.225-48-gd147737ac3ba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.225-48-gd147737ac3ba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.225-48-gd147737ac3ba/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.225-48-gd147737ac3ba
Git Commit: d147737ac3bacf4a44c5cfc4a531c308e2fb2027
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 16 SoC families, 15 builds out of 144

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 68 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    mxs_defconfig:
        gcc-8:
            imx28-duckbill: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
