Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B05218698
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGHMAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 08:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgGHMAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 08:00:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3B52065C;
        Wed,  8 Jul 2020 12:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594209631;
        bh=w085q45SPqD2hdeLzVqfVElQr80zw3mosGyuMIzddq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m2byPUUn6VcGfYNTxLPwJIhHovpkZRkBumD9QKcJ9SoIY+NUYrNwQrVmB2xpdKkdD
         ZBZp99mtQVL2vMltCgPmOFQxmAmuWAFoIL6nHSn/NftboehGp/QYmxD7+wzJOj/oOn
         lzT7o0oK221I0Y4/YsKpt2RLJLrdIwHDNJdQRpoU=
Date:   Wed, 8 Jul 2020 14:00:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     stable@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: "KVM: s390: reduce number of IO pins to 1" for stable
Message-ID: <20200708120027.GA651517@kroah.com>
References: <20200706171523.12441-1-pbonzini@redhat.com>
 <41c4e9e5-441f-3777-e399-70c82a2633e5@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41c4e9e5-441f-3777-e399-70c82a2633e5@de.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 01:33:49PM +0200, Christian Borntraeger wrote:
> stable team,
> 
> 
> Please consider commit 774911290c58 ("KVM: s390: reduce number of IO pins to 1")
> for stable. This can avoid OOM killer activity on highly fragmented memory
> even when swap and memory is available. 
> 
> We decided too late that this is stable material, so sorry for not marking it
> correctly. 

For what stable tree(s) is it relevant for?

thanks,

greg k-h
