Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9A3F03C7
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbhHRMe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 08:34:57 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43688
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234801AbhHRMe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 08:34:56 -0400
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id EE0AC4066A
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629290059;
        bh=S8eDiEj2nwrC8DuFEnxxDF01z2qJAlaJD7z8K74fm/c=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=F6l8K2v1LWEzymKPbLtRxRZtQQ5wSf8zG8Ih7mNhIRQ01cDhIXnn/+4xPlXMmO393
         0ZlCfyN/PQfs2dttZtT3RKuPuzWS+287xYERqYjTZ/R8iUwtYVRToG4t2xYTsQAOvc
         qc8Ri6FaERchGwXTMPkQy81K1dRJ86Df6PsSMBEY7VrIIYA3B7TF68BNpprwoDWPSB
         zrZLN2NK+RZ1zqcDpa4Epb6AM8q0GGDI0AR+rWVXbyghWFJMbK+zpRUfMZTBpqzPDL
         TQvei+vB8Ue6fDoNyBbsCxSJWJzZ9SdlPSz9cVSdHAACrL57uU/EQwS6gDvJmRUD74
         UMbTSoU4PdQfA==
Received: by mail-pg1-f199.google.com with SMTP id d1-20020a630e010000b029023afa459291so1346071pgl.11
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 05:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S8eDiEj2nwrC8DuFEnxxDF01z2qJAlaJD7z8K74fm/c=;
        b=UpYPZ9rWX+CwAJcBxR4YEClEap2vC3uUZbgVPS/LQZmmn0hgHVsZXxqqCx9nlclqZk
         UPEXpk+otQl+qA/QDaun6QUpCKkDyP2Q0dAtAKnu+G1Jf9L8Oa6hIX7v5TNwSKcxt11v
         1sZJu82OWu9jzDobT4hWKsIIUv8zLTRTYBOoN2scqHnDKCZBJy02yq+PG7YjwnR3reuN
         5JozZEKU2iVy6BmQT3g9inx8DUVUUpcA7qhlxyvm3fez9p/eJWiYnNuqp6zF30D6V9+i
         oW1GLWm41ejR3mQLh7iyjDUKxEurodjAdz+66BmT8KAmvV4VXa+NlzhWMPduBQ7/H0WV
         lTvg==
X-Gm-Message-State: AOAM531HaH8BD1qHMO8lEAG6Z0hJpQbCwe+DHt20oTmWCIFtvtmfERRV
        f1163MZxaxLwHoJShrZcemgWiBwG/XQMuP2QAcwcavq+5tbj07J8WktNRGrvQb5QKU2CA9Nuog5
        M5nPTcNXMXdXZiIw1x5JByDdMIcYN/Zjfrg==
X-Received: by 2002:a63:2f04:: with SMTP id v4mr8665369pgv.380.1629290056845;
        Wed, 18 Aug 2021 05:34:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8bV1GnDGMVm67ms6g2tN6K3y/M9+dPjPAeSAwU50ia7nR93WraGKvOlVZdmFUfRowoc3TtA==
X-Received: by 2002:a63:2f04:: with SMTP id v4mr8665357pgv.380.1629290056629;
        Wed, 18 Aug 2021 05:34:16 -0700 (PDT)
Received: from localhost ([2a01:4b00:85fd:d700:1397:609:e787:2244])
        by smtp.gmail.com with ESMTPSA id o9sm6726025pfh.217.2021.08.18.05.34.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:34:16 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10.y 0/2] disable ftrace of sbi functions
Date:   Wed, 18 Aug 2021 13:34:04 +0100
Message-Id: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One cannot ftrace functions used to setup ftrace. Doing so leads to a
racy kernel panic as observed by users on SiFive HiFive Unmatched
boards with Ubuntu kernels.

This has been debugged and fixed in v5.12 kernels by ensuring that all
sbi functions are excluded from ftrace.

Link: https://forums.sifive.com/t/u-boot-says-unhandled-exception-illegal-instruction/4898/12
BugLink: https://bugs.launchpad.net/bugs/1934548

Guo Ren (2):
  riscv: Fixup wrong ftrace remove cflag
  riscv: Fixup patch_text panic in ftrace

 arch/riscv/kernel/Makefile | 5 +++--
 arch/riscv/mm/Makefile     | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.30.2

