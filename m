Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663DD5E6690
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiIVPPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiIVPPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:15:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB5D97507;
        Thu, 22 Sep 2022 08:15:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so2710720pjo.2;
        Thu, 22 Sep 2022 08:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lnuz47dK1eYqQrB9YHQb6+A8b+I/Nzs+ej6QCQpp5uY=;
        b=IxCEwUst3nir6/P+I7umvU60vzi5cKn1v8YxcAWrbC+T/3jR7FdiAMbj3ZxzvPCPsk
         Xk6LyhmfVRDuW2P47HRwiYpcRNn2m1xY2Bdsj1iq5Oh9KApeZaS49OllxoxD7Q3V+rn9
         SaNwAM0Nse9ks6JO/r2Isl3bpgVIMC5fsW8FsL7J79GQIXsU8VV/vhudcoi3Xlvv9DWm
         WVZEima05jCfHE1WlpkXdahSwvfCVm6iH2Ibe1Whb79RW02qwWmX1sD7Mi10x12Pqt/C
         zPH5U+EHSUiMV/xbly71EaLEcOGclVDCy5adZx7HxI4fKaoJ6XqIRHYnK9Vhw2H0Ih/R
         /cuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lnuz47dK1eYqQrB9YHQb6+A8b+I/Nzs+ej6QCQpp5uY=;
        b=nkrnG+RnP1BgGQ3/SxQy5JqT+4alSVUICZPqGgOP067JixlmO1plwB6h6B6tmayXwO
         byl1v9SIF+5c27oNmrumU6eySYQDfqmcHGRk1BCnpRvmWUgW8TDtdwOF5rWFVY7cdiqT
         d+IyhW/xWXJwqKY7vqoTW0lYEoNRcZIbNzU73a7yNDJMsqZR+S7f0jdoGbrnqflDI8ut
         FwKTWSbjQbmOwyEp48df8V1WgxT9xirVDSazdHy2YdqrAWJdt6Xlm1KvkZmC86wDw+Yk
         PBXFL54vlRFnCTdoOIpLISITI6Gf7U4hdZLCnjrCEFKKzsni+1iNCLhaTbxD1WYh2hln
         FHPQ==
X-Gm-Message-State: ACrzQf1CV2PIwCHyjzsczW0DNF19zTwk9y/lZ0q89+v9KPYqMXOZChOD
        vpCyideqUSowqmjIM8/2nwJqjlfl1p0=
X-Google-Smtp-Source: AMsMyM4UuTn0WARWkYIfuUfgbMtcIxecuFkmgTdOh4Cj446WoCwjj3pU+T4X5KuZsYXp3J56O5LMyQ==
X-Received: by 2002:a17:902:da8b:b0:178:3980:4597 with SMTP id j11-20020a170902da8b00b0017839804597mr3839550plx.113.1663859704961;
        Thu, 22 Sep 2022 08:15:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:500f:884a:5cc3:35d4])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b001745662d568sm4226042plx.278.2022.09.22.08.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:15:04 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 0/3] xfs stable candidate patches (part 5)
Date:   Thu, 22 Sep 2022 08:14:58 -0700
Message-Id: <20220922151501.2297190-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

These patches correspond to the last two patches from the 5.10 series
[1]. These patches were postponed for 5.10 until they were tested on
5.15. I have tested these on 5.15 (40 runs of the auto group x 4
configs).

Best,
Leah

Changes v1-> v2:
- Added Acks

[1] https://lore.kernel.org/linux-xfs/20220901054854.2449416-1-amir73il@gmail.com/


Brian Foster (1):
  xfs: fix xfs_ifree() error handling to not leak perag ref

Dave Chinner (2):
  xfs: reorder iunlink remove operation in xfs_ifree
  xfs: validate inode fork size against fork format

 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c            | 22 ++++++++++++----------
 2 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

