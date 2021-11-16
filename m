Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DBF452F7C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhKPKv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhKPKvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:51:48 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D0CC061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:48:51 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y8so11576014plg.1
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ft3960Gcyu760DPw25fLOC4PWwYA5oMTpbiLIMJESzw=;
        b=m4MJCbxi0h0HeVeAXK1Ol+RCD9ZwTuUquW5M3TblBMKnTsPeDFnPp9+q7VDO/DjiVT
         2VudlZzhYbsGIEsU095e+Hh3TzCHaLAuNKyjRQkuRI8BK4cZ2dogAHVo1uIuPfxRh7U4
         SZy1UuD5GU7Lq8XvXTrQXMGbJF7yC7FC3Z2W9/Mu8MCKF5loXlU/cTnmlRQ7VbYHY9ii
         1WvJVGY0HkPXId6PGgwXgEWMSIT0SLJxUbIh/UJq/aLiIzoYwoRThaHxBE61HA+Wmo4N
         oSb3N1zCTzFavCxopYGbSDpvh5oqRddaDOdU2sY8/Db1ub4L8bWZIcpWPT1BdnAZeSG3
         oLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ft3960Gcyu760DPw25fLOC4PWwYA5oMTpbiLIMJESzw=;
        b=gLOg8QZEoPLZ6oy/L2LNoWRlrg8YkSnR2R7s5lgy+WefDZqwa3ANwDy3vgFJhahzTp
         lRq6svTo2puUD1O7jV94NekWexUJY5M+Tuv8Cegtv6EKwzRDUOnS/N9+GbbTQ5bp1x9n
         srzoWmw2ynyM8e84VlEjXLPxgJ/3917dVuKv/S/jmSZdcmI0jMhLFtx55QLTUoR5H5Fx
         Rn98L5c7zv7IbNu4AHVgvWKdNOASAwcNXli2vls58KHxqmH4+Ka2qe86GvnTR8MThIkq
         r3O6sFeHMcIuA4b6LHc5YGrMQb+frJANMtgnl3P6z+RsJ+/9XeHKIhmn7t5qbJY+9mCJ
         yQLg==
X-Gm-Message-State: AOAM533rnu1ov7ODBbAZQIOtUTI1pi5WNzdqOjTkZrf+qG7j3jMmQ9bR
        nCF96cS82m25e8G7z3AX2/Q=
X-Google-Smtp-Source: ABdhPJyQX7W3xJhuHgtNi8fTD1EA2rY0THC8BJZSSEcu1a2fiaesb/Cpk+pnFPMNhSfnpCKWKqY/kA==
X-Received: by 2002:a17:902:a717:b0:142:76bc:da69 with SMTP id w23-20020a170902a71700b0014276bcda69mr44372752plq.12.1637059731322;
        Tue, 16 Nov 2021 02:48:51 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id p2sm2024375pja.55.2021.11.16.02.48.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:48:51 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH 0/2] scsi/ufs: Cherry-pick 2 fixes for null pointer into 5.4.y only 
Date:   Tue, 16 Nov 2021 18:48:29 +0800
Message-Id: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orson Zhai <orson.zhai@unisoc.com>

Hi Greg,

Following 2 patches were merged into 5.10.y but not in 5.4.y.
We've found kernel crashes on our devices with 5.4 stable caused by missing them.

Please feel free to add them into the stable queue for 5.4.y if no issue.

Thanks,
Orson

Adrian Hunter (1):
  scsi: ufs: Fix interrupt error message for shared interrupts

Jaegeuk Kim (1):
  scsi: ufs: Fix tm request when non-fatal error happens

 drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
2.7.4

