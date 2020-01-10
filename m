Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C152B137757
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 20:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgAJTiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 14:38:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53229 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgAJTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 14:38:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so3227066wmc.2
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 11:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SebEmeupIeTSun5qWIuqS15Fxl71sECMlOMBv1zHL+c=;
        b=w7HLYODKXYLKivFMGhuvwUtpL37R9FQc9kg8IxA5WB4sBFrbF9H57V+dITHmE2109i
         4jLdMSGaMCdBA9S/urkz6DizRZOyYyxfESwdm6ykmquimlpkJYAhNgyxSRjFVfNzNhgK
         lNOaMMd8IZ937tFoLi8tEJ3tPfmF+pUvlRTrVIpAm7vv69QtKuZ1rNjXKRjLZUjNF/Dh
         IBgvws/wpEMf0o2ARXALdXfDyF+ic4ukHehajItyeDF9Fj/HKlNFCSBTVKqyAHgE1VPP
         P1XILgaG/VST6YDwx1LbAiqRefNctlv0tS8NXWzyIK6rGWpVyLur8FVw4whoxlj9nN9R
         iw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SebEmeupIeTSun5qWIuqS15Fxl71sECMlOMBv1zHL+c=;
        b=HPNN6vwCmQS3h8qp4F3k8otLo3ujeWoMLFRwX541I7OHuiZzBng7yH0dri9v5LCpfp
         XSKSNCrIQLbNmEQTJ8nNJtm7m7LOfQ536fb7B2b2MXelunwyiihPJm5+Z1bhYVDdD8Fz
         w2/zBYrfr77eKsni5hXLqdKE3vpfhcxj5tU5LoiHgE7qKdy+oSYVc5azMlAZNzA2PvTx
         72/GST53q86tzAmM3RXhNX1oPnHT5wWwo6Fhx9qeScnpWAxgmu24akZIjfG+1t6sMug7
         mOuVomrZzjRJkjJMBG9oXhWMtFM5lCsvJVcUHnQwECAsZS5jqLt65rcb1UN5/6NulV4s
         4SCg==
X-Gm-Message-State: APjAAAXEeZU9Rk8Qk40Uap29Ha99so3lOOrbihMT8ckCD9sOltkGCfG2
        dhpqXSov48Ix/RBpGu+zKRr++TGEvqarfA==
X-Google-Smtp-Source: APXvYqwgeOhxn2UBrUah0YnCJVcAW1ncBnaKT55Wfcu6C+F7FeMSVb0+oJxfoaVj+8yA7bmnx0PBBQ==
X-Received: by 2002:a1c:4004:: with SMTP id n4mr5895522wma.153.1578685091358;
        Fri, 10 Jan 2020 11:38:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 60sm3403286wrn.86.2020.01.10.11.38.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:38:10 -0800 (PST)
Message-ID: <5e18d2a2.1c69fb81.35cc4.095e@mx.google.com>
Date:   Fri, 10 Jan 2020 11:38:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.208-49-g6a7085976588
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 53 boots: 1 failed,
 44 passed with 8 untried/unknown (v4.4.208-49-g6a7085976588)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 53 boots: 1 failed, 44 passed with 8 untried/un=
known (v4.4.208-49-g6a7085976588)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.208-49-g6a7085976588/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.208-49-g6a7085976588/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.208-49-g6a7085976588
Git Commit: 6a708597658800a06a47cda9f486339ff2a93ba6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 10 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.4.208)
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.208)
              lab-drue: new failure (last pass: v4.4.208)
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.4.208)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.208-50-g8ff01da61a=
3f)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
