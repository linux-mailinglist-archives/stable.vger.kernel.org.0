Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941466E1B84
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 07:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDNFNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 01:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDNFNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 01:13:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724F5598;
        Thu, 13 Apr 2023 22:13:05 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9E50068AA6; Fri, 14 Apr 2023 07:12:59 +0200 (CEST)
Date:   Fri, 14 Apr 2023 07:12:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Message-ID: <20230414051259.GA11464@lst.de>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com> <20230321132604.GA14120@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321132604.GA14120@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 02:26:04PM +0100, Christoph Hellwig wrote:
> Can you send a patch with a new quirk that just disables the EUI64,
> but keeps the NGUID?

Did this go anywhere?
