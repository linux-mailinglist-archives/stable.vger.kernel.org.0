Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C094D13AD60
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgANPSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:18:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47036 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgANPSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 10:18:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so12502118wrl.13
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 07:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ujZYCf3B7ZBHgx4ce6AQLYjABFp9VADBdU+t0/cgW8o=;
        b=IcE6+2J8bVlY0KGyYUIcBFzDAb8VHZEsbKxZEULTo513HZTWIpjzn9SAaUlR/F3aa5
         pKj7BvdbnuC9o6engn6IIBIZxeh30Fmi4i4lhNLBU204yLv/F0wk2k37Mq6+XWKAyyXS
         FU8E2ojol8qXz4e88XKWmcbFpiPLrPVUXusO1eT1vRbc3MDrbs3rcrhfdubwdzLIF/cm
         /INUzPQk9M3ruX1YZnI3la69De3FqCtFvF3HIbIO8/k3h2cDfxO2uoPoFDJMuxTYCyGm
         +H3UPqkOLWUdry5AIFOmjOqRQXwkPDOG/ZCoSe7SNDv6o8jzRcx4Ru6tZq9drVJm8L7U
         P3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ujZYCf3B7ZBHgx4ce6AQLYjABFp9VADBdU+t0/cgW8o=;
        b=KVhkl+sPhoYWzpdFFhIDAl07GIXJ77MezHv7q73OZ2XBM68qkSpH63wg6qUuf6wL45
         JquPdg/nu6Acm1vUk4gesdq621WpLSlZNGL1ZHr/V4oa0EW7EyNtRzhBGVYErtdcrl68
         +dzUvwvo5sZDAmC0HgdipQxbnUe8Fuk2ZrUJy23+HNq6tzt14F6oe7Zu9tj+wFaj6ZWo
         ozoClhD53jCU3CKVYFYUYefUCUAuLd4UBTplXKd7zxsZg4imhZklH1zpxq8CbB+7VxwC
         7N+UrQVbdps3AwFxS5Ft+G0uQFFxnvg34TK+i+y6odZiqSviRhVRXKWDMovlXb4OM934
         Q1aA==
X-Gm-Message-State: APjAAAVcxeEZxJcuKzSvENxkwtWGmMsc3vIzXpZfYqMwwPa4BiHG2yFW
        PDR1TEK+7bU6fvT3s01lVJfRAbGozCZWjw==
X-Google-Smtp-Source: APXvYqwZ86ChraRnbn2u7pkUbB20sZYU130G9J0112a2O5SO28JUqKeacTv0hCzX7KjDSrIvffK65g==
X-Received: by 2002:adf:ee45:: with SMTP id w5mr24967253wro.352.1579015099022;
        Tue, 14 Jan 2020 07:18:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z6sm19958179wrw.36.2020.01.14.07.18.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 07:18:18 -0800 (PST)
Message-ID: <5e1ddbba.1c69fb81.92fc4.4724@mx.google.com>
Date:   Tue, 14 Jan 2020 07:18:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.209-29-ge249b6762aa6
Subject: stable-rc/linux-4.4.y boot: 46 boots: 0 failed,
 45 passed with 1 untried/unknown (v4.4.209-29-ge249b6762aa6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 46 boots: 0 failed, 45 passed with 1 untried/un=
known (v4.4.209-29-ge249b6762aa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.209-29-ge249b6762aa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.209-29-ge249b6762aa6/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.209-29-ge249b6762aa6
Git Commit: e249b6762aa64944a407b6e00bb99590fdee9091
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 9 SoC families, 9 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.209-22-gfbc4ae7c27=
ee)

---
For more info write to <info@kernelci.org>
