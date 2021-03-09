Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E598332286
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCIKEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 05:04:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3931EC06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 02:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mj8eBj+VT4BL6egNSJRqQr4Kz1rqAxuIWsFt0M1Ifrk=; b=B5kzfAztvwnbNwxH63mkIYk2+H
        3xrS0O/ElWDTvbu+cqV3g1Fv3N6coU9FiFuWb0diwUKpnCdHIqtobIvj95onVySHWzg/YYkd15cJJ
        O1EyiLJdQWMVJb1icTMDPSGQBxahOF1AtNdMIjE0DttQvX27xfhFIEqDg1Pa/34RklctufOe4LRjt
        rTDPALIFus7K3nl2FH3/GFR1WK4IdX3xXLWWcm5WKKgVkrBFiXGArHX5h0CuEWXlonkhkBlPkjm2i
        ZnLgTAs54f1wp56wwwZykBCvXgKD91FmhJLVQlRsfHXDiwwkwAkp8k/YwY15S5j2VMPQnWC5fIm/M
        vJbeYWdA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJZDf-000QGN-C5; Tue, 09 Mar 2021 10:04:06 +0000
Date:   Tue, 9 Mar 2021 10:04:03 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, emilne@redhat.com,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>
Subject: Re: [PATCH v2] nvme-fc: fix racing controller reset and create
 association
Message-ID: <20210309100403.GA100868@infradead.org>
References: <20210309005126.58460-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309005126.58460-1-jsmart2021@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-5.12.
