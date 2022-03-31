Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BAC4ED36A
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 07:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiCaFsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 01:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiCaFsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 01:48:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C745D18D;
        Wed, 30 Mar 2022 22:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VHxYyj8oI/x8CDOncWd8lVjMuGnCh4YGy0kjeNixfRo=; b=v+3GYGhhNOuOBkOlGBzEhkX85/
        JghKIhs9yfAn9EO74KcBy/YmZj7kU/erfqEDIuzitsVFumO/jucPXduLZnSJObuJa3z8ZmrSs1I0w
        70vgVwhlecmKbteJjUd1jjwOmcOk4e9AhhV90+W2ySM1rFNlqXOUaNC22L7EI79kZeCqrYpDPmGJx
        PeIeUCD+fqHRXFKBqeoBCWTYOZbVjEIYyF5PUULPMOiIb+qMZ32CGjf4LlwH6BT6sVYrxVXn6wdii
        Amx5vFrfAS00iLp3Q7kUZIM3x5700qrXsCiAXH66sqp3De9o/4CySRdGymA+kx4iIlHRK4WhbDB/S
        4yDBWt8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZndS-000jyC-Ph; Thu, 31 Mar 2022 05:46:18 +0000
Date:   Wed, 30 Mar 2022 22:46:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
Cc:     Jens Axboe <abxoe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        stable@vger.kernel.org
Subject: Re: [RESEND PATCH] drbd: fix potential silent data corruption
Message-ID: <YkVAKjFVgFxkUuIy@infradead.org>
References: <20220330185551.3553196-1-christoph.boehmwalder@linbit.com>
 <YkVACyO7rReUAjqj@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkVACyO7rReUAjqj@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 10:45:47PM -0700, Christoph Hellwig wrote:
> The change looks good, but this really should grow a proper Fixes tag.
> 

And for the resend fix the spelling of Jens' email address.
