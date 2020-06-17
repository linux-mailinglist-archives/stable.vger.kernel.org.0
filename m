Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844F11FD9F2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 01:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFQXxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 19:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgFQXxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 19:53:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FC5C06174E
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 16:53:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j4so1664811plk.3
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 16:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zB3alruMCGCzlOcmFX8mftG+9QbkhVzavB+VRjNKXus=;
        b=UaBfXjlHhslaIzY4xSd6On9CZL1Y5PbkiW9d+2dyL+n+w7+n8HZY58SNuX/LHiYd3s
         OwvnvwsRt++EJlzJV11GyV41Krv0SBTY7PD0hjlHXybg99RJyza2XZRi4/zSeWTJXtEM
         SuPW6WD5h2lujeB2l8O/5tqMJxiw8Dpl84GFbU/T0wBsf8zqPbc3LP7jhI8vNs2ClAOX
         sxuHUfCQoUjD1xm9O/8/uHTx1zVjCgQDQjvFbMODyuI7PSJ72da28DMGlgLAMLfb6U27
         5R01scjjtyPS23xhWkfMb6b3vgELoKKGafrkuq4NG+9so06Sww7o2VWvVhidVQU+KY9y
         tHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=zB3alruMCGCzlOcmFX8mftG+9QbkhVzavB+VRjNKXus=;
        b=gXKqS02N/CfiiubEOogIXweaXqfkN6sdkZ09HppvNWmyU4SInOksgk28/vIzGwFJJH
         Gyh0NXy12ZMXQL7DZY/q5IM0Bm9+N4lWtEs/mHbn0hfOhqujgd7wH2ZrciOQBqqjidE2
         OAlxqWqedFeRIhPnb2if/vLg8XGidzyBW9YHKWW/HXC0u0M+SaPY6H6o5pXPITvr/Kfw
         tlNHPRmkPN2udy/NZAFR+KGsqFgbGNWEl4RobRbXHmYvgdohOWQKFGvLh3WuhWNkhjQ6
         oJQIwM3Q0dt1QTvdMLhh1OvEFUo9d+4DraK1RPCzb1teQc3sEt0Z5xjNQGCD8H+2OphR
         Hkkg==
X-Gm-Message-State: AOAM530/zGWprxRstNaA0CBSbKk5LOoNEEqXy9lrJXv9EKCqNaVpBvzP
        j2bEnxRuNnNHgDPNdJgiIewTz9Kt
X-Google-Smtp-Source: ABdhPJws/ed8R82Z/9UZ8MyWLuh+SkOwVQtHfABp4vByH3/2/wjhCWZz3cjOX9J6D7mk+SIRawcS/Q==
X-Received: by 2002:a17:90a:c257:: with SMTP id d23mr1440192pjx.103.1592437991894;
        Wed, 17 Jun 2020 16:53:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y10sm784995pgi.54.2020.06.17.16.53.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 16:53:11 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Patches to apply to stable releases [6/17/2020]
Date:   Wed, 17 Jun 2020 16:53:08 -0700
Message-Id: <20200617235308.132274-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to the listed stable
releases.

The following patches were found to be missing in stable releases by the
Chrome OS missing patch robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
  Note that the Fixes: tag does not always point to the correct upstream
  SHA. In that case the correct upstream SHA is listed below.
- The patch referenced in the Fixes: tag has been applied to the listed
  stable release
- The patch has not been applied to that stable release

All patches have been applied to the listed stable releases and to at least
one Chrome OS branch. Resulting images have been build- and runtime-tested
(where applicable) on real hardware and with virtual hardware on
kerneltests.org.

Thanks,
Guenter

---
Upstream commit ba69ead9e9e9 ("scsi: scsi_devinfo: handle non-terminated strings")
  upstream: v4.15-rc4
    Fixes: b8018b973c7c ("scsi: scsi_devinfo: fixup string compare")
      in linux-4.4.y: ac8002f7cd0a
      in linux-4.9.y: d74a350d7035
      in linux-4.14.y: 13cd297f15ed
      upstream: v4.15-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y

Upstream commit 0d0d9a388a85 ("l2tp: Allow duplicate session creation with UDP")
  upstream: v5.6-rc1
    Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
      in linux-4.4.y: e613c6208242
      in linux-4.9.y: d9face6fc62a
      upstream: v4.11-rc6
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y (already applied)
      linux-4.19.y (already applied)
      linux-5.4.y (already applied)

