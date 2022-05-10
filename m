Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2103F520D4A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 07:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiEJFvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 01:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiEJFvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 01:51:13 -0400
Received: from mail-pl1-x662.google.com (mail-pl1-x662.google.com [IPv6:2607:f8b0:4864:20::662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF238712F3
        for <stable@vger.kernel.org>; Mon,  9 May 2022 22:47:15 -0700 (PDT)
Received: by mail-pl1-x662.google.com with SMTP id n18so15840576plg.5
        for <stable@vger.kernel.org>; Mon, 09 May 2022 22:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:to:subject:user-agent
         :content-transfer-encoding:message-id:from;
        bh=fP0P8qBKnwzuOi6hOGO8T9UgfCRJBw+0ZsQEoJ1TaGU=;
        b=qDy212kZ6RW78vfpSdqUz0D+UrrBKVU8FV3RRRXQAnVUJ6ICyNz520K/VAkZoC7f+P
         YZtVdzu4zgW6s5ww7lOde2WzVmJD6RdxyfnL9aBDPg6E4ePIe9UOOwTu/Tf0qBxY6Ooo
         EjLqEZLAudzEEcNZzcYYOqJXuPoxYoU4RcCfrKOH8PXA8WG2NayerrM4pi9EifSuc71I
         8CDr3HD8H9wzLoK7O6lt9zfRpbllzh0msWgg8N6y6T0SqP7IzPBjNQIv9kTgj1PWh5aJ
         Sa36UQrvHK21wPobdMxS+mXI4+ViwynfCo5cThdH4gVoVQl1WFwROBIFdf+RtyKoxt+d
         xFUA==
X-Gm-Message-State: AOAM530NHGxP1JCTgdw9XyydMUtT2IM/GoYfseAhdOsDNY4c7D54OS2F
        mPTANULlGgqjGi1RUf9rhaF0QiOS8u0CFOFU84wPBmVvaQ5i
X-Google-Smtp-Source: ABdhPJxtV+poFfheMEPdeibspO6HuX1df8ceBGd4avXU6v3y5Ewvm2Bm8vSYRVPZg7cEy2eUozJCj9lsz6tJ
X-Received: by 2002:a17:903:32c6:b0:15e:c1cc:2400 with SMTP id i6-20020a17090332c600b0015ec1cc2400mr19317899plr.153.1652161635351;
        Mon, 09 May 2022 22:47:15 -0700 (PDT)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id r21-20020a170902ea5500b0015e8d4e86a5sm143707plg.113.2022.05.09.22.47.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 May 2022 22:47:15 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from us226.sjc.aristanetworks.com (us226.sjc.aristanetworks.com [10.243.208.9])
        by smtp.aristanetworks.com (Postfix) with ESMTP id EB07350EBE9;
        Mon,  9 May 2022 22:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1652161634;
        bh=fP0P8qBKnwzuOi6hOGO8T9UgfCRJBw+0ZsQEoJ1TaGU=;
        h=Date:To:Subject:From:From;
        b=UISwcvx+W8J1IDF+OB/wEqVCsht5sdFKKoHdctSeLaxZ98U+Dqz0hlfDVcAKdGl/w
         HakPvgHR02GE7W628aV2+Kp1GGvz8MNQOWh1JmYEiIbt9OMeKw6TiMdbaTkBiKLxar
         Blhx/vDir6CFluD6lxhJVntMYxdpzRafGY5vIED7QYhXwPg/LvJwSfgJM8Gm5GKrUG
         JDKeSCRp1YnnRDquMZ4iULwt5r/TPAFkGgt5H2VYSNOMFNcPaUIvPqu03TTg6RxtJ+
         qrJ/+HgUanYbvDoAOwXbmaBdf8O5mmklRTVF46A7kfi1Y5cC3yZpBw/5uyQagquRP7
         IAr4TkuMy5TVg==
Received: by us226.sjc.aristanetworks.com (Postfix, from userid 10189)
        id C57685EC15DB; Mon,  9 May 2022 22:47:14 -0700 (PDT)
Date:   Mon, 09 May 2022 22:47:14 -0700
To:     stable@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fruggeri@arista.com
Subject: [PATCH stable-v4.19 net] tcp: make sure treq->af_specific is
 initialized
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20220510054714.C57685EC15DB@us226.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ba5a4fdd63ae0c575707030db0b634b160baddd7 ]

syzbot complained about a recent change in TCP stack,
hitting a NULL pointer [1]

tcp request sockets have an af_specific pointer, which
was used before the blamed change only for SYNACK generation
in non SYNCOOKIE mode.

tcp requests sockets momentarily created when third packet
coming from client in SYNCOOKIE mode were not using
treq->af_specific.

Make sure this field is populated, in the same way normal
TCP requests sockets do in tcp_conn_request().

[1]
TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending cookies.  Check SNMP counters.
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 3695 Comm: syz-executor864 Not tainted 5.18.0-rc3-syzkaller-00224-g5fd1fe4807f9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcp_create_openreq_child+0xe16/0x16b0 net/ipv4/tcp_minisocks.c:534
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e5 07 00 00 4c 8b b3 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7e 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c9 07 00 00 48 8b 3c 24 48 89 de 41 ff 56 08 48
RSP: 0018:ffffc90000de0588 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888076490330 RCX: 0000000000000100
RDX: 0000000000000001 RSI: ffffffff87d67ff0 RDI: 0000000000000008
RBP: ffff88806ee1c7f8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87d67f00 R11: 0000000000000000 R12: ffff88806ee1bfc0
R13: ffff88801b0e0368 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f517fe58700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcead76960 CR3: 000000006f97b000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 tcp_v6_syn_recv_sock+0x199/0x23b0 net/ipv6/tcp_ipv6.c:1267
 tcp_get_cookie_sock+0xc9/0x850 net/ipv4/syncookies.c:207
 cookie_v6_check+0x15c3/0x2340 net/ipv6/syncookies.c:258
 tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1131 [inline]
 tcp_v6_do_rcv+0x1148/0x13b0 net/ipv6/tcp_ipv6.c:1486
 tcp_v6_rcv+0x3305/0x3840 net/ipv6/tcp_ipv6.c:1725
 ip6_protocol_deliver_rcu+0x2e9/0x1900 net/ipv6/ip6_input.c:422
 ip6_input_finish+0x14c/0x2c0 net/ipv6/ip6_input.c:464
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:473
 dst_input include/net/dst.h:461 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x27f/0x3b0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5847
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097

Fixes: 5b0b9e4c2c89 ("tcp: md5: incorrect tcp_header_len for incoming connections")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[fruggeri: Account for backport conflicts from 35b2c3211609 and 6fc8c827dd4f]
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 include/net/tcp.h     | 5 +++++
 net/ipv4/syncookies.c | 1 +
 net/ipv4/tcp_ipv4.c   | 2 +-
 net/ipv6/syncookies.c | 1 +
 net/ipv6/tcp_ipv6.c   | 2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3f0d654984cf..c838dd7b326c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1938,6 +1938,11 @@ struct tcp_request_sock_ops {
 			   enum tcp_synack_type synack_type);
 };
 
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
+#if IS_ENABLED(CONFIG_IPV6)
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops;
+#endif
+
 #ifdef CONFIG_SYN_COOKIES
 static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
 					 const struct sock *sk, struct sk_buff *skb,
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 1a06850ef3cc..929f989de1f6 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -337,6 +337,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
+	treq->af_specific	= &tcp_request_sock_ipv4_ops;
 	treq->rcv_isn		= ntohl(th->seq) - 1;
 	treq->snt_isn		= cookie;
 	treq->ts_off		= 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c9fc6e3868be..2719c60f285b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1372,7 +1372,7 @@ struct request_sock_ops tcp_request_sock_ops __read_mostly = {
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.mss_clamp	=	TCP_MSS_DEFAULT,
 #ifdef CONFIG_TCP_MD5SIG
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index ec61b67a92be..ca291e342900 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -181,6 +181,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
+	treq->af_specific = &tcp_request_sock_ipv6_ops;
 	treq->tfo_listener = false;
 
 	if (security_inet_conn_request(sk, skb, req))
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c332f75f4e9a..c9ba827aded2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -789,7 +789,7 @@ struct request_sock_ops tcp6_request_sock_ops __read_mostly = {
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.mss_clamp	=	IPV6_MIN_MTU - sizeof(struct tcphdr) -
 				sizeof(struct ipv6hdr),
 #ifdef CONFIG_TCP_MD5SIG
-- 
2.28.0


