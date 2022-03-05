Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95A4CE5F9
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiCEQps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCEQps (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:45:48 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42649972ED
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:44:54 -0800 (PST)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AFD233F5FC
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646498693;
        bh=NYEhl1gauRIFyvA7X8W9kTTuWzqzvTkFkGuOqmBfZiI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=aLh7lvrfSH5gi3jllyMe+hpSvxMBf1/WClr3rEmGQW6JVgMoW5/JHzEDL9k5soySW
         WBM0oM6U14BFvtJEdfBL7uqXGejtCLVuAGWHUT/G28PXwUdk1zvSsyGJnSQPNkXRxo
         E0Ybm5XzmmE4MaahLasNVS09p/dJsi6hQ56F6JJOk/Buls6fInW5zTt7NtuPhQsA+v
         GxTCecukPmYz3FVtI/DT1UgSEhKl1wFREq9LflWgKg93hUdvwjmst7aL5FmOBLtRqZ
         hHJadfdX/JU9dA9UjT4c6w5dxgS6ynbWSLPqyEt+kebcZVVSGG8yrypllA6JMj9adG
         9jKhIUxsRcIMw==
Received: by mail-il1-f199.google.com with SMTP id l6-20020a056e020dc600b002c627a43bc4so1229263ilj.7
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NYEhl1gauRIFyvA7X8W9kTTuWzqzvTkFkGuOqmBfZiI=;
        b=GUUxBGIYWk5C9EVoINkZK7DDMXDOo0MqORweKojLIdMGIUfyIPqNlObTl8DYljcCo0
         SWw3W5U4+RDkym95NC2IAdwPCJ77sYo+lPKNX2luMaAbWMP6ILvaU0NjBtEQZhxktyHJ
         OWPM4cUPO4n46VFj7HY4mvVeCwIlieIUCjmp7u40K0vwUeL4LgTGvi4RrWK62dUoghUs
         luUBAErn9/EyctAh28a81BaIb3KAzw6Mn/AJKVujfjIBVV0YWHtKQegUtPPY7bhmDlVV
         gqbLJaW+PuPyIiInaC9z7d4JYKEimeJWRg1LP4OZikgZpgBUdIJ8D2+KrRvckVp/1NIJ
         sUxQ==
X-Gm-Message-State: AOAM531fwyIJndJJ2h0I9Gllhvp5WpvrNN6YLIi/Qx/NrhfrDzGdlW9p
        CYKYiZFawhiqeh3Tm/qcFoj34lQVZADBWc+VhWXqvTVg34ffCSJmqesbihD7uq20HqEVEYH3WRt
        KKv+MY51ScIZI+Y+3ZgOyVsL+STmCfmPaEg==
X-Received: by 2002:a02:ca04:0:b0:314:a737:f12c with SMTP id i4-20020a02ca04000000b00314a737f12cmr3787566jak.100.1646498684580;
        Sat, 05 Mar 2022 08:44:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMLbgHuv5ZfI61aUkzzdqAfT87mC1srLYWi8TtPxvB314nCxfcb5tvYCB8biXEWPsPUpFNJw==
X-Received: by 2002:a02:ca04:0:b0:314:a737:f12c with SMTP id i4-20020a02ca04000000b00314a737f12cmr3787446jak.100.1646498682185;
        Sat, 05 Mar 2022 08:44:42 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id k4-20020a5e9304000000b00640dfe71dc8sm6282106iom.46.2022.03.05.08.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:44:40 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Miao Xie <miaox@cn.fujitsu.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10+5.4 0/3] sched/topology: Fix missing scheduling domain levels
Date:   Sat,  5 Mar 2022 09:44:27 -0700
Message-Id: <20220305164430.245125-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LTP cpuset_sched_domains test, authored by Miao Xie, fails on a Kunpeng920
server that has 4 NUMA nodes:
  https://launchpad.net/bugs/1951289

This does appear to be a real bug. /proc/schedstat displays 4 domain levels for
CPUs on 2 of the nodes, but only 3 levels for the others 2 (see below).
I assume this means the scheduler is making suboptimal decisions about
where to place/move processes. I'm not sure how to demonstrate that - but
open to suggestions if that evidence is important justification for stable.

This is not a problem in current upstream kernels, so I bisected and found
that the first patch here fixes it. I can't tell from the commit message
if fixing this case was Valentin's intent, or just a happy side-effect of the
set conversion. The other two patches fix regressions introduced by the first.
All cherry-pick cleanly back to 5.10.y and 5.4.y. This platform easily
reproduces the problem Dietmar's fix addresses. I don't have hardware to test
the ia64 fix.

Note: This also impacts earlier stable trees, but require some minor porting,
so I'll submit fixes for those separately.

Here's a comparison of /proc/schedstat before & after applying these
fixes:

--- proc_schedstat.5.10.y	2022-03-05 09:02:53.742012974 -0700
+++ proc_schedstat.5.10.y+fix	2022-03-05 09:02:53.978014549 -0700
@@ -1,578 +1,642 @@
 version 15
-timestamp 4294926846
-cpu0 0 0 0 0 0 0 11723379710 9778613880 10858
+timestamp 4294921612
+cpu0 0 0 0 0 0 0 11082472390 9205899500 10648
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu1 0 0 0 0 0 0 2277443520 626484810 4433
+cpu1 0 0 0 0 0 0 12201047710 247440560 11608
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu2 0 0 0 0 0 0 11360128580 430647330 3533
+cpu2 0 0 0 0 0 0 1244693390 116917410 2404
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu3 0 0 0 0 0 0 1504701810 666595750 2594
+cpu3 0 0 0 0 0 0 2023237170 247418260 2734
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu4 0 0 0 0 0 0 2070188140 566422510 3433
+cpu4 0 0 0 0 0 0 2261150720 118563330 2327
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu5 0 0 0 0 0 0 2737520580 794259190 2179
+cpu5 0 0 0 0 0 0 3286662020 3363781000 1795
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu6 0 0 0 0 0 0 1355217580 540638960 1818
+cpu6 0 0 0 0 0 0 2086812960 186431060 2889
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu7 0 0 0 0 0 0 1322303720 727076810 1449
+cpu7 0 0 0 0 0 0 984642750 193210980 1375
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu8 0 0 0 0 0 0 2488707830 2247809760 3508
+cpu8 0 0 0 0 0 0 1038342660 274381880 2228
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu9 0 0 0 0 0 0 3191708630 2690459740 2435
+cpu9 0 0 0 0 0 0 1090402340 232010130 1371
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu10 0 0 0 0 0 0 2295923530 573454650 10026
+cpu10 0 0 0 0 0 0 1249725280 364934670 1247
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu11 0 0 0 0 0 0 1366244140 602765020 2232
+cpu11 0 0 0 0 0 0 995234160 120976090 1014
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu12 0 0 0 0 0 0 1385007460 631868600 1662
+cpu12 0 0 0 0 0 0 2010532490 237077330 1090
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu13 0 0 0 0 0 0 2144969280 595384820 2777
+cpu13 0 0 0 0 0 0 1016596570 277257800 1118
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu14 0 0 0 0 0 0 1313206720 361995100 1500
+cpu14 0 0 0 0 0 0 1124386850 213734350 4832
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu15 0 0 0 0 0 0 1769088490 558984030 1962
+cpu15 0 0 0 0 0 0 1612626690 167220340 4551
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu16 0 0 0 0 0 0 1260947000 604824630 1533
+cpu16 0 0 0 0 0 0 1066119100 341742550 5229
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu17 0 0 0 0 0 0 1220339260 287394490 1196
+cpu17 0 0 0 0 0 0 1329266040 256475780 1153
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu18 0 0 0 0 0 0 1151332330 556274460 1831
+cpu18 0 0 0 0 0 0 1236387900 239639410 5189
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu19 0 0 0 0 0 0 1200016680 567127160 997
+cpu19 0 0 0 0 0 0 1523636270 300871620 4023
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu20 0 0 0 0 0 0 1195348470 570474650 1109
+cpu20 0 0 0 0 0 0 1126288540 297161450 2112
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu21 0 0 0 0 0 0 1277455490 814789650 1194
+cpu21 0 0 0 0 0 0 2302310430 1805364070 1240
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu22 0 0 0 0 0 0 1263428680 552718430 1350
+cpu22 0 0 0 0 0 0 1087945000 130206270 863
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu23 0 0 0 0 0 0 1264414470 485266590 1463
+cpu23 0 0 0 0 0 0 1054634660 280990020 1184
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu24 0 0 0 0 0 0 1429073480 503548050 1445
+cpu24 0 0 0 0 0 0 1123577490 226069490 1433
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu25 0 0 0 0 0 0 1309990530 316293190 1498
+cpu25 0 0 0 0 0 0 1080655760 369044600 2773
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu26 0 0 0 0 0 0 1206544010 519627800 1264
+cpu26 0 0 0 0 0 0 919258630 270546860 1913
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu27 0 0 0 0 0 0 1216338400 633775470 1318
+cpu27 0 0 0 0 0 0 1159637220 294606980 1215
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu28 0 0 0 0 0 0 1241054650 563044740 1521
+cpu28 0 0 0 0 0 0 1085793280 238275360 1279
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu29 0 0 0 0 0 0 1238177030 607895300 1603
+cpu29 0 0 0 0 0 0 975472260 296850080 5950
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu30 0 0 0 0 0 0 1222379660 618126390 1267
+cpu30 0 0 0 0 0 0 977259590 265452470 1400
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu31 0 0 0 0 0 0 1228463310 436429700 1295
+cpu31 0 0 0 0 0 0 1029549240 385079090 839
 domain0 00000000,00000000,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu32 0 0 0 0 0 0 1150857660 458443260 1443
+cpu32 0 0 0 0 0 0 1137989080 155379510 830
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu33 0 0 0 0 0 0 1288926620 530869610 1143
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu33 0 0 0 0 0 0 1064890650 141282310 1238
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu34 0 0 0 0 0 0 1230636480 345658720 1974
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu34 0 0 0 0 0 0 1126557700 149430390 1057
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu35 0 0 0 0 0 0 1084736490 528163130 1496
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu35 0 0 0 0 0 0 1048369290 162456610 753
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu36 0 0 0 0 0 0 1848521640 518717750 1794
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu36 0 0 0 0 0 0 975866450 185664570 739
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu37 0 0 0 0 0 0 1136487530 561776030 1291
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu37 0 0 0 0 0 0 1014151630 117986160 711
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu38 0 0 0 0 0 0 1154730380 418654520 1130
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu38 0 0 0 0 0 0 948478220 132862590 535
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu39 0 0 0 0 0 0 1144030780 491775460 1212
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu39 0 0 0 0 0 0 996709910 198992080 615
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu40 0 0 0 0 0 0 1182461290 533219020 2015
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu40 0 0 0 0 0 0 1023849830 187724580 887
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu41 0 0 0 0 0 0 1390111930 576350020 2045
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu41 0 0 0 0 0 0 1089302000 307591030 1275
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu42 0 0 0 0 0 0 1264819760 658411260 1223
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu42 0 0 0 0 0 0 1057529600 360756620 971
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu43 0 0 0 0 0 0 1120156200 514251790 1167
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu43 0 0 0 0 0 0 1130354490 249162490 873
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu44 0 0 0 0 0 0 1162429010 490846050 1105
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu44 0 0 0 0 0 0 996281480 233931950 544
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu45 0 0 0 0 0 0 1175094470 486253990 3792
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu45 0 0 0 0 0 0 1287557470 389243900 857
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu46 0 0 0 0 0 0 1206328450 611934660 1011
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu46 0 0 0 0 0 0 1012812150 145312090 851
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu47 0 0 0 0 0 0 1239875590 631662220 1178
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu47 0 0 0 0 0 0 1334650830 129149840 904
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu48 0 0 0 0 0 0 1127137450 496075260 1252
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu48 0 0 0 0 0 0 1050451910 157675130 524
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu49 0 0 0 0 0 0 1089725850 499350870 1031
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu49 0 0 0 0 0 0 1009568530 164015380 551
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu50 0 0 0 0 0 0 1138275550 442770630 1094
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu50 0 0 0 0 0 0 1042049560 144771590 656
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu51 0 0 0 0 0 0 1285050770 556255110 1180
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu51 0 0 0 0 0 0 1196124700 345533600 1602
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu52 0 0 0 0 0 0 1135287470 669900490 1251
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu52 0 0 0 0 0 0 1059005120 328671080 959
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu53 0 0 0 0 0 0 1052382140 704579540 932
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu53 0 0 0 0 0 0 961409160 186745030 580
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu54 0 0 0 0 0 0 1056613490 548747320 871
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu54 0 0 0 0 0 0 1011145290 224896700 560
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu55 0 0 0 0 0 0 1076184220 529237530 944
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu55 0 0 0 0 0 0 958876130 317339290 525
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu56 0 0 0 0 0 0 1050944600 513470370 1053
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu56 0 0 0 0 0 0 1051539150 167015760 543
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu57 0 0 0 0 0 0 1075070090 614086950 1069
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu57 0 0 0 0 0 0 1030370820 171061400 744
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu58 0 0 0 0 0 0 1086053230 683194990 1096
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu58 0 0 0 0 0 0 986381790 339071610 833
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu59 0 0 0 0 0 0 1078064900 624794530 1125
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu59 0 0 0 0 0 0 983637540 206541540 733
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu60 0 0 0 0 0 0 1087840360 549309270 1009
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu60 0 0 0 0 0 0 959303820 189199430 650
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu61 0 0 0 0 0 0 1186287630 502624570 1411
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu61 0 0 0 0 0 0 1076313010 258114100 570
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu62 0 0 0 0 0 0 1235366620 516786740 1105
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu62 0 0 0 0 0 0 1033922290 317744630 680
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu63 0 0 0 0 0 0 1125316710 629103760 1013
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu63 0 0 0 0 0 0 1239489590 170772020 744
 domain0 00000000,00000000,ffffffff,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 00000000,00000000,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 00000000,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu64 0 0 0 0 0 0 2788609020 436872750 4697
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu64 0 0 0 0 0 0 2655399320 348922200 4258
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu65 0 0 0 0 0 0 1175095970 602591040 1646
+cpu65 0 0 0 0 0 0 1133366510 144062370 1900
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu66 0 0 0 0 0 0 1159633470 484732230 1028
+cpu66 0 0 0 0 0 0 1056929870 295084870 828
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu67 0 0 0 0 0 0 1181879050 242189090 1192
+cpu67 0 0 0 0 0 0 1679644300 188519850 1320
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu68 0 0 0 0 0 0 1069609740 515374680 1120
+cpu68 0 0 0 0 0 0 1184822190 283135330 1589
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu69 0 0 0 0 0 0 1094791160 471368430 3947
+cpu69 0 0 0 0 0 0 1038793400 268844130 3666
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu70 0 0 0 0 0 0 1100830350 672165480 1195
+cpu70 0 0 0 0 0 0 1024732540 220179790 1337
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu71 0 0 0 0 0 0 1167198960 234152500 3790
+cpu71 0 0 0 0 0 0 1134251080 302413210 8759
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu72 0 0 0 0 0 0 1146332560 558931220 1032
+cpu72 0 0 0 0 0 0 1396943660 239151480 5210
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu73 0 0 0 0 0 0 1714910490 774888000 7963
+cpu73 0 0 0 0 0 0 1128091730 312378380 3874
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu74 0 0 0 0 0 0 1256571280 630497390 3924
+cpu74 0 0 0 0 0 0 1178449930 344413950 1320
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu75 0 0 0 0 0 0 1112890040 558475380 1605
+cpu75 0 0 0 0 0 0 1305952100 165025280 1001
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu76 0 0 0 0 0 0 1140786500 569652590 1657
+cpu76 0 0 0 0 0 0 1076849210 317863470 755
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu77 0 0 0 0 0 0 1097628360 587567530 1440
+cpu77 0 0 0 0 0 0 1086787700 328470650 1430
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu78 0 0 0 0 0 0 1149736730 650445490 1035
+cpu78 0 0 0 0 0 0 1680336360 260050190 1145
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu79 0 0 0 0 0 0 1129301780 634451250 898
+cpu79 0 0 0 0 0 0 1185846670 409784040 860
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu80 0 0 0 0 0 0 1083280470 613362390 2919
+cpu80 0 0 0 0 0 0 947626090 254939780 925
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu81 0 0 0 0 0 0 1182646620 462538790 1446
+cpu81 0 0 0 0 0 0 1034791780 317812940 730
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu82 0 0 0 0 0 0 1168389530 593359690 1595
+cpu82 0 0 0 0 0 0 936165610 257726970 887
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu83 0 0 0 0 0 0 1482325300 609933700 5479
+cpu83 0 0 0 0 0 0 1137695650 312270790 1755
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu84 0 0 0 0 0 0 1154817750 636586100 2251
+cpu84 0 0 0 0 0 0 959641910 360020470 718
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu85 0 0 0 0 0 0 1083737220 508317370 1116
+cpu85 0 0 0 0 0 0 930767530 249465300 474
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu86 0 0 0 0 0 0 1125751820 600706320 1309
+cpu86 0 0 0 0 0 0 1030217130 433536370 757
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu87 0 0 0 0 0 0 1159553000 382391960 1118
+cpu87 0 0 0 0 0 0 931313370 297958230 524
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu88 0 0 0 0 0 0 1121472760 609510130 1042
+cpu88 0 0 0 0 0 0 917587690 263118040 533
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu89 0 0 0 0 0 0 1270451370 339109630 2094
+cpu89 0 0 0 0 0 0 971956020 323298630 1018
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu90 0 0 0 0 0 0 1667694220 826079330 4726
+cpu90 0 0 0 0 0 0 1023414050 311713620 1408
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu91 0 0 0 0 0 0 1142428420 613404860 2269
+cpu91 0 0 0 0 0 0 1023939420 340334100 636
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu92 0 0 0 0 0 0 1126722560 812651860 974
+cpu92 0 0 0 0 0 0 1062878040 357804860 693
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu93 0 0 0 0 0 0 1132265580 284143700 1568
+cpu93 0 0 0 0 0 0 1130873920 286905690 3038
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu94 0 0 0 0 0 0 1168056870 632657570 1362
+cpu94 0 0 0 0 0 0 1077998720 365820780 821
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu95 0 0 0 0 0 0 1159086250 678723840 1749
+cpu95 0 0 0 0 0 0 998022170 276888830 709
 domain0 00000000,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu96 0 0 0 0 0 0 1088858180 671421650 1034
