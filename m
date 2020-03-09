Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A9417DD41
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 11:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgCIKRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 06:17:42 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:37696 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIKRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 06:17:42 -0400
Received: by mail-ed1-f52.google.com with SMTP id b23so3313570edx.4
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 03:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:subject:date:message-id;
        bh=w7g2UQ1IoZWReK4yhbTGN3+82pf5ptnjaBfAxPkSx5E=;
        b=SUpFHANoHs8Fez/dlmaztbomKEWOd/xcOrqTxm7sezB1pRs1tnGgk4evj9Ysyh039W
         GLB5Ebmhwn6HoKjMFyrGUbRnD1+ML+ugCiDe9CRmXP1qPZctnOqFTZ6Zyk1cs76ubUbt
         fU8HbXMRmGOF6i48jT40VZgA/Xf1Vq6XKAQY5LpKF7aYnyVw3LsSvBgqXals4g6VyWlH
         4+Ow81aTj2SjZGKPnek3d2IiwetKNMd3jcFxeRHPcxWBoCtmj9HeP32Sk2LdxY8rFxR9
         xNOG5Qmb+6mqo/HgSh2Cd40RKH+3s00xIAYB1Qv+DZBMNf7xXh6iTe1akPuiXMKkXpcL
         tFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=w7g2UQ1IoZWReK4yhbTGN3+82pf5ptnjaBfAxPkSx5E=;
        b=BkJQoiOECE7SbW8pJ6jtBSs+1cSZULF3TWJ4gLa70cHFk22heS4saWgtoxYvTFwn2V
         nRIpk27XI88rLbH+k4BV3We/32SG338rsLim2VLaKZOGUF2fxgY2O+InzqN5KC/VjMLq
         Ux1pQakomVn3fWHZc99drcQGipzVSWRr7hB+m9aHbR7gKgRTEi1LUbfbiO6vaX/Wk75m
         tU38oxJUE7PDGciNWvumER/0xkZ377iajTPIjWaCR0rOgEcVdTALLEfhtOFJdkEsb32a
         IZuqH0RdwjGqigQIXOcRIPiI1lp1Bllu8QjnC6XDEvJ/F2BN16JH0+HeeoBu8ew7NrT/
         eUHQ==
X-Gm-Message-State: ANhLgQ3C6R3qF4GMH4EUkp6pBifmRNk0WE4vLRNQ6rW4wANp3OLaPd12
        UbmFU3/afM4UXCA9xpGKGoSr8ORLXdM=
X-Google-Smtp-Source: ADFU+vtCVsKnAtSwZFAXuVwH29RTDhM+vhBTlVmHGYWocgRmgM8rr/Rwn7ms/vRP2oTFNaXF2XhDPQ==
X-Received: by 2002:aa7:d719:: with SMTP id t25mr16406669edq.387.1583749060723;
        Mon, 09 Mar 2020 03:17:40 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:1934:edf1:9b2c:8a6c])
        by smtp.gmail.com with ESMTPSA id p20sm1317409ejf.6.2020.03.09.03.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:17:40 -0700 (PDT)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [stable-4.19 0/2] 2 stable fix for pm80xx
Date:   Mon,  9 Mar 2020 11:17:37 +0100
Message-Id: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha,

Please consider to apply both fixes to stable 4.19 tree.

Both apply cleanly to 4.19 stable queue.

Deepak Ukey (1):
  scsi: pm80xx: Fixed kernel panic during error recovery for SATA drive

Viswas G (1):
  scsi: pm80xx: panic on ncq error cleaning up the read log.

 drivers/scsi/pm8001/pm8001_sas.c | 6 +++++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 drivers/scsi/pm8001/pm80xx_hwi.h | 2 ++
 3 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.17.1

