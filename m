Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5C6E3329
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDOS0V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Apr 2023 14:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDOS0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 14:26:20 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE99F270A
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 11:26:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 8535161989EA;
        Sat, 15 Apr 2023 20:26:18 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id q3nyYnnlJoWP; Sat, 15 Apr 2023 20:26:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id E8363622623A;
        Sat, 15 Apr 2023 20:26:17 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h6de7diMJ8hx; Sat, 15 Apr 2023 20:26:17 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id C803161989EA;
        Sat, 15 Apr 2023 20:26:17 +0200 (CEST)
Date:   Sat, 15 Apr 2023 20:26:17 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     stable <stable@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Message-ID: <288240559.69421.1681583177740.JavaMail.zimbra@nod.at>
In-Reply-To: <ZDrmsnX5BHxtBNwf@makrotopia.org>
References: <ZDrmsnX5BHxtBNwf@makrotopia.org>
Subject: Re: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Request to pick "ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size"
Thread-Index: /+luI1lt6eV/ynqKJ8vb6eB8RV7kaA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Daniel Golle" <daniel@makrotopia.org>
> An: "stable" <stable@vger.kernel.org>, "linux-mtd" <linux-mtd@lists.infradead.org>
> CC: "Hauke Mehrtens" <hauke@hauke-m.de>, "richard" <richard@nod.at>, "Miquel Raynal" <miquel.raynal@bootlin.com>,
> "chengzhihao1" <chengzhihao1@huawei.com>, "Nicolas Schichan" <nschichan@freebox.fr>, "George Kennedy"
> <george.kennedy@oracle.com>, "Sascha Hauer" <s.hauer@pengutronix.de>, "yi zhang" <yi.zhang@huawei.com>
> Gesendet: Samstag, 15. April 2023 20:02:26
> Betreff: Request to pick "ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size"

> Hi,
> 
> please pick
> 
> 1e020e1b96afd ("ubi: Fix failure attaching when vid_hdr offset equals to
> (sub)page size")
> 
> from linux-next to stable trees.

FYI, the fix is not yet in Linus' master. But I guess it will be very soon.
The pull request is on the mailinglist.

Thanks,
//richard
