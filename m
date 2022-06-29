Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0924560267
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiF2OQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 10:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiF2OQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 10:16:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD102ED5B;
        Wed, 29 Jun 2022 07:16:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1FB8868AA6; Wed, 29 Jun 2022 16:16:44 +0200 (CEST)
Date:   Wed, 29 Jun 2022 16:16:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pablo Greco <pgreco@centosproject.org>
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG
 SX6000LNP (AKA SPECTRIX S40G)
Message-ID: <20220629141643.GC16855@lst.de>
References: <20220625121502.9092-1-pgreco@centosproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625121502.9092-1-pgreco@centosproject.org>
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

added to nvme-5.19.
