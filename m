Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB717497C2
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 05:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfFRDXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 23:23:10 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:55591 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRDXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 23:23:10 -0400
Received: by mail-wm1-f47.google.com with SMTP id a15so1485026wmj.5
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 20:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6OOFB+tC8xii6HpkcoCB267njtCZWFyEzGu0/puTRvY=;
        b=Me1XXMKM7Fle+oGS8aZVWrn1h3VjKdoK2HTyE2OPqcwlDVh3dZ/9J2LVw7BFiMTtUs
         Jmo1nh5cxQ+RuirOdLo0cLe6UFx3ZxKIX4iqd4e2VDIKjeClB1cjAl8Fm9v1xWHuLahX
         cvg7R4Dn8kLJ6s7SfwbRYnfiPF0FF32tiVkLq6Jz+MZHQy/ZCbF/EaEQoRQ4W3vgDow3
         Z6OZZNy3vGS+QSlDwo7J8jcBi3w1RILoJjKI+4qd1eDV0gstB2ZOTMIyTYEWonNgHs0g
         Dj+61QQDzPRyWctdHag0PDSPrzJ1tYwjaWfGZpixOq3Sl9t/xlncUp3J6kIxFnHPusqI
         AIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6OOFB+tC8xii6HpkcoCB267njtCZWFyEzGu0/puTRvY=;
        b=nDYIgQfvIdOuBa4Af3oJX1kerRo6xXQ5we0sTeHGDCziRZ+/WndsIXsy5ds0NPBBMv
         2kBRpEFDsDrQRKT/3IlVzGZWhWhY3PozgRLFBw8ZLIQwCEmfT5yWl5pjdjjtkazJDe3E
         oq5VF5+b0bVh0UCTg0mkM9AVySG6KuVXCbUOffe72npOpUvvJiG8efIb6NXcxiOLP0l3
         l0M9WYd9QhqGhiZfcfWchuc7hK+rUkvZgO2kMomRk1qXgek5Nkz1bZggtDPIgVKivXSq
         krmLf6YiMlliB9wja6T961Ev2nJUG9GhKmEZIzJctuf7jBStDlHgTmxWgryas+0WntUc
         mWXw==
X-Gm-Message-State: APjAAAWcPM76FocJj+ENRMugFhYa+nsGNu5ZVjK26jcMaIEo9Fc9P77J
        jgGj2JTwHHZtvV7N4veIC/Jrj/Ik62mMNQ==
X-Google-Smtp-Source: APXvYqwWuroTY5HOJpoZ47KQJr5CMqOWyHitgmoCyWiJie5U7i2HA5Aa3Bx02c8FytYX66Mkf9J9pg==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr1135088wmf.162.1560828187833;
        Mon, 17 Jun 2019 20:23:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 67sm913659wmd.38.2019.06.17.20.23.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 20:23:07 -0700 (PDT)
Message-ID: <5d08591b.1c69fb81.3e197.4f38@mx.google.com>
Date:   Mon, 17 Jun 2019 20:23:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.52-76-gd486e007abd0
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 110 boots: 0 failed,
 110 passed (v4.19.52-76-gd486e007abd0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 0 failed, 110 passed (v4.19.52-76-g=
d486e007abd0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.52-76-gd486e007abd0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.52-76-gd486e007abd0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.52-76-gd486e007abd0
Git Commit: d486e007abd08ab6e977da19580953578878bb41
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
