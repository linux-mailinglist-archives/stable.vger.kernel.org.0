Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98D134587C
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 08:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCWHUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 03:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhCWHUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 03:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86713619AB;
        Tue, 23 Mar 2021 07:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616484014;
        bh=xf/FJRT3op6/DF9iLA9eJZ5X6gvMzU0dp2gmxrew8Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0SLi843WFB3SJZg1fnvsZ7anQHXNe+tpuxQ/BMjEaOPoHHmBW0dcKdyzsuaC4pXqd
         luEzlgoRzJAgbshLSsQLvskuorTzaTRNSSeoCreTX+NTibG6CB12inl1cjD8JTYh4U
         yEgwJXtSt6KmGoREjyW3ICqqpWHnu+jo3mYDW3Us=
Date:   Tue, 23 Mar 2021 08:20:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Isaku Yamahata <isaku.yamahata@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, brijesh.singh@amd.com,
        tglx@linutronix.de, bp@alien8.de, isaku.yamahata@gmail.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] X86: __set_clr_pte_enc() miscalculates physical address
Message-ID: <YFmWq1uuvCiiBhBb@kroah.com>
References: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
 <0d99865a-30d5-9857-1a53-cc26ada6608c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d99865a-30d5-9857-1a53-cc26ada6608c@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 04:02:11PM -0500, Tom Lendacky wrote:
> On 3/18/21 3:26 PM, Isaku Yamahata wrote:
> > __set_clr_pte_enc() miscalculates physical address to operate.
> > pfn is in unit of PG_LEVEL_4K, not PGL_LEVEL_{2M, 1G}.
> > Shift size to get physical address should be PAGE_SHIFT,
> > not page_level_shift().
> > 
> > Fixes: dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
> > Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
