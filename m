Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C5F6BC585
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 06:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPFPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 01:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPFPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 01:15:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AE44C2A;
        Wed, 15 Mar 2023 22:15:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F3EA667373; Thu, 16 Mar 2023 06:15:08 +0100 (CET)
Date:   Thu, 16 Mar 2023 06:15:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Message-ID: <20230316051508.GA8520@lst.de>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 03:34:36PM -0700, Saeed Mirzamohammadi wrote:
> This adds a quirk to fix the Samsung PM1733a and PM173X reporting
> bogus eui64 so they are not marked as "non globally unique" duplicates.

What kinds of euid do they report?  Did you report the bug to Samsung?
