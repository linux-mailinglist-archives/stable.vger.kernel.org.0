Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC653546A6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 20:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhDESLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 14:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbhDESLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 14:11:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B3FC061756;
        Mon,  5 Apr 2021 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1DcSFcfs5hJKK+fhbOE6H8WkSNb3vT4ZfE9fsTtukpk=; b=L66P4A3PjIeQO6/jslYbDiXLnA
        8eb/QUsH1loXTfTQALSOa05Sf52ZfS2KJ1YGHGohXvyc1+gGe6+3wqRcm8i56UtrpFsgkxCbN5rOx
        DfNWA4n9cWJ5/VxeY8ycsADF7giR9RUNdvHBNwQ+hINErinYQfAQZar8jBYzpg5eHeY0JZfy3FP7i
        EukTtAsvAauUGiZgRR+TWgxJE8xR9aJkvD+fP3v3AVfTrHDdOm2QvzXRWpqfLTSmL/uZgIJDjudhW
        nMz4oPhMO60oFq6MwlKetYY2PTZnFaMhOfKL6/ykZN4YN9jV2NB1nnVtHMeVH1DAnRu5UZcBG2hrq
        4tsZ2/Kg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTTgr-00Bigl-Ew; Mon, 05 Apr 2021 18:11:14 +0000
Date:   Mon, 5 Apr 2021 19:11:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 6/8] radix tree test suite: Fix compilation
Message-ID: <20210405181109.GH2531743@casper.infradead.org>
References: <20210405160515.269020-1-sashal@kernel.org>
 <20210405160515.269020-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405160515.269020-6-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 12:05:13PM -0400, Sasha Levin wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> [ Upstream commit dd841a749d1ded8e2e5facc4242ee0b6779fc0cb ]
> 
> Introducing local_lock broke compilation; fix it all up.

I don't think local_lock has been backported to 4.19?
