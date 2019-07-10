Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E55464EBF
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 00:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGJWmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 18:42:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53493 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJWmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 18:42:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so3810428wmj.3
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 15:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m0Guh96AMFD34jnBuNeQ9uu3TCX+Yk/wnRb8ByMGl+s=;
        b=Rl2G0lulvR2M/8KK6/6Hp7AFaH5gEMim1eMSP7lpn3ogoUDBuNi3xjy6moUBdso8if
         j6GZixqhPVO7fIsoHoyC5CAEeK/PCAKa7XDH8p4hDBhz8T4udcalDrt2Ydw7Wg2m4qni
         xscyzZoOEWXd/h/f+N+U9TrFhHbPmwGHMfgxI8EkyPJvlv1SpW/y0q6OH4EZGZ0Ix+cm
         pjJZNXBzj7nfdU4IBN0FYwYgXZeTvcl0RtEJ8yCOWL5ubG1g558Vaka1l6eeDHf6Nnpy
         vmO0mndwCjuEv/Wf5Kg5kPbJpPplMkSwlx/bC650yX9a5Qv5zi0Hu4tQpQ8MWz8tCNcw
         B2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m0Guh96AMFD34jnBuNeQ9uu3TCX+Yk/wnRb8ByMGl+s=;
        b=Mviz10f/x4iUfLAvWM5OZzHuD2kwsdPYOLNdpdTZgcyRiZzV0VskilaeHm5J2/99fY
         QYwsTLI4dzagchGXF/rzvWziUbmEC8DomPlzC0G8+0wFous8zmhizer8yTOilNsxb+wm
         6q+2u+rgWvEOSPIRefuUQAtjl6fF0hIiS8puS8E41qy3cJtCs67lJh87h/GHzwiWD64X
         ddFPmB2une9ZGiZZn6Cne3ELpRbMoN8BbKBRDTPA1Wz3cU+QJmv8xZNl1Cn8/yGCN8Oz
         h4Vnf3+dxNHbOpgxnexe0wiKUll76IMFpOMdceaW6o3l9uYyG/IPA7szfyP6K5trjPfV
         O7UQ==
X-Gm-Message-State: APjAAAX4eQzlJ0YN5zG8uR+wIGq2fi3gMSWhTrXfVNapQry8wdGXnG8t
        wLTrTa5etU6aotsJUj62WKoJi65QDDU=
X-Google-Smtp-Source: APXvYqwDlxAHuTN5txEGfAkiAIa2AdK5E6AnLGEviSaibjfxhyls2dP2fzUvEhTXwU07ZQvqplWXoA==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr168735wmi.50.1562798570159;
        Wed, 10 Jul 2019 15:42:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l8sm6182485wrg.40.2019.07.10.15.42.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 15:42:49 -0700 (PDT)
Message-ID: <5d2669e9.1c69fb81.939b7.4c17@mx.google.com>
Date:   Wed, 10 Jul 2019 15:42:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.185
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 109 boots: 2 failed,
 106 passed with 1 untried/unknown (v4.9.185)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 109 boots: 2 failed, 106 passed with 1 untried/=
unknown (v4.9.185)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185
Git Commit: 9c51e1102c95e1c4849bf9b88c8b0c3da56b9c13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
