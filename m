Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AC431F71
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfFANwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:52:09 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46615 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfFANwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 09:52:09 -0400
Received: by mail-wr1-f46.google.com with SMTP id n4so3041442wrw.13
        for <stable@vger.kernel.org>; Sat, 01 Jun 2019 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oYrCK1vrmDxcCqiEMozMRsQctZwjNygkgmCuINb7LeQ=;
        b=e62xKGPWAKHmpe/emsB5DnPb48OCjvG7sBz5phtS46oxZd01VFp3Kw71NFZxmbsjBs
         KHhD4iTuO04CiOF4oNJW5dZCOANlCt4jDhnyJPYli5esTcUrVrJyxWa38zN6ykQGQ182
         V1VaaZ6K3DFGLyOsXhl9QaBwBBHm05fhxV1ut6veOtTe1aFG8GllBCYdLdVIODb9Kdvv
         8wSl9q8Xf2epHpcutO32FUVXHLbfRp315Wcmt3PIUNTpKNpunNfq8xuxyW3jLwMqt783
         isvdITHRk22qpl8FvHCU5TXXCnk54jncbJjWgxrukmCBwh+VRuCozrz7sA68BYnPGVpQ
         tdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oYrCK1vrmDxcCqiEMozMRsQctZwjNygkgmCuINb7LeQ=;
        b=FOIiPvdMLIrAE0tXhxZtAqNajcijhCLuC4DsIOfoCgXJqbzQA8VPnJFhrQUuymrbEx
         53Q04LTOl3+Ek1UJH8W3fVmOma35J2zWw50F4rzZ9kAE1CwjLFaBB/oXuuv8EU6iJobW
         GRGzaDM8+3Xti3yvuDoQQ3xIdwNOAFUUoPWMonPInHnHOfFc1GbryZIc3vQ4clv8UZB+
         lmozktTX0K5Ja39MtbQZlUvDfzaDYn9TPzEewAK7TtlpFpEimutKNgrtYG3Wn7OLEnz+
         YA9mjtv5h5ACBXouOi3jOQdRu8tfoxBh9Vv0Rg25QjKk6+XpWpcflNy9VZIq9TdLDuAW
         2Z1w==
X-Gm-Message-State: APjAAAWIIP2ujAUlRU8SeJSe7Ry4veh9M5mCBj0wp2KoBuojzHaQz8vc
        Ea9ei3OfYKMm6GRoTzekCw8y/D911NNauQ==
X-Google-Smtp-Source: APXvYqz6DW1+rnhD9tUWXNDTlWfnxPT3lIzoX83YLlCH5UADwOQfci4OAts7qZ3UGJLM7oj7/g2+yw==
X-Received: by 2002:adf:ea06:: with SMTP id q6mr10303650wrm.158.1559397127562;
        Sat, 01 Jun 2019 06:52:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 95sm19943508wrk.70.2019.06.01.06.52.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 06:52:06 -0700 (PDT)
Message-ID: <5cf28306.1c69fb81.d56a1.6e62@mx.google.com>
Date:   Sat, 01 Jun 2019 06:52:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.47-26-g822c65132427
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 118 boots: 0 failed,
 118 passed (v4.19.47-26-g822c65132427)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 0 failed, 118 passed (v4.19.47-26-g=
822c65132427)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.47-26-g822c65132427/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.47-26-g822c65132427/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.47-26-g822c65132427
Git Commit: 822c6513242770ce895c1cf4a684e91c6081bdc8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 23 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
