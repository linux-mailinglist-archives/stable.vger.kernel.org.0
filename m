Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB54657951D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiGSISb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 04:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiGSISb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 04:18:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1EA24970
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m13so8375838edc.5
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6Uf0Dm9fe+7VSifZ9Ol7H5+Xj84H1cTaayjgqmX5aY=;
        b=GRyyiqzYsZz3gGr34FdtwUF3KHGpKrKgwXc74ZXGDpxt0YZvKWw0V8TUpZS/pc/8q8
         gbtbm/BSkgp8OZHq3cPFc+S9YiIMO2gKmM1RNHat6RNZEh1P2P8c/EDFsK9BIs1koUAG
         SNWy0135Rb3TrqbJVhGVgOUe6fURUDmq/jDgCuPy27dRrbuUgI8cDr7sR2er/HxQ9ain
         srQhkruujkhRajuAveSbNfyfewcnLNRmGdMbNQ3p6YPig+/Dapi0b1hT4QUk8zFX6NcQ
         gsewmgHhDIyoGJCGPQhZSmH8pTDvI74g6TmK3pU+cBndk6rGpfw7xi+kjaCNv8rd1DA6
         Itnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6Uf0Dm9fe+7VSifZ9Ol7H5+Xj84H1cTaayjgqmX5aY=;
        b=ijAZlYrphqJ1Te8uyz4N+k68mPqR4HXTOp4awkLOXB8y12ileMdcj3dcTo1nlYaj9t
         MPTU6JaI3Qgssr9lY3wkoR53DB8NXdG/c5fsgMjlj+lM2xFtrbNrKZflqmck3jrkdVks
         ptBQ0tXKwubSKfLdFydSmR8fb2xyms8TLsUHxvJpOJ5hib0M86syLShB+HIAUP8w3CwL
         J+3n5f6nuoPkEKt3peAjmNJ0AlFONg0sePwcLoUkpRCrLHN7rgJ10blxwisZ57GS+GPq
         n75B93NNiEW/z67wI78i/KVGZHytJaKTuvYO2KxYjrCJl3bQX3T3t/e9htRWSq4WfHkP
         NYTg==
X-Gm-Message-State: AJIora/v8ml5+DPg7Avu7acMaBhmWJ59R1uuTpFgHxBYJB4b1BEu7FbZ
        OZFO1dNJasZL9QJMQUk6LbKs/kj5eb8=
X-Google-Smtp-Source: AGRyM1tqqhwjyDDEbp+9GJfHsLjyGI+cJbbIVXNg1ZYTYVkb8eua3NKS5sMFiXlR4JNlOWh6bg2QHQ==
X-Received: by 2002:a05:6402:495:b0:43a:a211:4c86 with SMTP id k21-20020a056402049500b0043aa2114c86mr42260606edv.294.1658218706523;
        Tue, 19 Jul 2022 01:18:26 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7cb4d000000b0043a5004e714sm10008075edt.64.2022.07.19.01.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:18:25 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 5.15 0/2] Backport support for Telit FN980 v1 and FN990
Date:   Tue, 19 Jul 2022 10:18:13 +0200
Message-Id: <20220719081815.466080-1-fabio.porcedda@gmail.com>
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
these two patches are the backport for 5.15.y of the following commits:

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio

commit 77fc41204734042861210b9d05338c9b8360affb
    bus: mhi: host: pci_generic: add Telit FN990

Backported because the orinal commits don't apply because of conflicts.

Tested on version 5.15.55.

Daniele Palmas (2):
  bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
  bus: mhi: host: pci_generic: add Telit FN990

 drivers/bus/mhi/pci_generic.c | 79 +++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
2.37.1

