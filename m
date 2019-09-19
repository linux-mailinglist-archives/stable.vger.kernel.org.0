Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7036DB7A39
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 15:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbfISNNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 09:13:01 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:36368 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732283AbfISNNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 09:13:01 -0400
Received: by mail-wr1-f54.google.com with SMTP id y19so3071041wrd.3
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 06:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cOXYC7HlWKUPuQ1T+zYqwgqGhNkYrWh/sRPLmpR8sbE=;
        b=x4XKff2rfQUFfO8cNboZajsEhkgLHE5nTsidlidYjZaXYHQYrTA+owInlKHNRiLvSJ
         ekL55jEWZE1LkpjOsZtz2XnWrK2LrNyGIQf+NokjNPgo9EfcvnQZ0Hbzn9IrpF2b8um3
         OMgsYqlLb/WrPbuFyy5Z37W2qSBuCawwKOl0SaDInthzZyzBJzxp6ax91NUFqlLVhpEM
         Ncrru7qae2ANAXqZg55aFOzDIa+NeWilUb5Wsnj69e1YAa3MbXO5xzAUQVs9xWyckIB8
         tAUz986W9d2CrAC29WIdQ6aMcpdXo5gKoHs6L0iv9PZukrsQFB9lxYfg33FxmT/T59i8
         3S2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cOXYC7HlWKUPuQ1T+zYqwgqGhNkYrWh/sRPLmpR8sbE=;
        b=lALVQuYZVuDzmnu/DHJ2N3vlZgrmPlyYQnSXRftrN1Ndxafe/s/RLYeUMsXSaGY+/W
         gWfnsuVrZFOfUtmhKrKtQIvMoT9y2GJ7uq+omtdNw1BqDIqM7YKJ0CkpUe+My7PMW6YQ
         CKP12u/+3cWezQ/VsFhWVP6YntZyntrmWd1X+pS1aBFA1DYYAZOapndB+/rv5jdVCJxJ
         IqBYD3+GOYVSotYnKLImDG78oZaPUg09Y6Yq6/tKuuz6KdaBbHz6u7gCEfCAF6zbR1VC
         N67mpu3nxGpEx83wNt3pz5Zst6XuYz4WMcGs2UrHCAQxsmWcOQqOxBzkLV9lhXa6Lp/x
         zHTg==
X-Gm-Message-State: APjAAAUhHdydqHCXqJ3Hy4HXBDSxEUFwfBbN/+LM7cUomXclcHen1Vxx
        F79bdh+1D8X26RTfk9G64TJg8IpgHuN0Xg==
X-Google-Smtp-Source: APXvYqy2qUl7if7UMBNz8xG7Cr6YEfu0gr/qh1EIRW7IYOZRYa+IPy19o6caypbY/r4+6Y+GXRV35A==
X-Received: by 2002:a5d:6302:: with SMTP id i2mr7545402wru.249.1568898777627;
        Thu, 19 Sep 2019 06:12:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h26sm18767008wrc.13.2019.09.19.06.12.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 06:12:56 -0700 (PDT)
Message-ID: <5d837ed8.1c69fb81.5f7f8.5c50@mx.google.com>
Date:   Thu, 19 Sep 2019 06:12:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.16
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 90 boots: 0 failed, 90 passed (v5.2.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 90 boots: 0 failed, 90 passed (v5.2.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.16/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.16/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.16
Git Commit: 1e2ba4a74fa73f911f5d0f5f8fb0f6e621024842
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 49 unique boards, 18 SoC families, 14 builds out of 209

---
For more info write to <info@kernelci.org>
