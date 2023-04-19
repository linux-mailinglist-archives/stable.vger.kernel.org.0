Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95C06E76DC
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjDSJze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjDSJzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:55:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180212103;
        Wed, 19 Apr 2023 02:55:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a80d827179so9678295ad.3;
        Wed, 19 Apr 2023 02:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681898126; x=1684490126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ffKlKly5QKfpKhWLaKvyu4GfbNjJqB/t08GzRyEnvUk=;
        b=OD1mBGSQM9WVdabrl08ILt3L1rjaIL5hkNCdoqysWUQM7uFR/fOSFL3PtKef3jd7Xb
         72sfLvj2JCoF3Av13WedZZGoDNqmrmXkbNXdSyM05Yyjs2UQ4slyZlHeeZr+2IRVQibY
         RoN4adlHi4+qGaJWijCimsnWTfjwdjD95nfsCJB6o/XlTtvNQtz3sBKGIgnuXctRG+o6
         SpF3/9Wqf4gRxKQl+FY9k+C1NnVVOzWSPcPS2rrAelGwpGO8yN86xe7xZp2vFbtJ64U6
         1YBUyGyUDKSLoShbBKhBnMpskffc9KbI+qwrPiTx+l7CPGKopFKS6REeUw62o7IdFGJ6
         qxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898126; x=1684490126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffKlKly5QKfpKhWLaKvyu4GfbNjJqB/t08GzRyEnvUk=;
        b=ka+64b8ZY4Wf9Hd8Q/r8K8Orpkh69DrqMnzQxVVqfZwBbbrVBgBDEZyIM8xyiHCDK8
         nX+cp2EYBEW/1/KByAOS3uKVPr0n4Lx5hw/SI6jtD/zPEP9mtLzv0DP0gREG5wZXQoHj
         LLgyYWv7NEZKI1fwaEPF8uSx5p3jOrDACRHsa+HUnutS2qx596rcMc94hPo4nH9HDLJu
         K4S/WEnOO8XcQMtoZvSACXpB+QD3YfNxoE8R/KrnORQLX6mVcRY1uyXJF5CA5cZelns/
         0QU8/RML46+ENmOn9jiQSM9B7dyk33KLRHE5l3O8ZvX2ihmMTSlcEnvaYIegnX7ydpBv
         6Dlw==
X-Gm-Message-State: AAQBX9dxtRHydDVaILWy6ah6B+icuZPh39p+7dEsadmpibf9K3t6qmn4
        HunEFYNqluVSgP9HkgUTtFdytfksUeWnSB3o
X-Google-Smtp-Source: AKy350bLkp3CoOtt91Imc2XhzmLkSfKMoYsu9cJ3NDUe++VPJXJoC4h9Sas3241O20yonuIqwPfDaw==
X-Received: by 2002:a17:902:db06:b0:1a1:cf70:33c0 with SMTP id m6-20020a170902db0600b001a1cf7033c0mr5451423plx.33.1681898126352;
        Wed, 19 Apr 2023 02:55:26 -0700 (PDT)
Received: from localhost.localdomain ([120.26.165.80])
        by smtp.gmail.com with ESMTPSA id jm16-20020a17090304d000b001a69c759af3sm9195428plb.35.2023.04.19.02.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:55:25 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 0/1] Backport several fuse patches for 6.1.y
Date:   Wed, 19 Apr 2023 17:55:16 +0800
Message-Id: <20230419095518.51373-1-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Antgroup is using 5.10.y in product environment, we found several patches are
missing in 5.10.y tree. These patches are needed for us. So we backported them
to 5.10.y. Also backport to 5.15.y and 6.1.y to prevent regression.

Jiachen Zhang (1):
  fuse: always revalidate rename target dentry

 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.40.0

