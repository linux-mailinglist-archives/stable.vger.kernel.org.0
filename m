Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620E12BFC3
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 08:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfE1GyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 02:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbfE1GyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 02:54:06 -0400
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4F32075B;
        Tue, 28 May 2019 06:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559026446;
        bh=Koq5vEOAleX7jJxDbpxwXPjUUIloA42daR06FqSOGuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0v0QI5ggUdnPfiye3FY+0lyjs2OFR2oa2udLThbWJ7aGU34bpgwHVCsKsnRnvurPz
         LAWM78KoaJHpAGhrU0UcWUoMEQPnRY3qUWXsxfkFs+q51JDoFclbzACd9sgOibHVHc
         qqRs0583xXGhi3Zdr3wCV5aBY8+1EjBoo+n+1+T0=
Date:   Tue, 28 May 2019 08:54:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] Security fixes for brcmfmac
Message-ID: <20190528065403.GC2623@kroah.com>
References: <1558992664.2631.12.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558992664.2631.12.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 10:31:04PM +0100, Ben Hutchings wrote:
> Please pick the following fixes to brcmfmac for the 4.14, 4.19, and 5.0
> stable branches:
> 
> 1b5e2423164b brcmfmac: assure SSID length from firmware is limited
> a4176ec356c7 brcmfmac: add subtype check for event handling in data path
> 
> They are also needed for earlier branches, but they don't apply cleanly
> so I will send patches later.

Thanks for letting me know, both now queued up.

greg k-h
