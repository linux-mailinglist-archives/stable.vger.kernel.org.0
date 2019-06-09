Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEAF3AC5E
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfFIWXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:23:22 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44563 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIWXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:23:21 -0400
Received: by mail-wr1-f41.google.com with SMTP id b17so7207827wrq.11
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kZjXK+r68KrlBgRhuUhh0DEvh0dzWA+BIAI/v+Cp5C0=;
        b=oS6afPoQxl4/JhhuF7qhG1Cc1mKVUej137S8mrBjU2S2xBYNff8e8MqUTInYEpEL2o
         /RFmKdUaFtTocPOGdx0okN+czAWth1WDV2bha/CxpzFk0dwMvkNV4f492Qz1YnbVh7e5
         JUfQLYGDDEa2MN2UriKqpqRw3sHnl41iOaDNmcK6V3GpX51X4d8T1/CFgQFNAv6Xm6Rp
         dapoCUX0NRmPl8QE5p3okBmO7tJ2yVaMTO344acamVAYt81OYOpPIuMqNk/UjXW5xGzg
         aNo4GU++itzGShICTsdxL2IzgeiemlPGPHKn/E4dDWGRD7l/oY38eGRV/Gr+Tz63inqE
         vOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kZjXK+r68KrlBgRhuUhh0DEvh0dzWA+BIAI/v+Cp5C0=;
        b=QYcod5WB/4mGrJ8C2RtjgW8JJPbThhIUpYOnn8Re3QfcVtBpcgAtqoXc/9ubw8/cjM
         XNL7ofC0tZlaDOeGe/avKmrVUlT3StPP0J83xAldtsTHL76Z7aUuzw8k6PblaunjOy32
         jQK9ceRbMxUXzaTWnnRxQJG7UW4LcQDEJB/6jQQoyi5ULA9NjHryQT81o5jlI+9gv7JA
         WR1ZJp/gsE2xX359AxHcPX7Li9fWXwFstwavSN4nNjN3mk2NeM58DwEhLXE1p86CdlOA
         FTHDYhTmQkWO+LWVhx4GZgDTvngZvBXIcdmjOd0hM6IttqU/enydfPXWn1vpE9m4VmM8
         jc+Q==
X-Gm-Message-State: APjAAAVOJN5GNBKtdM2f9NawyhJrkHfYrakByXPiJe7v12AO2MUrvjbs
        BxxInyaWAfU4RZt1/YUmAh/lT6NwNGA=
X-Google-Smtp-Source: APXvYqw0x8EfUth4gmLtGHXUbWE02Rff9v6DqdtP3WK4ugcqPeod8dr6+G98YOTqaghnVJHBnH4WJw==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr19877076wrw.345.1560119000368;
        Sun, 09 Jun 2019 15:23:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm13193021wrh.91.2019.06.09.15.23.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:23:19 -0700 (PDT)
Message-ID: <5cfd86d7.1c69fb81.c5f66.ebc3@mx.google.com>
Date:   Sun, 09 Jun 2019 15:23:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7-157-g5b3d375b3838
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 136 boots: 1 failed,
 135 passed (v5.1.7-157-g5b3d375b3838)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 136 boots: 1 failed, 135 passed (v5.1.7-157-g5b=
3d375b3838)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.7-157-g5b3d375b3838/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.7-157-g5b3d375b3838/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.7-157-g5b3d375b3838
Git Commit: 5b3d375b3838a28e769a56fdcb67d5422579d53b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
