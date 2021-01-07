Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B5B2EE942
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbhAGWxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbhAGWxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:53:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F096C0612F4;
        Thu,  7 Jan 2021 14:52:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id a188so4965662pfa.11;
        Thu, 07 Jan 2021 14:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Bpa0WaMi/Am/Z36+hdwoQHpyN4b6qO9HXyiYVoS/Ao=;
        b=DTsVTZkk/yQjDoAmJNrmQqjEKisqb9jk1cw2Dz73obZmFl24/E7+Do6qS2r0sYnu+8
         9KxzZnCY/JWIiBl++HnNxDFGLr/HA1H4EyTdxX1T6fkDySdD6gv7/2dLjpjUlrQYE0WV
         GLMmQMj3SlQgaiUnkuRpANx/cc36GRu0NbmTCyhx9G36p09fpKvxPuWCWh9aMVh9XXKq
         UwmZ72U9QHQMPWZ1H5PkiD/lmKA23UpebAd+LZSQCmZBLOxPdUE6uWq8NgSBfgHasskM
         HtYLDU7JdYfHAWxVaG7sPeFCmezxMuQxZURUX/58df+gL3hTOGki93aQxwHx0ls247rZ
         eAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Bpa0WaMi/Am/Z36+hdwoQHpyN4b6qO9HXyiYVoS/Ao=;
        b=KOa02efBLKR7Q65Ie6czUs0aGPZPoclaaN8+BoPavleUSToFa65Ftyf984l2eIjNH+
         HnIzhurw/KsZUUuitYfuBQ+pVBpycrWanCern1hqoLFqwQvGd6OYeQR19omb9LIteXDk
         slN9qt470gJ1Ki4W4jFXjUhO25LbO7O8gRvpxK/H7MnP6EzOPz/VWD2OSQf4H+dXPuUK
         xSbtr82kQPMcqgx4Igh8E5eh0B2yjoT6LA4kXt1YjcE9WIFF8lXEQcvEbGHgYPg4Be9u
         FdfZBWrKAbVkuUzJlc99UMDfceJX7Wi1lIXzL0I8lDXNvn0PWfLx5c+aTIsaquR1XUyJ
         CWQA==
X-Gm-Message-State: AOAM5326QQdi5BRGwN7Oe1PFAojQEQd8jRVf7oH80yDt2ySxVmgFwblL
        VOJCE/G5C+uwISiBLsEDurAOpsMBriE=
X-Google-Smtp-Source: ABdhPJztqanFv1CtkEoLF4Kc8PJByndcPuizWgsbT39EVryxj7uxzanUPGg92teXt5lKMxRtuWAobQ==
X-Received: by 2002:a62:b415:0:b029:1a6:8b06:68f4 with SMTP id h21-20020a62b4150000b02901a68b0668f4mr4161125pfn.43.1610059959282;
        Thu, 07 Jan 2021 14:52:39 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm6510603pfi.168.2021.01.07.14.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:52:38 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Du Changbin <changbin.du@gmail.com>
Subject: [stable 4.9.y 0/4] scripts/gdb Fixes for stable 4.9
Date:   Thu,  7 Jan 2021 14:52:25 -0800
Message-Id: <20210107225229.1502459-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

This series contains some scripts/gdb/ fixes that are already present in
newer stable kernels.

Thanks!

André Draszik (1):
  scripts/gdb: make lx-dmesg command work (reliably)

Du Changbin (1):
  scripts/gdb: fix lx-version string output

Leonard Crestez (2):
  scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
  scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace

 scripts/gdb/linux/dmesg.py | 22 +++++++++++++++-------
 scripts/gdb/linux/proc.py  |  2 +-
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.25.1

