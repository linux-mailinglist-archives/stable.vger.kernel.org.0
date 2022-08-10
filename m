Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427FD58EE04
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiHJOQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiHJOQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:16:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515475FAFD;
        Wed, 10 Aug 2022 07:15:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l22so17921934wrz.7;
        Wed, 10 Aug 2022 07:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=GeL+f7XYO6dVXckChFbfdawpRq2rGnmcTAN2AJwukas=;
        b=mhsl8rxKS/hPkJPaK0ufs9Ol3vgVrgANZWMcU9RKoaF3nCwpMeIXxQGgIIc/R3TGC2
         cElRVtSUPOD0jfpX4SZEiT91n2Q2L2bPsWMvWssKAsCP6VDg9BVcRY/coY1LrHqlQSvn
         0/Q4AZVhIZSAhBZtBzwTXlVwHr9NpQbRYvRx23Qsf4kUvZgeBCIXftplTcQmLxFHV936
         MjwlIH3X/HEf8rImBt4D+L5i25zZSW146pnpvueIeCdTfz19OaiM6TfTeGZl31hdR7Il
         kvU7g8hdMcW0J260xNZAm0Bo1Ls2BHgSvOr5jR3lodqSCR1LYZRtrHhwD6S6hE0SakkF
         Om2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=GeL+f7XYO6dVXckChFbfdawpRq2rGnmcTAN2AJwukas=;
        b=YQXYxTnbUUE+5so5DeY0kmOw33XgwWFiKJeIZj4ALjk2+Wq1+S1exUf6CWKCNZgDNS
         VsEEwH5MpMhSkH2BTmC/enqOmS3qUo3LQS213tm+JfCE0v/vlo4Oi32m79QFNab3cHmg
         EcWLcclnwqq8JmsGj13TCSz3EfUh/gJgZYcQJJ+0bVsjpl5I0N4xGPIiqWAXwiz/TzlC
         5KIPQamKjzwkHniXvpK57t/T8d7PHqNk9EdBU4TklRoprH3nYvCtIP7AWB8yYuWYuLM2
         N5KWn1FFTCSCNkJr16NeKOViD4Eiu90rflZf3MDEjWdOXw3U2+Qyx4bu5FW5R5Y0oeGV
         GiEQ==
X-Gm-Message-State: ACgBeo0wtLq6Pl/An/avzR8zSZTrJNfnelFm6IC4fXtU+r9OdJ31+CBQ
        fITfBqelL9FoPNEkfUrybeU=
X-Google-Smtp-Source: AA6agR4J2kze8hWh0omi+vEpw0r/ylG91MSTEseiWbt6Wzu/w/bejrJwOW80tqZI+Z7RCBW7c2Uwjg==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr17735104wrr.472.1660140957744;
        Wed, 10 Aug 2022 07:15:57 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id x13-20020adfdccd000000b0021d65675583sm16902969wrm.52.2022.08.10.07.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:15:57 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 v2 0/3] xfs stable patches for 5.10.y (from v5.15)
Date:   Wed, 10 Aug 2022 16:15:49 +0200
Message-Id: <20220810141552.168763-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This backport series contains small fixes from v5.15 release.

From this point on, 5.10.y xfs can follow and pick changes
posted to 5.15.y.

I already have some debt of fixes from v5.17 already applied to
5.15.y, but not yet submitted to 5.10.y - those will be included
in my next batch.

Thanks,
Amir.

Changes from [v1]:
- Drop backport that disallows disabling of quota accounting
  on a mounted xfs (Darrick)
- Added Acked-by Darrick
- CC stable

[v1] https://lore.kernel.org/linux-xfs/20220809111708.92768-1-amir73il@gmail.com/

Darrick J. Wong (1):
  xfs: only set IOMAP_F_SHARED when providing a srcmap to a write

Dave Chinner (2):
  mm: Add kvrealloc()
  xfs: fix I_DONTCACHE

 fs/xfs/xfs_icache.c      |  3 ++-
 fs/xfs/xfs_iomap.c       |  8 ++++----
 fs/xfs/xfs_iops.c        |  2 +-
 fs/xfs/xfs_log_recover.c |  4 +++-
 include/linux/mm.h       |  2 ++
 mm/util.c                | 15 +++++++++++++++
 6 files changed, 27 insertions(+), 7 deletions(-)

-- 
2.25.1

