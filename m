Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041F01044DA
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 21:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKTUSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 15:18:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42189 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTUSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 15:18:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so1441411wrf.9
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 12:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oVP//ZSYe90n+DBuU2K/EIxdA0hFDtIKzSbDeDQyBTs=;
        b=m+wSWI/4FdNEBFhdIwauU9ZfeGRSHV1Ii4bZTokHlH2srGgpbmVajiIOO97/BDlMxb
         ZnDhCHOET/cEwuEt6Ff9aIJDAfbkedWErDV98MTMOmDTp9G+ldLcADIHDoWLBT5LuPYe
         LNfZnlpHG6Zcrw/7awm/igJRHmIKkKmhifzOgDyVwJ4yEQvhyGaADGagGBTO2sgfFbVD
         QXqQ9F6eybodgMCQKlDttAhcI9fXhTggrgeVK79aA2H+L9j7UgSr/YqfkULs3Jku5fs6
         jp94JonHYvpdd6Fh3J2w1tA73JVmHhfd7mur5mUj+acuVmWP5W7ZeNasUyDYD4yxwxkD
         XDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oVP//ZSYe90n+DBuU2K/EIxdA0hFDtIKzSbDeDQyBTs=;
        b=BK3cUcSTVNcREPhvdyEHAFwsbuGpKrKaI2XKCi16E5sxf+sphcVQeA2BGcfdMHX/78
         OPR5p9ltOgE/6Rly282kI2agweldr4n8wzgXOaT8wYqYkyQm+26Om16tXOxXWEcvXRvT
         uVhvCbXkCbgdslki4gbBEzZYhqUF48QKSfzQbo8p9XqnCgSSHJ//qojJpadykhU4Yj8n
         pwesYhQw62lLWebRHuCpJ+OFq/p+XX6viGoEYOYA109YIEBbcjkxINEXMH5Rt2J07Xhk
         YWDE4S3vDFRSARX1fA0SVs8UxEQfUY/9ondz80AxmiTOyyns4jp1A1I7DvGYBNuYYfIQ
         2Rrg==
X-Gm-Message-State: APjAAAUiLVMTAZaGqJxtDNiRJaWDlBDQlyZcQdqRlnVedGh6nHi+ccDY
        BeJD8VLApyErHa49ANSr1IjY50PpOlpHLg==
X-Google-Smtp-Source: APXvYqyCk9HozojtzZQysMvxHnBW+ICVJU8/EIszWF0IKllZ3xvgCKRgnAujfPrUHTiIvAUwoTLdCg==
X-Received: by 2002:adf:81e3:: with SMTP id 90mr4974072wra.23.1574281092757;
        Wed, 20 Nov 2019 12:18:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p15sm415447wmb.10.2019.11.20.12.18.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 12:18:11 -0800 (PST)
Message-ID: <5dd59f83.1c69fb81.3e02c.278e@mx.google.com>
Date:   Wed, 20 Nov 2019 12:18:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.12
Subject: stable/linux-5.3.y boot: 87 boots: 0 failed,
 86 passed with 1 untried/unknown (v5.3.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 87 boots: 0 failed, 86 passed with 1 untried/unkno=
wn (v5.3.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.12/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.12/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.12
Git Commit: 807d174bcb26ffc9eeb944d39591a15059aa7cbc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 57 unique boards, 18 SoC families, 12 builds out of 208

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.3.10)

---
For more info write to <info@kernelci.org>
