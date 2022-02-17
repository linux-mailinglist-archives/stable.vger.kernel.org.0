Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4914BAA54
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbiBQTwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:52:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbiBQTwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:52:38 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA064D9EC
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:52:23 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m126-20020a1ca384000000b0037bb8e379feso7007038wme.5
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A3C8J86bxGYWJFqq6KhOj0GowL/xre8Vk3Bj14zu+nE=;
        b=KzfB+efE6r78i9rDM7X7X7UbQTBHQH55x363hzbvqwGgI7vELDCwyd/FqVBmYXrum7
         Ym+89GRZrlpwgZZtVjzTOgrBVq5j0jpBcm7V2J3mg54Gu0CMf9tE5Xy+GmUr16iAVj6W
         Rz+4FWiUIvnSqouWvEP9Y61J4ZEoaGLiMTc/a5ugZHh6MzfnSiqLJpGUiwPIacRh2kwh
         iQEPjYNqZW+6/IZgu+fJvxW7axlY/92+z+qDZaO9bceyeAFwNFoMhqf6brGtXSLdD7Dy
         rL2+TbmiOxSSyLq8DW4f37wQvO/GOya2umgbZ3TfQSIWHSqIkm9qsFiS6lp6ZK+9JQto
         E/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A3C8J86bxGYWJFqq6KhOj0GowL/xre8Vk3Bj14zu+nE=;
        b=5aToCQJvJCTrV9pHtksC8Ex+KgldN5K5+dqSt+iTnK7wyAfTV9/ADWLfeTesXXU6Pg
         HB+x/qifHgdWUm/fuzXbl5veLyu9+229OF5KYlC8IxMP15zxECpH5uaBS0JJAIjCCNWS
         7viwtnuNxMZi5EVcQEwl5Vqi6YrM83yL1GY7JBr15MpXxquRZZYP5LLRj78V23uVBLkc
         S5LQIbxrpEC1B2PWoMY+ZfZYiUFxPReFvs6M5wQumN5c685/3BgF6vlB6/jjh3VPHzRD
         +/0bSbV41G9iXTpbSJ7cKo2BLvGmYGKe2TMICOpJUnrr4mKeIG9kw4M725lpV1Viajfo
         Fpbw==
X-Gm-Message-State: AOAM530jHIvPwFXMvvWJA5fpzWDaak/fOTLTv7hFZKQMPwlkPyw71mW5
        KSdhg2t/5woyx3H/OOOqt4s=
X-Google-Smtp-Source: ABdhPJyV4MSHxGDGE2oLdVhyAuDubpR4BZuM4xLZt05rR9BcV9maYlOB/YPfPuSaSqW/CM6bN503qg==
X-Received: by 2002:a05:600c:3589:b0:37b:b9fb:f939 with SMTP id p9-20020a05600c358900b0037bb9fbf939mr4051232wmq.188.1645127541929;
        Thu, 17 Feb 2022 11:52:21 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id h10sm32360180wrt.57.2022.02.17.11.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:52:21 -0800 (PST)
Date:   Thu, 17 Feb 2022 19:52:19 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     gnault@redhat.com, kuba@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xfrm: Don't accidentally set RTO_ONLINK
 in decode_session4()" failed to apply to 4.19-stable tree
Message-ID: <Yg6nc3i9iRjyoPvF@debian>
References: <16430300795760@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uj/36KpsijIkZEvX"
Content-Disposition: inline
In-Reply-To: <16430300795760@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uj/36KpsijIkZEvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 02:14:39PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply to 4.14-stable.

--
Regards
Sudip

--uj/36KpsijIkZEvX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfrm-Don-t-accidentally-set-RTO_ONLINK-in-decode_ses.patch"

From c9e2825e4424bff39816b7e23625718aead28982 Mon Sep 17 00:00:00 2001
From: Guillaume Nault <gnault@redhat.com>
Date: Mon, 10 Jan 2022 14:43:06 +0100
Subject: [PATCH] xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

commit 23e7b1bfed61e301853b5e35472820d919498278 upstream.

Similar to commit 94e2238969e8 ("xfrm4: strip ECN bits from tos field"),
clear the ECN bits from iph->tos when setting ->flowi4_tos.
This ensures that the last bit of ->flowi4_tos is cleared, so
ip_route_output_key_hash() isn't going to restrict the scope of the
route lookup.

Use ~INET_ECN_MASK instead of IPTOS_RT_MASK, because we have no reason
to clear the high order bits.

Found by code inspection, compile tested only.

Fixes: 4da3089f2b58 ("[IPSEC]: Use TOS when doing tunnel lookups")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[sudip: manually backport to previous location]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 net/ipv4/xfrm4_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 1e5e2e4be0b2..e85b5f57d3e9 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -17,6 +17,7 @@
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/l3mdev.h>
+#include <net/inet_ecn.h>
 
 static struct dst_entry *__xfrm4_dst_lookup(struct net *net, struct flowi4 *fl4,
 					    int tos, int oif,
@@ -126,7 +127,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
-- 
2.30.2


--uj/36KpsijIkZEvX--
