Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4AFF5870
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfKHUUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:20:39 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43158 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfKHUUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:20:39 -0500
Received: by mail-ot1-f66.google.com with SMTP id l14so6269456oti.10
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 12:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jtPjbB5aknx1Pqzf0Srtqe+A6mXZ9+cYamkg9DFe5dA=;
        b=g4BP9hFL13TMVpcOYQF8qV8LYy/s367wY+m+MiNfD3wIIglEL1UdblRTCqpWr2k2ym
         niR8Pn2ykDMg73LRH5Gl4LHg7JN5NsnOATertHEHCsk5LCewqs/YWIVI4Tgeqptnjne/
         FAvGeUn0bCc5DZ3uYdUkfmz1vcRxeBtGIGZI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jtPjbB5aknx1Pqzf0Srtqe+A6mXZ9+cYamkg9DFe5dA=;
        b=BqHWDXjCqthiTDHRjBOERs/Xf7YdMcxE4TVqSWl1uKjj1A0je8Cq47jVPP3BikWATg
         nNYU1kGjNQaTnD2Tnla7iTA28KBT5qipXTqOOCyHXeEb6x0bCQNxCagSnWNKf9QTVZ1f
         kGruM9TNWb2X8MW4WcPlUmPQGeYEPn0zXATt+mgi7pTdmy7EfemJmv7H66DLervYZn/s
         md9CiLc+V328X9SLf1YrZIzKv7jLy/RhPBkkbv+bQ5Pk2WSbdw9i4PLE7xDHDQjdaF+r
         DanVMew9R53B5HER23URlItvkdEn8HnGYVEVm2jSlPylAdOJCDzG/Smj1l+QA8nqh4YY
         Zjpw==
X-Gm-Message-State: APjAAAWdv+q/EGxdpFMcntYODANchg9FROxT+S4Nt9p1Ktj7vnO/VPf+
        PFhWbPBgZXJJVtxZ7TFQnt3sQA==
X-Google-Smtp-Source: APXvYqxNwPm93boGaKl8L86Jy9a9O7Y8UGg24NTkuSsnRh4sqrM54qfkLQbyDzAvzwZF4WameTkkcA==
X-Received: by 2002:a9d:6294:: with SMTP id x20mr9556499otk.31.1573244436141;
        Fri, 08 Nov 2019 12:20:36 -0800 (PST)
Received: from cando.ausoff.indeed.net ([97.105.47.162])
        by smtp.gmail.com with ESMTPSA id o18sm2251083otj.38.2019.11.08.12.20.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 12:20:35 -0800 (PST)
From:   Dave Chiluk <chiluk+linux@indeed.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH v4.19.y 0/2] Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date:   Fri,  8 Nov 2019 14:20:06 -0600
Message-Id: <1573244408-31101-1-git-send-email-chiluk+linux@indeed.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20191104110832.GE1945210@kroah.com>
References: <20191104110832.GE1945210@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here's the backported patches for 4.19.y.  Logic is basically the same, the
issue was primarily with patch context. The patches are really back-ports and
not cherry-picks because of that, if that's an issue feel free to change the
text description.

[PATCH v4.19.y 1/2] sched/fair: Fix low cpu usage with high throttling by
[PATCH v4.19.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings
