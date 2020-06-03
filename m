Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06B51ED746
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 22:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCUVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 16:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCUVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 16:21:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638B7C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 13:21:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b7so1417378pju.0
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 13:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O5s634Q8WnIDGuVW9P3Rlq1betVw5j2OWwXUj0kOWFQ=;
        b=I8qV5RHZZjcLZjkgvM0Vlb3RCT3zdXJ8Npe54SnOvnKhozWKmD7yAcZ8rtHgQzFBQ7
         nyKv9rZzBBpZn/fpHV0DD6T5/R8+2KJCsRmdKAaSyCEwosaN5OW7jUvoUVc5lrlpZY5C
         D6C15+NpH3hAG8XjIxIDXm+mjpfTMOWDW76aZdmW8h6TUpzWHlv6dBSl7dp1JxEP3heb
         L3NdxTRR8oNWardBYUitABPmIObrNiH7gJ+AZraNeJoM6PEgFwZP/UMZfRach+tB8ONr
         WNj5YgrTY+Yn+GfIOZiHqWNXAVJpoj9NuKfBzU/KhvbFqf/gj8kVm/Lrx2GDAykHaqxl
         jICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=O5s634Q8WnIDGuVW9P3Rlq1betVw5j2OWwXUj0kOWFQ=;
        b=qXG5kwEKE90A4nYFL2acJqKkGBKgk06cuuYmea8dq8dtKSCzwVaLJjG9Q0TD7X2TNq
         l0R8j9PdtPDA3btZjVzs19H+2IcaBAlyl2qUUSEjAvgHd51kJra+EoaZOVyaBJaWmLOE
         cADK0yLfqhOKyz6PyGo9SNk2qbPYu1uQ3xreC61y9UIcO7B66QbLdDXMa4iTHMQbkI+s
         ANTg7jhgXRmh0/WDHMZGhF/lqjuzdXt1wGd+wEXbzLUy6fupDcxQXaMrsAhFtCEqV/qJ
         u9mdeq+N/dGqJWgEJ6j06+pGNNIcphC3Y29jkvAPwvI2BXKdWfONy9G9LdDlf47jvJ3p
         3Plg==
X-Gm-Message-State: AOAM532UhRq2RPZHQcdOZP1IefhKwjkTEpJb8gtHLXn8NLyONHr23ive
        kW02MgTLI3GouylCGO3q3Vo4JqrQ
X-Google-Smtp-Source: ABdhPJzgFU3HGZTCSFznfv+Bv9yyGb3zwNeB2jfrV3Z7cpPtwM7jLVNYO2Q6Ak1iZZrTXGLzYwairg==
X-Received: by 2002:a17:90a:db90:: with SMTP id h16mr1898560pjv.119.1591215702557;
        Wed, 03 Jun 2020 13:21:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q44sm3361658pja.29.2020.06.03.13.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jun 2020 13:21:41 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Patches to apply to stable releases [6/3/2020]
Date:   Wed,  3 Jun 2020 13:21:35 -0700
Message-Id: <20200603202135.78725-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Upstream commit 0e0bf1ea1147 ("perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode")
  upstream: ToT
    Fixes: 51fd2df1e882 ("perf stat: Fix interval output values")
      in linux-4.4.y: 7629c7ef5291
      upstream: v4.5-rc4
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      Presumably also linux-5.7.y but not checked/tested

Upstream commit b8018b973c7c ("scsi: scsi_devinfo: fixup string compare")
  upstream: v4.15-rc1
    Fixes: 5e7ff2ca7f2d ("SCSI: fix new bug in scsi_dev_info_list string matching")
      in linux-4.4.y: c4c2a8f5b740
      upstream: v4.7-rc7
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y
    Fixed by:
      ba69ead9e9e9 ("scsi: scsi_devinfo: handle non-terminated strings")
      [This patch needs to be applied as well]

Upstream commit e87581fe0509 ("usb: gadget: f_uac2: fix error handling in afunc_bind (again)")
  upstream: v4.18-rc7
    Fixes: f1d3861d63a5 ("usb: gadget: f_uac2: fix error handling at afunc_bind")
      in linux-4.4.y: c67c2ed829f3
      in linux-4.9.y: 5180169dae85
      upstream: v4.10-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y (already applied)

Upstream commit f9ac89f5ad61 ("platform/x86: acer-wmi: setup accelerometer when ACPI device was found")
  upstream: v4.12-rc1
    Fixes: 98d610c3739a ("platform/x86: acer-wmi: setup accelerometer when machine has appropriate notify event")
      in linux-4.4.y: ccf0904c49b1
      in linux-4.9.y: 03470ba96a96
      upstream: v4.11-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)

Upstream commit 7284fdf39a91 ("esp6: fix memleak on error path in esp6_input")
  upstream: v4.18-rc8
    Fixes: 3f29770723fe ("ipsec: check return value of skb_to_sgvec always")
      in linux-4.4.y: d55d38496455
      in linux-4.9.y: 753b04d213ec
      upstream: v4.13-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y (already applied)

Upstream commit 3dc7c7badb75 ("IB/mlx4: Fix an error handling path in 'mlx4_ib_rereg_user_mr()'")
  upstream: v4.18-rc2
    Fixes: d8f9cc328c88 ("IB/mlx4: Mark user MR as writable if actual virtual memory is writable")
      in linux-4.4.y: d803aa2fe665
      in linux-4.9.y: e2ba7bf19727
      in linux-4.14.y: 1c82abc1b26a
      upstream: v4.18-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y (already applied)

Upstream commit fa16b69f1299 ("ALSA: hda - No loopback on ALC299 codec")
  upstream: v4.12-rc3
    Fixes: 28f1f9b26cee ("ALSA: hda/realtek - Add new codec ID ALC299")
      in linux-4.4.y: e2d12bdaed6b
      in linux-4.9.y: f6e94c2c16fe
      upstream: v4.11-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)

Upstream commit 86aa66687442 ("libnvdimm: Fix endian conversion issues ")
  upstream: v5.4-rc1
    Fixes: 9dedc73a4658 ("libnvdimm/btt: Fix LBA masking during 'free list' population")
      in linux-4.14.y: bf87f274fe9f
      in linux-4.19.y: 4e160b91c776
      upstream: v5.1-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y

Upstream commit e2abfc0448a4 ("x86/cpu/amd: Make erratum #1054 a legacy erratum")
  upstream: ToT
    Fixes: 21b5ee59ef18 ("x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF")
      in linux-4.19.y: f28ec250579c
      in linux-5.4.y: e0253c422024
      upstream: v5.6-rc3
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y
      Presumably also linux-5.7.y but not checked/tested
