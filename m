Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F144F5BB
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFVM1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 08:27:08 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44126 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVM1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 08:27:08 -0400
Received: by mail-wr1-f49.google.com with SMTP id r16so9037994wrl.11
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 05:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nk+PfsvIzPYsYomITvYnn5PpfhYoXBtgmHnMF51qOqg=;
        b=vnKk0oP7VFiDzUWngWfxdinBnXNXC6G8KqaFPCrlMfrsTsUsMh3bBct5+np3bbjV7t
         uKZKbTo2C62b7YSp0/TuLj5gl0WId66IVKtHMRpnyNplzFVcSV13OiocLNdsAeekhv/Y
         n2xp5615BE4Zo9TZ5iNk+ZoPf89iDYL0b7N5YJcrNouS+mGw3ZyLQ1VdYwdORXS04mHV
         BLEBOWBM3rcnlHYBXBM8R44gzOHTLucM0AGtOYi8uXDyfw9JCgg+xvXmqDsFCy0aKJEv
         HS47mT+0t3HYH/+zP6jELtObIuQqrYZNcjnkTOQGiXOi869SrTmfdmrIAR/2Ydm+lhKF
         jIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nk+PfsvIzPYsYomITvYnn5PpfhYoXBtgmHnMF51qOqg=;
        b=ZVqkXAx9mXd2wz43dcSROvBX6hBQ/edkkMNf4AnMkdLwJXdkqSTK1c+Hy4T/cnplmQ
         ZcpiOp6A6BJTjUbrCp2zf2WgrmI2K7kXg5s/eXuQ4VetWXllCIZmA+PlIcs3FLiCEz7k
         HqoIh/qeS7+C+aqsmyyWvpnF3zf3l6a+y9b2lIgBWsLQHWgQT2uz8VVlbJph8zEaZVZx
         VygwwxekHhYjKHmrXhpnt5uDHycwYiNaO9nXdf1pfe2KTNTRX+PxgbP9/cj+j5lErziu
         Ziv5ekrSoLDFCTwvkWzqDPkEigj06i7v96KIfd0xWQJ26sLXhn5Ug4kJae6LqIUsU8xG
         BDJQ==
X-Gm-Message-State: APjAAAUzqNWyMq4jVbX3TJCU43coVARq94BpmylHLX9uz6qPG4FxjPOp
        yqalbpkCPVEWsN4xZS1UgPn4BsqnqrjHdg==
X-Google-Smtp-Source: APXvYqy0SsfL4Bty+tL8mH95wRBa6DmPHOPX5kstDcncpqTh4hP73PsrLeQosUfbcbtmj8vKTw6pYA==
X-Received: by 2002:adf:ea4a:: with SMTP id j10mr6799521wrn.3.1561206425905;
        Sat, 22 Jun 2019 05:27:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b203sm6395522wmd.41.2019.06.22.05.27.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 05:27:05 -0700 (PDT)
Message-ID: <5d0e1e99.1c69fb81.b7f06.3bef@mx.google.com>
Date:   Sat, 22 Jun 2019 05:27:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 63 boots: 0 failed, 63 passed (v4.9.183)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 63 boots: 0 failed, 63 passed (v4.9.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.183/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.183/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.183
Git Commit: 72f67fd749dba12f6412b8d57e680b435c3f284a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 16 SoC families, 11 builds out of 197

---
For more info write to <info@kernelci.org>
