Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A913D1336DB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 23:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgAGWuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 17:50:54 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:35235 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgAGWuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 17:50:54 -0500
Received: by mail-wr1-f42.google.com with SMTP id g17so1402028wro.2
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 14:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kGdlMxJ7dUlI7MSYVuCRK3DU5uPjNi+s0QHfsmOHgOo=;
        b=OYpNH65gVqrOe8mwiPhF3nflqv9pL6joB1Bs6HVc/fkpW6F1d+TLD1zgunikGI3SMd
         w/N0wL2OUM1EBeDwr8hiutOZS2G9itFIy3CNf2bYu7eSCaZi/wJhc3KvY5SrRMrCsiFM
         rw6ToNAV0rrGBR6LO9jKxUPqpY34Z75DmaoMFhI5S/zyxJHxJlYyJHjQyEX2Au60oTSm
         5zSobaAqulnYDYW1alsqPlhjmHBkbvNEaYYdeAfOeTh8vc/6zihJCRdrz/8XKD2QXsko
         oa2X/VzNEH4ThbrE34P7kha/Pxmdph4KtfXA+r4V/AL0stMnIKTV6DCBpguLM8i3zugf
         Bfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kGdlMxJ7dUlI7MSYVuCRK3DU5uPjNi+s0QHfsmOHgOo=;
        b=MaH4OP+3jA90FITPuo89OWpMbq4Hp9gfwXYnR+OBm77uAehmMCS/ShSF1EXDHGeRzl
         V6GVsLW6t2bHaiJlEdfdZotuztJ8S7qxdtwA7XBEh2aAwLpm/53t2rSkAlX7euYV473p
         B5z9wGEtWqFAHgX+5UxNJQEugls4LTww7ZX5Nse/32EdBeceFBn+zjW85Cj65cVlTlph
         tO/0AI0c+T2aO+W5XlizFd3e2i7vpx4E91+RdNH0YwDuFE+xEEFJqU5UO0IvgTdVCOAG
         b7s0m/tJNeFcLD8pfIP7ABqGNNNewCYPZdCfq8VUXV+oVQm2uPhEofGS/zdJJ+3/jQZG
         Ny/Q==
X-Gm-Message-State: APjAAAWxte1BdvX0qKQVtLzsOe1nsQe6Tqj9kAP3N/VK2I+H2p8ntD5B
        floCpk4/bG+42Rac+sS/XgE06xY5oyigLQ==
X-Google-Smtp-Source: APXvYqy05ytnT7XCZ29SqgqwFzTnUDFDUBjQ5oG+T0B+YciPceoM8EucSI2OR9FFBYrPAFQFA3ZO5A==
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr1276261wrn.28.1578437452187;
        Tue, 07 Jan 2020 14:50:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t81sm1385795wmg.6.2020.01.07.14.50.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 14:50:51 -0800 (PST)
Message-ID: <5e150b4b.1c69fb81.4a62e.74e7@mx.google.com>
Date:   Tue, 07 Jan 2020 14:50:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-207-g455c61b76ca6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 28 boots: 0 failed,
 27 passed with 1 untried/unknown (v4.9.207-207-g455c61b76ca6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 28 boots: 0 failed, 27 passed with 1 untried/un=
known (v4.9.207-207-g455c61b76ca6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.207-207-g455c61b76ca6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-207-g455c61b76ca6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-207-g455c61b76ca6
Git Commit: 455c61b76ca6a510e7f539a6bf611d20116115bd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 9 SoC families, 9 builds out of 183

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.9.207-171-g9142f346a=
4e1)

---
For more info write to <info@kernelci.org>
