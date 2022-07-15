Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A73575CDD
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 09:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiGOH7Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 15 Jul 2022 03:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiGOH7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 03:59:16 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CE320BDA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 00:59:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B215E62B9C68;
        Fri, 15 Jul 2022 09:59:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1TIbjO2dgAkX; Fri, 15 Jul 2022 09:59:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 468FC6081104;
        Fri, 15 Jul 2022 09:59:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XYp_pi8sEsn6; Fri, 15 Jul 2022 09:59:11 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1702562B9C5F;
        Fri, 15 Jul 2022 09:59:11 +0200 (CEST)
Date:   Fri, 15 Jul 2022 09:59:10 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz =?utf-8?B?TW/FhA==?= <tomasz.mon@camlingroup.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Message-ID: <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
In-Reply-To: <YtEdIujszEKSprbF@kroah.com>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de> <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com> <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com> <YtD/9KJZwlVj+6hS@kroah.com> <20220715074631.GA7333@pengutronix.de> <YtEdIujszEKSprbF@kroah.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times
Thread-Index: tNvwF06jkVVUKvGeMUaVv400VmkHJQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
>> My IRC history doesn't go back far enough, but if I recall correctly
>> Miquel is on vacation, he would have picked up this patch for linux-next
>> otherwise.

Exactly.
 
> Ok, let me do a round of stable releases so that people don't get hit by
> this now...

Thanks a lot for doing so.
 
> Hopefully this gets fixed up by 5.19-final.

Sure, I'll pickup this patch.

Thanks,
//richard
