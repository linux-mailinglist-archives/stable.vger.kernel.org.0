Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F1D6CA80
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbfGRH7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:59:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42216 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfGRH7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:59:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so12564879wrr.9
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 00:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nThpdK5yO2OfCE8SuE9Qiy+7h9LlRqpG8oEJp9t7qAA=;
        b=iv35If7LvIPX64JGojlluiKskuuBeA8o0gKTO+SMDUG6dPEq0TTyH4A0RA5vriHrH7
         s6zKDmEkyxe/iOHhLIEZnND0343mB7RhAHSAn7LlYieElme0j01PZ/DnxOCoS/jaAxDP
         vk5uese8FiHNzznu4XVXnBPlDkeD3VoMrm+QnNhu76VtzuWUtvyYmInJ4b/rszEL5XeR
         U8GKml5ATgHEIg5R4R05ShFVAm1SnKeXWwGFQl7XrJWqjya8zB4C9j9KRCwVatstHwRd
         h772DjbOydSIXrAgyC6Bxt4Xl++EKPvDntTaxYZLvN82gY8oQYgYoqwLhvHheeBUPLb9
         XYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nThpdK5yO2OfCE8SuE9Qiy+7h9LlRqpG8oEJp9t7qAA=;
        b=id4bstrpyRrUr1JZU5HDh3AlsFv3NnXKb2911IvDOFTgf1F6ocgq/K6++BRWp6XAbI
         PssQtaDmru/YKu4RhwGhuZQvwVTNVIEPqskjv+sko269mf/OUzQ+XI3ubGSRRx6zFHt+
         4gZFhIbbB2zHucrhZsgpDg0SciFIXc5nE6oFEkMSLEQ2gUoYdrhCYn1kOFwgypkMjTYV
         5+NciKcLi0Bffw/q4deXngv6yPC6jqQU6bElZ5TfvuGYp3PGemT6/tk4QRIYfmxuMWe6
         WZ9L6CFFHUjDBc+H0vqcZqtoTJSo7wjnypOljZ5Ns/O8N/oPWJJAe/pL+gQPOw2A/Ejg
         YtUg==
X-Gm-Message-State: APjAAAWk5/uwcoetqtWFONtjR+Z7IsC9D+SgNgCWpxs67xo6toeJn0eM
        1gElzBVhRpsdBAJLU/yp2JzByD9IpFI=
X-Google-Smtp-Source: APXvYqzhw0XZxCsNtRG3XLillKWgFTycPLwo1x7ZJC4Srq2jD8/D64HRDnINMc+hJpBYcfnxOj3Epw==
X-Received: by 2002:adf:e708:: with SMTP id c8mr37290633wrm.25.1563436785062;
        Thu, 18 Jul 2019 00:59:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k63sm33677298wmb.2.2019.07.18.00.59.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:59:44 -0700 (PDT)
Message-ID: <5d3026f0.1c69fb81.91715.19f2@mx.google.com>
Date:   Thu, 18 Jul 2019 00:59:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.18-54-ga80425902cdb
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 135 boots: 1 failed,
 133 passed with 1 offline (v5.1.18-54-ga80425902cdb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 135 boots: 1 failed, 133 passed with 1 offline =
(v5.1.18-54-ga80425902cdb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.18-54-ga80425902cdb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.18-54-ga80425902cdb/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.18-54-ga80425902cdb
Git Commit: a80425902cdbd5ab05f9f9af4e992fee397a1d47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
