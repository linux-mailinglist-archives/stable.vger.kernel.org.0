Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71F23887BA
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 08:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhESGou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 02:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhESGou (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 02:44:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F9C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JfcaAWiL9MX/KzgqZFMd5GxaGaNC7KsyrSBFfXwwLXo=; b=s6tpzZl/vCPHQm8bwEcudEJ99+
        BCpIes9O4hr0XdndLBH8c8gp9XuHBzo1A8xlOcOXIkA4ML9K3/q3urUiW4O/UoeayXO5ENl3FGq7v
        CGZKzy2bRMZy705+eMX5OE0SHPpsBo3iUkxefPfjGFxF8IwZVCXE/5ujMxZonQL8OfwLjKmzBO55g
        3tQAFsd28NBnoBJEKgyWBiMSfauCCarezvz5Cw6y3CL9Kzgf2C2F4wnq9hNZYJrm/CIw1aEuZVwu8
        prL1Lkb+EK81d3kAyjNVoEM9q40mnm+ldmIGV5P3p7YuKAjx3VxSl3eFzb2jPcHBEix9uEJiJdLef
        bhoIdT+w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljFuD-00EhMY-7f; Wed, 19 May 2021 06:42:25 +0000
Date:   Wed, 19 May 2021 07:42:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
Message-ID: <YKSzQeErB18H7/Z6@infradead.org>
References: <20210511045635.12494-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511045635.12494-1-jsmart2021@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-5.13.
