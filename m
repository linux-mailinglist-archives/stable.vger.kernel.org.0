Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A92F3D97
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437117AbhALVhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437147AbhALVVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 16:21:52 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E9FC061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id n16so2485311wmc.0
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHqWPTbAjwKRhfVrB1+QYO52mFQh0zZVRCxM57T7AMc=;
        b=lH4XC4hwgizevwUrkwGJsSt067R0rgKjB6zn3qhTQyvQ7MkRzY/mpOYxmVRpJEnD6a
         O21ygp85lSUzuU5Xsf4Jyh07K6f+MZzohQSE3MFExRTGut5Io/7j3R9Tvnp20gFYSaJ8
         72+vyoBlAv+9S1vIy/Sf8tHP+ewzZ0YCFqw5f0o24dEEw3bYTd8ye8M9JGAemovVsBry
         7uCEiwT/bjGBsVpu4RJSQvbEnv3vL+X6h8NpHXf0u4GccAASsprMEL1LtnTApOpGW0Uh
         vxC4p5arGp8JRwB8RtS4W/rJFoJbodbZexCRr8wqK2fnlu/lbi2nLtjMmW1QGyY/Fzif
         YBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHqWPTbAjwKRhfVrB1+QYO52mFQh0zZVRCxM57T7AMc=;
        b=D20iWBe3BdtbUkKSQX5sB3yAnAQyRTqDYH8JR7rKQSFtWYgiejzbik6Ku/2ct7U2/E
         NgVFwm29ILKVJz5iAVL2zKURyLx3IEYVSlepGqTOhDWm6SBWQQjdAfCyqLPJcxqODie1
         1ClmSRBUb3N/Q6QGVOHhGDgA8RFYbHUpjh+YIy12gug+jFcV8YYF97z9KJyPLzUV6xzY
         g8cXAueoEgArt6lllCv5Oe/5xb+S+c0N8OFTf6+QE3ytbRnsJmsPGItXwd3RWNdvf2Yp
         CHiXXAESH927gy+F1pugZ1YI1QFbyTo7LzyKIrZdeZ+cMR0EheIRQlaTksTTcP4HMRPR
         r+Gg==
X-Gm-Message-State: AOAM531zns/uNwR7L+LdJDNCEIJVklvVkaQPJ2rqni2pQi1UtfqCqYya
        wSc4xmUrrzGd2/GexBXkxjMdGW7DA1tKig==
X-Google-Smtp-Source: ABdhPJxmBXa5B3gyEfshE8FfZogm76KD7LVn+mUK3IAMh4TbK7vAqe8qlwS6NGm2QOwthtI04Z4yVQ==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr969805wmf.173.1610486470303;
        Tue, 12 Jan 2021 13:21:10 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id y13sm7166093wrl.63.2021.01.12.13.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:21:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10-stable 0/3] backports for 5.10
Date:   Tue, 12 Jan 2021 21:17:23 +0000
Message-Id: <cover.1610485688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.10-stable, 2/3 is a dependency, the other two failed to apply.

Pavel Begunkov (3):
  io_uring: synchronise IOPOLL on task_submit fail
  io_uring: limit {io|sq}poll submit locking scope
  io_uring: patch up IOPOLL overflow_flush sync

 fs/io_uring.c | 88 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

-- 
2.24.0

