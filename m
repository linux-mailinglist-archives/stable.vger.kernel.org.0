Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78E310D3F0
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 11:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfK2K2v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 29 Nov 2019 05:28:51 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:39218 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2K2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 05:28:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 8BE0E605AD4C;
        Fri, 29 Nov 2019 11:28:48 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id MzjCSbs_Kowu; Fri, 29 Nov 2019 11:28:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id A1ADE62EBCA9;
        Fri, 29 Nov 2019 11:28:46 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PpKVc_9Wkzol; Fri, 29 Nov 2019 11:28:46 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 77A026083139;
        Fri, 29 Nov 2019 11:28:46 +0100 (CET)
Date:   Fri, 29 Nov 2019 11:28:46 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Joel Stanley <joel@jms.id.au>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Hou Tao <houtao1@huawei.com>
Message-ID: <1768300347.101090.1575023326346.JavaMail.zimbra@nod.at>
In-Reply-To: <20191129001930.651128-1-joel@jms.id.au>
References: <20191129001930.651128-1-joel@jms.id.au>
Subject: Re: [PATCH] Revert "jffs2: Fix possible null-pointer dereferences
 in jffs2_add_frag_to_fragtree()"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
Thread-Index: YU57vPD+ANar5XiWuA9wwI2ZV1KT3A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Joel Stanley" <joel@jms.id.au>
> An: "David Woodhouse" <dwmw2@infradead.org>, "richard" <richard@nod.at>, "Jia-Ju Bai" <baijiaju1990@gmail.com>, "Al
> Viro" <viro@zeniv.linux.org.uk>, "OpenBMC Maillist" <openbmc@lists.ozlabs.org>, "linux-mtd"
> <linux-mtd@lists.infradead.org>, "linux-kernel" <linux-kernel@vger.kernel.org>
> CC: "stable" <stable@vger.kernel.org>, "Hou Tao" <houtao1@huawei.com>
> Gesendet: Freitag, 29. November 2019 01:19:30
> Betreff: [PATCH] Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"

> This reverts commit f2538f999345405f7d2e1194c0c8efa4e11f7b3a. The patch
> stopped JFFS2 from being able to mount an existing filesystem with the
> following errors:
> 
> jffs2: error: (77) jffs2_build_inode_fragtree: Add node to tree failed -22
> jffs2: error: (77) jffs2_do_read_inode_internal: Failed to build final fragtree
> for inode #5377: error -22
> 
> Fixes: f2538f999345 ("jffs2: Fix possible null-pointer dereferences...")
> Cc: stable@vger.kernel.org
> Suggested-by: Hou Tao <houtao1@huawei.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> 5.4 cannot mount (some?) jffs2 filesystems without this fix. Hou pointed
> this out[1] a while back but the fix didn't make it in. It's still
> broken in -next.

queued into -next.

Thanks,
//richard
