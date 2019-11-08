Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD20F584D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKHUQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:16:20 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39758 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfKHUQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:16:20 -0500
Received: by mail-ot1-f66.google.com with SMTP id e17so6285088otk.6
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 12:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vxBQHBPKX+LldqoKCqlNbLPkzpq5l9qd4/bJQuN96ns=;
        b=eciPcRpVhMTLr1VlzqZlAQUiTA+jqFNPJCuf9y34x9yTTu5Xe/R8kybP0OFSpVzXJW
         c8nRLXoQtYiD8qCOd5s58in4s4amU4UOklxXfGQ4/62CftBfRA1xJss9ZefgkCyyKihE
         EkjeJbcSh0VQ7XEdzBkli1IjWPftdhLjzfn5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vxBQHBPKX+LldqoKCqlNbLPkzpq5l9qd4/bJQuN96ns=;
        b=YaNn+12Hdf80xOm8mdT/q3gp5BaYymhbqi3VaUus9xxHAvG4gl/JAn12pR9+LuyMdd
         oonpkv9JqEIUDsm7kvIJH9DgNMScsm7vzXq9pQ5jHUrFtOFQOnZ4orxU46iWC4WFlRqF
         hHGRT7pAO0kMWGBAbZH5wyqW7MfqdETHLJIRq8ljnNuK/08wbc9Lg1+uYZDrfTrSfezl
         mQXnZHseA/aNFZuiNX3EtH+gh2wvCvEO59pc8wBGOtfnsVg8x5vbxWQkGZ4Fyc6KnClb
         QBIAHVeoT2UrBxCEq58iA4rSizP+Qt8mbQLStjviLVIOpT1ivkc11qXK7h6+gvbNPwFq
         IgXQ==
X-Gm-Message-State: APjAAAVRZdYCHib9N2EFJ26U4H5qQxHcGGEy71C5GsufLxSRP69jaMw1
        sgHZlGmcfSKmPlzgcGmNpiHtfQ==
X-Google-Smtp-Source: APXvYqwpBaFfgCs9oePXLa3YZmCwZGkIvtf4GwKcc16SKbA2wZuLQeCIvxV+0qYMEIUNpSnN+SxtAA==
X-Received: by 2002:a05:6830:1d82:: with SMTP id y2mr9992464oti.360.1573244178421;
        Fri, 08 Nov 2019 12:16:18 -0800 (PST)
Received: from cando.ausoff.indeed.net ([97.105.47.162])
        by smtp.gmail.com with ESMTPSA id u126sm965129oib.45.2019.11.08.12.16.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 12:16:17 -0800 (PST)
From:   Dave Chiluk <chiluk+linux@indeed.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH v4.14.y 0/2] Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date:   Fri,  8 Nov 2019 14:15:55 -0600
Message-Id: <1573244157-28339-1-git-send-email-chiluk+linux@indeed.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20191104110832.GE1945210@kroah.com>
References: <20191104110832.GE1945210@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here's the backported patches for 4.14.y.  Logic is basically the same, the
issue was primarily with patch context. The patches are really back-ports and
not cherry-picks because of that, if that's an issue feel free to change the
text description.

[PATCH v4.14.y 1/2] sched/fair: Fix low cpu usage with high throttling by
[PATCH v4.14.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings

