Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF28052022B
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 18:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbiEIQYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 12:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiEIQYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 12:24:39 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C2C1BEB0
        for <stable@vger.kernel.org>; Mon,  9 May 2022 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1652113240;
        bh=XCF0lJ2Jqe0cXlQXdrdCTstcW4Ef6Zw2obIAjHTKvOs=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=B7CtrPR0zbUfqbFVC0GwICfall3buju1l2w+lUH2mvdNlC06wrBK7OagBiUZ+TmzQ
         3QLR7wUdyxr71QzNJF+XI3cfEZr+jrrCZKlrbEDyvhwujkV55NVhVhY3Koe77Gdj9X
         jlrcTW/AL/huix3C9UzunvpCQATHS64BVQqPrQxY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from p100 ([92.116.155.173]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MiJV6-1oKez81KgY-00fVTd; Mon, 09
 May 2022 18:20:40 +0200
Date:   Mon, 9 May 2022 18:20:38 +0200
From:   Helge Deller <deller@gmx.de>
To:     gregkh@linuxfoundation.org
Cc:     deller@gmx.de, dave.anglin@bell.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "parisc: Mark sched_clock unstable
 only if clocks are" failed to apply to 5.15-stable tree
Message-ID: <Ynk/VkI7WQcf9bmw@p100>
References: <16520837712276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16520837712276@kroah.com>
X-Provags-ID: V03:K1:wbErPZX9NqMD3H57KDuwvSv1+xcIT/1MWnTSsvq9DSlI/amlDsH
 zMbcedmIr0svG7YRHN0GviD+50HqPFSEO8u8vuwuHlcL0yBZdRxzbFffbV3gr0vmf+N4z45
 IVGNePshBR7okbmUxj9mPKB5Dm9c5kEO+OmHA0Y2/UFiLETOEpyqDQJG+K3rraIhZVOoOU8
 0RigcsLwJK+PBz+NOHSYw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ET4Lovazr6s=:9mWRAZEpjZhV13eaurWTvW
 2lUEs/oIL9xe0nWX1FYOyODW9KmlemmGQ7yyMchZgVq+CA2/LgX3nH3nHOO8HvMeWOPODgtCp
 ikqbxT3ALWDdbFXiRqqcaTQiPVIOjQfVKRt9WRWuzHTEmbCfwBpQZDV+MOd83+UVdNXfV4bAt
 Ei+O0hd60Dmpj6CIb4SRNXg9OEuwxaXwa0gBa9+JGLxwB4xzjxjMXn3cy+IgSN+T0n86t8//S
 uz5JQDzNNUrC/l/luZIA89oP62LKd+9NGGnyEbtpiECI7aAe7Fg/vpNFR9LWFa1dnyOkyF4x5
 cC2s56U6mqokv2WCvE7kINl/uCHhTpX/8sqtZLr+vZCHjTcrmX3565aG7+eNbXgphfMdf6i20
 16D9ZWLaO/oKZj9Jt8WLw2uXkFTXo9gw31/56YGCiRvbbEfZD9XWsH0AGKt/kpiNQf3C0ZvEg
 maTPwU1BPjyUy3lNVwOyXNd635QAvBaUOPii0u7uMhiBS8oguznmENujHXtpc1UV/qlD5DHTB
 Gug/Ff5t8gJBBngg284tp3uAd3PlJ6Yd5X1HjbmWU8rz64a9T2t34lc4US7jVNq65lIRKpJEH
 TC6hMhZvfIIja5CfJlL1m6tionagollVLRrelPmVlJyzH0xs+lEOlBUHH0FPjmPgN/JameD9A
 1hiFRHFBN0W6iZXmZUDnR6AHN/j2+DFbSfKDrQ1WO7VV+wayknGgZWvKJkOlJYztMAPv4F46K
 24DE/O/QWp+or2NRMVam7NeWfM3uMkg77eM4PIlh7K0GFPkW3/thNu1HaBJrD9Y5SVnQK4L5N
 S/zbTzK4cPDE+XP501GoiZxRgUnd7uVXKLhWo4ldd1mg3OafVtuBwqFv8LiwOyLZVEDBoTxgL
 uUwYs0FJO0gfxwFDFV2ofsfBrb/35AIDlCpHsG9EIz92CQTHauS6ASCB0e55DBWYZ9OlNbXX6
 7C4ueQg0tuSLEs+ISqfL4Bx1AONZnXAh/1360AEuqw8OU7yngTOzno9vEYUuX9fJP5k7L485U
 elMn1RQVpLB9QuSBZTrEyBhl6A54hPfyzmpRclfd5KZPgh7nBFqCkVjkuaD6wO2h/GOi5KTRZ
 e9yMQpIsR4p7pI=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

* gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>:
>
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Please apply below patch instead to v5.15-stable.

Thanks!
Helge


=46rom 7dacfca67135dc703df89d273553d8f5259776ce Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Mon, 9 May 2022 18:13:29 +0200
Subject: [PATCH] Revert "parisc: Mark sched_clock unstable only if clocks =
are
 not syncronized"

This backport reverts clock changes which made the Linux internal clock
unreliable on 32- and 64-bit SMP kernels.
This patch brings the clock code in sync with upstream v5.18-rc6.

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: John David Anglin <dave.anglin@bell.net>

diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index cceb09855e03..3fb86ee507dd 100644
=2D-- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -150,6 +150,8 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_PA11
 	dma_ops_init();
 #endif
+
+	clear_sched_clock_stable();
 }

 /*
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 061119a56fbe..d8e59a1000ab 100644
=2D-- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -249,13 +249,9 @@ void __init time_init(void)
 static int __init init_cr16_clocksource(void)
 {
 	/*
-	 * The cr16 interval timers are not syncronized across CPUs, even if
-	 * they share the same socket.
+	 * The cr16 interval timers are not synchronized across CPUs.
 	 */
 	if (num_online_cpus() > 1 && !running_on_qemu) {
-		/* mark sched_clock unstable */
-		clear_sched_clock_stable();
-
 		clocksource_cr16.name =3D "cr16_unstable";
 		clocksource_cr16.flags =3D CLOCK_SOURCE_UNSTABLE;
 		clocksource_cr16.rating =3D 0;
