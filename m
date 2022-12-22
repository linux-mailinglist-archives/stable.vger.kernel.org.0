Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F0E653D06
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 09:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiLVIgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 03:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbiLVIgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 03:36:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABC20BF5
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 00:36:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id x22so3182517ejs.11
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 00:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TOfc7EGG83O/xS/Uaar9/uexk/8D+4jXs6c0U4ftxC0=;
        b=gfHxNAQcIb72vXPpnCGJHdtH5YsR+5yf953FvOjGAhWm3ROz2AVyy9CDJBLeNf0Xsf
         g9Eh9BgzRGBI33iFH5EZMV1EyIo7qyQnOzqYxqpf0Gjth3XeVsWoNbJNSN2vNy6sOFuW
         Wsug4Breu+GJr9uWJSgyuWFyAkODYy3I0LhGAhQx8d/XTHDWTyujMAqRk8IKCo3XupVR
         EtXTA5QFtT71L7oUN1XfeOIi1qNPuI4Ftw7zc5iri5clz6gloEaAgmrsnTwzIJpV7zKC
         Y4ovHaf0puufxFDIxFt9QIkeiNIL/eHaZGlBfSNoMU4eDIyvuDDHx7q4G0Acjva9LNJa
         JpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOfc7EGG83O/xS/Uaar9/uexk/8D+4jXs6c0U4ftxC0=;
        b=mwTobPKmhIJVKEI/tBykGvGeKeOxYXnx0fy8nuYQUxrfUpKnNMorMqG/MI4RwpSV+V
         EWV/yGIWk1jWABzVDEMk+2pKxMgBkBnoSaeLzdjhZVByXB2zaGqcr0MZPrSEg5Cz4PsX
         PogHEQlmT7qH51L+nfAZ8+vp0TCILZ0HC0+TKTktMO58bqeO09NyRol8HG7DJmhVfl/1
         tOmivNNS8/fvNZToGsoofAzRXqsltHe2f1O1JHaIk1QbmyZR/nC94HAHWGmxOSgIewH4
         zGxqPaSodDDUtRQTNRXyJ6gSTKtOQ6kqr0OCLIbyp2sk0j6y/GoZcF7CZMPxgV0onT6j
         etRQ==
X-Gm-Message-State: AFqh2koTyT9Ct8uHdjenf8IqNjlNBISDDEH4fbgumUDGF5JUUyZF8nKo
        Oejngg14peQm881Aug7IAb/vLhBKZs4YqGZi
X-Google-Smtp-Source: AMrXdXufKakRH5nGU5aUpV3tx6ejjMjOfwfADHcgGBq0LAtF8x6ieGOMYJpFB7vOGDLs3YVRR2cQ7Q==
X-Received: by 2002:a17:907:80ce:b0:7c1:26b9:c556 with SMTP id io14-20020a17090780ce00b007c126b9c556mr4429988ejc.15.1671698161125;
        Thu, 22 Dec 2022 00:36:01 -0800 (PST)
Received: from alba.. ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id t16-20020a1709060c5000b007c14ae38a80sm7987721ejf.122.2022.12.22.00.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 00:36:00 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org
Cc:     willemdebruijn.kernel@gmail.com, mst@redhat.com,
        jasowang@redhat.com, edumazet@google.com,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        willemb@google.com, syzkaller@googlegroups.com,
        liuhangbin@gmail.com, linux-kernel@vger.kernel.org,
        joneslee@google.com, Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 0/2] net/af_packet: Fix kernel BUG in __skb_gso_segment
Date:   Thu, 22 Dec 2022 10:35:43 +0200
Message-Id: <20221222083545.1972489-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The series is intended for stable@vger.kernel.org # 5.4+

Syzkaller reported the following bug on linux-5.{4, 10, 15}.y:
https://syzkaller.appspot.com/bug?id=ce5575575f074c33ff80d104f5baee26f22e95f5

The upstream commit that introduces this bug is:
1ed1d5921139 ("net: skip virtio_net_hdr_set_proto if protocol already set")

Upstream fixes the bug with the following commits, one of which introduces
new support:
e9d3f80935b6 ("net/af_packet: make sure to pull mac header")
dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO") 

The additional logic and risk backported seems manageable.

The blammed commit introduces a kernel BUG in __skb_gso_segment for
AF_PACKET SOCK_RAW GSO VLAN tagged packets. What happens is that
virtio_net_hdr_set_proto() exists early as skb->protocol is already set to
ETH_P_ALL. Then in packet_parse_headers() skb->protocol is set to
ETH_P_8021AD, but neither the network header position is adjusted, nor the
mac header is pulled. Thus when we get to validate the xmit skb and enter
skb_mac_gso_segment(), skb->mac_len has value 14, but vlan_depth gets
updated to 18 after skb_network_protocol() is called. This causes the
BUG_ON from __skb_pull(skb, vlan_depth) to be hit, as the mac header has
not been pulled yet.

The fixes from upstream backported cleanly without conflicts. I updated
the commit message of the first patch to describe the problem encountered,
and added Cc, Fixes, Reported-by and Tested-by tags. For the second patch
I just added Cc to stable indicating the versions to be fixed, and added
my Tested and Signed-off-by tags.

I tested the patches on linux-5.{4, 10, 15}.y.

Eric Dumazet (1):
  net/af_packet: make sure to pull mac header

Hangbin Liu (1):
  net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

 net/packet/af_packet.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

-- 
2.34.1

