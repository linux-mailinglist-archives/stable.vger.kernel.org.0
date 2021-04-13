Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F135E343
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 17:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhDMP5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 11:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhDMP52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 11:57:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD0AC061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 08:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=na1Wr+UddoqteY1PW44J5UqsiQXXRQvO9/9AwEIe/ow=; b=MRMKNN1NbWXd6VEz8O9v2uWdtl
        N1vjXFKWYmFxyICGBVmyOrqQfZXy8ZqRoNLHE93f2xK9D743audnKR0hBlB1b7oRgBPBiORHMFYQe
        GSBGmLk6KtUsEUEiTY5D5mhGqTtP9lrACRFu+5TTYvSg57TxPjvti8HXquosvOsjmi9iZq/sR+VDM
        6VJb1YKg/LOZYJAtizBU1xwMPHM1Gs3tJNjxHmktailQCdN8ibsruLjKa7fh7tB6GTwK0wZ6J3fxx
        dWaFJu1p/0vEZ2wkeAZrOoJHIlTiHR1w2K7l3MZV/kPvYR+ffPLq6M+dzOw7/qgeZvoJvSBRPiUQH
        e7XjkSFQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWLOh-005wZe-O9; Tue, 13 Apr 2021 15:56:16 +0000
Date:   Tue, 13 Apr 2021 16:56:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com
Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Message-ID: <20210413155615.GA1415050@infradead.org>
References: <1618308289-12929-1-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618308289-12929-1-git-send-email-Prike.Liang@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is still not split into separate patches for the PCI and nvme
parts.
