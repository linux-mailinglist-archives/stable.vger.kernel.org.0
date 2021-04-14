Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6D35EC41
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 07:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhDNFgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 01:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhDNFgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 01:36:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48CF661244;
        Wed, 14 Apr 2021 05:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618378577;
        bh=Vj+HP59OMz3KDqYcngvrQ2A9lMs3T43KVgG8tJEsyeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HdSA141Gz7fxQaYyXhrOoLfaTXoGZWP5AJnaQ6pUBHhcN4CWkPuo2EeE89maXXGXK
         bF/3ETaztETAJQy9I5yKIjHmNGtuH8M9D/x1FJCPkDVMhRml+q0TZI8ofFnb8/BVf/
         pwABU/lZPYfVkaYFCE37RTFg9rVT0mMgwxgWbcJQ=
Date:   Wed, 14 Apr 2021 07:36:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Camille Lu <camille.lu@hpe.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5.4 v3 1/1] iommu/vt-d: Fix agaw for a supported 48 bit
 guest address width
Message-ID: <YHZ/T9x7Xjf1r6fI@kroah.com>
References: <20210412202736.70765-1-saeed.mirzamohammadi@oracle.com>
 <YHVJDM4CXINrO1KE@kroah.com>
 <0C3869E0-63C9-42D5-AAE2-D9D24011B93E@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0C3869E0-63C9-42D5-AAE2-D9D24011B93E@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 11:05:34AM -0700, Saeed Mirzamohammadi wrote:
> Hi Greg,
> 
> I don’t have any commit ID since the fix is not in mainline or any Linus’ tree yet. The driver has completely changed for newer stable versions (and also mainline) and the fix only applies for 5.4, 4.19, and 4.14 stable kernels.

Why can we not just take what is in mainline?

And if not, then you need to document the heck out of this in the
changelog text, and get all of the related maintainers in the area to
sign off on this.  Diverging from Linus's tree creates a big burden over
time, you have to make this really really obvious why you are doing
this, and what you are doing here so that everyone agrees with it.

Remember, 90% of all of these types of "do it differently than Linus's
tree" are buggy and cause problems, be very careful.

Please fix up and resend.

thanks,

greg k-h
