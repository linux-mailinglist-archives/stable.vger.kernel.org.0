Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D627480B2F
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 15:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfHDNkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 09:40:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41159 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfHDNkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 09:40:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so78547387wrm.8
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 06:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H24CfI7CXoF2lLPQ+mS6NhRtRMN8VSCtXntg2c4UVCU=;
        b=lbUw35HuiQViLBQqTG0Adr2Pf4z+w+VTEh5oSMFD79yhXuEFjeIB00tT++uHkrrU8E
         UW5gRcDtE9Y+NTo8G9TLoUsSiLlk5qIuCacVy6iLvGO8cEBlQ6f6/joz+2gqbaZd7GTq
         sx2/JM0lZ/IV+/aJK/3YzF//gQLE2fkfxFWRqLO0e7EqK31sBYO0rIEsZkTglfHeGwPx
         9srfrQr58wsFHUNGjRL5tcSyQk4k2wj90Sgxf2QsEd1VfF0t91bD9Beg8KJzSq0Q30x6
         /XoXeLBxyt+dO20ysEquJnNLVCMHjfXET00gIxF5t81SJkwwtRcBxcEp0TcjWE9Wj79Q
         o+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H24CfI7CXoF2lLPQ+mS6NhRtRMN8VSCtXntg2c4UVCU=;
        b=FGr2HgLf7eLIpwCbqiKH7iPIlsva0nrgD/SzPDj37Wqn/fHWj/Nff9GptydIhqW/HG
         FaeMFMbAdUiyc/Yg3yGPutD6XlK4glEkxhzQK/J6J8/6QefnLjZ1WUH+QqrfK8I40gyM
         QBSliwWSrkRLZjyCDRQuGlabMOVlr5lC7rtrijdltKdck52YXOxW1ykfhf2xWyUyPdgL
         2eF0cpbDUY5YzxNv6hwnrCGaI2rAifotMZMeQ85e5Oq436VT5SzKEGUU5OaukrlP+2Cl
         f7APe4w78kPIewyBVqTE5gAEj3EAoWsQ3YE/1iU7mwCL75a4Zy6ozav+EUe/bU+G3A3M
         rRmw==
X-Gm-Message-State: APjAAAXdMr70Qg80EwPPcOMN4lC2STHINglla6D/OuFNZXvsv9bawQzj
        aqKvugBkeo+8WlT6suSg5oGuZDer
X-Google-Smtp-Source: APXvYqwYUgPL6xCec2QCb2D8iUtaNQLnj7oqjhDZzvF8bOvcy7s/0hu2lptMi+ADaVv16RtLWQjkNw==
X-Received: by 2002:a5d:4205:: with SMTP id n5mr15571516wrq.52.1564926011764;
        Sun, 04 Aug 2019 06:40:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm85798080wrw.33.2019.08.04.06.40.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 06:40:11 -0700 (PDT)
Message-ID: <5d46e03b.1c69fb81.2471f.ddac@mx.google.com>
Date:   Sun, 04 Aug 2019 06:40:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.2.6
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.2.y boot: 68 boots: 0 failed,
 67 passed with 1 untried/unknown (v5.2.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 68 boots: 0 failed, 67 passed with 1 untried/unkno=
wn (v5.2.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.6/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.6/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.6
Git Commit: ec97ca18aa3a9123b5b64339e5993347295ebf88
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 16 SoC families, 12 builds out of 209

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.2.5)

---
For more info write to <info@kernelci.org>
