Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5B5B2737
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiIHT5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 15:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiIHT5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 15:57:10 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B486CA50D4
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 12:57:06 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BEE643F1A5
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1662667024;
        bh=+ARAo/cq8zYY0IIK5Gtrzo6xiSMvFEp1heoD4XHj5qQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nEFXAuDJKKgi3e0wqAMU7yI45qY0O/xFYNjA1/P8oOayE5GbOnZlJOO+bydRVUeFj
         1dJnJQ5BIPxNt6DxWC0SprwywSbt1cMjggbHEMDN50BuqAxxLm5tDqT/eDFlhb/ldx
         +cvkhXGGcdhu7m2MWUFMJSz/NFTByq0W25n7vZl/jNfshB1Fdu3KMtsQ68Ih4TBZKA
         JYiwIGF28mP8V4Cy5hDe2u/ynK+eM/X0ggP+0Uwc8A4X2oKR3VP4WFdcYVd2VMXY1P
         C7fzkSmMTjILOFkauXBW3v4mFx9f6qaK7hrlLfXVsYdwLgIUm4sWWHfhvUQEzIBGhv
         0cS8l1g7Bnocg==
Received: by mail-pl1-f198.google.com with SMTP id q6-20020a17090311c600b0017266460b8fso12492005plh.4
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 12:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+ARAo/cq8zYY0IIK5Gtrzo6xiSMvFEp1heoD4XHj5qQ=;
        b=hNTpNr3cwyNYsa52E5dm42lkddpz51TGkMkpjWb1ojtQyQwMW4MSwEYrh9Kdsl7LsI
         f8nSVrfKDB2Y0DGjBRSgJ3CPUYhdtHrQP4QtNoHSmNCC30YjRlwQU1ZMarEF4dILr7Gd
         DBcLxZv+akpiQFeol0H+2l1ZbBXnuBtKvXYydRwk9sZHSgBrmPAjViTB9p6LzAf5fmjq
         vT4s9doLVGwo6n6z2OKaTCF9jMLasSjcDRWOZ/I2E4r8SMFtUl7lchLjQDYDK/Ii4QwB
         3fSDjuXfm6SamQaaMwSpdcW6vQDQkU3zgZ75WzMcIuba7lClvFojYEbCglixzmn6G70v
         XPdA==
X-Gm-Message-State: ACgBeo3Wu7ZZLJk12OUjmILbpoGjmh3e5axEAkbk+YpCN2N3zco1qH4h
        1rebknH1CK9SStYduvurTor9vsJBS4hC1wXUsjdlWiuX8yxnMaXXEu/GpCQsNFNVe4XwTUFezLF
        dY9icXpdyj7iGhZDSrIrVmnmTivn+IO33RA==
X-Received: by 2002:a17:90a:ba01:b0:200:8769:1c34 with SMTP id s1-20020a17090aba0100b0020087691c34mr5893708pjr.0.1662667023362;
        Thu, 08 Sep 2022 12:57:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR46QPj9PknW8Wg131befJx9fQrDjV97NnaOaHJJySPVtOlDJQ8K6xjiAhDXNDZwI66uK+k5+g==
X-Received: by 2002:a17:90a:ba01:b0:200:8769:1c34 with SMTP id s1-20020a17090aba0100b0020087691c34mr5893693pjr.0.1662667023072;
        Thu, 08 Sep 2022 12:57:03 -0700 (PDT)
Received: from luke-ubuntu.buildd (cpe-75-80-146-43.san.res.rr.com. [75.80.146.43])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902684900b00172f6726d8esm14863255pln.277.2022.09.08.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:57:02 -0700 (PDT)
From:   Luke Nowakowski-Krijger <luke.nowakowskikrijger@canonical.com>
To:     kernel-team@lists.ubuntu.com, nicolas.dichtel@6wind.com
Cc:     stable@vger.kernel.org, Edwin Brossette <edwin.brossette@6wind.com>
Subject: [SRU][F][J][PATCH 1/3] ip: fix dflt addr selection for connected nexthop
Date:   Thu,  8 Sep 2022 12:56:20 -0700
Message-Id: <6da58a8a8b3f07050ca2348b376a43347fc7e5e6.1662666093.git.luke.nowakowskikrijger@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1662666093.git.luke.nowakowskikrijger@canonical.com>
References: <cover.1662666093.git.luke.nowakowskikrijger@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

BugLink: https://bugs.launchpad.net/bugs/1988809

When a nexthop is added, without a gw address, the default scope was set
to 'host'. Thus, when a source address is selected, 127.0.0.1 may be chosen
but rejected when the route is used.

When using a route without a nexthop id, the scope can be configured in the
route, thus the problem doesn't exist.

To explain more deeply: when a user creates a nexthop, it cannot specify
the scope. To create it, the function nh_create_ipv4() calls fib_check_nh()
with scope set to 0. fib_check_nh() calls fib_check_nh_nongw() wich was
setting scope to 'host'. Then, nh_create_ipv4() calls
fib_info_update_nhc_saddr() with scope set to 'host'. The src addr is
chosen before the route is inserted.

When a 'standard' route (ie without a reference to a nexthop) is added,
fib_create_info() calls fib_info_update_nhc_saddr() with the scope set by
the user. iproute2 set the scope to 'link' by default.

Here is a way to reproduce the problem:
ip netns add foo
ip -n foo link set lo up
ip netns add bar
ip -n bar link set lo up
sleep 1

ip -n foo link add name eth0 type dummy
ip -n foo link set eth0 up
ip -n foo address add 192.168.0.1/24 dev eth0

ip -n foo link add name veth0 type veth peer name veth1 netns bar
ip -n foo link set veth0 up
ip -n bar link set veth1 up

ip -n bar address add 192.168.1.1/32 dev veth1
ip -n bar route add default dev veth1

ip -n foo nexthop add id 1 dev veth0
ip -n foo route add 192.168.1.1 nhid 1

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> RTNETLINK answers: Invalid argument
> $ ip netns exec foo ping -c1 192.168.1.1
> ping: connect: Invalid argument

Try without nexthop group (iproute2 sets scope to 'link' by dflt):
ip -n foo route del 192.168.1.1
ip -n foo route add 192.168.1.1 dev veth0

Try to get/use the route:
> $ ip -n foo route get 192.168.1.1
> 192.168.1.1 dev veth0 src 192.168.0.1 uid 0
>     cache
> $ ip netns exec foo ping -c1 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.039 ms
>
> --- 192.168.1.1 ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.039/0.039/0.039/0.000 ms

CC: stable@vger.kernel.org
Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Reported-by: Edwin Brossette <edwin.brossette@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20220713114853.29406-1-nicolas.dichtel@6wind.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(backported from commit 747c14307214b55dbd8250e1ab44cad8305756f1)
[lukenow: use dev_hold instead of dev_hold_track as dev_hold_track
requires some debugging infastructure that we don't want to backport]
Signed-off-by: Luke Nowakowski-Krijger <luke.nowakowskikrijger@canonical.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f99ad4a98907d..16fe034615635 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1217,7 +1217,7 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 
 	nh->fib_nh_dev = in_dev->dev;
 	dev_hold(nh->fib_nh_dev);
-	nh->fib_nh_scope = RT_SCOPE_HOST;
+	nh->fib_nh_scope = RT_SCOPE_LINK;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = 0;
-- 
2.34.1

