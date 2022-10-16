Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF66003F0
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 00:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPWdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 18:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJPWdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 18:33:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B38E2A25C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id q9so21316161ejd.0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cW6zCaRYCkHol4+Ow1pmvRXSsQeJEYbHgmDplNV9qt4=;
        b=Q7nMTyWVZWuHFDdgYJ+NUpwGbFy8l0KSihP5G1RrecSuFZ/OOPzaTV0NV55KBfF6UW
         9VT3j5VVeXfNcmOVLXjo4Vrq/2vCRbLZLD+WRR+SXOoEMCivCMBmU8jl6h3MZ3zedpyU
         QNkqg4fZGNAfah8DNR20uFdz6bBr7RNVAAyUKJWsPy1JIR9UBnJPjPNCDziCKiEvzClW
         9mvfDGEDVaZno4YvcW2DjqBrnBnNME1EQC2iWCn5ac8oAhxgwUvRDDlkmDQBTq0pUHwF
         sc/CGZPu2AGqhrXQMPfPyXERvRkLg+ApzlFoE2RzhkR0aCF9n4QNhc+9w2LfRkUp1dvV
         zrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cW6zCaRYCkHol4+Ow1pmvRXSsQeJEYbHgmDplNV9qt4=;
        b=agOOLSkte5+CyIpAuG61iZp4GAR4EHQpcjaIBuo8aCJK3063s2Syb6HIbSE8VpWamg
         718bV68phEKhQMoMevTPRnAZJ81DYSPh3yIkgmffqffKxRYsHaGJn3wOglXy/KPRu9gW
         QZ0CTXn68/sKGb7CuaDHt9NVqFE24zLuQ0DJBDT9SQpMVELvWtiIOldVAmpErtH2DUlF
         YNXp3xCiqoa+Go7eDu0tSj2hsOzSg0xP3CpkJ07LmZtQ3JJndLyNC63qreuZjDJXMemI
         itozlDTbDKGUQFt1fgR69VEQufmbKxalXfc/nAnnI6WrIJTnV0ATU/NA3W8pU5QXhFTZ
         BdHg==
X-Gm-Message-State: ACrzQf2QwxC/hP8AwjSYFYaBnfp7MDjUFqvXxhPWEcO3JZa869eO6vgt
        UjAsYdfITuxJ/qCv8DkTGliZajvcR+4=
X-Google-Smtp-Source: AMsMyM4chnnInMLlxhNKQSljFtlI4Tw/HDRbIXdrhJG5xdd8KsO27LqSQzva1aWcNeGDGXeE/AReIg==
X-Received: by 2002:a17:907:a068:b0:78d:cbcf:f7bc with SMTP id ia8-20020a170907a06800b0078dcbcff7bcmr6474609ejc.519.1665959623634;
        Sun, 16 Oct 2022 15:33:43 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id jt3-20020a170906dfc300b0078db5bddd9csm5193496ejc.22.2022.10.16.15.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 15:33:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.10 0/2] io_uring backports
Date:   Sun, 16 Oct 2022 23:31:24 +0100
Message-Id: <cover.1665959215.git.asml.silence@gmail.com>
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

io_uring backports for stable 5.10

Pavel Begunkov (2):
  io_uring: correct pinned_vm accounting
  io_uring/af_unix: defer registered files gc to io_uring release

 fs/io_uring.c          |  8 ++++++--
 include/linux/skbuff.h |  2 ++
 net/unix/garbage.c     | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

-- 
2.38.0

