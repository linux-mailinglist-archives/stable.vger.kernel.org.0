Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D14394C8F
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhE2Oyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 10:54:40 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:49357 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhE2Oyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 10:54:40 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8389E194072C;
        Sat, 29 May 2021 10:53:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 29 May 2021 10:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4wKHef
        8kJGHofsN/1VJSTDt0i8K2Ped058p57FNzH2c=; b=MIJlm3czqBH18Pe0z8WaJM
        2l+M0QnPemakyCtGc1T49aU7ZwCacDn5oiX9iXEfi5vkixhHW/T4sEijdOXxrio1
        OWbsjAmxTPtJ3kWlV5xH2jSXBxgZwzj9mG+th2KJVMhxUCu87sB+a65bvdzfccyZ
        dflpGUc6xk9OOt3RTanV0N0f8+Y+lId2T3jizxZTttdT343TC/mSxi67dJ+kzWyu
        H36ipqftnq5VKv+4JqzUNGlDWsCadytoV6YYfOC93up/T+BQuOuzZDbKrE2IJWZb
        ItgZTQHo6hCmuvgozinE/SKOzv13DFBcSWyptAd+UwPM4iEV7ZHuv9sp8kz3QH0A
        ==
X-ME-Sender: <xms:T1WyYNSTEzr8-eo4rQ0lVggw8NUVB4qXGDVu3LcWwiHEOcCmLO2fNA>
    <xme:T1WyYGyFjLi8Ct8HJmNBOY-cy9L529ByKKgQ0NCq1f4lY3uktPBBabaH14Wy7TPwr
    7lOsT8UCsjDAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T1WyYC0vpHLKWYjQ51D89JAKrDSs_uqTQcHuLW4EZ0P0E-EyEmQ-Yg>
    <xmx:T1WyYFDwqRqRdBUSOZ9fDN3NZVLdoH1NOhejMVuk8HGC_bYvVrcipg>
    <xmx:T1WyYGj2Ri5t7WSKWile63o2l_SWnhOQWmAHxhVXxbPv89bfH6zD9w>
    <xmx:T1WyYOIkRa15AJ7W3lClF5KKxlcTtbcvwCUTPZ7O94a1VU2IvjHDHg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 10:53:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cfg80211: mitigate A-MSDU aggregation attacks" failed to apply to 4.4-stable tree
To:     Mathy.Vanhoef@kuleuven.be, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 16:53:01 +0200
Message-ID: <16222999817165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b8a1fee3488c602aca8bea004a087e60806a5cf Mon Sep 17 00:00:00 2001
From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Date: Tue, 11 May 2021 20:02:45 +0200
Subject: [PATCH] cfg80211: mitigate A-MSDU aggregation attacks

Mitigate A-MSDU injection attacks (CVE-2020-24588) by detecting if the
destination address of a subframe equals an RFC1042 (i.e., LLC/SNAP)
header, and if so dropping the complete A-MSDU frame. This mitigates
known attacks, although new (unknown) aggregation-based attacks may
remain possible.

This defense works because in A-MSDU aggregation injection attacks, a
normal encrypted Wi-Fi frame is turned into an A-MSDU frame. This means
the first 6 bytes of the first A-MSDU subframe correspond to an RFC1042
header. In other words, the destination MAC address of the first A-MSDU
subframe contains the start of an RFC1042 header during an aggregation
attack. We can detect this and thereby prevent this specific attack.
For details, see Section 7.2 of "Fragment and Forge: Breaking Wi-Fi
Through Frame Aggregation and Fragmentation".

Note that for kernel 4.9 and above this patch depends on "mac80211:
properly handle A-MSDUs that start with a rfc1042 header". Otherwise
this patch has no impact and attacks will remain possible.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.25d93176ddaf.I9e265b597f2cd23eb44573f35b625947b386a9de@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 39966a873e40..7ec021a610ae 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -771,6 +771,9 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
 			goto purge;
+		/* mitigate A-MSDU aggregation injection attacks */
+		if (ether_addr_equal(eth.h_dest, rfc1042_header))
+			goto purge;
 
 		offset += sizeof(struct ethhdr);
 		last = remaining <= subframe_len + padding;

