Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43D13D1694
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbhGUSCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 14:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbhGUSCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 14:02:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F906C061575;
        Wed, 21 Jul 2021 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9RT4PyD91dRKt/JcdMzt4T8CVasdTpw3pfAjcsgWVk4=; b=wZJ2oFLgnqPkvGsQjb54IVdM11
        1QyaCu74yf7MAPhpTK8hvKrOsN/Sa8z0UsgX9TU1/MkVp10mRCxeKNnbQoO+f7CHpvsNT4KVtSCCU
        /1zgCeTSMlbxbwLiO0/QURyZ/Ox0e+HTg82tQWAue1IBUNn6O1DK5vBe9cdv8navMvbGFY3VHmphp
        J10hU87wQOzeWw9DHb0Xb6z9jEh1IczLM+qDPMDdR7dTBk22IkUm+jgA09svhhrDB2m+D7o/JyYzt
        87ilDYkZ9ANLoU+NzIGiT3TABOaugyANGybsnEVkduOS95XjqSzkal/lxdLo+lMClUA9LGLvPtisI
        nxZg6XJw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6HBL-009VB3-Kf; Wed, 21 Jul 2021 18:43:07 +0000
Date:   Wed, 21 Jul 2021 19:42:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Camera <bugs+kernel.org@dtnr.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: fix mount mode command line processing
Message-ID: <YPhqswl0EbBoqDZ0@casper.infradead.org>
References: <20210721183326.102716-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721183326.102716-1-mike.kravetz@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 11:33:26AM -0700, Mike Kravetz wrote:
> In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing
> of the mount mode string was changed from match_octal() to fsparam_u32.
> This changed existing behavior as match_octal does not require octal
> values to have a '0' prefix, but fsparam_u32 does.
> 
> Use fsparam_u32oct which provides the same behavior as match_octal.
> 
> Reported-by: Dennis Camera <bugs+kernel.org@dtnr.ch>
> Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> CC: <stable@vger.kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
