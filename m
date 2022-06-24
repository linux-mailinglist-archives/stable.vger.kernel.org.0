Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A315599FE
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 14:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiFXM7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiFXM7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 08:59:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65577527FD;
        Fri, 24 Jun 2022 05:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vMOXdBy5q0jneD6eagGKUyxYDxjR9s5ISqYNMfmQSLs=; b=e9VIrFRSAoJIFu8bsXbrZyRRTc
        i0XRBruZXdofziujw65WQJCUaxKA2cynWytHcpHtsukfz1JLZwagaQIlgR56v/CWe7tnG+vbzzotD
        0aMsikP80AhoEI7hiEUBajzmFOTf6jRTzhz994vFGETTgH5J0VSUNccEo+LT5qKkFVTBkDF/d83XA
        wsvpi9S/qpTTwNJHnKJiEhFWx7eZME93DJB04Lw3dpSTOLZBg94XsXvfPj21CDJ3WMifj55kxHDMB
        edLRo7xTly67AzTxZqdwl7sFY2hMlu7c0BloaHDnS/2dH5QsuRAp8ZN8P40Byj5mO+b6lZNNwoQhT
        41RxiRww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4iuR-002GrT-UF; Fri, 24 Jun 2022 12:59:39 +0000
Date:   Fri, 24 Jun 2022 05:59:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, Joerg Roedel <jroedel@suse.de>,
        Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] MAINTAINERS: Add new IOMMU development mailing list
Message-ID: <YrW1Oy0ojM5pXREB@infradead.org>
References: <20220624125139.412-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624125139.412-1-joro@8bytes.org>
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

On Fri, Jun 24, 2022 at 02:51:39PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The IOMMU mailing list will move from lists.linux-foundation.org to
> lists.linux.dev. The hard switch of the archive will happen on July
> 5th, but add the new list now already so that people start using the
> list when sending patches. After July 5th the old list will disappear.

Shouldn't this also remove the old list given it has only a few days
to live?
