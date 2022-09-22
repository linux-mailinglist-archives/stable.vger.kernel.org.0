Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B985E6780
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIVPrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiIVPrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:47:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BA5D58BC;
        Thu, 22 Sep 2022 08:47:36 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c11so16171038wrp.11;
        Thu, 22 Sep 2022 08:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=UYXRye64GfI8JuQepi0CogOynp4VVQTGOWPwuZU4C4Q=;
        b=VPaL+A7u1WrdrZXyoSI1oGVQfREnPAb4TDXu+2XQ2nI93tMdmdL5FlYMPLtFTBYI1C
         Cep+U1Sohks16xTvpxcDA0gZdwrW/GogH9UIBH1V2BI46Mme9WothP7RxWAW/SR/IPbV
         l/AsEnlNOGe59LNTIqlFVEDWpF90m4iZO7CKQDGPLp5nBW2WmcdLTqxm1L0cgzdb5+lf
         vdWaWBWSIAp9ybl627l+LVfaJg8MPEZh0f5IFVFU8WRsnqCUcRE4AvVj0h5z6r3cBCqR
         VsbbSQPekISb8jTB2BG6nOyTOS0e0HhVfcJ7JYqiRxiQ4w2K8kEDwI2Kj9JZUo8ZJOmf
         PyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=UYXRye64GfI8JuQepi0CogOynp4VVQTGOWPwuZU4C4Q=;
        b=5VF6BEJ4XCUQ2qqTtudk+uIlQPZizBnFau9moTv+S5mgQYW05o2Ozmb0xHNZOLm4hq
         rRFGlu+lDGNb+u6GC45CeoPrL3Q9Y8Nx1pXsh4YcEBttBE69aIcJN9pj0PpVMXJrTabF
         e0+JllQR4DPMQyKJ6HW12DcWqvVSg7lL6bxWE8khtvu9mmeM1vmlHGjBI+u0dcGKhr9O
         wJWu+eMxLQ6rYcRd01X0RfmwP1XtNTA3987YjE7GqvnDJ+Uoq6up3mhBq8J2Rk5hTIgU
         qaxHK7fgP9J2JWCzU2VomdkQWB1iEpcPvOESZTKEcgSVdvm26DKvURvttf7qvBP5bDhg
         j0uA==
X-Gm-Message-State: ACrzQf2ihbHI5I1uzjbe608+f2lU4cTTckWDShLGyM119v74mbPgzgYT
        vQUKl1yr6t/2601j0wHnTGv9yMWReoc=
X-Google-Smtp-Source: AMsMyM4WYj4g7CiULRqYgelItrcYl0B4CvqL7lprJ2+qxm+t9IBvizYy3xH1qUaV246SkXRROEXyaQ==
X-Received: by 2002:a05:6000:2c5:b0:22b:c77:7690 with SMTP id o5-20020a05600002c500b0022b0c777690mr2504835wry.563.1663861654865;
        Thu, 22 Sep 2022 08:47:34 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6405000000b0022af9555669sm6272386wru.99.2022.09.22.08.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:47:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] re-send two xfs stable patches for 5.10.y (from v5.18+)
Date:   Thu, 22 Sep 2022 18:47:26 +0300
Message-Id: <20220922154728.97402-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
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

These are the two patches that you asked me [1] to defer until they
are posted to 5.15.y.

Now that Leah has posted them for 5.15.y [2], please apply them also
to 5.10.y.

Note that Leah has an extra patch in her 5.15.y series:
"xfs: fix xfs_ifree() error handling to not leak perag ref"
This fix does not apply and is not relevant to 5.10.y.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/YxCulVd4dESBjCUM@kroah.com/
[2] https://lore.kernel.org/linux-xfs/20220922151501.2297190-1-leah.rumancik@gmail.com/

Dave Chinner (2):
  xfs: reorder iunlink remove operation in xfs_ifree
  xfs: validate inode fork size against fork format

 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c            | 22 ++++++++++++----------
 2 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.25.1

