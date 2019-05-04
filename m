Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5032C139F2
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfEDNEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 09:04:02 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:54011 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDNEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 09:04:02 -0400
Received: by mail-wm1-f44.google.com with SMTP id q15so10243633wmf.3
        for <stable@vger.kernel.org>; Sat, 04 May 2019 06:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aS8/6muzaI6Chcg7Qpbok7TxDRJ3G3PglAvmguXpU6c=;
        b=VQ16R0E/SCcjULDtlnYp/5llUMMApRKy6kTypy4HOfELFMHmToIyWNFlXVD/A7twEC
         cEh0x/HGngE1yAU+fJgNwwe5Zm8XOCzGH5bWF3ynvaaXSgHRfDY+wW0gSUjgKQcjLnxl
         zAf0J7l2yhobOZHaJOYfyabHZIpvyL8fSaS4+zcwxCKbLwdt54nHBovRip6PVDgIJhwY
         NoQH6wrq+Q8mlaaopQtXmI8Cs9iRqL1wRp5kDJrvgudVlZgBluf6TDyUH4BU7ko/ncGg
         ihySfTF8zd1c2oaQSJtuINK+rZUr+b8WykDQFqJ5orQrK2xO0tz8jMxruvF5V5MlyNqb
         ppqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aS8/6muzaI6Chcg7Qpbok7TxDRJ3G3PglAvmguXpU6c=;
        b=Yyn3it104ebGpbDHoJZImrs2f6YX7yLvxGMyTg4t4KiaSkcQINzAyGtub50uUEMp41
         p3RZABhSHQxPMpJ3Cl76vqDk6CsU4BE03NFDcd4wQoCpxSgc08OCun2fkBx1ERmjLgYN
         hm9iMknPZHPDs1MbngKw4vsQrcnMvG6YWsD9LN9Zyy8M/qDoIQCrRwitWwiycpjyZ9w/
         WnB3PgNwyYCAiKq8ww76h/WKtBPJNmoQfpKDuVA6tes9VY+Tqao2s0x+YTBPC1Ysq91z
         j9Y/XnpBU8qB+RGSPKXuZ9zC0y6qBZO2CKTkgSXsTK92ntxmagXM5g2qcOzQbmXe9OLJ
         EJIg==
X-Gm-Message-State: APjAAAVkKE/dY6x2jmFCplfuOhMARPLYAgApvit8qvymO/al24w3GokD
        nHJhtAY6KX7IqeF0egRf0sWRbk+PkNkDcA==
X-Google-Smtp-Source: APXvYqymn6OGvXN3rkgCXEQLpUvMUYYNpVwS8j2WF5LXnhpngMEzhh5oiwuUMFb5yy63DfG4E7h0Uw==
X-Received: by 2002:a1c:7a12:: with SMTP id v18mr10281717wmc.69.1556975040363;
        Sat, 04 May 2019 06:04:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c21sm5305042wme.36.2019.05.04.06.03.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:03:59 -0700 (PDT)
Message-ID: <5ccd8dbf.1c69fb81.3172.dd08@mx.google.com>
Date:   Sat, 04 May 2019 06:03:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.12
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.0.y boot: 64 boots: 0 failed,
 63 passed with 1 untried/unknown (v5.0.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 64 boots: 0 failed, 63 passed with 1 untried/unkno=
wn (v5.0.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.12/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.12/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.12
Git Commit: 6006d5b025224f2db8751d317e2e6bcdad69d4b6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
