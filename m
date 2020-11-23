Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F342C0261
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgKWJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:39:20 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:45475 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbgKWJjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:39:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D797919434DD;
        Mon, 23 Nov 2020 04:39:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=b0PaRp
        WBp428NJCBK4gDdtGLs0HWY4N/tWsgJFumzQc=; b=TFl4LIvqNU4d4MimQDWuVg
        2bZvsXfBhFQy+lINxqrgjTd5TTOAk+bRd+52jRGF+vF1L9TJS18xPTa86z2AAw8Q
        V4EUIGy6xJHwmGZ6F1dh6AELy3lXBkq1jc+Czd1KwhyNp5wp3j9dgiB2dbv8/gSZ
        a4VgtBfvABZpZGlleNTOxOpHqDMwYz3NQSre5EYaPokCtCGeKUDq0urFoIeev7Yv
        Vr9FygjGNYj7aqM/KfS72EzyQacSicw+IVB6Ap+XR0TN11pQsdRkhOOOCYUd4t0u
        HqN0qMi6qgzvLnJvXvbb3eLAGr/bB6oZB7egKLaXicu6ReZXCHqFpY0FFyszCCWg
        ==
X-ME-Sender: <xms:RoO7X19wwLvd3SKURCLqZ-0JGfOkmaKnxEwLOnM-G-9se3vnikZZtw>
    <xme:RoO7X5tObxf9DbjUe7kSl3tMfz9TV3GdRNbAZUGD6q12DmmJ4aR9OL4YYbZqeWKYn
    Oiuu6X1PZO77w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhephfeukedvheelleeigfehfeehgffggeelvdffhfekhe
    etgeduuefhveffgfeiieelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpvdejrdhs
    ohenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RoO7XzASSNNIMjV7p2JE8PyPHphceIHVzAckQjEkCYsC-e2ll4quQg>
    <xmx:RoO7X5dKKl83skVpl4QlCNBm6B5BJc1bQmxcBhauIiHBCSdLzjvx_g>
    <xmx:RoO7X6MwfXVNXn49A2Xkl9F_vAO2yBLEPIQZ4bySxN0AcCckgYAiqQ>
    <xmx:RoO7X7ExbYk5144rjEz0qaZSP9JvHgvs536Q5hdk1ssePtMfWpl9-tA_6x0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8D483064AA7;
        Mon, 23 Nov 2020 04:39:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf test: Update branch sample pattern for cs-etm" failed to apply to 5.9-stable tree
To:     leo.yan@linaro.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, coresight@lists.linaro.org,
        jolsa@redhat.com, mark.rutland@arm.com, mathieu.poirier@linaro.org,
        mike.leach@linaro.org, namhyung@kernel.org, peterz@infradead.org,
        suzuki.poulose@arm.com, yao.jin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:40:29 +0100
Message-ID: <1606124429115169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dd94ac807a5e10e0b25b68397c473276905cca73 Mon Sep 17 00:00:00 2001
From: Leo Yan <leo.yan@linaro.org>
Date: Tue, 10 Nov 2020 14:34:17 +0800
Subject: [PATCH] perf test: Update branch sample pattern for cs-etm

Since the commit 943b69ac1884 ("perf parse-events: Set exclude_guest=1
for user-space counting"), 'exclude_guest=1' is set for user-space
counting; and the branch sample's modifier has been altered, the sample
event name has been changed from "branches:u:" to "branches:uH:", which
gives out info for "user-space and host counting".

But the cs-etm testing's regular expression cannot match the updated
branch sample event and leads to test failure.

This patch updates the branch sample pattern by using a more flexible
expression '.*' to match branch sample's modifiers, so that allows the
testing to work as expected.

Fixes: 943b69ac1884 ("perf parse-events: Set exclude_guest=1 for user-space counting")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: coresight ml <coresight@lists.linaro.org>
Cc: stable@kernel.org
Link: http://lore.kernel.org/lkml/20201110063417.14467-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/tests/shell/test_arm_coresight.sh b/tools/perf/tests/shell/test_arm_coresight.sh
index 59d847d4981d..18fde2f179cd 100755
--- a/tools/perf/tests/shell/test_arm_coresight.sh
+++ b/tools/perf/tests/shell/test_arm_coresight.sh
@@ -44,7 +44,7 @@ perf_script_branch_samples() {
 	#   touch  6512          1         branches:u:      ffffb22082e0 strcmp+0xa0 (/lib/aarch64-linux-gnu/ld-2.27.so)
 	#   touch  6512          1         branches:u:      ffffb2208320 strcmp+0xe0 (/lib/aarch64-linux-gnu/ld-2.27.so)
 	perf script -F,-time -i ${perfdata} | \
-		egrep " +$1 +[0-9]+ .* +branches:([u|k]:)? +"
+		egrep " +$1 +[0-9]+ .* +branches:(.*:)? +"
 }
 
 perf_report_branch_samples() {

