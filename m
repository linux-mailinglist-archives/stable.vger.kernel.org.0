Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DECB60D771
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiJYW6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiJYW6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:12 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136E4C97CD
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:11 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a5so9329866qkl.6
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFv1K3Qrd4ChjdMM8tQjTHt/kk3vkV72zIf6q5bfqjU=;
        b=gzh7o14vvUeeG8XbGMLYlQIL7cJJ95ojGKaJr7GqSUq7CGv6wnV0R09WJkW23VVY7D
         +FocjccGV2bjSLiU1vBBYERow+F3YUVMUAiO2ejBavLYKr209nvXv4C+K0vaojZ/TIV3
         vC8xyGgygU3V/YyVp4sqXqxFcMMvWVR3vaMIDyl83Qhzh6tc6CN7kWASNouajy56In2o
         WF/YsoBMTvw5fX6QdcFZ0GPQ5Nkc8DqcJC676SIKK8ksigPxNFR2HhFajuiEbx0TCU8w
         l+X0fVOrC2ozrKjupNrysrshkyjruK/sc4H0tg5V1cHUOTn9++l5J9+WZxuulGLto1hr
         6XCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFv1K3Qrd4ChjdMM8tQjTHt/kk3vkV72zIf6q5bfqjU=;
        b=I2YTz4MG1xKWmsXir7lf+YH+7JwxCvP89y3s5Q4J5J0mzW3ibS3SRe0nYaFnAV6p8Q
         LCdYb5BWgiaH8kiWEiFSpX+XAK/+9jo+Ba7ixlmD3I26Fp9PhwDJ4Ul/v4wQGlICBkF5
         Ac/VbBBfUVKkui0vQFLQY93Sj/p36eixvqI9qwD5krzwGSHRWliNweK5srRe5yhvx5sq
         0F2PnOMmG9a+XluSCNJLqR7//352CSzPs+N/0c9EQQqsmtFExlfVJrOtkjcAYAu9eisC
         v8a3WLvocVVwnzZLj2LEA+TGKIfPRvkFU3f7TusOlGDtsYogk93XKjdy8uUP1h04IFNO
         DXQA==
X-Gm-Message-State: ACrzQf33o47mOtsKuOZJg+TDN2H6H5Bx0bFL6qfraoi+oj68uWGS4OcT
        onTyFeMw3z1r5lA9/gO3NFRW/Cuu/4s=
X-Google-Smtp-Source: AMsMyM7+X8wtugPYAl8TCnF8NEA/nepy6W/NudY/1QtgVonhYsCUlgVPz7nu9N2xe+YtaxhHur5DGw==
X-Received: by 2002:a05:620a:29cf:b0:6d3:2762:57e5 with SMTP id s15-20020a05620a29cf00b006d3276257e5mr28782519qkp.389.1666738690041;
        Tue, 25 Oct 2022 15:58:10 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 00/33] lpfc: LTS 5.15 update to correct path split changes
Date:   Tue, 25 Oct 2022 15:57:06 -0700
Message-Id: <20221025225739.85182-1-jsmart2021@gmail.com>
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

This patch set reverts the patches for the partial pull in, then adds
the full rework set and all known fixes. lpfc ends up in a state
somewhat close to 5.18.y

-- james


This patch set was created via the following:

 # Revert prior partial "path split" patches
git revert 17bf429b913b 6e99860de6f4 9a570069cdbb 2b5ef6430c21
      b4543dbea84c c56cc7fefc31 1c5e670d6a5a

 # Pick up full patch set for "path split"
git cherry-pick a680a9298e7b 1b64aa9eae28 561341425bcc 6831ce129f19
      cad93a089031 3bea83b68d54 3f607dcb43f1 e0367dfe90d6 9d41f08aa2eb
      351849800157 2d1928c57df6 61910d6a5243 3512ac094293 31a59f75702f
      0e082d926f59

 # Pick up atomic_inc VMID fix
git cherry-pick 0948a9c53860

 # Pick up known fixes on "path split"
git cherry-pick 7294a9bcaa7e c26bd6602e1d c2024e3b33ee cc28fac16ab7
      775266207105 84c6f99e3907 596fc8adb171 44ba9786b673 24e1f056677e
      e27f05147bff 


James Smart (33):
  Revert "scsi: lpfc: Resolve some cleanup issues following SLI path
    refactoring"
  Revert "scsi: lpfc: Fix element offset in
    __lpfc_sli_release_iocbq_s4()"
  Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
  Revert "scsi: lpfc: Remove extra atomic_inc on cmd_pending in
    queuecommand after VMID"
  Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"
  Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to
    native SLI4"
  Revert "scsi: lpfc: SLI path split: Refactor lpfc_iocbq"
  scsi: lpfc: SLI path split: Refactor lpfc_iocbq
  scsi: lpfc: SLI path split: Refactor fast and slow paths to native
    SLI4
  scsi: lpfc: SLI path split: Introduce lpfc_prep_wqe
  scsi: lpfc: SLI path split: Refactor base ELS paths and the FLOGI path
  scsi: lpfc: SLI path split: Refactor PLOGI/PRLI/ADISC/LOGO paths
  scsi: lpfc: SLI path split: Refactor the RSCN/SCR/RDF/EDC/FARPR paths
  scsi: lpfc: SLI path split: Refactor LS_ACC paths
  scsi: lpfc: SLI path split: Refactor LS_RJT paths
  scsi: lpfc: SLI path split: Refactor FDISC paths
  scsi: lpfc: SLI path split: Refactor VMID paths
  scsi: lpfc: SLI path split: Refactor misc ELS paths
  scsi: lpfc: SLI path split: Refactor CT paths
  scsi: lpfc: SLI path split: Refactor SCSI paths
  scsi: lpfc: SLI path split: Refactor Abort paths
  scsi: lpfc: SLI path split: Refactor BSG paths
  scsi: lpfc: Remove extra atomic_inc on cmd_pending in queuecommand
    after VMID
  scsi: lpfc: Fix broken SLI4 abort path
  scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
  scsi: lpfc: Remove redundant lpfc_sli_prep_wqe() call
  scsi: lpfc: Fix split code for FLOGI on FCoE
  scsi: lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
  scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
  scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()
  scsi: lpfc: Correct BDE type for XMIT_SEQ64_WQE in
    lpfc_ct_reject_event()
  scsi: lpfc: Resolve some cleanup issues following abort path
    refactoring
  scsi: lpfc: Resolve some cleanup issues following SLI path refactoring

 drivers/scsi/lpfc/lpfc.h           |   56 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |  303 ++---
 drivers/scsi/lpfc/lpfc_crtn.h      |   21 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  338 +++--
 drivers/scsi/lpfc/lpfc_els.c       | 1378 +++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   44 +-
 drivers/scsi/lpfc/lpfc_hw.h        |   14 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |   29 +
 drivers/scsi/lpfc/lpfc_nportdisc.c |   98 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |   11 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 1953 +++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.h       |    5 +-
 13 files changed, 2308 insertions(+), 1944 deletions(-)

-- 
2.35.3

