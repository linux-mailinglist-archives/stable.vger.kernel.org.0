Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E801361C9
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 21:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgAIU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 15:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgAIU13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 15:27:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FAA72072A;
        Thu,  9 Jan 2020 20:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578601649;
        bh=kONMymtiH/9dXPtXqzdEAzqFnZQb1jMMHojTiC7QWTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y6eBk9/Re7rJJGM25qiR9Nlept3qf4sl7P63+Dos2+xFPyJUMePODHyXEgzg1HKC0
         JlieXNKelOuU0wgQJLqv1j3v4vqNJkIJZMaBDlV9tmngxDh4FaJwjWS4aiW/nKrqaf
         71eWE2uzXJgh7S8BwP+Ia7JMJ8Z/2HsoqR0V8iCI=
Date:   Thu, 9 Jan 2020 21:27:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.4.10
Message-ID: <20200109202727.GB7962@kroah.com>
References: <20200109202717.GA7962@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109202717.GA7962@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3ba15c3528c8..726bb3dacd5b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 460afa415434..d30a2e6e68b4 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -120,7 +120,7 @@ static void flush_dcache_range_chunked(unsigned long start, unsigned long stop,
 	unsigned long i;
 
 	for (i = start; i < stop; i += chunk) {
-		flush_dcache_range(i, min(stop, start + chunk));
+		flush_dcache_range(i, min(stop, i + chunk));
 		cond_resched();
 	}
 }
