Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FF21B4D8F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 21:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgDVTnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725779AbgDVTnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 15:43:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C1C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:43:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so1432429pjb.3
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Xhu+vj+GDtXkHXfPbYJ+1su4yFc12lN/2lz3Sp8qqLE=;
        b=dw5NJmBA2qwUHYqRZmdWJwSq1fUXGPho/2Y1Lzgn5hDF6AB5k7C3sEvqqk1r1JF6I/
         fQBZXpEh07Llh3FaRTTL75nGglKbmRXu2SH74QRvLuFvpuQ0vqMQulhz3M3pqqcyEtzY
         7BbEIuUkR+NRryAKU02DA5wUwFTT0GVD+BjH3rNcPC5lwXeu6yrrSyCbJz52sybcm1AT
         AJAQQFof8loGwYvCHsf6cdJF8CeHgFM1pGjStBRV4+FRXCk/mgcbrCThviKzOegBms3q
         e1LFqxkgFmyOKMVES1zxKcTdB7H1C22pE+drVZqkFtcAvKv+4qjPlkp/n7Byzlr/yB0R
         Jchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=Xhu+vj+GDtXkHXfPbYJ+1su4yFc12lN/2lz3Sp8qqLE=;
        b=YDx5i6rv7o80SzDVS5lKxe63L6GHF8z4kb0PiElV4i32eXDE1SU84qWpFX1HwXYMaF
         eRx7Q/rI7yCoMi4305ITYSv5RQnbfm25bmTY0VWAAVEMCnI4s345PR24p74PdIrNdeSy
         ZFr8o4MM/bQdTIWHGo3yl+QJfntWW8BDtcxyOx2lHAtFeXQ6atkTF2fWKde+3atQRv5K
         tXrtgC9eTJkJjI9CPkF6TC3fSRQHhahiPHXQ8c3glzAH+G40DKw+z1KYovPv2lwmBOW4
         TYAps5KhBFydEtCuAgtshzECyXnishqOi8rziJjWqE6tUlx5vwiPE2XietAkQmiPGYsQ
         qWsA==
X-Gm-Message-State: AGi0Pub4W6nLHu6ZiVLz0WbR6u4GYNJzZcnO3upZoUgiste8BsGMI75x
        jTjyWHB58Gmiw8LuBWv9i3/eOrk2
X-Google-Smtp-Source: APiQypI+cVUJ5D4KEQRa8GtDQTXklErz9bPiLRysuQF37nUlqSWfX69sNSMN7hu5mW77ONOgacHbRg==
X-Received: by 2002:a17:90a:d504:: with SMTP id t4mr344001pju.123.1587584588563;
        Wed, 22 Apr 2020 12:43:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l137sm299438pfd.107.2020.04.22.12.43.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 12:43:07 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:43:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: List of patches to apply to stable releases
Message-ID: <20200422194306.GA103402@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to the listed stable releases.

The following patches were found to be missing in stable releases by the
Chrome OS missing patch robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
- The patch referenced in the Fixes: tag has been applied to the listed
  stable release
- The patch has not been applied to that stable release

All patches have been applied to the listed stable releases and to at least one
Chrome OS branch. Resulting images have been build- and runtime-tested (where
applicable) on real hardware and with virtual hardware on kerneltests.org.

Thanks,
Guenter

---
Upstream commit 6a30abaa40b6 ("ALSA: hda - Fix incorrect usage of IS_REACHABLE()")
  upstream: v4.17-rc4
    Fixes: c469652bb5e8 ("ALSA: hda - Use IS_REACHABLE() for dependency on input")
      in linux-4.4.y: 4281754e6bea
      in linux-4.9.y: 71bff398b0d4
      in linux-4.14.y: d3222cfc0b58
      upstream: v4.16-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y (already applied)

Upstream commit 20b50d79974e ("net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()")
  upstream: v4.15-rc8
    Fixes: 8f659a03a0ba ("net: ipv4: fix for a race condition in raw_sendmsg")
      in linux-4.4.y: be27b620a861
      in linux-4.9.y: f75f910ffa90
      in linux-4.14.y: 3bc400bad0e0
      upstream: v4.15-rc4
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y

Upstream commit 773daa3caf5d ("net: ipv4: avoid unused variable warning for sysctl")
  upstream: v4.16-rc5
    Fixes: c7272c2f1229 ("net: ipv4: don't allow setting net.ipv4.route.min_pmtu below 68")
      in linux-4.4.y: 94522bee72fd
      in linux-4.9.y: 06f01887683f
      in linux-4.14.y: 3bcf69f8e786
      upstream: v4.16-rc5
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y

Upstream commit 2ecefa0a15fd ("keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h")
  upstream: v4.20-rc1
    Fixes: 8a2336e549d3 ("uapi/linux/keyctl.h: don't use C++ reserved keyword as a struct member name")
      in linux-4.14.y: 448b5498f6c6
      upstream: v4.19-rc3
    Affected branches:
      linux-4.14.y
      linux-4.19.y (already applied)

Upstream commit 9f614197c744 ("drm/msm: Use the correct dma_sync calls harder")
  upstream: v5.4-rc1
    Fixes: 3de433c5b38a ("drm/msm: Use the correct dma_sync calls in msm_gem")
      in linux-4.9.y: dca98889e8e5
      in linux-4.14.y: 7ed71842d3c8
      in linux-4.19.y: 39718d086d9b
      upstream: v5.3-rc3
    Affected branches:
      linux-4.9.y
      linux-4.14.y
      linux-4.19.y

Upstream commit 555089fdfc37 ("bpftool: Fix printing incorrect pointer in btf_dump_ptr")
  upstream: v5.5-rc7
    Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
      in linux-4.19.y: 5fab87c26f0a
      upstream: v5.4-rc1
    Affected branches:
      linux-4.19.y
      linux-5.4.y (already applied)

Upstream commit ce4e45842de3 ("crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static")
  upstream: v4.20-rc1
    Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
      in linux-4.4.y: 33378afbd12b
      in linux-4.9.y: df1ef6f3c9ad
      in linux-4.14.y: c0933fa586b4
      in linux-4.19.y: 70ecd0459d03
      upstream: v4.20-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y
      linux-4.19.y

Upstream commit 01ce31c57b3f ("vti4: removed duplicate log message.")
  upstream: v5.1
    Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
      in linux-4.4.y: a4fa2a130412
      in linux-4.9.y: d2a6df768b55
      in linux-4.14.y: 61a2e1118c8a
      in linux-4.19.y: 8ce41db0dcfc
      upstream: v5.0-rc5
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y
      linux-4.19.y
