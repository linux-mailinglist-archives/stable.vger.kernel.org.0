Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095376781F7
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjAWQnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 11:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjAWQnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 11:43:09 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3080B11B
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 08:42:44 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 44B1C68C7B; Mon, 23 Jan 2023 17:41:32 +0100 (CET)
Date:   Mon, 23 Jan 2023 17:41:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ross Lagerwall <ross.lagerwall@citrix.com>
Cc:     linux-nvme@lists.infradead.org,
        James Smart <james.smart@broadcom.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
Subject: Re: [PATCH] nvme-fc: Fix initialization order
Message-ID: <20230123164132.GB8398@lst.de>
References: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-6.2.
