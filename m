Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0F86BE1F1
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 08:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCQHdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 03:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCQHdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 03:33:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7501F922;
        Fri, 17 Mar 2023 00:33:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DD55D68AA6; Fri, 17 Mar 2023 08:33:33 +0100 (CET)
Date:   Fri, 17 Mar 2023 08:33:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Message-ID: <20230317073333.GA14827@lst.de>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com> <20230316051508.GA8520@lst.de> <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:31:38PM +0000, Saeed Mirzamohammadi wrote:
> 
> eui64 values are not unique. Here is an example:
> namespace1
> nguid   : 36554630529000710025384500000001
> eui64   : 002538191100104a
> namespace2
> nguid   : 36554630529000710025384500000002
> eui64   : 002538191100104a
> namespace3
> nguid   : 36554630529000710025384500000003
> eui64   : 002538191100104a
> namespace4
> nguid   : 36554630529000710025384500000004
> eui64   : 002538191100104a

Eww, that's really a grave bug.  Interestingly enough the nguid
works, so I wonder if we should just quirk the EUI so that we have
a least some uniqueue identifier.

> I haven’t yet contacted Samsung. Do you recommend any one to reach out to?

We have plenty of Samsung folks here on the list, maybe someone can
reply?
