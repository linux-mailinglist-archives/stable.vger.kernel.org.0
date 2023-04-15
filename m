Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8896E3333
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 20:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjDOShY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Apr 2023 14:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOShY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 14:37:24 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFE419AD
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 11:37:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B363661989EA;
        Sat, 15 Apr 2023 20:37:21 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 2ZkRJUYzMcDn; Sat, 15 Apr 2023 20:37:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 07D06622623A;
        Sat, 15 Apr 2023 20:37:21 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sYN0Wmqo47dJ; Sat, 15 Apr 2023 20:37:20 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id D7AE461989EA;
        Sat, 15 Apr 2023 20:37:20 +0200 (CEST)
Date:   Sat, 15 Apr 2023 20:37:20 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        stable <stable@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Message-ID: <557432802.69470.1681583840768.JavaMail.zimbra@nod.at>
In-Reply-To: <2023041544-unending-glowing-e5ce@gregkh>
References: <ZDrmsnX5BHxtBNwf@makrotopia.org> <288240559.69421.1681583177740.JavaMail.zimbra@nod.at> <2023041544-unending-glowing-e5ce@gregkh>
Subject: Re: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Request to pick "ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size"
Thread-Index: 0ft8VSmtq084fRfhryZVFw9RtiiJQQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Any specific reason why it wasn't tagged cc: stable@ if it was known to
> be fixing a regression so that we would pick it up automatically?

Because I noticed only after I pushed already to next and therefore planned to inform
you by mail. But Daniel was faster...

Thanks,
//richard
