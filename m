Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EDE478C9D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhLQNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbhLQNqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:46:19 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649AC06173E
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:46:18 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id z4-20020a1c7e04000000b0032fb900951eso4073179wmc.4
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdKVRQTB+ygcPjQqeQ7Uxm2NcgP8laoI/9TsYcZNS9w=;
        b=DUW+cyeDI6wHrdi4GMphNgO5DojVLDkHGvh4gFYbTV0tmGsOxum2QHDdHIS9vZjxHv
         4ZrzDyQF/q9E90+mXRuT6UP4BTLE0zn8Vc4E7BMgD2MCILZx6cWazOT8KSbnh1uKyh78
         wr70yhlsyD7OcKFReS1nEXBLEDeZFhOq/nV5BwIlqu9476RfPsBtIGZ1CCmgDvAIDrco
         IbxAFy/myCRdg5TcWz2hIrN55yOCisyE2JmOZ/22svz5ZnSAVcDo5gc8I+ApRTv8oL8t
         Gpm6Amm0UGsK6JbP51pni+cv0V/UpeC0xypsPVjU3WTPlUsTKPdyeSoSe3NS/wa98fGs
         WNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdKVRQTB+ygcPjQqeQ7Uxm2NcgP8laoI/9TsYcZNS9w=;
        b=xkNZ7WJHcSn4lRXK3Jpv65c+HPAOr+QPfXQJ9CvLeeRal2XgFCU3oPmrlgfd57Zn7y
         +bXMlUdEQu+kEGJSX+y970LGzAfIuSO/qNaR3JRGUwRKj9Ipx+fNKv42DP0SLWp4L4we
         RUrrVq8kdP/aL2SYyRB8d/66v/9pgbgkHagVaZ8v1qZf5D6eEGaiRLDePQxnnNwKMIS8
         51/Y9AeAKjs+9PBtPBUH0fkfchcSiWyA14g0xFd63nr39gFLBGgLQcV12+715dp2Jfg/
         Z2oxt526p6/gNbQfBC7oWzoS3kwSmCdx860t/pME6MGpXHwy25viQToZh8Jpvs4wzhZ7
         x8ZQ==
X-Gm-Message-State: AOAM531yfL8Tzis2LxuCMm+c0lqj/MkgXKVTYHLG0cigSNMX+oRbI6jW
        bSZ1KGOtxSJBniBfLgE9e2DiwQ==
X-Google-Smtp-Source: ABdhPJxPABnhfoXnPdWLJk3MEqNDzo8El3vuW8EAIjvwdW+3eOgGsQc/P/OmQDfwN98DkfwHNYmEkA==
X-Received: by 2002:a05:600c:3b8f:: with SMTP id n15mr9811764wms.180.1639748777246;
        Fri, 17 Dec 2021 05:46:17 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id a22sm7106009wme.19.2021.12.17.05.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 05:46:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and return incremented endpoint
Date:   Fri, 17 Dec 2021 13:46:06 +0000
Message-Id: <20211217134607.74983-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

net/sctp/diag.c for instance is built into its own separate module
(sctp_diag.ko) and requires the use of sctp_endpoint_{hold,put}() in
order to prevent a recently found use-after-free issue.

In order to prevent data corruption of the pointer used to take a
reference on a specific endpoint, between the time of calling
sctp_endpoint_hold() and it returning, the API now returns a pointer
to the exact endpoint that was incremented.

For example, in sctp_sock_dump(), we could have the following hunk:

	sctp_endpoint_hold(tsp->asoc->ep);
	ep = tsp->asoc->ep;
	sk = ep->base.sk
	lock_sock(ep->base.sk);

It is possible for this task to be swapped out immediately following
the call into sctp_endpoint_hold() that would change the address of
tsp->asoc->ep to point to a completely different endpoint.  This means
a reference could be taken to the old endpoint and the new one would
be processed without a reference taken, moreover the new endpoint
could then be freed whilst still processing as a result, causing a
use-after-free.

If we return the exact pointer that was held, we ensure this task
processes only the endpoint we have taken a reference to.  The
resultant hunk now looks like this:

        ep = sctp_endpoint_hold(tsp->asoc->ep);
	sk = ep->base.sk
	lock_sock(sk);

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: lksctp developers <linux-sctp@vger.kernel.org>
Cc: "H.P. Yarroll" <piggy@acm.org>
Cc: Karl Knutson <karl@athena.chicago.il.us>
Cc: Jon Grimm <jgrimm@us.ibm.com>
Cc: Xingang Guo <xingang.guo@intel.com>
Cc: Hui Huang <hui.huang@nokia.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Daisy Chang <daisyc@us.ibm.com>
Cc: Ryan Layer <rmlayer@us.ibm.com>
Cc: Kevin Gao <kevin.gao@intel.com>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 8f840e47f190c ("sctp: add the sctp_diag.c file")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/net/sctp/structs.h | 2 +-
 net/sctp/endpointola.c     | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 651bba654d77d..78d71ca56452b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1380,7 +1380,7 @@ static inline struct sctp_endpoint *sctp_ep(struct sctp_ep_common *base)
 struct sctp_endpoint *sctp_endpoint_new(struct sock *, gfp_t);
 void sctp_endpoint_free(struct sctp_endpoint *);
 void sctp_endpoint_put(struct sctp_endpoint *);
-void sctp_endpoint_hold(struct sctp_endpoint *);
+struct sctp_endpoint *sctp_endpoint_hold(struct sctp_endpoint *);
 void sctp_endpoint_add_asoc(struct sctp_endpoint *, struct sctp_association *);
 struct sctp_association *sctp_endpoint_lookup_assoc(
 	const struct sctp_endpoint *ep,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 48c9c2c7602f7..bdbf74fc7eb4c 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -222,10 +222,12 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 }
 
 /* Hold a reference to an endpoint. */
-void sctp_endpoint_hold(struct sctp_endpoint *ep)
+struct sctp_endpoint *sctp_endpoint_hold(struct sctp_endpoint *ep)
 {
 	refcount_inc(&ep->base.refcnt);
+	return ep;
 }
+EXPORT_SYMBOL_GPL(sctp_endpoint_hold);
 
 /* Release a reference to an endpoint and clean up if there are
  * no more references.
@@ -235,6 +237,7 @@ void sctp_endpoint_put(struct sctp_endpoint *ep)
 	if (refcount_dec_and_test(&ep->base.refcnt))
 		sctp_endpoint_destroy(ep);
 }
+EXPORT_SYMBOL_GPL(sctp_endpoint_put);
 
 /* Is this the endpoint we are looking for?  */
 struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *ep,
-- 
2.34.1.173.g76aa8bc2d0-goog

