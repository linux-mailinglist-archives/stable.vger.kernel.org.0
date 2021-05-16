Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BDD381EC8
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhEPMcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 08:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhEPMcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 08:32:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27140C061756
        for <stable@vger.kernel.org>; Sun, 16 May 2021 05:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D+VfpzHVykKomFZMr2BUPiHEv4+HQDs6qEWfHqHULgM=; b=V3Mm1xurx/hiR2K1Ae/QwJh/R3
        CxBbp/qWHTdC6GJgpNDYeHqFxaibgy1zTJk7+cjOOERuaCe0Ht/nwVah7JU3QzqnprN/dVJBgevbc
        XdJygXdk5M2gkmZYZMysT/bHKeXeD+ipQtuMllnNgBqtqREGiQsp1Jq2WiJcDisw+jHyDy6eIJqBr
        kYXgvyhlLvc97Jyps9EcViJzAEBlPA1vy1qHFhe82MD0OjgCdqazNjzpZ0FcRcPhbdaejOZPrDlQ5
        cpEvQPNQACebpGjAqGXaQqr0bpO0J2LJ4yZ1o1pXWcCBfZR0p2PmdHDV9AmOaMi7ZH1sau/T1V/Tc
        cniXp/TA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liFvF-00C0eS-5P
        for stable@vger.kernel.org; Sun, 16 May 2021 12:31:10 +0000
Date:   Sun, 16 May 2021 13:31:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKEQib+uC8t+gr8z@casper.infradead.org>
References: <20210516121844.2860628-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516121844.2860628-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to label this one -- it applies to 5.10/5.11/5.12.
See other patch for 5.4.

