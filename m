Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406956B205C
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCIJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCIJmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 04:42:44 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F63BE9831
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 01:42:43 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC30C67373; Thu,  9 Mar 2023 10:42:40 +0100 (CET)
Date:   Thu, 9 Mar 2023 10:42:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
Cc:     linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
Subject: Re: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000
Message-ID: <20230309094240.GD24868@lst.de>
References: <20230308161929.18446-1-miroslav@mishamosher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308161929.18446-1-miroslav@mishamosher.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-6.3.
