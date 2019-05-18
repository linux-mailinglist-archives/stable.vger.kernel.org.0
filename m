Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C4221E9
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 08:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbfERG4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 02:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfERG4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 02:56:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2287E2166E;
        Sat, 18 May 2019 06:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558162598;
        bh=+u07tRr6vOatJ2rDH+HwtKI2kHw47Dz0Vy9KEsSmRSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qB9Zz9nqMQx8LqtOLOig8fmroNbIohOpItlfNvvg9GPUXwoWk/kPHkD0MmPBtWm3k
         5xNBg+Op7/GRdZ9CWrXQF7nhUb/lZ+kljLa/7v3mLyTJatbiFu/+Wo70q6/7K9kSmr
         +vJVikbNJim2OK7ZjTQZsWeN3SPNcjzrL0Q8nTIg=
Date:   Sat, 18 May 2019 08:56:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@google.com>
Cc:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: gcm - fix incompatibility between
 "gcm" and" failed to apply to 4.9-stable tree
Message-ID: <20190518065636.GC28796@kroah.com>
References: <15580966386436@kroah.com>
 <20190517174025.GB223128@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517174025.GB223128@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:40:25AM -0700, Eric Biggers wrote:
> On Fri, May 17, 2019 at 02:37:18PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From f699594d436960160f6d5ba84ed4a222f20d11cd Mon Sep 17 00:00:00 2001
> > From: Eric Biggers <ebiggers@google.com>
> > Date: Thu, 18 Apr 2019 14:43:02 -0700
> > Subject: [PATCH] crypto: gcm - fix incompatibility between "gcm" and
> >  "gcm_base"
> > 
> 
> Can you apply the following commit first?  Then this one applies cleanly:
> 
> 	commit 9b40f79c08e81234d759f188b233980d7e81df6c
> 	Author: Wei Yongjun <weiyongjun1@huawei.com>
> 	Date:   Mon Oct 17 15:10:06 2016 +0000
> 
> 	    crypto: gcm - Fix error return code in crypto_gcm_create_common()

Thank you, that worked!

greg k-h
