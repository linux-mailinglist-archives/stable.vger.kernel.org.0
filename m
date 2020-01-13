Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E731D139040
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgAMLki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:40:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33466 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMLki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 06:40:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so8224185wrq.0
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 03:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wd9ggJ5kH5TBjGrHXl8vsM6F8WZ1Qf1TRuwLzBAy3QQ=;
        b=k8dTboDilV/bYCbRmoveIo5p/N5WDgM2XWy4/6dI71Urhoei1aQ7yjQo8NV6+UIcoF
         2ZNKv8EMBm3hpbxxxYHVPkAwLHKJnzwcBvqIuXLiw709nUtq6i7UCb16yRj3Ygv+0e9B
         YagBGZ5Oo2yA2k2T89Uds5LGdEp02NLo/zf4kZ+yEB5o1oD3nn1SAFXVKhR5aHDEQxaZ
         WAHaJ10unKz9sldWuxq2cPOQfys8nAj7J7wYs01lu5Q9FunrPtSasBl9g/kNtbef0BL7
         tTMHGepuLWFZimadjtGYw4PRQ0mhVN8YBfi/s9v7m121UZ+PCG1PbKW+DJEjG+AyAGp5
         4Lqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wd9ggJ5kH5TBjGrHXl8vsM6F8WZ1Qf1TRuwLzBAy3QQ=;
        b=ifhRcMEYO83v4+TXaABlfzYSof1DIlq2HhBFTRKLEnDuFQSEQcfVFoxpybtrMcf36n
         fSiLNqOlMjX+Z+csuFkDg8CthBPd7zpRzNdU9qn/oVGW8YpsrqKmVGtZZZparjwdcbZ8
         PfQoNB9dEAkDYo9UmK91/7ucIcin10UrygFRmoj1ZtDdEfhZCs8p/DIpfYiiHXViiMQb
         maDD6Tk6f1I+NcQtRbyXkjGNm3dX0dMdvR55sgupY5gOwf5x89KFq8YIsQS54IzI9e6w
         u0D0Xig/Bw1+97HZOQpkXuNYZokjevUOCLMnGvl+00UWtyTSpmsSK1n4sgLNdlrr+Tkb
         7wfw==
X-Gm-Message-State: APjAAAV2Qpdth5dYmP/ablzD34KWUi3UgeVAgSrXg0JShI2LEs0h/V/b
        fpeLDPeeHaFtpdvkCx95Ftnwh8n0KRIzPw==
X-Google-Smtp-Source: APXvYqxu3HKo+QdnsoPCBqDlBF7XHgwdB5zLOXVAnwc/OZcj4ale3tsY32NIlygYlp6D7dO1buiwzw==
X-Received: by 2002:a5d:6211:: with SMTP id y17mr17938925wru.344.1578915636847;
        Mon, 13 Jan 2020 03:40:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h66sm14796675wme.41.2020.01.13.03.40.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 03:40:36 -0800 (PST)
Message-ID: <5e1c5734.1c69fb81.869a3.c15f@mx.google.com>
Date:   Mon, 13 Jan 2020 03:40:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.209
Subject: stable-rc/linux-4.4.y boot: 20 boots: 0 failed,
 19 passed with 1 untried/unknown (v4.4.209)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 20 boots: 0 failed, 19 passed with 1 untried/un=
known (v4.4.209)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.209/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.209/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.209
Git Commit: 3e8701c52068b6f224f103ab28d9c827b4d1257d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 15 unique boards, 5 SoC families, 7 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.208-60-gce8c9a6be3=
d9)

---
For more info write to <info@kernelci.org>
