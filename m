Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108A7455D72
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhKROKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhKROKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:10:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4269C061570
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:34 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id iq11so5207455pjb.3
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=TaofwYvgaJyPB38QbxAucrSq9rLhTS3d5euFBuVLmec=;
        b=Wu8ERhXPMlhwhNHkW8fihatw4WQEobf7cq6qziEW4FGmdOVE0Rhopxj/dad/9Bq1rb
         Jxhlty2W+waES8V7Y7UWV9LOdBdVHlHhFHjAH+hjzBgQ2Yc+6I/mdZ+0qyJz7UwG1Zum
         aCq292XwgijjUrGFVNRcrdJnatvJxfw9/77jbFGsAolr/Oo1O2t2vodft/kwEFBI0R9e
         txNbmdDmBRjxDyLStfugx+hc14Uv8Aq/iXZktcC3r0dQSajZRNgB2wjj2fU/8QpDo4IW
         G7aGP4Gx+Ph0ZTldCWB9gLo/BSCUpgFSrQ8Gx5qHGee8S/JV60ocPFHMt3PHO1BHAQx2
         Ed0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TaofwYvgaJyPB38QbxAucrSq9rLhTS3d5euFBuVLmec=;
        b=SnHbPO+bPJUPhaOGHAjNxdlL3tIka1st8amKpMjh3XAeqPCWVYx+92PeFlbw+RmVJX
         y42kB1mEBk/QXJVhHFkA1qAa4/SezhZ51yshWRThrCkGBgUqDiWoSggJ/9Pvb3bkF21r
         YMn0XlxupzS083cL94+85L5HFjxE+BQhJE+fnILIbNb3HNkCCUfVXAioc38ln64U8XGB
         3vKvt8HfLt9XaQKY/gWI6Hf9q9qcpiD3rQvqyKSUdZ3WjE338a1VEOAnmJPIaLUHRPIB
         K0X6HZAz3twLNbE3QEOBnFG6/AbcSBt5/PSxHvIQaQ9LnGVehlI+opCK04OyiYmeLu2n
         U4Ug==
X-Gm-Message-State: AOAM5310feAJ3V0Ld6MtfoN9mSU+YsJv4MLvZh4sbUoi4oLim783EQAa
        5ppfSFs0a0G9YLDO3ivNRXw=
X-Google-Smtp-Source: ABdhPJyNYB/CQ9sCb67ChdjiB5NryAog873le2AOBOzSSWKf+W2v6yKj9MHdF8JhJQ0+H/ZpDUtooA==
X-Received: by 2002:a17:90a:d70a:: with SMTP id y10mr10965224pju.36.1637244454401;
        Thu, 18 Nov 2021 06:07:34 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id h196sm3510717pfe.216.2021.11.18.06.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 06:07:33 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH V2 0/2] scsi/ufs: Cherry-pick 2 fixes for null pointer into 5.4.y only 
Date:   Thu, 18 Nov 2021 22:07:00 +0800
Message-Id: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orson Zhai <orson.zhai@unisoc.com>

Hi Greg,

Change v1->v2:

- Remove Change-id in commit message.
- Fix build error for one struct member missing.

I am sorry for my careless about not testing for build before submitting.

-----

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

