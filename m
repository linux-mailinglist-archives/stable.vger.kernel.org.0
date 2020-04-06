Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCF19FDDC
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 21:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDFTHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 15:07:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38718 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 15:07:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id m17so450845pgj.5
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 12:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nn6lAXvMhOSAG463Tcw7G3OuyKtKbiDNyhVK6NjC7mA=;
        b=gEsOrKCNs7EvU0CA/t4YOusXH5AQFGv37CmHaimROV+i6F8WLWq30SHrtbEdknNTyh
         V2zNfSmAUq7JeUWIc0YEVmiakqKyFyX5aBOewl11Na3JxfkwUFYBSoPP6KB5XB4kaf/Y
         UbIprWWy3OTFJflJCHOAok6NnzL4x+1Agaja/DKUViaF7g6+PnelxnN/RPmqgcsZfNmy
         l5vbDMm/0tfKk4wvY9gELMqOXgG0ISlIqRIPwY4M9DWe0FpSXrUTIwF7KFGQtnZO/vio
         7o75YsfE+l6kZd4KM1gYRVdcnSLAPi0JFCako5LoPOuFH0RJDHY9j+ROTj3c1XCPgnkD
         ahIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nn6lAXvMhOSAG463Tcw7G3OuyKtKbiDNyhVK6NjC7mA=;
        b=qDd1ubRiOQxZoLO9HHJmFr05dJL+75U9gcvXSHKTqYUCuwyfEq9TwrfnUy+1ASpHq5
         XiR+j6qERYNL2xIEYeZbjKdGMec3MqySNQFWVE6h/WIK7Lm4Yu0Mo7yUskUfzr8F9pTE
         cCafUjITLbAf4+he+ILjdqp+jwk4iKPmJZvSOz2PZAYB8tXtgoerzZf/Z69NX5OdDrTf
         tyyXcaAf1UhcPUHZivaJ2Nbw+64iy0XnyqmYS1+Kg3Q/0G4dDxor25yrNCAvOopChXBf
         dkj1uJmDH6D96G0ctDK0AKm8sY8CQrtYHVfvPaExeQlYin6qn9SQ6i5HYkCXTKqosoLg
         ZGBg==
X-Gm-Message-State: AGi0PuZa0RaRSkzbHP8g8/cnUkxyD72K4yTV/mvHe256l66mGtOTyEcK
        fYM0wL63DeJs91u7eljSDAXoAqhmW0c=
X-Google-Smtp-Source: APiQypJKu8MNTnuuAjOybo7BpjN/WS3Xn87yS/kVQMIrQzaaKGVol3fF3QjL2CScb/zvG0dn4+Al8w==
X-Received: by 2002:a63:d74e:: with SMTP id w14mr553037pgi.157.1586200030482;
        Mon, 06 Apr 2020 12:07:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q185sm12192184pfb.154.2020.04.06.12.07.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:07:09 -0700 (PDT)
Message-ID: <5e8b7ddd.1c69fb81.90088.72af@mx.google.com>
Date:   Mon, 06 Apr 2020 12:07:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 68 boots: 1 failed,
 62 passed with 5 untried/unknown (v4.9.218)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 68 boots: 1 failed, 62 passed with 5 untried/unkno=
wn (v4.9.218)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.218/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.218/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.218
Git Commit: a5ad06fc4b7b22f6df0c21b7052a82e039305a14
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 14 SoC families, 16 builds out of 197

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-baylibre: failing since 13 days (last pass: v4.9.216 - fi=
rst fail: v4.9.217)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
