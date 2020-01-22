Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC90144ABA
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 05:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAVEM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 23:12:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41725 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVEM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 23:12:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so5740838wrw.8
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 20:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hMNDaELr/b3NCM+MgnJOrVtvZeyd/6Le0eFHqLnTCG4=;
        b=HlXUU3tVGnrUSJAM2EoO1ebie8pacRFzNbrNM1FYMnlsKC5sAiVPg1oPnxC0Hg//hK
         xceaUWz99n/DR4gWRvUUFzItBNuX50U25MQ4qCvENBymgbXGUv4uc91OeAzhKVifQU/j
         Med+npLPvj5wtDuqunCLArgVfLEcRqhq2GF30AcPa11NTXJkzM6/6whkbiYSXGA75TXr
         4oWJdc8sTbwZLOountDPnC3XRT3cx8j9vfmortbj5b1L6jPX5PBtAMwHu/05S7Rn5ezI
         o8jZhEf/PaCVsiE3WoNCA0aebpfw5VTuMSeQ8fqAeGsvY0D7VgkAkaJly/o2lVV6XIl6
         u9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hMNDaELr/b3NCM+MgnJOrVtvZeyd/6Le0eFHqLnTCG4=;
        b=bdKD3FzS+AuvK8+Ju1UtlKlzlZtvNZj21FJ47nY36Pi6WgI+qem92RmkdNjgnONZGf
         CfG7S4vaobAtJxw9dry0fqqg/xsOD9DYuWragn+gW029jQztv/UmZyoCmd85pCsVZ5wU
         qxxKrHOlsav1KonqFEU92R96axItKm6mn8xmy78DyKx9HExDE7TyY3vanaSnDaoHc5+a
         lwZeoIbtNf8S2ubvGizutVwojHdFVhXGsMDeNr9O6/S7TIPLBTrKLiGAp29WE+j+w37t
         YIldYbeDQtrjQbi7ktgfHlbt/miQ28vPtLSPB0+rTV4C7Fw10hB++hAwVL/nEMiwrs7v
         zmNw==
X-Gm-Message-State: APjAAAUmMF/5BVML+goPTbUVUVsJZiGf40VY1LTl/3ggbbKWCsfsi9s4
        jKyx8Xak+Yv8RrQt7edppaNgeqgyFfEu2w==
X-Google-Smtp-Source: APXvYqwy6SsbqMUksjhHQGaNXG8XgtCtQQOroCRP36cqCRk21hk73M+LZg7Tv4ef4+HNuNZ9KSLoHw==
X-Received: by 2002:adf:f789:: with SMTP id q9mr9040386wrp.103.1579666373615;
        Tue, 21 Jan 2020 20:12:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n16sm56197439wro.88.2020.01.21.20.12.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 20:12:53 -0800 (PST)
Message-ID: <5e27cbc5.1c69fb81.e161c.fe89@mx.google.com>
Date:   Tue, 21 Jan 2020 20:12:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97-88-g854a2a8f9451
Subject: stable-rc/linux-4.19.y boot: 57 boots: 1 failed,
 53 passed with 3 untried/unknown (v4.19.97-88-g854a2a8f9451)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 57 boots: 1 failed, 53 passed with 3 untried/u=
nknown (v4.19.97-88-g854a2a8f9451)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.97-88-g854a2a8f9451/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.97-88-g854a2a8f9451/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.97-88-g854a2a8f9451
Git Commit: 854a2a8f9451c77029355b3ca1cf0c963aaaffd5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 14 SoC families, 13 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.97-66-g6e319a78bc=
27)

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.19.97-66-g6e319a78bc=
27)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
