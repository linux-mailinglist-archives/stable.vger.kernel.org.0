Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9955CD9E5
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfJGA04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:26:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40142 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJGA04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 20:26:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so4368378wrv.7
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 17:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YbHG9iyH4j0VYIfMA/F37j5Dw6XERcBMiTFe13GZVaU=;
        b=i/TNQoEKzNYRbedo3qDmyTGG7vaZdswngn+TLEG7MtbmWykOrsbFcbyXHXra+UIpzb
         hHnDxwopI5Tb78Pouy3PyPgGNJ+YFNKUsXdfSmc7k9RGob8vsvemaxjSnCIlvRyDbRH/
         3d52+xCGYy51W1w9prf9bMI6G6tMCeBN9lV1s6vhb7iD0J31bilrt74HuRsoJ59wwo32
         cyr/7MKe2zYSdL6AxL5wYkfaLPE2p12h7oji5bFjlNhW9BHbYVU73+3C1BKG425jzaCe
         dyIcnE25vN5vXN3SrGA371moy3vQkF0EwsFsw979aRbl8c3VicRHmr6PlQ5ffxRG+AVL
         LWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YbHG9iyH4j0VYIfMA/F37j5Dw6XERcBMiTFe13GZVaU=;
        b=Cpzz0vW8W3r4Ggb1IX7lCYqz8niZPLuYeP5ngwUKItf0ZcIf8/yAbSqarSY06ucAHt
         AQCazNzbScJD5iMVv9Cd3lG8hOf5lwOPvgAzBaCh5wAj38w0cI7QQmp+Wjy1nzWqUEAH
         KGs8j4s9eift7U5ERT+cEM636YbxLcYp6ggOuI4piZq1YERTat0/bJYu7YZEYQvnPA7e
         BbQ6buZJOOHx7gkJIABidCrbjCEOG02sYu47xXqmmSbnkPJ2P0cCuLLR4+ITsw0hREn9
         fzZeFL1WjF14ZYpY+JNPnn2NZOTty9uyMlfagNIsGGKl/dilOr7S4NihcCRYaHz08Wdu
         cqhA==
X-Gm-Message-State: APjAAAUrnBuRWyXTmfsnjo1MLC5q0hGUfUdwOTajNSBi5h27SOPdmPKj
        dJjmCTyMHhgkqhRCEXSoi/J9N7ROho0=
X-Google-Smtp-Source: APXvYqx5QPmey2d6kbtR87R3WQF99aeMtZUlemegeNAS+Eh+mTFpsmdrG35QPQ32GhX+1Gtb89++xw==
X-Received: by 2002:a05:6000:d:: with SMTP id h13mr15731298wrx.170.1570408014135;
        Sun, 06 Oct 2019 17:26:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t4sm11942442wrm.13.2019.10.06.17.26.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 17:26:53 -0700 (PDT)
Message-ID: <5d9a864d.1c69fb81.35282.51f4@mx.google.com>
Date:   Sun, 06 Oct 2019 17:26:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.195-48-gce2cf4ffcd94
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 41 boots: 0 failed,
 41 passed (v4.9.195-48-gce2cf4ffcd94)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 41 boots: 0 failed, 41 passed (v4.9.195-48-gce2=
cf4ffcd94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.195-48-gce2cf4ffcd94/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.195-48-gce2cf4ffcd94/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.195-48-gce2cf4ffcd94
Git Commit: ce2cf4ffcd946bd02d4afd26f17f425dc921448e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 13 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
