Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF80451673
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbhKOVZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244213AbhKOVWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:22:51 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90531C0432CB;
        Mon, 15 Nov 2021 13:06:18 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n8so15531610plf.4;
        Mon, 15 Nov 2021 13:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pdkroTh+57X81CRfLMuPticZu0w7m2cSqwASgcC59+4=;
        b=U5gzjH2q2MohYRt0B41/5G0ExzIjAyoP/j4H7zZLFx0s9O5evQXZN+dbUqRZ/ZQCHm
         CDbldbLbMp446MOTK9ZZ+KanNspkl3KFS1UW1fqVBrb7cikP8L31CYK/UGpzEYV8chVL
         i+HKHjkxktj4+JMuJxeIxcV5MhhQu4bnKJsC3j+VeU2T9csUYxa/rO4BhsHogNHq3sVM
         vaHP/gEylf9S+g4eAhX1YdCTg8l8hd06saa7WEDaqWh9OBIWAqRD0+UuCEKEjyKdWScx
         NjqWGeJZUw1faoaJYYDsKMTAlDC6D5BNiEbp42TjXznB/OYrx+nS8uaTlt6+E3bkgzFV
         OeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pdkroTh+57X81CRfLMuPticZu0w7m2cSqwASgcC59+4=;
        b=AWI9PN3pAc/xXgvi2E7oh9Pz9viPR1dS6fhxscGvGR8Arx8MWe9EX5yTCHDB0Qg/zO
         6l/ffugABcBIZVbysxe3hJKQ5YgPaoiHIjkBLn2r4ltpYEs4KLA/o2ecOiXIuhz11bTm
         1vTiFM5YgrgiI6Si6nMxxz/2346gRSSTbqapR2QfmRGr28ar90HacQZyLPnemGBQm8KR
         03D5MsaDw7l+b8/0syH2nA4h2O+DoXkwf1CJmI6WLXm5c2tBVo+osWbKE7y1KXrf2GBQ
         7Ymbydb3CxS5LZN3zChUD44xhDn60OFDw9//tlT9/SN+3bE+ES2AHib7pvieLYNWHKRz
         oOwQ==
X-Gm-Message-State: AOAM5335hA9S+lV4ilXLzXFUs4hP+idiqhnldaS6mERhsDinLjSCLm/S
        2c1AtgRiMYpu/GE6kmd9csg=
X-Google-Smtp-Source: ABdhPJwye0mrZNsA1+g0CQTQQFC6vNnjkKGU0QNT17Kg2RBzf7d9klzK5SKqzQas4RdVY/L1cPFbow==
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr1916242pjb.201.1637010378034;
        Mon, 15 Nov 2021 13:06:18 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id mi18sm235338pjb.13.2021.11.15.13.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:06:17 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 15 Nov 2021 11:06:16 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Message-ID: <YZLLyFnT95o4Sa8X@slm.duckdns.org>
References: <20211115164607.23784-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115164607.23784-1-arbn@yandex-team.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Ingo, Peter, this looks fine to be sans a couple typos in the descriptions.
Please let me know if you wanna take them through sched tree. Otherwise,
I'll route them through cgroup tree in a few days.

Thanks.

-- 
tejun
