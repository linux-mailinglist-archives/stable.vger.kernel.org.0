Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E749B6294CD
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 10:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbiKOJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 04:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiKOJtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 04:49:17 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE97112AA1;
        Tue, 15 Nov 2022 01:49:16 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5CC0567373; Tue, 15 Nov 2022 10:49:13 +0100 (CET)
Date:   Tue, 15 Nov 2022 10:49:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bean Huo <beanhuo@iokpp.de>
Cc:     beanhuo@micron.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro
Message-ID: <20221115094913.GB25284@lst.de>
References: <20221114134852.73402-1-beanhuo@iokpp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114134852.73402-1-beanhuo@iokpp.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-6.1.
