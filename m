Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C38526CFB1
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 01:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIPXh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 19:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 19:37:58 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C6C22207;
        Wed, 16 Sep 2020 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600299478;
        bh=oTiutNRnQeTLVdZaIo0gxpqheAp3Tb/+c5M1702C67Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rEFZNIUbdtuWvvwDGDdT9oXzv8Ync4w5KbAwXrhBXqi0D2GYLA+SkUieOJQk5zDjS
         IG/Qg5ByQmzCtmf3NIRo7IPH3FQ/GKrhBsNqPzg+v9kpDKiCDxFEB7YssmnZsj5hlI
         DCZEs1MVUZk+eI22w4WMwJMjPIj1HVjpehsxbRag=
Date:   Wed, 16 Sep 2020 16:37:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
Message-Id: <20200916163756.af1bece4bbd1937a20a727df@linux-foundation.org>
In-Reply-To: <f522bcb8-575e-0ac7-69cb-1064e8b38c58@linux.ibm.com>
References: <20200915121541.GD4649@dhcp22.suse.cz>
        <20200915132624.9723-1-ldufour@linux.ibm.com>
        <20200916063325.GK142621@kroah.com>
        <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
        <20200916074047.GA189144@kroah.com>
        <9e8d38b9-3875-0fd8-5f28-3502f33c2c34@linux.ibm.com>
        <95005625-b159-0d49-8334-3c6cdbb7f27a@redhat.com>
        <f522bcb8-575e-0ac7-69cb-1064e8b38c58@linux.ibm.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Sep 2020 18:09:55 +0200 Laurent Dufour <ldufour@linux.ibm.com> wrote:

> >>> It's up to the maintainer what they want, but as it is, this patch is
> >>> not going to end up in stable kernel release (which it looks like is the
> >>> right thing to do...)
> >>
> >> Thanks a lot Greg.
> >>
> >> I'll send that single patch again with the Cc: stable tag.
> > 
> > I think Andrew can add that when sending upstream.
> 
> Andrew, can you do that?
> 

I did.

Patches 1 & 2 are cc:stable, patch 3 is not.

I'll queue up 1 & 2 for a 5.9-rcX merge.

