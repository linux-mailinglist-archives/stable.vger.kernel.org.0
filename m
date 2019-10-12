Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DED4B79
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 02:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJLArt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 20:47:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43171 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLArt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 20:47:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so13629585wrq.10
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 17:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2pVV1qLe7hi11upjbqrsP4SKZqSAVpPxE0sjR26a+nM=;
        b=A6is3IlEyj11HqpqdRexac4cHdseRH4nMSMw7WzCvudxfT/6NqvRe9iD7tcY4LHTU/
         d3+1Pm+alm7wI70V5zLw6ZAREBH7AhbaiuUh56CYvbmA7Bqe3iimsCMJe98WkAh3kUdE
         sYkBj/gkU1mQhMCu1g2U/rMx6usM1kLq027sLHMH6pZUF1Iuq4QOjf0izU+//EpqiUs9
         1cfNk66mR4HgALj6/V1O4rp2mafu+5OVp1j1gKS4EypWcw96rd2VqdQiQnvkVmXF62yc
         pZRxeobagELRsfiUtX7krCv2tlh1V98CoPHKA2MulGbzYZXgYvwRF0Lfqc/f1x2jNzFR
         +eoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2pVV1qLe7hi11upjbqrsP4SKZqSAVpPxE0sjR26a+nM=;
        b=TuPw765J1dwWj7AgDAOBTdPyKWTp0ZTtFfuIHCwn/PqPCcbGCfY/PINffA6A5H5eMX
         bWjcP+drycvG/SMY0wz/gJSPgXlJUIeqZ0fR1ibRB5UdMpDnqTw2oScr3knFQ6v9wI7N
         0fmt0rlMd9Kgun8+v6odlhKA4+sYI+QOrG0inZdwSE1E8eqrYh6GWASZrwqhaB60nC/b
         pdVvwyHMIULoHgA/mv30KZNamR7TFwwlsNAuecC7gl2gpB3TimI20rNKnM0Km+89/4kK
         E/nHChN2smR+VjHDhLxO47mCMef7ZiOlHix7a3Ij3S5Yo6RY4hz4q0RFNhwNsm8mA0zw
         SQgw==
X-Gm-Message-State: APjAAAUjY0B8wl99f4IyqNnfnu0Gtk2I5s/cA8K4EASb4gWvTdGojUhl
        iJ/rRnzFcKNx5YgHr1s0loLiFP00D3DUEA==
X-Google-Smtp-Source: APXvYqwMpAV0HJfWfHmj3l/wmrbB0hsnMYvVDta8BmDqpb5aWHJOfAtvRNe7MGFqdXPjyxsyoIROHQ==
X-Received: by 2002:adf:f68f:: with SMTP id v15mr14896440wrp.234.1570841266926;
        Fri, 11 Oct 2019 17:47:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z125sm13043066wme.37.2019.10.11.17.47.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 17:47:45 -0700 (PDT)
Message-ID: <5da122b1.1c69fb81.255e.0380@mx.google.com>
Date:   Fri, 11 Oct 2019 17:47:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.21
Subject: stable/linux-5.2.y boot: 80 boots: 1 failed, 79 passed (v5.2.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 80 boots: 1 failed, 79 passed (v5.2.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.21/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.21/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.21
Git Commit: e91ef5bcdeda8956eb9f1972ed90198b698dca0f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 55 unique boards, 17 SoC families, 13 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-h6-orangepi-one-plus:
              lab-clabbe: new failure (last pass: v5.2.18)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-h6-orangepi-one-plus: 1 failed lab

---
For more info write to <info@kernelci.org>
