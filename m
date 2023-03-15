Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8FA6BB982
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjCOQUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjCOQTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:19:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC8D1BF5;
        Wed, 15 Mar 2023 09:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=23NHnacHcYDw0tHhI3us0xSr3J
        Qr1Dta9HsNHugTXBPXV0fbGGG3oDuYUI5vTpDd0pQx/xYpUOAJYljhVp1qWWVY8n1as85vk8hdS9f
        JWfMb0lPHHv7GqqbBagfjt/XUbP+T4BHopyL9+0zjW5RWXsm5aYqcQl1Rc3O53yyiJcM74g0XmW1Q
        G8hIChzHonUvjjr8WGdKJ0rq9T3YBRZTwYqIg+RmbiEVBDvPo1g/Z/CNPOU4ID4tiXcWZhHjl/0bz
        Jkb0PjGEa0d9r9ASQ2dN/P6BZ/g+NSmWa09Jbwlj18ZCUtoxQdl/JU6KAlECp5RxYewIqZxFKk1qf
        +kHd32Yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcTqU-00E2hI-2V;
        Wed, 15 Mar 2023 16:19:22 +0000
Date:   Wed, 15 Mar 2023 09:19:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] blk-mq: release crypto keyslot before reporting
 I/O complete
Message-ID: <ZBHwCkpqqHZUHyRJ@infradead.org>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308193645.114069-2-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
