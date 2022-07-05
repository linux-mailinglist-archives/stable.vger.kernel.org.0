Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639B6566B29
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiGEMEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiGEMDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:03:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB2183B5;
        Tue,  5 Jul 2022 05:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDC2618BB;
        Tue,  5 Jul 2022 12:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB63EC341C7;
        Tue,  5 Jul 2022 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022629;
        bh=tBysG5slX1gmz22KZWHuypWFecdUfpb8HUCfdcMG+6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szulpqWdonnlMKUMPkbU+sko992NBTM2kDnaZl2tEpG1ZMGIf7dU3T0sMQFZnL9ix
         gYXc0DGf5a37iyZtSbMIRVG6VvGaFVPUJNPyIcgua/9ZKTZuxyqKuAvRwJXGEGBl18
         TdcwJCy+aJybsqkCny6M1kXtrw6CmHB/1rnpXMfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, willemb@google.com,
        Dimitris Michailidis <dmichail@fungible.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 12/58] selftests/net: pass ipv6_args to udpgso_benchs IPv6 TCP test
Date:   Tue,  5 Jul 2022 13:57:48 +0200
Message-Id: <20220705115610.607118418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dimitris Michailidis <d.michailidis@fungible.com>

commit b968080808f7f28b89aa495b7402ba48eb17ee93 upstream.

udpgso_bench.sh has been running its IPv6 TCP test with IPv4 arguments
since its initial conmit. Looks like a typo.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Cc: willemb@google.com
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20220623000234.61774-1-dmichail@fungible.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/udpgso_bench.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -120,7 +120,7 @@ run_all() {
 	run_udp "${ipv4_args}"
 
 	echo "ipv6"
-	run_tcp "${ipv4_args}"
+	run_tcp "${ipv6_args}"
 	run_udp "${ipv6_args}"
 }
 


