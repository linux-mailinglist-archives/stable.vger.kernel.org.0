Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B735AE02
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 16:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhDJOLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:11:51 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:43721 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhDJOLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:11:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E75F019408B1;
        Sat, 10 Apr 2021 10:11:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6cQuR5
        Q7znMGnPT90QTuRBbtKfaCXiapFyllikALajM=; b=msdtrs+jLKwjyv0YmHSI5V
        R1M8iWdkRKi+ckYGoQsWh8Upj7rNvJNl438Qkb0O3LZRfwOKVNYbqo2Pe6YyIcIA
        OGi8it5BgEQtHkx3UgPcOnbh2QpdJzdAhGobqno7E/IH9Rh4Phza7PfJH+OHyh9N
        kPN1GRW8YpYLNgqficQYAhzb/OsQ7tJhMOy5vPnM2G9L1dskGrSJvLF/i4uKolDF
        fQ/Yj8Jj3GRdn0ViI3y+Ditq9P0Bgl9abMitLpqfpJU7Ij2t+mjSkhKnM5zPQxpO
        Hk46PeemiRy4Z6u/K77j3OYwtWyuw4+ErRXIbIbJluOzGqA5DdAcb7Zb7jAnNcDA
        ==
X-ME-Sender: <xms:F7JxYMQul-rp82nIizJSfwCuqYMnn26aTWr97s-XTG9DG8M0UHE4OQ>
    <xme:F7JxYJwdCROSlKl918Wb7jFZj4Znuho5ezyfetegW0p1wXRVelUNr8zN0PQdap-Ch
    igetnZ0zboaRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepueeghfetheeuudefgfeutdegleehueeuvefhleevvd
    egvedutdekueevvdehledtnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:F7JxYJ0brNa9csDzZoZW1R54OzkJ3lKpmxDY60KLpNELogelEKwN-w>
    <xmx:F7JxYAA8tufhWdzeGvXgdctYpSmp9hQ7WNXVz504DiOF_o8W0i-5Fg>
    <xmx:F7JxYFhQw-73e6CduoZfgt_qTCrrysUR9DuhEOEpQ9RNLh5KAtcbvA>
    <xmx:F7JxYKv2UZ2YwDTddJXcyyrZhRYSdaqz3zjnTmKc3f3-fFJR78-apA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CA56108005F;
        Sat, 10 Apr 2021 10:11:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] virtio_net: Do not pull payload in skb->head" failed to apply to 4.14-stable tree
To:     edumazet@google.com, davem@davemloft.net, jasowang@redhat.com,
        mst@redhat.com, xuanzhuo@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 16:11:33 +0200
Message-ID: <161806389310822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 2 Apr 2021 06:26:02 -0700
Subject: [PATCH] virtio_net: Do not pull payload in skb->head

Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") brought  a ~10% performance drop.

The reason for the performance drop was that GRO was forced
to chain sk_buff (using skb_shinfo(skb)->frag_list), which
uses more memory but also cause packet consumers to go over
a lot of overhead handling all the tiny skbs.

It turns out that virtio_net page_to_skb() has a wrong strategy :
It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
copies 128 bytes from the page, before feeding the packet to GRO stack.

This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
meaning we were not packing MSS with 100% efficiency.

Fix is to pull only the ethernet header in page_to_skb()

Then, we change virtio_net_hdr_to_skb() to pull the missing
headers, instead of assuming they were already pulled by callers.

This fixes the performance regression, but could also allow virtio_net
to accept packets with more than 128bytes of headers.

Many thanks to Xuan Zhuo for his report, and his tests/help.

Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://www.spinics.net/lists/netdev/msg731397.html
Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb12..0824e6999e49 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
 
-	copy = len;
-	if (copy > skb_tailroom(skb))
-		copy = skb_tailroom(skb);
+	/* Copy all frame if it fits skb->head, otherwise
+	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
+	 */
+	if (len <= skb_tailroom(skb))
+		copy = len;
+	else
+		copy = ETH_HLEN + metasize;
 	skb_put_data(skb, p, copy);
 
 	if (metasize) {
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 98775d7fa696..b465f8f3e554 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
-		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
+		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
+		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
+
+		if (!pskb_may_pull(skb, needed))
+			return -EINVAL;
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
 
 		p_off = skb_transport_offset(skb) + thlen;
-		if (p_off > skb_headlen(skb))
+		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
@@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			}
 
 			p_off = keys.control.thoff + thlen;
-			if (p_off > skb_headlen(skb) ||
+			if (!pskb_may_pull(skb, p_off) ||
 			    keys.basic.ip_proto != ip_proto)
 				return -EINVAL;
 
 			skb_set_transport_header(skb, keys.control.thoff);
 		} else if (gso_type) {
 			p_off = thlen;
-			if (p_off > skb_headlen(skb))
+			if (!pskb_may_pull(skb, p_off))
 				return -EINVAL;
 		}
 	}

