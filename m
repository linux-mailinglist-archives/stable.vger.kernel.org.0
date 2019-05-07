Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F33F16DB2
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 01:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfEGXCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 19:02:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40528 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGXCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 19:02:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id h11so638654wmb.5
        for <stable@vger.kernel.org>; Tue, 07 May 2019 16:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZfkFCbVRP9KQSecBhB9VxP3hD1nBo0sqwfQD181lQWA=;
        b=obwO6CFt+HuT5iJko9/tvbXjhmNoNtBtjYeGQ9SaP7WOty4p4nwLACoJl63F81sn2E
         2HDhv1oFUxoIUmz5785IZ15YHZsHNADzvj3ioWYJF6ZVo5/vYLAx28c8y6WaWpXoa3x7
         sArpquHJSx/32oWG3EzOeU8pkGLFYj3+9WqZAL653c1ZUrHSfSQ22EL8KhU7u6W2/nUf
         34DD6U8OJ+Bw0kqlAWQYcDioIJ1Go0B2WiP++jTLREy51QLWf6U0NygJHnz/QXS9ziC7
         GP4n9dI0PLKYXvgj3AtdUST4Sl2rWntnKjHxWlkKWtSu4VlOKmXF5ulOuP4xV+Jsk5Yg
         HV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZfkFCbVRP9KQSecBhB9VxP3hD1nBo0sqwfQD181lQWA=;
        b=EHHu/JGeR56hy/xcApzYwZJ1AbORe9rknhOVkDCNKYURjdxU+uCjq7/JWMy+BEUq3w
         uTac1hIMmmOhyc0nChCfe5MDaQeT5o7wu8uasCq0P0wHn48+HdcmH1cDdxV3xT29mWFB
         trI7nbfgGoXMq+v8l5NKxYSyAkWU+Ey0yQwNg4ECgoKwqyoSrBRz1zM513+jo8eSHBp6
         mQUdHeOAqcQqV3g8U+AcN+5zZzrrSLHxj7CWCARgCx2dXoieEy6t8oKy7h0MzlXHwrLP
         MiVPu0UxnmRSn6AzlLvSNM9tKUUiM1kDiHqU4XwOVPY2HvIs5HO0ymGNNwx78ixowTT/
         AUHw==
X-Gm-Message-State: APjAAAU0xTMIm2hnY88csn/C3HOQ/0HPkS9R5iqrq5q7ACWrZ8bOGHO1
        cx+laiO5DWkIMTX6+ciRuBZSrabeDBh/zw==
X-Google-Smtp-Source: APXvYqw0EmM489p7kPhWe7zLEWhkH7eff4sQ44/NfamVnkKSdK4J3NqDZLePi2gEu8f0NxGjIefVWw==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr530181wmc.130.1557270170596;
        Tue, 07 May 2019 16:02:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w7sm1142126wmm.16.2019.05.07.16.02.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 16:02:49 -0700 (PDT)
Message-ID: <5cd20e99.1c69fb81.4256b.5256@mx.google.com>
Date:   Tue, 07 May 2019 16:02:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.173-61-g43d95ffd279c
Subject: stable-rc/linux-4.9.y boot: 51 boots: 0 failed,
 50 passed with 1 untried/unknown (v4.9.173-61-g43d95ffd279c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 51 boots: 0 failed, 50 passed with 1 untried/un=
known (v4.9.173-61-g43d95ffd279c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.173-61-g43d95ffd279c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.173-61-g43d95ffd279c/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.173-61-g43d95ffd279c
Git Commit: 43d95ffd279c80b33fcc2c0b327c1195e3331185
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
