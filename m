Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B23CB48B2
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404583AbfIQIAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730600AbfIQIAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 04:00:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9182189D;
        Tue, 17 Sep 2019 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568707216;
        bh=+lR0jnNqxv9Byr7EwMkc589pkTQrcw710KzCgsC1f/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z9fzlFM7Hd8deUn211VrQ7F/UhBs6BfYp4IY2GWTBKi1R8M1Z+rwH1VL/tVUjj2e8
         Aqx6aT36mZGfq91+bGJkwr6HV1U9GNiQAH5sJCXf0NPCTLiw2BXP3/7p/bnlQaynfZ
         yZiDGjzY6H3AFEjQcY/61RrOqPeFXT2g9X6s/t78=
Date:   Tue, 17 Sep 2019 10:00:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Paul Burton <paul.burton@mips.com>
Subject: Re: mips patches for v4.4.y, v4.9.y, and v4.14.y
Message-ID: <20190917080010.GB2075173@kroah.com>
References: <d1030b70-e919-a082-837c-8ac4bb5aaa96@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1030b70-e919-a082-837c-8ac4bb5aaa96@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 06:27:03PM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> please apply the following patches to v4.4.y, v4.9.y, and v4.14.y.
> 
> 351fdddd3662 ("MIPS: VDSO: Prevent use of smp_processor_id()")
> 0648e50e548d ("MIPS: VDSO: Use same -m%-float cflag as the kernel proper")
> 
> The second patch fixes the build error reported for decstation_defconfig and others
> by kernelci, and the first patch is needed to avoid a merge conflict (and it doesn't
> hurt to have it in the branch).

Now queued up, thanks!

greg k-h
