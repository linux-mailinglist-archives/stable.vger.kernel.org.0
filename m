Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EB85AD367
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiIENDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiIENDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:03:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF36029C90
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 06:03:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2732468AFE; Mon,  5 Sep 2022 15:03:14 +0200 (CEST)
Date:   Mon, 5 Sep 2022 15:03:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] nvmet: Fix a use-after-free
Message-ID: <20220905130313.GA31278@lst.de>
References: <20220812210317.2252051-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812210317.2252051-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-6.0.

