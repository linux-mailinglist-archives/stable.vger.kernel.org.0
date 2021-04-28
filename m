Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F736D17C
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 06:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhD1E6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 00:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhD1E6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 00:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6DE61408;
        Wed, 28 Apr 2021 04:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619585860;
        bh=zIiT1PbUs+SyDYaLo3CJMY/RugWKH7CbaBZpa2MBVaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDvsCeJV3YdeTEg7qq2m+H6sSGL/Jsv7BMyL550JqWyJghbNggmpXSykfN4G+Z+vF
         V9ELCEXkZmO4bld6WmEvZtPsexhCG4i6BsqIgRtI5wjqW8g5tJ69yRfV8tlQ2KoZ4c
         WeYM35cb8f9kJaQVJ5Dp8ke5zOEv2rGAthFzfE4g=
Date:   Wed, 28 Apr 2021 06:57:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
Message-ID: <YIjrQdJtpJ0br5m9@kroah.com>
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
> CC+ stable@vger.kernel.org
> 
> On 4/27/2021 6:17 PM, George Kennedy wrote:
> > Hello Greg,
> > 
> > We need the following 2 upstream commits applied to 5.4.y to fix an iBFT
> > boot failure:
> > 
> > 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
> > Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
> > 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
> > Wysocki ACPI: x86: Call acpi_boot_table_init() after
> > acpi_table_upgrade()
> > 
> > Currently, only the first commit (1a1c130a) is destined for 5.10 & 5.11.
> > 
> > The 2nd commit (6998a88) is needed as well and both commits are needed
> > in 5.4.y.

Is this a regression (i.e. did this hardware work on older kernels?),
and if so, what commit caused the problem?

These commits are already in 5.10.y, what changed in older kernels to
require this to be backported?

thanks,

greg k-h
