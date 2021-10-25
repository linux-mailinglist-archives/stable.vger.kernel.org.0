Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7674391BA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhJYIvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhJYIva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 04:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3199460EE9;
        Mon, 25 Oct 2021 08:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635151748;
        bh=7xYC8z2v2133Fm/+cEUHm2aaM69ew42icd/6tyvvl6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tY5ecPrhJgNpH+B9gpZpuilc0RH2q4SVO3EcstKJXdvGb0CcrcWI4tz9pJ1YL0ej3
         1UDqqOEBXcHDhdZztEJYR16zfmUicsOdYFFfomGHHEBXXbJ7Rq1mYSqa3ZjNVr9/x+
         fCIsvXABn7IoVOTXhgl3nAoOd+zBoTKVTwtDFWnM=
Date:   Mon, 25 Oct 2021 10:49:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.14 1/2] s390/pci: cleanup resources only if necessary
Message-ID: <YXZvghpz4NuK6Llc@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
 <20211021141341.344756-2-schnelle@linux.ibm.com>
 <YXVLsMbqZ389YHX8@kroah.com>
 <YXZhPl880f8an3UR@kroah.com>
 <1bb91a1b400c10c0b54f445cc6af8525576946b9.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bb91a1b400c10c0b54f445cc6af8525576946b9.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 10:43:46AM +0200, Niklas Schnelle wrote:
> On Mon, 2021-10-25 at 09:48 +0200, Greg KH wrote:
> > On Sun, Oct 24, 2021 at 02:04:00PM +0200, Greg KH wrote:
> > > On Thu, Oct 21, 2021 at 04:13:40PM +0200, Niklas Schnelle wrote:
> > > > commit 023cc3cb1e4baa8d1900a4f2e999701c82ce2b6c upstream.
> > > 
> > > This is not a commit in Linus's tree :(
> > > 
> > 
> > It is 02368b7cf6c7 ("s390/pci: cleanup resources only if necessary"),
> > don't know where the sha1 you have here is from :(
> 
> Oh sorry yes, this the correct commit. Mixed up and got the hash from a
> local branch, even managed to match the first 3 digits. I resent with
> the correct hash.
> 

Already queued up, just need a 5.10.y version now, thanks.

greg k-h
