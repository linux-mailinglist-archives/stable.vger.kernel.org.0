Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B67AC8D7
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391613AbfIGSrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 14:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729261AbfIGSrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 14:47:15 -0400
Received: from localhost (unknown [80.251.162.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE82208C3;
        Sat,  7 Sep 2019 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567882034;
        bh=ETlwQ/jDA2N/DocT9nVHq8Y/UgXTj0x2ZCKwFEuLirk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d7lhWhd3bM0O9T6OXqLR+D+sy4YnWKGTzPUhmGx3IkD1+rtUZte3doy/Va48GtOs/
         +zkSqCS2GA5vzm35V7WOhaJjpj7Phxgp7RXUp5ZGpXcMMxQ8zzMFQIgFAat2geji0y
         U65bTTi55rNld7a+p+dw/jaNgyAHfN93goAV+yWM=
Date:   Sat, 7 Sep 2019 19:47:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Francois Rigault <rigault.francois@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Vishnu DASA <vdasa@vmware.com>, stable@vger.kernel.org
Subject: Re: [PATCH] VMCI: Release resource if the work is already queued
Message-ID: <20190907184711.GA30206@kroah.com>
References: <20190820202638.49003-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820202638.49003-1-namit@vmware.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 01:26:38PM -0700, Nadav Amit wrote:
> Francois reported that VMware balloon gets stuck after a balloon reset,
> when the VMCI doorbell is removed. A similar error can occur when the
> balloon driver is removed with the following splat:

<snip>

Note, google thinks your email is spam as you are not sending this from
a valid vmware.com email server.  Please fix this up if you want to make
sure your patches actually make it through...

thanks,

greg k-h
