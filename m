Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EDBCD9B9
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 01:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJFXoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 19:44:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36639 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfJFXoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 19:44:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so13075096wrd.3
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 16:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CoQTMz0vIJgWBxYS9gPLJc7l5g0XXw6MmRdRKh3CsCw=;
        b=dcyzYc+rg6xeqrVkeo2HTrd0Y1BUb20zFFhc/y2j5uZ/mHbaUDA63J5GOoNA16IRdm
         vRirq7yvejakBq/O/5WUNPNM6jZv4/2MZhBhkw2u19MBIyxZM4ni8dlWeL8XcZDPAPwf
         M7odHxJg6qg9b6xywphvjluiHe9XIzdtMSbo5QENKOO8PbLmH7l2BKmZvQtZi4KFGkMD
         QX+arEi2nZagp7HsY3NyxkUW3NQl/xjfLj6YT0fh7PnnpZJ1UcADsCPclDpll3pY+ls7
         hL839DqUtMCwIIEJ48gdQ0fSJ5hkMlmkvdtayo790gebNm1zyfp8lczKafxGco2L1NwR
         j5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CoQTMz0vIJgWBxYS9gPLJc7l5g0XXw6MmRdRKh3CsCw=;
        b=lFdXaU0LTTiNfN7/qBLnoGePwOQxscerd5VUjNRp/UDYy37Th4C/ro6nIBkL++fmZa
         soF3q3ewDVUhzWB7mIoYlHO2FIMv+2zdpnHoDSU0eRtjAE0YHglx4Tcl4NOnjx5ehUyU
         Z4x+sVD6Yh4G+bMBp5VTO90Uph4N4eyuSC1JCZ1zQJhqjKDLx8KN8iBffg5qhr9F3ZxD
         CWIxCYA0hYiaNY6ISQMS938e8Tne19wk72nH3L8hMcOehrBYj3tB1LJSm8hLmHRUsVP0
         7wn4Q71gQ0TZvs9gt3u0tHLoK9Bj9S/3ZGh+CwhfHw5QehZVlX0uBoweO2DEEl/7UyKQ
         33qw==
X-Gm-Message-State: APjAAAVQ/DN17vYeTl5ZwAZfK5oUzS19giy/Dm+GpBbsKwtOOKq3FF28
        2VqgeMvoNFosltSObUYQLadd3ahpk1k=
X-Google-Smtp-Source: APXvYqx586ACGaE/qdzGq/bYEtQTU49LTrljKaOVuGM9UBE1i3Fv7PVPG6rHHjOgwsr7yn0eOzx9SA==
X-Received: by 2002:a05:6000:1046:: with SMTP id c6mr6546637wrx.189.1570405475919;
        Sun, 06 Oct 2019 16:44:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z13sm9894126wrq.51.2019.10.06.16.44.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 16:44:35 -0700 (PDT)
Message-ID: <5d9a7c63.1c69fb81.5bac7.a2ac@mx.google.com>
Date:   Sun, 06 Oct 2019 16:44:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.77-107-g61e72e79b84d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 55 boots: 0 failed,
 55 passed (v4.19.77-107-g61e72e79b84d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 55 boots: 0 failed, 55 passed (v4.19.77-107-g6=
1e72e79b84d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.77-107-g61e72e79b84d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.77-107-g61e72e79b84d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.77-107-g61e72e79b84d
Git Commit: 61e72e79b84d3a2519ad88c10964d7e4fa11ef1d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
