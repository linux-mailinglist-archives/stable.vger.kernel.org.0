Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DD3A5F9E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhFNKEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFNKEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 06:04:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41C6C061574;
        Mon, 14 Jun 2021 03:02:51 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t9so8201853pgn.4;
        Mon, 14 Jun 2021 03:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rNQD4x8X3fqLopq7YlxB2amn3le3fNKisSEzfuWGwmk=;
        b=KsODG2p+0P7TzUkSGtY6l1BPl3iRfswiPFdZQxactpYuArBXPIkRUm6upHjC6LdNOh
         xbbN5+6kFwV+b14IfzU4ZbNpljF11z8KxifrIXCBWDGhOlzAScB8ft0Gj2pPeAkrKEoI
         1t9usoOwl0+TURy3AsUREHmYK9qzBAjJOaednhBf6v9GeLZLAYSBEDM6+Pb4XTNQoMJZ
         i7ZHxdJ8ayX7wtdjPujrE9YY8kmp7v0CTIXx0Qv1V7rs5PYDk5RWCk1t2GDTe1z/Hmon
         t7ZPdNY5/En/TKh6G/8mrPI9HAhlSfmqudiPAMp3Boy+oFGb8uuEDVqWROnxIlU0zsLd
         2w5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rNQD4x8X3fqLopq7YlxB2amn3le3fNKisSEzfuWGwmk=;
        b=nLFtTPybj2iso+FLfYTINVaayDCCZmAvE7u9KwBCyd2Ma404J3WM27KGRsoV0+CiKT
         nf2QsLUu2VscqjIvPOh9ZI0TM/YcEYqHudo6LclVaPMs3i+pL601uBpI6XX2BKgYiaq6
         LOm5wxgWQAZEtvN3a9G1iSuxXldrEuhjUOvPtjQH1s7uANnrFvWxV2VGho4QghkGNdlw
         Ttb28QYrPypnf7nTwtyFwvO4+q1wXdp2NFStSc53VJvXUnYPSNSddZMySipurlwIH2tb
         m1QwximRUSxbAvs7KIDv8EfybZHfPAYH1TVz1FLhNpwLpJcmhKCvUkjtYxCOxmOV8QDG
         R65g==
X-Gm-Message-State: AOAM530Lndyln9x6NPMmwiZvwSCgj+k1kpoqh1Jol5WJhFiwYecqa09Y
        8fLiX4gj7IIyZdiZ7N+ta+A=
X-Google-Smtp-Source: ABdhPJznYWcNRclazSfMjDvL7XG0PCNfjNv0tmjFeg+HSzd1vhRPQW2g+gETCvqtBzX2rwbDieEAvg==
X-Received: by 2002:aa7:83c3:0:b029:2e8:f2ba:3979 with SMTP id j3-20020aa783c30000b02902e8f2ba3979mr21137727pfn.8.1623664971383;
        Mon, 14 Jun 2021 03:02:51 -0700 (PDT)
Received: from localhost.localdomain ([143.244.42.72])
        by smtp.gmail.com with ESMTPSA id x28sm12005906pff.201.2021.06.14.03.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 03:02:51 -0700 (PDT)
From:   youling257 <youling257@gmail.com>
To:     keescook@chromium.org
Cc:     torvalds@linux-foundation.org, christian.brauner@ubuntu.com,
        andrea.righi@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Date:   Mon, 14 Jun 2021 18:02:34 +0800
Message-Id: <20210614100234.12077-1-youling257@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608171221.276899-1-keescook@chromium.org>
References: <20210608171221.276899-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I used mainline kernel on android, this patch cause "failed to retrieve pid context" problem.

06-14 02:15:51.165  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1682) failed to retrieve pid context.
06-14 02:15:51.166  1685  1685 E ServiceManager: add_service('batteryproperties',1) uid=0 - PERMISSION DENIED
06-14 02:15:51.166  1682  1682 I ServiceManager: addService() batteryproperties failed (err -1 - no service manager yet?).  Retrying...
06-14 02:15:51.197  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1695) failed to retrieve pid context.
06-14 02:15:51.197  1685  1685 E ServiceManager: add_service('android.security.keystore',1) uid=1017 - PERMISSION DENIED
06-14 02:15:51.198  1695  1695 I ServiceManager: addService() android.security.keystore failed (err -1 - no service manager yet?).  Retrying...
06-14 02:15:51.207  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1708) failed to retrieve pid context.
06-14 02:15:51.207  1685  1685 E ServiceManager: add_service('android.service.gatekeeper.IGateKeeperService',1) uid=1000 - PERMISSION DENIED
06-14 02:15:51.207  1708  1708 I ServiceManager: addService() android.service.gatekeeper.IGateKeeperService failed (err -1 - no service manager yet?).  Retrying...
06-14 02:15:51.275  1685  1685 E ServiceManager: SELinux: getpidcon(pid=1693) failed to retrieve pid context.
06-14 02:15:51.275  1692  1692 I cameraserver: ServiceManager: 0xf6d309e0
06-14 02:15:51.275  1685  1685 E ServiceManager: add_service('drm.drmManager',1) uid=1019 - PERMISSION DENIED
06-14 02:15:51.276  1693  1693 I ServiceManager: addService() drm.drmManager failed (err -1 - no service manager yet?).  Retrying...

