Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681C11072F4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVNRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:17:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53678 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKVNRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 08:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bc1VxuPaXsAT8yXNZ/fQ4VrszJzZOyOpmylH10VmVz0=; b=kv4+mLR+i2WFk7DxbnaBw1HDw
        6i0wunYIrgLvVa7HynPyJgQhjy3KBuvkPovbei1i/fOHBJa0G8CcqhO/67rBuUEPz9PRwOh/nyjCO
        0Oy6eEpjS9rUls7q/n1HNUmueBgVnwsx29yQke0Z96K4/hThGuqlK9HdZhpkCUxP8AOKZrubc/gii
        adayQudiIdixC+HxJSgMrwVobF1Kne7ihNRInJtYNAavZq5MnYiJpgj0CJ+IZq8w1oChQvSNo3B4x
        yttooJvDiQguEspB11xDMwdstum9zwCtcs/bdDB/vbAOOiZ1b6rC3AYkosm3hnFR+CYXQ2utOaC7G
        AHF7qbUYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iY8oK-0003Sx-7l; Fri, 22 Nov 2019 13:17:20 +0000
Date:   Fri, 22 Nov 2019 05:17:20 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Fix pipe page leakage during splicing
Message-ID: <20191122131720.GA12183@infradead.org>
References: <20191121161144.30802-1-jack@suse.cz>
 <20191121161538.18445-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121161538.18445-1-jack@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good modulo the spelling critique:

Reviewed-by: Christoph Hellwig <hch@lst.de>
