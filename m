Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C3F18D820
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 20:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCTTJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 15:09:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38992 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTTJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 15:09:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id d25so3760265pfn.6
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 12:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BGsOsgBdnfCFl2O3h3qZwXVftHCuIlhtjzxl2Z18SuU=;
        b=rSS/x5i0JPEd+p1klx+jSk3hV7O+foKhAlb8bHxWAAAZT0gJ4PrW0nEqAKlKni3cbt
         RHBhlPx2aEyQJ3Bt6F90nGI7jQU2En6ff+k7B65eQkIIcNyfq6JJ7plq/UNs/wg4pdZ0
         PmIEcWSMbRkYMptFzXHoqhVr6PsMLvQS3i303rwO5+o/XyNHK8d57/QXG6uVr8DQpSqI
         ONFgnRk662Jw5rRRzDKzQOFZkNMSEYX7ilOPRPx2DSLYa2x3OgQDHo4G0nKa9V7G0Klu
         eZcDFwwefAzZwgaIqD4x8YbEaoYtAG/RP1nu0Zilo4w5mtQ1n6XdKHbRPOx1QVUi7FkU
         glXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BGsOsgBdnfCFl2O3h3qZwXVftHCuIlhtjzxl2Z18SuU=;
        b=XaTYOaHiQH+qizTMtiD+ZvIHtFYanFcK5pLT/WvbhZ9+9k0kgp5/qf7EvBxt3ILT5J
         EYqxNgTko59NFMWXhdEWWvNZW/RuzZ9hd8xm1U3JVE3mZXikBPSXjCdtpiz0RwXv6ov9
         0j4tivM/2v+xiaGGY05+TjS/c3foYY5GCOHyRA9lpNxEvOK5T2B85Ybz7LhYrOe4m6+8
         jH0wafi4N6BZwk650BiukfNUbeq6uDqUbCX1Cn9mqWDnoHq/KwLRKBVugtgdlAkO9wFy
         TJ79tutLxtL9aQieK9js/CB9vpXPvT1XVa/uvrkbhDM5eXOz7a1JMdtrUffx6eucZC95
         H1hw==
X-Gm-Message-State: ANhLgQ0wVrUmyOygnw8Zyur6GD7fQ9aTXPANDKME5AV6PKsEUisgbL5M
        XSgAAmtS0vNY0b5CKVuH0TCJ4FZZvUI=
X-Google-Smtp-Source: ADFU+vtq6k8ZWlI1afcwiOnf44Yy4RF1kQp73MmKeneuqWPemIYtheyYRlFri2RNmBt+9KMmCMCSHw==
X-Received: by 2002:a65:44c1:: with SMTP id g1mr10202804pgs.362.1584731381283;
        Fri, 20 Mar 2020 12:09:41 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm6114363pgm.27.2020.03.20.12.09.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 12:09:40 -0700 (PDT)
Message-ID: <5e7514f4.1c69fb81.97dfd.5590@mx.google.com>
Date:   Fri, 20 Mar 2020 12:09:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.112
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 94 boots: 3 failed,
 86 passed with 5 untried/unknown (v4.19.112)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 94 boots: 3 failed, 86 passed with 5 untried/unkn=
own (v4.19.112)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.112/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.112/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.112
Git Commit: 14cfdbd39e316efd91ae6e403ef8211f0b022603
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 56 unique boards, 18 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: failing since 4 days (last pass: v4.19.109 - f=
irst fail: v4.19.110)
              lab-baylibre: failing since 4 days (last pass: v4.19.109 - fi=
rst fail: v4.19.110)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.111)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.111)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
