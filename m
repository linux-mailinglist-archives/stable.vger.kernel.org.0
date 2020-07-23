Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0502122B30F
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgGWP5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWP5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 11:57:14 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDBFC0619DC
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 08:57:13 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id z5so3320160pgb.6
        for <stable@vger.kernel.org>; Thu, 23 Jul 2020 08:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=vKV9OYQWtrJkGbUs5vxvcAcqG5UJTBW23uUbq/cu+VI=;
        b=UYJrwzeb0EbcekImgG0E94qotdILysqHqfbVlWY3y3U70ty+8wpVQwWMJJGSSrLAEO
         t93ZhWWl64lbDKP6xNCQm6nUEJL8XyU0FHEj+XJYLh3VFP8wj4RV/3SnvSYYe9PJ4DcC
         AT4h3Nv9WaQfeszOLdXGIJoUQHPbXdQP/+F0YKzeV82tcTDQgwsXhrD3uS3LqpzXHysv
         eDaC/K9XYdwjiRO9SBgh8ZNAn8cGQ1+QN9NNfUKd0G2lq00/he1R2NsdkiAWmiRhGB5T
         JE9U3dRevKkW9ePvK+DGsOdEn7J6pxzzEqgrEoSrbVBdJE8Kzam9L/1SWGCE7FdOMHUs
         clpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=vKV9OYQWtrJkGbUs5vxvcAcqG5UJTBW23uUbq/cu+VI=;
        b=WIaic9MfEtLNFes3qXb8JrA1GaSu7y7j06g4KVXS5J0FyChLLTNJurzkWdYQZM4qAm
         b99ZTJ+4VETLZJ4orcysLUN+a5P1Ufl/V0u/tgd/J5GRn7kcPXP5+p00GmfGjkX+Mbib
         JfMxR3xjwwI1JXjx5xr4Hte6hqbpDoN7s56M4VprIO9hdDHyBc1ZEWrBK51sAv3gyjSV
         BN85589Hxld9rcIiMAy6AAaQ4iGNraEUu0JNHlFqtDknyfOWu4MCxNgMA316M4V5Q86P
         Jldgbx7pgvXol5d9I4vdYbMofHLVVLTYzrwMrTeA0IZExb9K113tyMVoRkUbIixefGPA
         jbig==
X-Gm-Message-State: AOAM530OB1h94GNEh02Jpn7Eliyyf2eEqxrfr5iZHfZ0RqM6gvpBoe+x
        VCaqCugi0G1U0hERrCQmnPFHycRD
X-Google-Smtp-Source: ABdhPJxVoDrPxgWx3T2prOn1SW86ATqz8fTlMtKROE/yI1a7HqwFF3JHLTVC47Gnqc8BTJJtOumzkw==
X-Received: by 2002:a62:8c54:: with SMTP id m81mr4638078pfd.215.1595519833159;
        Thu, 23 Jul 2020 08:57:13 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v3sm3401073pfb.207.2020.07.23.08.57.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jul 2020 08:57:12 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Patches to apply to stable releases [7/23/2020]
Date:   Thu, 23 Jul 2020 08:57:08 -0700
Message-Id: <20200723155708.5233-1-linux@roeck-us.net>
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
Upstream commit 2aeb18835476 ("perf/core: Fix locking for children siblings group read")
  upstream: v4.13-rc2
    Fixes: ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
      in linux-4.4.y: a8dd3dfefcf5
      in linux-4.9.y: 50fe37e83e14
      upstream: v4.13-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)

Upstream commit d41f36a6464a ("spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours")
  upstream: v5.4-rc1
    Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
      in linux-4.14.y: c75e886e1270
      in linux-4.19.y: eb336b9003b1
      upstream: v5.0-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