Upstream commit 64611a15ca9d ("dm crypt: avoid truncating the logical block size")
  upstream: v5.8-rc1
    Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
      in linux-4.4.y: b8cd70b724f0
      in linux-4.9.y: 5dbde467ccd6
      in linux-4.14.y: 0c7a7d8e62bd
      in linux-4.19.y: a7f79052d1af
      in linux-5.4.y: 6eed26e35cfd
      upstream: v5.5-rc7
    Affected branches:
      linux-4.4.y (conflicts - backport needed)
      linux-4.9.y (conflicts - backport needed)
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround")
  upstream: v5.8-rc1
    Fixes: b10effb92e27 ("e1000e: fix buffer overrun while the I219 is processing DMA transactions")
      in linux-4.14.y: 0f478f25d50c
      upstream: v4.15-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 7c6d2ecbda83 ("net: be more gentle about silly gso requests coming from user")
  upstream: v5.7
    Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
      in linux-4.14.y: 5c336039843d
      in linux-4.19.y: 8920e8ae16a8
      in linux-5.4.y: a93417dfc1b0
      in linux-5.6.y: 17e1f3e32239
      upstream: v5.7
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y (already applied)
      linux-5.6.y (already applied)

Upstream commit 8418897f1bf8 ("ext4: fix error pointer dereference")
  upstream: v5.8-rc1
    Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
      in linux-4.14.y: 9da1f6d06b7a
      in linux-4.19.y: b878c8a7f08f
      upstream: v5.0-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit a75ca9303175 ("block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed")
  upstream: v5.8-rc1
    Fixes: e7bf90e5afe3 ("block/bio-integrity: fix a memory leak bug")
      in linux-4.14.y: c35f5d31451f
      in linux-4.19.y: af50d6a1c245
      upstream: v5.3-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit be32acff4380 ("scsi: ufs: Don't update urgent bkops level when toggling auto bkops")
  upstream: v5.8-rc1
    Fixes: 24366c2afbb0 ("scsi: ufs: Recheck bkops level if bkops is disabled")
      in linux-4.14.y: c909605d73ab
      in linux-4.19.y: 028a925c0540
      in linux-5.4.y: 3c9edf55817a
      upstream: v5.6-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
  upstream: v5.8-rc1
    Fixes: b469e7e47c8a ("fanotify: fix handling of events on child sub-directory")
      in linux-4.9.y: 987d8ff3a2d8
      in linux-4.14.y: 515160e3c4f2
      in linux-4.19.y: 20663629f6ae
      upstream: v4.20-rc3
    Affected branches:
      linux-4.9.y (conflicts - backport needed)
      linux-4.14.y (conflicts - backport needed)
      linux-4.19.y
      linux-5.4.y (already applied)
      linux-5.6.y (already applied)
      linux-5.7.y (already applied)

Upstream commit 607fa205a7e4 ("ASoC: core: only convert non DPCM link to DPCM link")
  upstream: v5.8-rc1
    Fixes: 218fe9b7ec7f ("ASoC: soc-core: Set dpcm_playback / dpcm_capture")
      in linux-4.19.y: 57f633cfe3fb
      in linux-5.4.y: 5585d2a98904
      upstream: v5.5-rc6
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 3e5095eebe01 ("PCI: vmd: Filter resource type bits from shadow register")
  upstream: v5.8-rc1
    Fixes: a1a30170138c ("PCI: vmd: Fix shadow offsets to reflect spec changes")
      in linux-4.19.y: 956ce989c41f
      upstream: v5.4-rc1
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 8a325dd06f23 ("of: Fix a refcounting bug in __of_attach_node_sysfs()")
  upstream: v5.8-rc1
    Fixes: 5b2c2f5a0ea3 ("of: overlay: add missing of_node_get() in __of_attach_node_sysfs")
      in linux-4.19.y: 9af27fab0061
      upstream: v5.0-rc1
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 8bc3b5e4b70d ("xfs: clean up the error handling in xfs_swap_extents")
  upstream: v5.8-rc1
    Fixes: 96987eea537d ("xfs: cancel COW blocks before swapext")
      in linux-4.19.y: a585ac0e767b
      upstream: v4.20-rc1
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit fe17e6cdc0fe ("ASoC: SOF: imx8: Fix randbuild error")
  upstream: v5.8-rc1
    Fixes: f9ad75468453 ("ASoC: SOF: imx: fix reverse CONFIG_SND_SOC_SOF_OF dependency")
      in linux-5.4.y: d98020a3fddd
      upstream: v5.5-rc1
    Affected branches:
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y

Upstream commit 10ce77e4817f ("ALSA: usb-audio: Add duplex sound support for USB devices using implicit feedback")
  upstream: v5.8-rc1
    Fixes: c249177944b6 ("ALSA: usb-audio: add implicit fb quirk for MOTU M Series")
      in linux-5.4.y: da2d50868e59
      upstream: v5.6-rc1
    Affected branches:
      linux-5.4.y
      linux-5.6.y
      linux-5.7.y
