Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1E124B0BD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgHTIGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgHTIGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B472080C;
        Thu, 20 Aug 2020 08:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597910780;
        bh=Sx5yyiEC1FpvUXVsEDeL59EhbArvoPGIE5qp+2ZgREY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dd1qfev3CTiEY6ouTiINLJ8wcqIr80ZzsqCP4j36A7Fyq+BZ+QnwjTPabaUqdYjaO
         y+R2VIkFMJz9IAHeEFCcZzVoEiArp2yNZ5Wh3x00RA2/BzQNx1TWcGuA4hifK7jqAq
         yoNHM7KhCZDG4l+pHRguw4/pJq1WlQbTNyV8A49Y=
Date:   Thu, 20 Aug 2020 10:06:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] khugepaged: retract_page_tables()
 remember to test exit" failed to apply to 5.7-stable tree
Message-ID: <20200820080640.GB4049659@kroah.com>
References: <1597839864213170@kroah.com>
 <alpine.LSU.2.11.2008191725400.24973@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008191725400.24973@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 05:28:10PM -0700, Hugh Dickins wrote:
> On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> ------------------ rebased commit in Linus's tree ------------------
> 
> >From 18e77600f7a1ed69f8ce46c9e11cad0985712dfa Mon Sep 17 00:00:00 2001
> From: Hugh Dickins <hughd@google.com>
> Date: Thu, 6 Aug 2020 23:26:22 -0700
> Subject: [PATCH] khugepaged: retract_page_tables() remember to test exit

<snip>

All of the backports now queued up, thanks!

greg k-h