+cpu96 0 0 0 0 0 0 1076213250 246073440 1144
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu97 0 0 0 0 0 0 1084578260 657263910 965
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu97 0 0 0 0 0 0 1089207190 278552890 777
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu98 0 0 0 0 0 0 1155363860 677912580 820
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu98 0 0 0 0 0 0 1001342500 222042250 514
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu99 0 0 0 0 0 0 1123658310 733324780 3648
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu99 0 0 0 0 0 0 1007677080 301149080 504
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu100 0 0 0 0 0 0 1041477650 257079720 867
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu100 0 0 0 0 0 0 972506880 385884360 416
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu101 0 0 0 0 0 0 1191361810 636538910 3298
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu101 0 0 0 0 0 0 974294670 272094560 508
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu102 0 0 0 0 0 0 1027637190 1027592650 896
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu102 0 0 0 0 0 0 959323770 215147500 526
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu103 0 0 0 0 0 0 1049586270 474586730 694
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu103 0 0 0 0 0 0 962155270 250005300 405
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu104 0 0 0 0 0 0 1056801510 567839680 937
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu104 0 0 0 0 0 0 944547500 369975100 511
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu105 0 0 0 0 0 0 1049807110 321118020 1003
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu105 0 0 0 0 0 0 936931920 278799140 518
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu106 0 0 0 0 0 0 1058988110 407412350 779
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu106 0 0 0 0 0 0 992514920 204349860 484
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu107 0 0 0 0 0 0 1087302870 644794130 892
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu107 0 0 0 0 0 0 951027340 351111760 373
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu108 0 0 0 0 0 0 1053536950 753506520 1110
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu108 0 0 0 0 0 0 959110110 248373640 466
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu109 0 0 0 0 0 0 1079558220 661923680 1076
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu109 0 0 0 0 0 0 978116070 283975030 497
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu110 0 0 0 0 0 0 1051782880 693691540 966
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu110 0 0 0 0 0 0 1200655260 228535480 407
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu111 0 0 0 0 0 0 1072784680 725402230 930
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu111 0 0 0 0 0 0 958671630 301625770 488
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu112 0 0 0 0 0 0 1092326900 620897120 1016
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu112 0 0 0 0 0 0 961275720 99527390 506
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu113 0 0 0 0 0 0 1097176870 452148240 968
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu113 0 0 0 0 0 0 1050580800 164687930 459
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu114 0 0 0 0 0 0 1043246910 296896540 818
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu114 0 0 0 0 0 0 935203120 337609020 436
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu115 0 0 0 0 0 0 1046630300 835711580 1032
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu115 0 0 0 0 0 0 920711560 362788320 410
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu116 0 0 0 0 0 0 1019896220 741195420 894
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu116 0 0 0 0 0 0 950105000 162430250 380
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu117 0 0 0 0 0 0 1051417940 746554690 901
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu117 0 0 0 0 0 0 927573890 303061770 445
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu118 0 0 0 0 0 0 1085908780 928991030 932
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu118 0 0 0 0 0 0 937698460 213624130 468
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu119 0 0 0 0 0 0 1085966970 561995010 4399
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu119 0 0 0 0 0 0 941677380 291821570 441
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu120 0 0 0 0 0 0 1094590210 649582620 970
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu120 0 0 0 0 0 0 951214990 351014070 383
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu121 0 0 0 0 0 0 1095479360 594625150 875
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu121 0 0 0 0 0 0 997367490 266501080 663
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu122 0 0 0 0 0 0 1077279080 924059570 832
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu122 0 0 0 0 0 0 1006559400 404526420 535
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu123 0 0 0 0 0 0 1022723200 616165890 865
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu123 0 0 0 0 0 0 1001242230 372577590 482
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu124 0 0 0 0 0 0 1085378010 879766840 939
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu124 0 0 0 0 0 0 966569660 409064230 543
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu125 0 0 0 0 0 0 1064272780 673730380 910
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu125 0 0 0 0 0 0 1015090880 379873040 546
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu126 0 0 0 0 0 0 1052980350 821785610 866
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu126 0 0 0 0 0 0 1004517820 388610830 507
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
-cpu127 0 0 0 0 0 0 1089387480 667011780 845
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+cpu127 0 0 0 0 0 0 967130520 339113090 485
 domain0 ffffffff,00000000,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain1 ffffffff,ffffffff,00000000,00000000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 domain2 ffffffff,ffffffff,00000000,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+domain3 ffffffff,ffffffff,ffffffff,ffffffff 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


Dietmar Eggemann (1):
  sched/topology: Fix sched_domain_topology_level alloc in
    sched_init_numa()

Valentin Schneider (2):
  sched/topology: Make sched_init_numa() use a set for the deduplicating
    sort
  ia64: ensure proper NUMA distance and possible map initialization

 arch/ia64/kernel/acpi.c  |  7 ++-
 include/linux/topology.h |  1 +
 kernel/sched/topology.c  | 99 +++++++++++++++++++---------------------
 3 files changed, 54 insertions(+), 53 deletions(-)

-- 
2.25.1

