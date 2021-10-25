Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375B5439093
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhJYHui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhJYHui (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 03:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DCE260E05;
        Mon, 25 Oct 2021 07:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635148096;
        bh=b9t62NTnJVBvsb3SCcHmPPXaUMjJ6afSF9Ug9E6JIX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TRQT+6krhZCvEd1tDl8vM+4UnTHbaQlImnztRTuT5Jl/6JbNTeQsjnXLBlpGtFV+S
         P20hZSiQrZbzm5dgq4XipDhujFF0tnK2MjGbqA3GBiO/1LyG/JLjmYHF+6fBEi8LuT
         8ZrGj7ABs3VQmZdi4Kgr9c2gZdJO01xPcZo2GB74=
Date:   Mon, 25 Oct 2021 09:48:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.14 1/2] s390/pci: cleanup resources only if necessary
Message-ID: <YXZhPl880f8an3UR@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
 <20211021141341.344756-2-schnelle@linux.ibm.com>
 <YXVLsMbqZ389YHX8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXVLsMbqZ389YHX8@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 24, 2021 at 02:04:00PM +0200, Greg KH wrote:
> On Thu, Oct 21, 2021 at 04:13:40PM +0200, Niklas Schnelle wrote:
> > commit 023cc3cb1e4baa8d1900a4f2e999701c82ce2b6c upstream.
> 
> This is not a commit in Linus's tree :(
> 

It is 02368b7cf6c7 ("s390/pci: cleanup resources only if necessary"),
don't know where the sha1 you have here is from :(
