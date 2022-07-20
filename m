Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634D457B0A1
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiGTF7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGTF7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:59:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09601558DA
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:29 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x91so22442300ede.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3m/4PtSTOPdjYMb7u2uCmXV4+/QmSZCN6ab07aD8YLQ=;
        b=ShkFSfie7h5lw+Pl5xJAs4g9PDNs9Ec0a89fIiXDkxH+V/fSoY6+6R3Z77HkaElBK+
         ErqCy5zS0uNVr6waHeKvf0f+MEPHdz7WIbUTSm0ukGmKXATwzNmb6bSbAYZweg9Cja3M
         wzPAvJqQS4jXd6tTAzY4NOgeIbb2f7KWlU8LSDHPaWwin+h1WUrGow0LIhyn7JmtBoEr
         MFQhtz7TQDBqEVBYA/GCmcYQ1JqdtzR/tEm88q1nDt+5U/5vVOdpNwHHPydMxozeT1IM
         aKUvh2mnwwJZC6xOGdZzdZXa8w/WG0ba7/FIfc5iSUfINgXa/qxjnskbSqEisYMBn2NG
         PO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3m/4PtSTOPdjYMb7u2uCmXV4+/QmSZCN6ab07aD8YLQ=;
        b=5uSJwCDWBdPTrjDhBM3wbiO5GQxVvhvx761Di/VxCDsDekyc6BWIiMnpaz/yBvLZjS
         mtcVrqX75CD+hoqUefOOfB1Aw3Db/18MEdr/H3ocea+asMtcXGv4IeYqSMTlGhlHRcPx
         PuJM/73z/FUsc848J5t4FK5iu2Bn3Wt7tsmBPLFYyW3u9r51iyVuvDQm6CuC/tdj8vUs
         UZ2Lg/eky+62mnahuI8Sdcru4eafw1e5PUOzdKylPFw7TQjmkSjQxzH+gIzdtXw9iO50
         hl/I/DUmNYYGxiv0i2viydrkZMjWrkG9oBQgUF4pfU36stZKrxxeJe7VDy1bn3HOWZxq
         6NsQ==
X-Gm-Message-State: AJIora/xEKFODDpRahm+hF10zdwu1+gceUPvlUKQorSQmsLdWmVqw56K
        TU9LAjb5Yp1h/e8R1XxeEJhAgX+t8jQ=
X-Google-Smtp-Source: AGRyM1ump1naaUfG4LmNx10gAqiIi6ASM4vMflPTnvicG5RdpFcCoQSOuh4uoVLuQwSREiupFO9c9w==
X-Received: by 2002:a05:6402:3708:b0:433:2d3b:ed5 with SMTP id ek8-20020a056402370800b004332d3b0ed5mr48126390edb.246.1658296767145;
        Tue, 19 Jul 2022 22:59:27 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id u2-20020aa7db82000000b0043a253973aasm11556666edt.10.2022.07.19.22.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:59:26 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v4 5.18 0/2] Backport support for Telit FN980 v1 and FN990
Date:   Wed, 20 Jul 2022 07:59:22 +0200
Message-Id: <20220720055924.543750-1-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
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

Hi,
these two patches are the backport for 5.18.y of the following commits:

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio

commit 77fc41204734042861210b9d05338c9b8360affb
    bus: mhi: host: pci_generic: add Telit FN990

The cherry-pick of the original commits don't apply because the commit
89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
on the PID, 2022-04-11) was not cherry-picked. Another solution is to
cherry-pick those three commits all togheter.

Thanks!

v4:
- rebased to 5.18.12
v3:
- fixed typo in the cover letter 3.18.y -> 5.18.y
v2:
- fixed my email

Daniele Palmas (2):
  bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
  bus: mhi: host: pci_generic: add Telit FN990

 drivers/bus/mhi/host/pci_generic.c | 79 ++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
2.37.1

