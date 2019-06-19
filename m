Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02984B70F
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 13:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfFSL3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 07:29:33 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:38454 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSL3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 07:29:33 -0400
Received: by mail-wm1-f54.google.com with SMTP id s15so1438010wmj.3
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 04:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u0VEHBUZATL1pMBbjUytrGJWV9neab+fY5gkwdmIBXg=;
        b=u1g7caL7zUoAKHHLyzNw8b7Bs7rcYnZFPVobuUuMGMAitgpYdvwbKRoIWXjJ443E7u
         pqaXalL52Vhmbs8h5YJs+4quDXh0sVUpfuZcU+alwi31A0pteVb457bSPS0sKvff3xk+
         5kbqSnBXuU814xfKuZmZVRQ/IFtFYPnPQn3ZyQ2ANoCFYaVRRLNsS8or7Cie5Y59vV72
         htVTpA21wPyq/bWDB0SFlRD9446Kdyh7MEItE0UrnfpmU2o4PMmtmOC6XyrX5y8RtdcX
         xo19ZYGPM6pe3UHgZqdldvsULrX4rITvEEfr2i9xLRuQAfRQFQsHmsLVuF8zmwZm2mfW
         QqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u0VEHBUZATL1pMBbjUytrGJWV9neab+fY5gkwdmIBXg=;
        b=WIyophjHRMvWU+Q2j89Z6kJzrP/XWNm2kdUORL7jzdKl40n5wJUx86/tZf2AoP73V9
         Cvpn+K4TzXG/m+s7TndoU5lFgguC/rE66BpzHMMKhWAGz/l6e9HIoqJMXeVfkL6aI0cp
         Hh8oxbAKNPY3cVgBBQDpiSmFMnjjdGa4K1wDJXKQkO7RI7fzSSZnbSIho0vJEJKyXmal
         lcYmKDraWp2/xeYc2KVEnFgrF9NCPEgTkqoxB2rd+DtsdgZxex0iklnRTTDUY9C6yrsS
         TW8oXW2D0rw3fvK3sdZrPK93dbDQR7TIJrWK4bWgEgEC5ng5HclNKQrwTTpd6pYvMyHK
         mGVQ==
X-Gm-Message-State: APjAAAXLstMAQX5pV17pv8FObmE+fi6KwLth08AJQlmS6bdCw29fw8Zt
        fKfuz51/ZMWweSMkUCC//0HwVpnjNPVNwg==
X-Google-Smtp-Source: APXvYqyfqd+pQdpkyeIydXVvXQnoFMpT6fDiYiYcONcdLKVJKNfYJT5tizCaqvKj0v3V9LjfIrb0vg==
X-Received: by 2002:a7b:cf32:: with SMTP id m18mr8119547wmg.27.1560943770684;
        Wed, 19 Jun 2019 04:29:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l12sm42443537wrb.81.2019.06.19.04.29.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:29:30 -0700 (PDT)
Message-ID: <5d0a1c9a.1c69fb81.31beb.53dd@mx.google.com>
Date:   Wed, 19 Jun 2019 04:29:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.12
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 59 boots: 0 failed, 59 passed (v5.1.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 59 boots: 0 failed, 59 passed (v5.1.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.12/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.12/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.12
Git Commit: 5752b50477dace442b8ca238a6957918436efeeb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 15 SoC families, 10 builds out of 209

---
For more info write to <info@kernelci.org>
