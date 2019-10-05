Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618FCCCBE8
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 20:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387609AbfJESHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 14:07:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44468 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387477AbfJESHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 14:07:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id z9so10651701wrl.11
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 11:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eHi0fj6whiIFYcUv9AR2iGAh2YxsD+eN18iYp9IPfNA=;
        b=m5ascc1uY2IpqeuM58GctXxg3OVoIF0nVA0B1YHV5c0WE9nGW2MPTADXuP4TL+pB8f
         /GF7KH6T9VHC1nK8tP8fURCl0yQpzXs8NVvNFTjx2jVdBKzEozAOC/TkNxkUVjR4IyH1
         SSWCmNlMd/ZwkAFiAH62my58Iwa3ZlqicmRkBt5EiW7Ad/ZQOlHZaWsHHBoyrCEGSVhs
         fw/ipac+PxGWozjaUXZ8eo8DZBxcLHQOzXIQP7iHRhufm+R+g4I6v0GulBrJMcZtKuI/
         wD5hdR/QD4Tb02o2sJE4y52PeUT4oakHWu1dSa62TnTQzdPTm5NS7x+nzcAuYoTEPkmN
         kY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eHi0fj6whiIFYcUv9AR2iGAh2YxsD+eN18iYp9IPfNA=;
        b=hUrAR0iqR9nECd2hCi27aGBfuQ4jER8rNhehDIG3WGeTRFIh8u23oiow7icXoycZ2A
         Pqb5ZVTxrad3qQ/jFTVpQgpLWQlS9OA2LpTpqVZ0G7C8Fy+oNWjtwnpW3jGOpn/rcf4+
         75dhrg4Ig9TjcxFvsipse2Fd0uM3dTcdB5iCuZBylx+zc1OxBufb/XkvbxmmMmJeAAaG
         HatOb75yF0LBqdu7WRaajVcDNS1/JoU1KzzXiTvVCsmcdo8o9zaYbbm1knGeDd+tfpUh
         l3Jm6QsC2ycMIs7QrOMRimPq5gLAv3KsxceBfPZiW0pBu/kU3rO2/oYO4sx8SZwWfsio
         H/SQ==
X-Gm-Message-State: APjAAAWpn8ZY80R25lVIQ6jAmwyQQkEXBX8dh0ABPbqoi7zhsf4I5pHD
        zOztM6zykFQeaOj1Ejm4eAta8itDgcY=
X-Google-Smtp-Source: APXvYqwQmIIyUJwQmNj4KJDZSsPu0bJ/prLHT4PuITXnxZKEnNyGFnQJsiyWJzW0RnPz7Z2BUvZm0A==
X-Received: by 2002:a5d:568d:: with SMTP id f13mr15566154wrv.162.1570298827397;
        Sat, 05 Oct 2019 11:07:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b12sm9408605wrt.21.2019.10.05.11.07.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 11:07:06 -0700 (PDT)
Message-ID: <5d98dbca.1c69fb81.7ba56.8f24@mx.google.com>
Date:   Sat, 05 Oct 2019 11:07:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.147
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.147)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.147)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.147/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.147/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.147
Git Commit: db1892238c55c5138801f131a837ccd0056f002e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
