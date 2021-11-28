Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC142460653
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 14:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhK1NH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 08:07:27 -0500
Received: from mout.gmx.net ([212.227.17.22]:56509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhK1NF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Nov 2021 08:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638104510;
        bh=KAFEF4nBqZSjJAHkByl3gAhKyW0iRheiGP4BsFsbc3s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ElTuKILq+JPF1ppUBGWaIE8n2oiyj/P5xA3Gz8ybUlkP3zpVDYXoPw6efJSLr901S
         ja75BpsR1E7VprDP4y4VQpMbmLmBwXqnhXkyAMGk6LApmx+bzMhuYe9i4+OEnmoHuX
         emJLb7bxPRKsRddpZGJ3jzvjprSxKEWnHm1yhQ4A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.226.229] ([157.180.226.229]) by web-mail.gmx.net
 (3c-app-gmx-bap55.server.lan [172.19.172.125]) (via HTTP); Sun, 28 Nov 2021
 14:01:50 +0100
MIME-Version: 1.0
Message-ID: <trinity-b64e638e-f901-4daf-bbe4-669da3962cd0-1638104510657@3c-app-gmx-bap55>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Xing Song <xing.song@mediatek.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Xing Song <xing.song@mediatek.com>, stable@vger.kernel.org
Subject: Aw: [PATCH] mac80211: set up the fwd_skb->dev for mesh forwarding
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 28 Nov 2021 14:01:50 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:sXBK9O3DEe0u6NzXR8M133TOYbyKFZYcy3mc9Q8wM2a4TJS1Eij4B34cHduQysmsA6TI2
 USmIs+KZyf9WIeUk1XwU+MIHkN9sjaA3yJzSaY1ECVCRqKomdbOHk4IfH38T13oSNnHVdKHMlYQu
 b+gsxZ20g+XVGjnuD5iIyC7fLkyOmYXSg1Y4uAel8uWYuOPjcyUh4gboTFGu02GHSJtQzzQFiybn
 3skUzQoqXx7vJzwWYVG36Tcvxpbv+jVfJE86R7Fkn5hwPjXOjKDSQo9nx98y6RYrGwI7eR539Gpo
 uQ=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OFx5dKGunjs=:y3OjPL4IMg1WunScyGKILE
 6STxlAl89B/BWggVLH4vk8jztqWY4LM2A8jdZ8Dz3EMnxCJd/UpcIi65Soz6RyIUPrYRSRrJH
 GhahQBKrzVsX03sGEzlsRL+hPnJz1snE5IixM/5MNWP/mrvRsbcRAUseSS/HmfOqYNRvjlQxl
 mvLrQJmmEtU1CAyvyaHDTRL9Iu9xET2AEm1/08mQieDjXO9tRhKI8UMLyBxIU2QU7+ORXLT3n
 0FlE89kEm7hXTYi4mElhnp/PXiMO1CA0Ik8iN3P46Jm7INAJVl1i24EMYPa984x142P7Akmc2
 k6cjZN4bVM1dL8Elh9LdbMN60im6dbIUyayj68UFWVa8D7Rctt4ve8Xr6j0tcyDTTrh6nzK9x
 nY+Ze4/gi6PIsrkNZBnzppkJyCc1xXZdijjXpfgz45FPGBj703km04LVC7n5Hp5xycNxRu0ek
 NSUlW7a/YkrupKNih4eV8IdVWFjN0LoQYqmPBaChadc8T8Nuzlgm7E30YdqcPxXouP9Ixt39v
 RfkIBUr918D81zBGpEex0r9WXyK2p3ZtImSQnlSCLZm9WY0vBJTxMGNXrK2T56mfEtVds2N6l
 plhjwaXJoS8JqPW5jlc8r1myI01pHT8yd+79YnaarvTf7THpMddXLN5dHKDUq9j9Vf7fuUQqY
 q2GHY92yRR37t/O72AU5OA1BuS4iXYTCpFG2u7kz2wRX8p4mNDlATJ2Ko0h0j1hEQca8mSpV2
 rkfKzeezRxmVkI0DzaaBUXkcDbNjgGy+da7ahi7xeBU4rDX4UlgeWJhfKZfh3Qq3zwGQfOjYl
 LzQZdoA
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

maybe we should add Fixes- and Stable-Tag to get it fixed in 5.16 and previous versions

i would suggest the commit introducing the warning shown when the skb->dev is missing

Fixes: 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
Cc: stable@vger.kernel.org
