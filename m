Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770D86BD323
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCPPOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 11:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjCPPOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 11:14:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBAEC4E92;
        Thu, 16 Mar 2023 08:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mtHu+J4hnGprgFkgWHUxAcP06d
        /HtIpvLcoJEI8fgfUGkvgJeQfEoIZ3pzJVI8+eoUazSIxxt98VGCTeNFUXXSLquP3qn2kFc7d+TpM
        R1vb8L0DgYh6q1SewsQ+eQt918eFLQ7AjTe3FhJUp8283c96LS7iw0rqUjhdW/nidHmgGkfapLnSQ
        wiRfuMLwijY549mvMTKctMWRns55XleN5LbPlJ8QA9WWGDMhZrWkbD1a8B0VL5nJ8r081wi/0ZlM1
        rYJIGQBfctC84aMFuq8jOJVuF33k8lGJun4qDK+afEOLL2QJj2788lpX2kZYyfaS1fQK9/akWnfNb
        Jrtg0Now==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcpJQ-00Gmqj-1P;
        Thu, 16 Mar 2023 15:14:40 +0000
Date:   Thu, 16 Mar 2023 08:14:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/6] blk-crypto: make blk_crypto_evict_key() more
 robust
Message-ID: <ZBMyYOwNdZ/dyuWS@infradead.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315183907.53675-4-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
