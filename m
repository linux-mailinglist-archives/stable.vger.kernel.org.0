Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B246456D7CC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiGKIZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 04:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiGKIZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 04:25:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87091A82A
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 01:25:47 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c13so3831988pla.6
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 01:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfKZelDEKWOxb6s9bGx6/ZVERD4nGU2QPmmidfnMsJQ=;
        b=XqvTpumkyG0CTvrWFdn3OaCSSJaMLs+KB8p0njggRNVyzT0FZPjx3waJfgbH/p3wox
         mi1XuywC2DPytUxwhJuPIaXBZwIgaQmRpZmKoGxcTNdlspO520/tdFA5YGl89oBdwWD0
         MRmVoJsbtF4xP4QCwcXGNJbXXTRnH2AvUZzxU2ilBCgGnVJqmgp1nGE9SdeJ+/rM+diF
         RXmVQOkUuxirHecifTa6Fip1LpGjjZFQmVNIleFP3FwmfRYG1F3PPmbSdRCmuGB0SOlp
         iFsidm2uWYYJx+NqShwkXYPy0rZdCfWbC+eBBHtX6rWDH8g7uEvNYLwpBwx2XySQLTUs
         CHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfKZelDEKWOxb6s9bGx6/ZVERD4nGU2QPmmidfnMsJQ=;
        b=ldjPdyj6Hf7cUGJK6e1xWn8ZXqdJB3C5hZUtvv0ndBAs6iWFz1DTT8rfS5rH6JatV5
         C8R4gHOBG0yLdasgt8+tIFOLkknOC76zS4/h5tnj7dI2qQsVO1aCISqlWMvkemFJDGPy
         yv822QUjNaY6pfRcswYpvMJp5X237RuFbGv1CnK45APjbn2BJAEVIdodpYqAQK0h0oZT
         0AhagIQ/KMDtuf0a5nWIqM8EiqvizphkLSo2fTkg3wQe4meYCzHAWGh63SZPNBdgbD9Y
         WGJPaEexe85UKmQFg+XeQ6i7JawI1NAx8B9wqSA6KSp3/gKcbukcm6tNYzXw7AmGFWz9
         CIdQ==
X-Gm-Message-State: AJIora+ly9HjbjCTd9oFVwjOWUOPXDXtEmsDfQr2x5j2aKPTlz/rps7k
        JXLxpxDQ1Qx3eFJ63JLckZfGX3XLpnA=
X-Google-Smtp-Source: AGRyM1vkmrl0DiOen6WER2ofd8c3XmY9D6OXUbmwPPhlwqbfQQXqjEfX1uDS+tGGFig005vxTwJnmw==
X-Received: by 2002:a17:90a:1782:b0:1ef:cc5c:411a with SMTP id q2-20020a17090a178200b001efcc5c411amr16894358pja.147.1657527947072;
        Mon, 11 Jul 2022 01:25:47 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z24-20020aa79498000000b0052542cbff9dsm4288087pfk.99.2022.07.11.01.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 01:25:46 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrii@kernel.org, kuba@kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 5.15-stable] selftests/net: fix section name when using xdp_dummy.o
Date:   Mon, 11 Jul 2022 16:25:38 +0800
Message-Id: <20220711082538.38608-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d28b25a62a47a8c8aa19bd543863aab6717e68c9 upstream.

Conflicts: there is no udpgro_frglist.sh as we haven't backport
edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
to 5.15-stable tree.

Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
selftests") the xdp_dummy.o's section name has changed to xdp. But some
tests are still using "section xdp_dummy", which make the tests failed.
Fix them by updating to the new section name.

Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20220630062228.3453016-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh       | 2 +-
 tools/testing/selftests/net/udpgro_bench.sh | 2 +-
 tools/testing/selftests/net/udpgro_fwd.sh   | 2 +-
 tools/testing/selftests/net/veth.sh         | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index f8a19f548ae9..ebbd0b282432 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -34,7 +34,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 }
 
 run_one() {
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 820bc50f6b68..fad2d1a71cac 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -34,7 +34,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6f05e06f6761..1bcd82e1f662 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -46,7 +46,7 @@ create_ns() {
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
 	done
-	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 }
 
 create_vxlan_endpoint() {
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 19eac3e44c06..430895d1a2b6 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -289,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
 	printf "%-60s" "bad setting: XDP with RX nr less than TX"
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null &&\
+		section xdp 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
 
 	# the following tests will run with multiple channels active
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
 	ip netns exec $NS_DST ethtool -L veth$DST rx 2
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null
+		section xdp 2>/dev/null
 	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
@@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
 	chk_channels "setting invalid channels nr" $DST 2 2
 fi
 
-ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off
-- 
2.35.1

