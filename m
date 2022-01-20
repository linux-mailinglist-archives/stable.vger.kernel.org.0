Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173F3494A4D
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 10:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiATJFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 04:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358472AbiATJFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 04:05:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4635C061574;
        Thu, 20 Jan 2022 01:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=DJpHxZ7rMF7GfQesarrjHBj3Y7
        ahoxuEq0Zx4cNJ34e8fZ/aDuBNBoG/lLOBhJv4rXibYPONa5HzWzKdDTXUtvq1AgTMsdqkwqlWQql
        v18bWslt0q+6hE80Fd80WcI/676v3Cex0IS9Ludr7U1whsrLLUPJLXIr3mh7B2krkVgDk5fqmppqj
        F7TcmG+AFcnzArBvYliNq9GVFNU0Lht5dbQwIG2vlfhRnSLKYEpCs3PiNt4ZIdygFl8Di5pZFGrhD
        8mwVtgoN2dwhGFuwFlisZeyG1E0Cm+1/8UFV0HG8TdoJKuq+oqucfwROI/GwaU4Ax8j4/N7sPoJ/Y
        SpRMm1ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nATNR-00A375-FF; Thu, 20 Jan 2022 09:05:05 +0000
Date:   Thu, 20 Jan 2022 01:05:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] udf: Fix NULL ptr deref when converting from inline
 format
Message-ID: <YeklwZ0QvR3Axedw@infradead.org>
References: <20220118095449.2937-1-jack@suse.cz>
 <20220118095753.627-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118095753.627-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
