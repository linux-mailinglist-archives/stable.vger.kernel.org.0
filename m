Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88395291FBF
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgJRURC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgJRURC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 16:17:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AB8C061755
        for <stable@vger.kernel.org>; Sun, 18 Oct 2020 13:17:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id j8so4397918pjy.5
        for <stable@vger.kernel.org>; Sun, 18 Oct 2020 13:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCahzXhRp0T35kK4yYVBbfx2/6V7LwCq+Y8reDypZ9E=;
        b=HItaadbbAOjIYm4N4oT/VkrcCSWKuP6hpPdsMBWDMXKfoB2JQAfCfd4nmt/JPB9TEI
         MpnQVCOgrUfQQ36KbjGG0kEzANsMmnC+I7sDgOgzz+cYifq/OJN4RMFoJnSdVKCzCTzx
         /4ISFVRIwgx+tt4m69YcqWixP9VRiqHl28xYAeMLHpl60lkl37AoZ+teav9u3vtq8k5n
         doPb11CKmyPJxX9+/cyOqASuI7HbVjGawwgDJZHRB3eCgHvxFZW+9TjAPpSvY+MHrZGM
         wRNTBHO/rLlDlqRmyEBClWLpTmPFZjXuPtv0Dacd9FeqzPMqVtKMPWXwFJ8AMIyxz56B
         XKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lCahzXhRp0T35kK4yYVBbfx2/6V7LwCq+Y8reDypZ9E=;
        b=Dt/g5TQ5zkxtjFxhBSuC/5wmsZBj6hpwV8ccvhPfQPv+U+k9Gbtyn7QjUtz7m0f/La
         QXQfD+7IjcLH18RoQfmUsRF8GxmNh38xru9pLetlPmxylkyMQLhomNcFionOiLG6s4M1
         /fbX98QKsOl0rJ6v/6MJpqfQ4+uqHLbmq3xKa68AAOuF8MOiEcHt4Vykg6dKci83uGdg
         9neroBJrMfPmOb9SDHsqxYK/dxG+uh4ZBKcry4QauXCyxIXm6eQflrVD4t3ssTw9YnCa
         LJxmjyf/leXJTIJu4jZb0dvVX03W3694BIuvDSXHUCSD1XC3Xm0s2DSRrjDd3iJTGwVH
         Wxzw==
X-Gm-Message-State: AOAM533wtyYrHlHTo4hM3Gk4AkSxJMKs8uUznEmfNJurfyD+gVlyCmsZ
        1NDQbQ3c2nl9S7tCvFDRCuMZpYaKFgw=
X-Google-Smtp-Source: ABdhPJzvN9B0oUIf+/kf2ww9jcR0Q2jLN67CFJFRTePRJYP5dz2QNLgXcnvuUrDjn/QR69fV7xktXw==
X-Received: by 2002:a17:90a:8c02:: with SMTP id a2mr14590600pjo.186.1603052221319;
        Sun, 18 Oct 2020 13:17:01 -0700 (PDT)
Received: from localhost (g167.58-98-146.ppp.wakwak.ne.jp. [58.98.146.167])
        by smtp.gmail.com with ESMTPSA id q21sm9270516pgg.45.2020.10.18.13.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 13:17:00 -0700 (PDT)
From:   Stafford Horne <shorne@gmail.com>
To:     stable@vger.kernel.org
Cc:     Openrisc <openrisc@lists.librecores.org>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 0/1] OpenRISC binder.c compiler failure fix for stable
Date:   Mon, 19 Oct 2020 05:16:50 +0900
Message-Id: <20201018201651.2604140-1-shorne@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backported version of the v5.9 patch to fix issues on OpenRISC using
get_user with 64-bit values.  This also fixes compilation failures when
compiling binder.c.

Discussion: https://lkml.org/lkml/2020/10/16/198

Stafford Horne (1):
  openrisc: Fix issue with get_user for 64-bit values

 arch/openrisc/include/asm/uaccess.h | 35 ++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 13 deletions(-)

-- 
2.26.2

