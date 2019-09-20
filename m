Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E9DB89CE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407135AbfITDvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:51:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38125 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403998AbfITDvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:51:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so705689wmi.3
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F9l8I5TdxL6PCQcPL+1DndsT7qoplt01uSl1H39UVpo=;
        b=HjEuKUwHxHs0pAm2fy9LQmxYxJVes89SuXo4lSuqyEpfvWzCFZa3ffNPe29ISQhtuF
         k9w6Codjg2UqwhQd8fBwQovn54OHITobAgM60ETFdvgywEmFYeNtezTPP0L5Ys2CraB2
         w3NvcWgjvbCVBfKUS0U3jSD4AvqQUqcZY+qdv3rdePv8o57eOmGl7ygW8ZJ3dWtcTZbU
         gKEXV1jUGWPpa2D7oJTvYYfrAtU8IMseMqm0VcioIuhIbWzuwJ4G3b1YUtYUWMrkGkTh
         z/7qFOzP536FNT+OU3bV1L9/oBaRj28vWrL2vbEJE9bjIYJUmmc65OQvCjSPWimbjRoc
         zemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F9l8I5TdxL6PCQcPL+1DndsT7qoplt01uSl1H39UVpo=;
        b=pSE/+ODT3R5n5V9K675DuvgyOuew9acZK2oGwifliq4CPisY13XHUQ+0VmNpdc/Lh8
         LlqiPDe4f+ch/75dSz42tmaCH1i1xU5FbiLnKGWlHHNR5iqf6+4OnazRo7ZgYGllpO21
         Z8+OBL+RXMF7K1WULvUp/7TXwLzcbpVGgsklgoP2GFe3GCPKMOk5wwSKxUvHJRKG4zIo
         7b6Xb6fn4FE2smqTd3rm0FK1JCiuCp4kU7slv30gh8tUBf5vlDigxrCx5IbyAuPh6LIo
         d5F29lNvySlQWUBgLzl1PesIGpIPY7LxGcitr0B6+p6R+GSVj1SxQ5eVIpQ/dpRc5Mym
         BRlA==
X-Gm-Message-State: APjAAAVEVwwBXcj809J8r0cJ9H9EjNyWdGtS2/7wjq9J7HX+n9ZykRVc
        CqXKQ7PE3l969GVhdjmycGmpfQlbQpf6bQ==
X-Google-Smtp-Source: APXvYqw+Sky9/DZ6OBEkxxlH/6tua5cTvUXiCpsMDeUS8KBl2FQCN378CC34jLvHhsGIDFwQAgaxVg==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr1295865wmk.47.1568951462670;
        Thu, 19 Sep 2019 20:51:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g138sm412418wmg.29.2019.09.19.20.51.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:51:02 -0700 (PDT)
Message-ID: <5d844ca6.1c69fb81.c7605.164e@mx.google.com>
Date:   Thu, 19 Sep 2019 20:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.193-57-g7b679e1a966b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 47 boots: 1 failed,
 46 passed (v4.4.193-57-g7b679e1a966b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 47 boots: 1 failed, 46 passed (v4.4.193-57-g7b6=
79e1a966b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.193-57-g7b679e1a966b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.193-57-g7b679e1a966b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.193-57-g7b679e1a966b
Git Commit: 7b679e1a966bc6ac22d75cae76b97a9fded9367d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 10 SoC families, 8 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
