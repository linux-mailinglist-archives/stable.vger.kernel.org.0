Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D313C3CBB
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKNJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:09:01 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53961 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhGKNJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:09:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 796AE1AC106A;
        Sun, 11 Jul 2021 09:06:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 11 Jul 2021 09:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v61GIK
        JzPYYyF6cqqN1Beri6MmWG95b6Y/8/We+lyP4=; b=IFO7/BpkYddX2BI/XvBmN2
        8FX7AoRcoKEoA6//e8TT4crH4dCj2TDhE46dSHH6nr9ey8kf1NhomYlq4BiBZ3Gl
        8B7fmjaO4TRdjZAnxEEGEVGUxXq6mAcfcfixd6yTqdba6MavDD1jEAeqH/p9Oqw9
        aY7o4lg8IYqccJgjrNB3hh21HZ9qttvhtecF46W16RHV/p2XFQm6AFcLJh8TMwdC
        vvsOUf4zJMajAU9Pr6Dpk0qLCeMuKHMVFEwBswYo47a+OFrXGsFlGeitmCKNs2pD
        V2yWYYmJ7OubsVyZqLDK196vAwiSNlBxV1VynOdLJnJUxtS75CyoxXv3tOPLlLwQ
        ==
X-ME-Sender: <xms:w-zqYK4Rs9eIdYHFfNiOXiw43NVBNEEwOS-U-jxBHLwl_8KkNW5z5g>
    <xme:w-zqYD73fjEh1CBhTWBJYh5HIGbfDfKNEBzp1ulofd8MClbApL2oLfvrJfF0rEbeH
    qUwwLpj3GjWIg>
X-ME-Received: <xmr:w-zqYJdRuc07wrBaz2C5tZUB45Se12zdeZwLnesL7Y2R4676YHxi4BKcbPlrgRR5GvhSDe9vQcUbPK_TSdD0KqqOGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w-zqYHLTTIVnWMSt3RaLmaI69c1EHfIdu6hlhV8zQKzCurBGmN0IUw>
    <xmx:w-zqYOI3Cs2BiByQsVsOSH5k70er4Ovm2tqfoxGJxUDPGcPZoUjfuw>
    <xmx:w-zqYIxzzXydKyANH3vWizcYDqTNFXQsCIPFvul4uHWQnY-HMf5Drg>
    <xmx:xOzqYFWfe_UuKAZUpDFuciqgif35bC3tgASFNxdjAXKL-QfVDv9rnIOHYbU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:06:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] selftests/resctrl: Fix incorrect parsing of option "-t"" failed to apply to 5.10-stable tree
To:     xiaochen.shen@intel.com, skhan@linuxfoundation.org,
        tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:06:09 +0200
Message-ID: <162600876912955@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1421ec684a43379b2aa3cfda20b03d38282dc990 Mon Sep 17 00:00:00 2001
From: Xiaochen Shen <xiaochen.shen@intel.com>
Date: Thu, 27 May 2021 17:31:53 +0800
Subject: [PATCH] selftests/resctrl: Fix incorrect parsing of option "-t"

Resctrl test suite accepts command line argument "-t" to specify the
unit tests to run in the test list (e.g., -t mbm,mba,cmt,cat) as
documented in the help.

When calling strtok() to parse the option, the incorrect delimiters
argument ":\t" is used. As a result, passing "-t mbm,mba,cmt,cat" throws
an invalid option error.

Fix this by using delimiters argument "," instead of ":\t" for parsing
of unit tests list. At the same time, remove the unnecessary "spaces"
between the unit tests in help documentation to prevent confusion.

Fixes: 790bf585b0ee ("selftests/resctrl: Add Cache Allocation Technology (CAT) selftest")
Fixes: 78941183d1b1 ("selftests/resctrl: Add Cache QoS Monitoring (CQM) selftest")
Fixes: ecdbb911f22d ("selftests/resctrl: Add MBM test")
Fixes: 034c7678dd2c ("selftests/resctrl: Add README for resctrl tests")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

diff --git a/tools/testing/selftests/resctrl/README b/tools/testing/selftests/resctrl/README
index 4b36b25b6ac0..3d2bbd4fa3aa 100644
--- a/tools/testing/selftests/resctrl/README
+++ b/tools/testing/selftests/resctrl/README
@@ -47,7 +47,7 @@ Parameter '-h' shows usage information.
 
 usage: resctrl_tests [-h] [-b "benchmark_cmd [options]"] [-t test list] [-n no_of_bits]
         -b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CMT default benchmark is builtin fill_buf
-        -t test list: run tests specified in the test list, e.g. -t mbm, mba, cmt, cat
+        -t test list: run tests specified in the test list, e.g. -t mbm,mba,cmt,cat
         -n no_of_bits: run cache tests using specified no of bits in cache bit mask
         -p cpu_no: specify CPU number to run the test. 1 is default
         -h: help
diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index f51b5fc066a3..973f09a66e1e 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -40,7 +40,7 @@ static void cmd_help(void)
 	printf("\t-b benchmark_cmd [options]: run specified benchmark for MBM, MBA and CMT\n");
 	printf("\t   default benchmark is builtin fill_buf\n");
 	printf("\t-t test list: run tests specified in the test list, ");
-	printf("e.g. -t mbm, mba, cmt, cat\n");
+	printf("e.g. -t mbm,mba,cmt,cat\n");
 	printf("\t-n no_of_bits: run cache tests using specified no of bits in cache bit mask\n");
 	printf("\t-p cpu_no: specify CPU number to run the test. 1 is default\n");
 	printf("\t-h: help\n");
@@ -173,7 +173,7 @@ int main(int argc, char **argv)
 
 					return -1;
 				}
-				token = strtok(NULL, ":\t");
+				token = strtok(NULL, ",");
 			}
 			break;
 		case 'p':

