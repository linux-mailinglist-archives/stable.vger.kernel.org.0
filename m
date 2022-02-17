Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E8B4BAA5D
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbiBQTxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:53:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245574AbiBQTxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:53:30 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF513CEDA
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:53:15 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id x5so6011758wrg.13
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tzdM8F7uXsOjgC9rbmFKRbd7fwtLeTDOHO3LRf4X40s=;
        b=jYCmDGg/tdHFdr4/PI/SPSuLgx805Mvna2o2fvQlfcHgzAZF/iqpuzUJ7WOiDVvLl7
         lZSCcKmIr3rPyOO+hUGJjNumf0aOJolP2yf0u7kbP/rR8N1lVK1PK/9wg8/7lEwMpMiI
         Mp6oZavEyv+6fVEW+Q0IijDmkIg9PapInsbS7aqMQyXOLX1Mo7NvQpblMCnWfD3VmDdZ
         Qu4ev58PbEWjFI0WpZoIgZt97wJ/hpka9t4utXrIR5s2t6zOWa2anIEm7v5tqAogHnRC
         119gJbDoWoGPh32BMLrgJHQDn5d5MKRaOhGdYegNI0/4V8uht9uMQZarpd/OHGtjWYzB
         /fuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tzdM8F7uXsOjgC9rbmFKRbd7fwtLeTDOHO3LRf4X40s=;
        b=iwAOqSMZZ554d5HUB0gQHfULAWzHjjnT7l3SVj7/SHFHt1b55CSTHkaCEekLVD+R7P
         gW0vuia0ecvwGinXh4B0/gLnDU9qErGhYCOCdPvXLOwqWoBWONU8dEb9ZG4nbReOLB6S
         J1gMy5mkGuMlETVRwE4NV8ebWCuo4Dxix6gWO+xIXPV+WP6i8KWa5oDrrE/4o+u07kTs
         jn6LS5HMORiimsB6esEOiiUyBwYsW/BlNXz1sFAQPX1ohblJZw8nho7OazHeQwpOr3/3
         /u1xLI7sFzq+efe+wDh5dgH5/xFFsLp+ZJKymV7AV+4RvD8fCujS7GgoKJqnzkEcROsW
         rr3g==
X-Gm-Message-State: AOAM530N03O9znbTdNhgB82+s2TMLIihaq3e+g6LizWPX0enInDqVD7S
        zDrr7jO6YrHDUQMeoY+D/KY=
X-Google-Smtp-Source: ABdhPJw3dehtCmI8QeFQDfY4k8w8FlRQfDaVs018jNwfQD+2thAf5WtKe88W1s235AsoA39diTK9sQ==
X-Received: by 2002:adf:82ee:0:b0:1e3:e79:9bfb with SMTP id 101-20020adf82ee000000b001e30e799bfbmr3442762wrc.129.1645127593752;
        Thu, 17 Feb 2022 11:53:13 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id x11sm2083597wmi.37.2022.02.17.11.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:53:13 -0800 (PST)
Date:   Thu, 17 Feb 2022 19:53:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     gnault@redhat.com, kuba@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xfrm: Don't accidentally set RTO_ONLINK
 in decode_session4()" failed to apply to 4.9-stable tree
Message-ID: <Yg6npwqf5NQ3HoXJ@debian>
References: <1643030078236210@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="p49kGZYgxtstiNFB"
Content-Disposition: inline
In-Reply-To: <1643030078236210@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p49kGZYgxtstiNFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 02:14:38PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--p49kGZYgxtstiNFB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfrm-Don-t-accidentally-set-RTO_ONLINK-in-decode_ses.patch"

From 1742fa1b8c81d3a20bb9cf812d4b3015800c1ebe Mon Sep 17 00:00:00 2001
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
index 1805413cd225..0f405045dcd8 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -16,6 +16,7 @@
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/l3mdev.h>
+#include <net/inet_ecn.h>
 
 static struct xfrm_policy_afinfo xfrm4_policy_afinfo;
 
@@ -123,7 +124,7 @@ _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
-- 
2.30.2


--p49kGZYgxtstiNFB--
