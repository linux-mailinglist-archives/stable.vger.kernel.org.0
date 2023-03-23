Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46226C6FA7
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 18:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCWRtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 13:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCWRtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 13:49:12 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725961CAF9
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:11 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r11so4702084wrr.12
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679593749;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JC3gE3k89YUkz1ODwY5c4t7YRDvqjbQvxZDpS4x4DxI=;
        b=89vah9vb59TfF9cyq15Zx4/r6/Ldy0QLbpH5+ZP4A/x5t/Yoc7r3fYGYq1QcsQXm0W
         eder6VTpAaBsQfIha3kvEqQu3sLZC2CSIeC3KQa73arjRv3r7KzSiO9oEPnHLLfe+lyJ
         fwDqK/Vajtc5TW9qw5hgh3yQmGO2gmbAK3bqL/wj5KG+4AbQKMl2rikhEzQoqeRQRqTE
         cyM3IBErTqnKTQzPKH+S89ebUaPyrz8kzXlvvrJLyXTKcYZ7D07riPXGgj9Z4JfiZxLq
         PaMAYYk29DASJ6t30s0MiDeyGoCisW18iPGJYHgsOPJu8fM43FlMw2UrSC0CIIXBtIit
         EV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593749;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JC3gE3k89YUkz1ODwY5c4t7YRDvqjbQvxZDpS4x4DxI=;
        b=rzHKswU6TetlKx119bm72iJbI8vKbEDh35yeeRKOsvoiji+rxWF0pS3ZVWt/TrRfw7
         fX4/YawQIXJWTLYM0zdb4R900ob6cZivHC6FULzJGzyltt0P8Pge8Zqgf2MbJtB3kjVz
         a4huqFFEYMx/fmHDUCXl5GIuzrKXrKC2CdEeUPdl+DQfa7147nr/o5zEwQpCWaEF5lF3
         gfW5Um9a59z5uv26KZ4MA3gBQuLkMtQx2/3u1vdIy1z4DQNNMJh+J1Mi+7CXmbm/8dK6
         IhtOZBg449Mrq0QL3bTGS8Y6d2LjTKRGD99FOwXZqi9gktAYzrcCW13Ul5TA9HQiX0j0
         r01g==
X-Gm-Message-State: AAQBX9dtBK/dTfe2TWgqfe6CDbRspYd9dMbc05pfFGTXSCpAK8AXXXNm
        G96J7EFiRp39Cyuz702phPQmcpr/6Ib1VLXTHzXhxl79
X-Google-Smtp-Source: AKy350bukyE6YmXw7xIntCcEgO6szDeF6XfQ/IzN4OvVLSE7eYzBN3sbCJ2yZzpqDF1t95zTYTAKBQ==
X-Received: by 2002:a05:6000:1206:b0:2ce:a8e9:bb3d with SMTP id e6-20020a056000120600b002cea8e9bb3dmr67364wrx.4.1679593749629;
        Thu, 23 Mar 2023 10:49:09 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id a10-20020a056000050a00b002d78a96cf5fsm9534483wrf.70.2023.03.23.10.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:49:09 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 6.1 0/2] mptcp: Stable backports for v6.1
Date:   Thu, 23 Mar 2023 18:49:00 +0100
Message-Id: <20230323-upstream-stable-conflicts-6-1-v1-0-ef2a6180eaf3@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAyRHGQC/y2O2wrCMBBEf6Xss2tzgVL9FfFhk25toKY1m4hQ+
 u824uMZZg6zgXAKLHBtNkj8DhKWeIA+NeAnig/GMBwMRhmrrLFYVsmJ6YmSyc2MfonjHHwW7FA
 jK0eken3p7QCHw5EwukTRT9Xy3yTfvgoXbruzrq018Rg+vxc3qNl937/6LvOxmgAAAA==
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Jakub Kicinski <kuba@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1314;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=mTUbtQFbSzKc7Z2lCN06pjWm+Zk3etxWiVsL3NBzy2U=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHJEUugWJ4BPzvj+zJKw59egyGDMFOp20gcIXa
 QFFGpK2Z1KJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZByRFAAKCRD2t4JPQmmg
 c09UD/4lpaTrpwRC3geXLV+qh21lhrrwk2/PCcB582zanS/knO4tS5Fc10VPxdSY8usapmEX821
 oKzMadc7Fd1FU7sFbLzP8L1FbDX6yAVi1fr8sPsWDxzXN+ppikbIR515aGkOZJMM/Dk2n9IrqyE
 xBAJ8Ob7I0mlnznEgJ9Mhylbbxsguq0vFrGnvaIy9kmyYq2TU1o2ybRWYWkVCXpzd5ehlGrv+hT
 mjuTOr461bXlSfFe0rblBv4yiSbGhE+7DlHwN+k0gz4m4MFVUiuOMa1JlO/NOFDjMeCiHasD1gW
 zwsyJ32p9ZjqFcQ1m7Hl/++mm8uptjEIURZ61B12C6Qm7wLoHRAji5Nh1soGgJ0ImhmtrJG1quG
 yK3HDieh/JdYgYZTM67WWMYPEMU4QnAiLXuXH4ZBC2PXYUQMUOJehfgeIY+1dl2YBfoLT7n3BrT
 YEAve3XD5w3D5lzO02qm54hjIFdOaHU9IAsNU+77E9wAfVHptd2Ctbt7mVOFLqeZa+hSgvEun0s
 NZ0Le9wvvUyOoOovXruiX/0em+tBwYOP72nAwPBmyQoL7SMIudZAgAp7SDSIUrmhUmfxw6K+ihP
 QuWrktEwdpklmVi5k/RzNbA5khDfFkhNMjCQxfONWM6Ph3f7WtOncsxgi/lKDzWaD3YtzTdzJiD
 iV/IyXDrHcIG9fQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Recently, 3 patches related to MPTCP have not been backported due to
conflicts:

 - 3a236aef280e ("mptcp: refactor passive socket initialization")
 - b6985b9b8295 ("mptcp: use the workqueue to destroy unaccepted sockets")
 - 0a3f4f1f9c27 ("mptcp: fix UaF in listener shutdown")

Yesterday, Sasha has resolved the conflicts for the first one and he has
already added this one to v6.1.

In fact, this first patch is a requirement for the two others.

I then here resolved the conflicts for the two other patches, documented
that in each patch and ran our tests suite. Everything seems OK.

Do you mind adding these two patches to v6.1 queue as well if you don't
mind?

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Paolo Abeni (2):
      mptcp: use the workqueue to destroy unaccepted sockets
      mptcp: fix UaF in listener shutdown

 net/mptcp/protocol.c | 46 ++++++++++++++++++---------
 net/mptcp/protocol.h |  6 ++--
 net/mptcp/subflow.c  | 89 +++++++---------------------------------------------
 3 files changed, 47 insertions(+), 94 deletions(-)
---
base-commit: 0866b93e23cb1d66eb4b105d305cdb185ca17b7d
change-id: 20230323-upstream-stable-conflicts-6-1-e0baa081983d

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

