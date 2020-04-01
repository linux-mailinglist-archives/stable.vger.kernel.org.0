Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B528419A4F7
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 07:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgDAFv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 01:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbgDAFv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 01:51:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DB42074D;
        Wed,  1 Apr 2020 05:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585720316;
        bh=300rTD67tIjehHXi6oyNfVRMk6w8gOppwHWZGGAJgp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RFD7M7HlNyO3UNQqS/beLoAxweszcg8EiVEoV43IFOPgdA8hg9VIxt5awSz1rfvgZ
         Wjp7t098PZuibQP7pj528Rm+0R9tZ7Nr6/0lhPW3RS3XKAHEzNjs8jcrj7xl4goVd+
         Wsv4IbFKE0iudO+jpW81a10xGbFZliNX0t7WInNk=
Date:   Wed, 1 Apr 2020 07:51:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Woody Suwalski <terraluna977@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401055152.GA1903194@kroah.com>
References: <20200331085308.098696461@linuxfoundation.org>
 <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 11:06:16PM -0400, Woody Suwalski wrote:
> Greg Kroah-Hartman wrote:
> I think you have missed the
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

It should come in soon, in another release or so, when the next set of
networking patches get sent to me.

thanks,

greg k-h
