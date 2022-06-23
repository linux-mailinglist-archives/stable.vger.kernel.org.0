Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB7557D5F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 15:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiFWN50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 09:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiFWN50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 09:57:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C039142;
        Thu, 23 Jun 2022 06:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZR7WYsC9ggzKFmk4barPoYL+cA
        IRuuH7RRvyalfeCcQBJmnzggpmggnhW0c2wvsABsE0fonZ9XCMMCYgtYelZfx1YgbCFwtT1sWT24y
        c5hH5Z1Vd4wT5uUh9WOdSY5z/0iFK8Z2gqTzWVz4iWLDS5xzir9a8UWCU4z5LOfoW98xeEQFaiBnS
        GIYluazdnf6h070NcuRhGyjYGnxvjvLhpYqID+Xk93C4o/FCvL44BlQtfslI9P2z+cPrujBQ57iVf
        QA7qGL8eGL1//uaPibDxDizbk32PMbBsnmljX4xvQuWCo8kSGeUGJaTPUOnJjnU+qiSLQChQXf/RW
        9YkWnBVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4NKm-00FRN2-Io; Thu, 23 Jun 2022 13:57:24 +0000
Date:   Thu, 23 Jun 2022 06:57:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/9] block: fix default IO priority handling again
Message-ID: <YrRxRKH8TGfYrY9n@infradead.org>
References: <20220623074450.30550-1-jack@suse.cz>
 <20220623074840.5960-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623074840.5960-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
