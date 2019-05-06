Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72AD148F3
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfEFLbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 07:31:20 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:38170 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfEFLbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 07:31:20 -0400
Received: by mail-wr1-f47.google.com with SMTP id k16so16790092wrn.5
        for <stable@vger.kernel.org>; Mon, 06 May 2019 04:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sxeERINseJcB8fUmnbDFyhjp01J3CSb1D/r4BIrtMJo=;
        b=AkBM1aRQVf6Y2NuDb+JHuFIdKjwaeLfAR15vCkVuHdU+AP6y3pvW0rStKCib6c/xup
         AzoEF0OSFvnZgPOHp/85+ZtOWIvmYC2PJ1DW0ZesbpWnqFXLrhOSxXhvgr2ZVIigutlA
         h9knpN2mKOqrsbLlAIfPV/bDxjSHAztLVicj3z+tcp4T/DnYCsYbhfo+KglPvv9OlM19
         P7gC7m0bI346wqSu1Ybd74ooWxrdl9kmF8rfEv/WImTEpMIW9kFln6NkDwmiccUHwreB
         M+W1NLM1rLPGmk58/bO/pfcaAs1wsIpazKnTL2WfFDVIks4uXinMPK1596wR2NG4Sddi
         ek7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sxeERINseJcB8fUmnbDFyhjp01J3CSb1D/r4BIrtMJo=;
        b=XfXTQAvMtVhNP4ipSHZKouMhd4hRLoy00VSViPLyqXrdhbsSGsIfbZ0i8jwz67NzGu
         +RG9JcxRnB6nxi13706VHDOz0WFjv0YIfDsMS7vxNYfPMl5WYFqD8lkqXa0NwlF4TjC1
         jEKkNDoRFmUTD3TgkcVOpk1eAOV9rHMTXAR6cJM7fjDzoagsuwJlckYxlC6rIMdxbuxo
         FPZk7pokOKi0pNRa8Tm7Qgv+AW9c6WJHA1iYYOg8dFHlk38JnjnxIDPHGR1dYWdUq0/U
         2GrfuVBSKhLc8TudFiTkbEmTHUmbXYQhSV9iK6zTiZ7+K48SlVK7+5tmUk9JCwMgs/7b
         Ipxg==
X-Gm-Message-State: APjAAAWhuabiWigNCV+oNi752CoZ2NYB5TmFhfuYPtbjKYJ/dTKZBftY
        /8lOvmWizGty0pPuXCOoWCUPs6k7kPMcpg==
X-Google-Smtp-Source: APXvYqxLYUKGrvcT+UU7/DZ4FVugoJn5K5AXD/+zkYU3zkL4KeliFs75Pt2Ef4N0PV7y5nwD62aHpQ==
X-Received: by 2002:a5d:49cb:: with SMTP id t11mr7398086wrs.67.1557142279069;
        Mon, 06 May 2019 04:31:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g12sm10576740wmh.17.2019.05.06.04.31.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 04:31:17 -0700 (PDT)
Message-ID: <5cd01b05.1c69fb81.af58e.749b@mx.google.com>
Date:   Mon, 06 May 2019 04:31:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.13-84-gbfca9d5e5795
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 135 boots: 0 failed,
 132 passed with 1 offline, 2 untried/unknown (v5.0.13-84-gbfca9d5e5795)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 135 boots: 0 failed, 132 passed with 1 offline,=
 2 untried/unknown (v5.0.13-84-gbfca9d5e5795)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.13-84-gbfca9d5e5795/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.13-84-gbfca9d5e5795/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.13-84-gbfca9d5e5795
Git Commit: bfca9d5e5795258ee8d43d4518f1a6a4a03c9aba
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
