Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CC81EFD81
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFEQZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFEQZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:25:57 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A08DC08C5C2;
        Fri,  5 Jun 2020 09:25:57 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q16so3831260plr.2;
        Fri, 05 Jun 2020 09:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NmjJTQt+IYO8O2qNw9u4ijfCErC5N7IeIeNyGgIbvio=;
        b=mPr9+gTWNwpKDsKOJGXUCBCs6GLgzT1t4M83KwCqmr/HsvIbBW/n2qeroOgyD98R6Z
         BC+D75K4uc8/eeWfuLhSALEX9dkCM3hVPiwIQ9XLfNdPvZl/+1DogxkGfjg6toeXhG6+
         1Alyg0VAtCIUkzVf3hLvW+1rVyUN/+cRgky20Q0toXOK4tvV1+Nor4QYqV1rk4ho/NRz
         oeE1h6z/SJacetRElo5Z+obsMwTLvayvvv1kQklCQkKfkapXbRJ2ygj0YIC00un1Crv/
         zNlcapqzRA7maZ64zUDSAcH9GqZAa8JHVwA8nSgQtwYirbrMTLSy4SILBGLvhLtF9SmW
         u6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NmjJTQt+IYO8O2qNw9u4ijfCErC5N7IeIeNyGgIbvio=;
        b=k9kQdE6q9aOYYgo5ohKMMRm+UV2vfha289MV9qqDsPpCJt/ClJJsJk2LVhqkpdTTMP
         FIYoKLuyszFuQevCjAGDY3klBz5o85AkR1CFb/IMLtrVhE46CtmQJM6l4APoFwqT79CW
         /zj0M31g7SZRd8mgsleIaKBEvl6WnA3coxdnRcIw6mHWJuBNlhVOlH1FcQC2tkM1BvoD
         SRXfDoJMahK4v1uWVJsEJrcoUKiW9wTnDS7sskMQkFuGX/kpD0Edc7CDCBdYAoFk/+aP
         u405ztoiL/xgYJgFk/ykyj4ylCewMwoEVeX5uhnID5IEKYMpT1WMj4wKYOla+IQybMzB
         bgLA==
X-Gm-Message-State: AOAM531SR7EFRux+wNv/rJmLBH8bhARYWb3eJwhJci9qIz6Yv9T6EEFZ
        Z6zjkKAA+MTVkX1jRcB5mhMaakw2
X-Google-Smtp-Source: ABdhPJzY/o/kBe/m0Q1OcLEXBvHQsXZ1pxuuE+S08cN5pisOWBUb/sNIFZDsOJIS8dbxTeLacLU9fg==
X-Received: by 2002:a17:90b:f0e:: with SMTP id br14mr3833000pjb.78.1591374356024;
        Fri, 05 Jun 2020 09:25:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:25:55 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on 64-bit kernels
Date:   Fri,  5 Jun 2020 09:24:57 -0700
Message-Id: <20200605162518.28099-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

This long patch series was motivated by backporting Jaedon's changes
which add a proper ioctl compatibility layer for 32-bit applications
running on 64-bit kernels. We have a number of Android TV-based products
currently running on the 4.9 kernel and this was broken for them.

Thanks to Robert McConnell for identifying and providing the patches in
their initial format.

In order for Jaedon's patches to apply cleanly a number of changes were
applied to support those changes. If you deem the patch series too big
please let me know.

Thanks

Colin Ian King (2):
  media: dvb_frontend: ensure that inital front end status initialized
  media: dvb_frontend: initialize variable s with FE_NONE instead of 0

Jaedon Shin (3):
  media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
  media: dvb_frontend: Add compat_ioctl callback
  media: dvb_frontend: Add commands implementation for compat ioct

Katsuhiro Suzuki (1):
  media: dvb_frontend: fix wrong cast in compat_ioctl

Mauro Carvalho Chehab (14):
  media: dvb/frontend.h: move out a private internal structure
  media: dvb/frontend.h: document the uAPI file
  media: dvb_frontend: get rid of get_property() callback
  media: stv0288: get rid of set_property boilerplate
  media: stv6110: get rid of a srate dead code
  media: friio-fe: get rid of set_property()
  media: dvb_frontend: get rid of set_property() callback
  media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
  media: dvb_frontend: cleanup ioctl handling logic
  media: dvb_frontend: get rid of property cache's state
  media: dvb_frontend: better document the -EPERM condition
  media: dvb_frontend: fix return values for FE_SET_PROPERTY
  media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl()
    return code
  media: dvb_frontend: fix return error code

Satendra Singh Thakur (1):
  media: dvb_frontend: dtv_property_process_set() cleanups

 .../media/uapi/dvb/fe-get-property.rst        |   7 +-
 drivers/media/dvb-core/dvb_frontend.c         | 571 +++++++++++------
 drivers/media/dvb-core/dvb_frontend.h         |  13 -
 drivers/media/dvb-frontends/lg2160.c          |  14 -
 drivers/media/dvb-frontends/stv0288.c         |   7 -
 drivers/media/dvb-frontends/stv6110.c         |   9 -
 drivers/media/usb/dvb-usb/friio-fe.c          |  24 -
 fs/compat_ioctl.c                             |  17 -
 include/uapi/linux/dvb/frontend.h             | 592 +++++++++++++++---
 9 files changed, 881 insertions(+), 373 deletions(-)

-- 
2.17.1

