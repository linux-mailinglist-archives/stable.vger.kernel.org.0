Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D91DB9155
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfITOD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:03:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38191 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbfITOD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:03:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so3888071pgi.5
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aASZYhNYeoxf44qppJAJbkYQpFCqSCHD7XoU53gnIDg=;
        b=Vi/5mbHE9AgTMzsOwfTRRdks7Qp+G5WbnoOvGlluquAPu1+IuUQ5fFlLf7RLDiFGC3
         +KRkgYfx5Plk2fEQLI2lFNlwj8OyOsoiNdh7bZZJbUlVGrcQX4hmtruIAhtFrGSWWDQg
         d+GktCrtT6N/ctoeKA29lFOF1DpGEU4qGThNBBceNEidwo2TpFXHJW3oNrhS/FdATuro
         HcrcAurkCvETpT/jKHQIFtUMNYF62smyD/+/iCjaAG97MgjTMl4eC+8MMqD+Oq2hckOF
         cfG0PaoD7jGQaL7Uj/mIUHyCeC5gbGqzCUUxgnFmeBE5QbMui+aIomSlBx0tzvdO1yiv
         UlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aASZYhNYeoxf44qppJAJbkYQpFCqSCHD7XoU53gnIDg=;
        b=TBaIBOyTEEZ3CtvKMAG55Ok6mceFJqHBCBGOZ2Cw82paC7K6e6QLN0R2Vs3nPk7A4R
         giSVH9hPp65bGzHD7xZUXzPGK1F7KjxqXEQ80x3pHoo0/kk/cM+AmsJJzM7aELj3mtiP
         Mt9xmwF4C/ABqDcYFxecqLXMZPrQ2dEWHmw3TKtR9xA4kXBIL9bmoWSoa3zHaVlg1RGs
         GbZ9HXT5mfFglz5leoVmcSD7nikDGuxwwC5kI+TnhsxU7OBQW0hEvCJhSsabeBlwDkwq
         ALYmi1kx0UQSIFbooB8h6MwXdWs/OEBZrDdZGbDyGKPc0S60jALrck1FtZ6Tiv+RQtnY
         TjOA==
X-Gm-Message-State: APjAAAUpKubQrFbG9X8AboqIrj0lFvJ/OIFLoyQpVpGaGSrfeGZ8S008
        BE0WbsWBYGys2SF9Wm3rKQMglDIT
X-Google-Smtp-Source: APXvYqzEra0wrvIxieLi0DMl9KLwHlsp93oTyQZ8qV96K16J7OViram1bzlnj52bKjATcfUoQpRdSw==
X-Received: by 2002:a63:7153:: with SMTP id b19mr15184793pgn.10.1568988235742;
        Fri, 20 Sep 2019 07:03:55 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id 8sm2232180pgd.87.2019.09.20.07.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 07:03:54 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     nicholas.kazlauskas@amd.com,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 0/3] amdgpu DC fixes for stable
Date:   Fri, 20 Sep 2019 09:03:35 -0500
Message-Id: <20190920140338.3172-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This set of patches is cherry-picked from 5.4 to stable to fix:
https://bugzilla.kernel.org/show_bug.cgi?id=204181

Please apply!

Thanks,

Alex

Nicholas Kazlauskas (3):
  drm/amd/display: Allow cursor async updates for framebuffer swaps
  drm/amd/display: Skip determining update type for async updates
  drm/amd/display: Don't replace the dc_state for fast updates

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 56 ++++++++++++++-----
 1 file changed, 41 insertions(+), 15 deletions(-)

-- 
2.20.1

