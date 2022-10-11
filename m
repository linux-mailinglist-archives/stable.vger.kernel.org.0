Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77475FAC2D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 08:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJKGIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 02:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJKGIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 02:08:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68468868AF;
        Mon, 10 Oct 2022 23:08:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E7BC767373; Tue, 11 Oct 2022 08:08:29 +0200 (CEST)
Date:   Tue, 11 Oct 2022 08:08:29 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Park, SeongJae" <sjpark@amazon.com>
Subject: Re: [PATCH v2] nvme-pci: Set min align mask before calculating
 max_hw_sectors
Message-ID: <20221011060829.GA3172@lst.de>
References: <20220929182259.22523-1-risbhat@amazon.com> <EB43F4D1-BFD0-408B-93E7-10643B59F766@amazon.com> <b73250f3-2dd6-36da-4d69-3149959f2e67@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b73250f3-2dd6-36da-4d69-3149959f2e67@amazon.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch already made it to Linux 6.0, so I'm not sure what we need
to review again.
