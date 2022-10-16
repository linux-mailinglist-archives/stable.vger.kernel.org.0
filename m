Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F269600348
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJPUfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJPUfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:39 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BCF36DF0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so20862857eja.6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JtijseIF9rcDiXBG1sccQH8HeZLuOnytJzwbzy3nh+s=;
        b=YlDPXEBfvpccnJ/hqA8Eg1DGdJgWxa0/6ZbBaLn7a/brLL7JpsQ9aV2iNVKIsiR7b8
         sLIMOl32Ac7hpxPb1hlcJnt1Tw4Hj4JgdYJhcTANoVc91FkgecN/k4ttEJw2ReL1UTHt
         50eabxi1PK5dp7NNAfLht4igmUG8+CY/1F7ODrMZTE4mB+mR416cXhewpeSQOsE/Vt9k
         N2KH2MJcBDHSkytTd88dsoAN70zvGb4EoMNIshsX4yBh2EU1mFoG2ed9d3uzdUX+7X92
         NeZgT9Ut+eQHkvQmly8h3T2PYj6sHqpaHyVIRPFKhFTiOst/bHyztyolV//XQB7ZULUW
         SmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtijseIF9rcDiXBG1sccQH8HeZLuOnytJzwbzy3nh+s=;
        b=6zf9nxVKFuMBib0QygF2vGzUTK7aoDs25656LoZbNErrlXndLWb4apDags5xdRrsib
         lfRSfxFWKDD1bQtNbOGIH+jyXaIr0jF26MfCID3aWfJEXcvBXklHPTGktvXfs30qm18P
         lhhYtJU3+nMB7jJ+s74VMufigz3/gF9NqD8o7EYlklsSdwdDZxaKRAdMn6xK1jeGKEfc
         bYWltNdm2ObcyfvRXCOBIKj1aUwGXMLt2YVrXhRJfbDl03K/a754dnacr7JiLvjI0rew
         B0e5kK4eE21/99XTnniAuwHUUa605Mj8BxDAP9HZQtumskgLxFQugNOZMPxOyXLTMWrJ
         Vvcw==
X-Gm-Message-State: ACrzQf2Z+Q4RKQZFS9QTFerfQKHRyT3YgSRYBn6omJD4768WJ7iUcB41
        I1Je+Ds7HFYOzkhSx1q5XT4bntEYY6s=
X-Google-Smtp-Source: AMsMyM7d5rwf6tGtXCCbi/Ir7+1mtVxWlL0xv+k2HHmValsBF6w7i+binyGEB1geELdTCZUZ1CAdvg==
X-Received: by 2002:a17:906:5dae:b0:78e:3109:36d1 with SMTP id n14-20020a1709065dae00b0078e310936d1mr6257807ejv.470.1665952536358;
        Sun, 16 Oct 2022 13:35:36 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 0/6] io_uring 6.0 backports
Date:   Sun, 16 Oct 2022 21:33:24 +0100
Message-Id: <cover.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

io_uring patches that has failed to be applied today with their
dependencies.

Pavel Begunkov (6):
  io_uring/net: refactor io_sr_msg types
  io_uring/net: use io_sr_msg for sendzc
  io_uring/net: don't lose partial send_zc on fail
  io_uring/net: rename io_sendzc()
  io_uring/net: don't skip notifs for failed requests
  io_uring/net: fix notif cqe reordering

 io_uring/net.c   | 60 ++++++++++++++++++++++++++----------------------
 io_uring/net.h   |  7 +++---
 io_uring/opdef.c |  7 +++---
 3 files changed, 40 insertions(+), 34 deletions(-)

-- 
2.38.0

