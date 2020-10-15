Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF21D28F7A5
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgJORav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 13:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbgJORav (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 13:30:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1212225E;
        Thu, 15 Oct 2020 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602783051;
        bh=Fn37psXQwgsvIEZmLgJEDONyMCFDWwU02QJv5yw0bAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ONmGO8d5XPmqMJJzavAR+FutWScDH/ngjF0sTwLrl3NwYyep19ivWfmIul0QrHW1
         j6sHxSlcbFEzrGQ/UfOKpyLyWiixQsR/jxb7WJ3ywBcIYSnowGy/lER+L4BjhG0EdN
         mzBTexkD0jAIltAS2835nr9+C7cctpfKWWRnF5FY=
Date:   Thu, 15 Oct 2020 19:31:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     stable@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Forgue <andrewf@apple.com>
Subject: Re: acpi ged fix backport to 5.4 stable
Message-ID: <20201015173123.GC85496@kroah.com>
References: <74cde3d0-11fc-43fa-aaaf-ec61fd6ec318@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74cde3d0-11fc-43fa-aaaf-ec61fd6ec318@apple.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 07:37:22PM -0700, Vishnu Rangayyan wrote:
> Hi,
> 
> Can we have this backport applied to 5.4 stable, its a useful fix for
> generic kernels compatibility.
> 
> commit ac36d37e943635fc072e9d4f47e40a48fbcdb3f0 upstream
> 
> 

Now queued up, thanks.

greg k-h
