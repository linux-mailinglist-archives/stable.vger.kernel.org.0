Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90310611C33
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ1VJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJ1VI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:08:59 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F25C24A55F
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:08:58 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id a5so4276989qkl.6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OIZkQT7P7n2V0HK08GKYFXvjIeYfszWynbb2hBX1gaI=;
        b=hxRbxjptcuYu5UA5kc+iEKzoCp0vc1QDdW0KaskVVkFwatB+ltFXMgwD6lKE0jQ+8l
         QV+Mv4u8HMrk3hAy8Yv/cfAeq+Nm5K5CHURCVm5LmZ1Wn3yzxuN/6LNgjSi/29S1Bzz6
         fkZbJcN6vC5xTjlui1Uvl+yeXfHp7IkriTLBNaqZKXys0oSO1+vN1i7S2MP9TDqVArbR
         QHIocmpcweVBI1xEy2HhYz50T+C5CXW32WsRH2WO1xZDgwIEAOBo+n6rzHdIBQevpQkp
         tuJhm6/+0vkYpt7aiGQl2/6BXejaSwUUUyfLYFaYJrEHHSzKNDZoSWic7XyN8bY1qHYE
         QM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OIZkQT7P7n2V0HK08GKYFXvjIeYfszWynbb2hBX1gaI=;
        b=OGBuGqXYcFPOG9zJ/tgIbQiLi7KnUfnBdfdW/XwWjUIaYibsKBniXTNqPbjftiCM2l
         /P8Ztox6yhYX40sBlbvU7k0T6lqC1SHLMXDUMLkc2wwZkQqfruW+u9pCAIFEPTg0JkM3
         2Pwq3aODA2JiXNI68zZpy8azxIUOQlr4BOD59T5Dzu0XV+2dIahWA6wCm0QnMC33LzZh
         K2bCYnwkDWb1LewDESyJi/NHPuTkELgENOvYPrRCFnIPI6Wpd/5P8Qq1pcFcEHxvONBp
         ckANsWgjIsaUe8XT8G0lx8sC9l4TwEXicPay5w8dXhFxdgpMogDVBTSUBhvh0YDMPoxk
         oXew==
X-Gm-Message-State: ACrzQf0Ee+JRi6MGV9//AysFj7IFuW2ZsmS7STS+8Xfrw+IfVAvOFMEF
        76CdPh71KLlzfVEydbrsZ5BqQ5fChnA=
X-Google-Smtp-Source: AMsMyM7w8+3J+Q1moYV9y9CsYOsaAKCPTvmOZ7X4FuHzB7crTvDUBQKwhKHNXqqiMOpNP6kCbHuC/w==
X-Received: by 2002:a05:620a:408a:b0:6fa:b07:3552 with SMTP id f10-20020a05620a408a00b006fa0b073552mr974241qko.377.1666991337501;
        Fri, 28 Oct 2022 14:08:57 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fu36-20020a05622a5da400b0035cf31005e2sm2906808qtb.73.2022.10.28.14.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:08:57 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 0/6] lpfc: LTS 5.15 update to correct path split changes
Date:   Fri, 28 Oct 2022 14:08:21 -0700
Message-Id: <20221028210827.23149-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An issue was identified with lpfc in the LTS 5.15 kernel. There is an
FLOGI failure which prevents FC link bringup.

In the past several kernel releases, we have been reworking areas of
the driver to fix issues in the broader design rather than continuing
to create a patchwork on an issue-by-issue basis. This means there are
a lot of inter-related patches.

In this case, it appears that a portion of the "path split" rework was
pulled into 5.15, and the portion that wasn't picked up introduced
the error.

This patch set reverts the patches for the partial pull in.

-- james


This patch set was created via the following:

 # Revert prior partial "path split" patches
git revert 17bf429b913b 6e99860de6f4 9a570069cdbb b4543dbea84c
    c56cc7fefc31 1c5e670d6a5a

 # Then manually correct of the revert of b4543dbea84c which
   inserted a line in the revert process.


James Smart (6):
  Revert "scsi: lpfc: Resolve some cleanup issues following SLI path
    refactoring"
  Revert "scsi: lpfc: Fix element offset in
    __lpfc_sli_release_iocbq_s4()"
  Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
  Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"
  Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to
    native SLI4"
  Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"

 drivers/scsi/lpfc/lpfc.h           |  40 --
 drivers/scsi/lpfc/lpfc_bsg.c       |  50 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   8 +-
 drivers/scsi/lpfc/lpfc_els.c       | 139 ++---
 drivers/scsi/lpfc/lpfc_hw4.h       |   7 -
 drivers/scsi/lpfc/lpfc_init.c      |  13 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  34 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |   6 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  83 ++-
 drivers/scsi/lpfc/lpfc_scsi.c      | 441 ++++++++-------
 drivers/scsi/lpfc/lpfc_sli.c       | 876 ++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.h       |  26 +-
 14 files changed, 906 insertions(+), 824 deletions(-)

-- 
2.35.3

