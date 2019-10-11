Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3894BD4011
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 14:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfJKM6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 08:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbfJKM6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 08:58:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 269D5206A1;
        Fri, 11 Oct 2019 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570798721;
        bh=t8zfNEIofHvVu2Wei3y+UkR0jiiJAB6OS6pOU28U8nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABi5DAe/Y/Zm2p+Az41NPnPFW40sWPwWL6y2DC5HHkt0MfQDMdM471JGaeTpAulXs
         KvOQeEaxNV1d0OiyF8pQTqAHlRCTtRr8lH6r9rn+PpUyCgW3IZojC+Ed+0pPD0/CAQ
         iHTMg43O0JHi/bsoqEiIUj7Es0UIHs7BrZ6i2Hh8=
Date:   Fri, 11 Oct 2019 14:58:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 082/114] powerpc/book3s64/radix: Rename
 CPU_FTR_P9_TLBIE_BUG feature flag
Message-ID: <20191011125838.GA1147624@kroah.com>
References: <20191010083544.711104709@linuxfoundation.org>
 <20191010083612.352065837@linuxfoundation.org>
 <20191011112106.GA28994@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011112106.GA28994@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 01:21:06PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> > 
> > Rename the #define to indicate this is related to store vs tlbie
> > ordering issue. In the next patch, we will be adding another feature
> > flag that is used to handles ERAT flush vs tlbie ordering issue.
> > 
> > Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
> > Cc: stable@vger.kernel.org # v4.16+
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link:
> > https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com
> 
> Apparently this is upstream commit
> 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 , but the changelog does not
> say so.

Yeah, somehow when Sasha backported this, he didn't add that :(

Nor did he add his signed-off-by :(

I'll go fix it up and add mine, thanks for noticing it.

greg k-h
