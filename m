Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6C418898
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhIZMVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231344AbhIZMVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:21:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EB5360F92;
        Sun, 26 Sep 2021 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632658767;
        bh=LycJZaJPCD2qNM4COTsWjXggxadANHWRBht74JQD7xI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t8JMXYJ4omdoCTa9bwmtr7BvxmIXwtBOmFzbiRdCqfGAWP0/gBc6XTLblFweM3IeV
         1p/GrM6tW1F12RvoTPJCStFbAxcjN5SKOoPZTY61JmkaCDWDZYt8hi941zzzzk1SA5
         V7uDncGAsAb93VHF5qoCpJGGrWMxJVWC00uk7zWg=
Date:   Sun, 26 Sep 2021 14:19:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to
 1.5s while waiting" failed to apply to 5.10-stable tree
Message-ID: <YVBlSNYjASqDizPG@kroah.com>
References: <16317166872028@kroah.com>
 <20210915165243.xaviyv4pwdmk6vhi@pali>
 <20210925214639.3fnbfc5eovd5bzqg@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210925214639.3fnbfc5eovd5bzqg@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 11:46:39PM +0200, Pali Rohár wrote:
> On Wednesday 15 September 2021 18:52:43 Pali Rohár wrote:
> > On Wednesday 15 September 2021 16:38:07 gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Hello! Below is backport for 5.10 (and probably it should apply also for
> > older versions):
> 
> Hello Greg! Have you looked at this backport for 5.10?

Ick, I somehow missed this for 5.10.y, thanks for catching it.  I'll go
queue it up now.

greg k-h
