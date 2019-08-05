Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0896823DA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbfHERSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfHERSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:18:34 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A80220880;
        Mon,  5 Aug 2019 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025513;
        bh=DsKTo+gj4/5QL+cFumUzNcE1pReFfAPkdBCflJUZ6Jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qidQWhBuUBEERhxV2FagJjsnlP7UdZJGAqJGCGXaeHIqSmc7F4o22oOOMFomFB9Ii
         4A5J7jV2xKoVLXr5wnxGxfLQJwfJ5+KiwEdkXfAhZcTxXQ4UDEZyJSCbBfRtTmdtWQ
         9iLlt5XcusK9Jy7clzYHGrllfn76Xo6183LWc5i0=
Date:   Mon, 5 Aug 2019 18:18:29 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] arm64: cpufeature: Fix feature comparison
 for" failed to apply to 4.14-stable tree
Message-ID: <20190805171829.ac23vgysff3dcivd@willie-the-truck>
References: <156498316678190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156498316678190@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 07:32:46AM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backport posted to:

https://lore.kernel.org/stable/20190805171410.19358-1-will@kernel.org/T/#u

Will
