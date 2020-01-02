Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D091812F09F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgABWy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:54:26 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42766 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbgABWyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 17:54:24 -0500
Received: by mail-wr1-f52.google.com with SMTP id q6so40733972wro.9
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 14:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s6u6sQjCfZodfEfDdfG0U4qg+3YB8Xz74pcoqW6AlzE=;
        b=jj1JAGAMYJnGdEHr8dN9e5xGq3HwVEqU8cbXoH4kkPhqXNT/8ad9C/kmypwvXt/XvU
         2HDUUHm9mxOe2wtFTT8fSnexGssq7O4Wyq5RZcVZbcpGqhlijZ0bfW1djc5ZdaEFHl1V
         GG4HJChOe5yYcK/3moppgpDWd02i4r/q+aw6uYtL7Up0Jfi2x735tmojSIFFBaoypgfW
         N0Hp0Wq2qZz9n2W2LOSC2bA3hn0rUGDrmkygb3EDQO3i2Ylb+JL9csSq3bMNZKoaNdDk
         h4xoYFYeFLovPobIj09ZsbaRtij4imErQnSyUcz/Ev7YAos2pNbrVbLl9rCrsYv7DaeL
         SOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s6u6sQjCfZodfEfDdfG0U4qg+3YB8Xz74pcoqW6AlzE=;
        b=RM2ZjB+hgoj37DfIPvvO9uf4pmllZXbPaiVPOCqWuukMQ6aisC5fvV5PoSoKFG4d2Y
         K5JzddUGUO0+1L4Yr93HXKSOvOlUUO04SKJxmduv4KrUmmqkdmufQicdQshEtQ+cnx6s
         fZtyZKj709nli3qiZkGRtmDK9vTuZpjS7NbCdfcLyb6qy0KDdVlUd9nUiymp44F+WEog
         jK4OJIavDn+1W0AXxPBDA5gsMzbYunCCIK/z7euDEHig9+FByynfnKBsNmbI1IA7VWiR
         u+7co5b+xLnfIW1ltnZMuvtA9xkfgvsgGlHh/xK0cspB7MY43IxOOjy1BCu3NCwGA0GH
         aGQQ==
X-Gm-Message-State: APjAAAWUwrDxb7JseAMSTL2GxnYJ4xN1HJe6vX/yozzv7t8se+1iKWUB
        JOcMiTTMwJfxuvn2QzbQKroPikXGTXyBiQ==
X-Google-Smtp-Source: APXvYqwAAj/S+qbGeVz9RpU7W6KbsKzUnIsu2/Hm8EBy1t7DK8VlNTG8VRH9YLEun6RyPJ3GZB8bog==
X-Received: by 2002:a5d:4692:: with SMTP id u18mr83037652wrq.206.1578005662185;
        Thu, 02 Jan 2020 14:54:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b137sm10269640wme.26.2020.01.02.14.54.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 14:54:21 -0800 (PST)
Message-ID: <5e0e749d.1c69fb81.fb472.ef33@mx.google.com>
Date:   Thu, 02 Jan 2020 14:54:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-115-g0ca4b109a55f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 63 boots: 0 failed,
 62 passed with 1 untried/unknown (v4.19.92-115-g0ca4b109a55f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 0 failed, 62 passed with 1 untried/u=
nknown (v4.19.92-115-g0ca4b109a55f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-115-g0ca4b109a55f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-115-g0ca4b109a55f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-115-g0ca4b109a55f
Git Commit: 0ca4b109a55ff684a5725923fbc132b0653c3983
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
