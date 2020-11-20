Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E17A2BA558
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgKTI7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgKTI7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:59:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028382224C;
        Fri, 20 Nov 2020 08:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605862756;
        bh=1LWDK9wxtiHw0M8wzUFGuapScSNSyTYrfvzGmXcfH8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJT/PvHRrKa4c9dtZHdl888KShjSPLbhoJTAhjCfzTcaEojVx7t6uCU/E1+YSK+gk
         73HqRlsXwDF6DLETgBW6PEhdXkmTZSOCAQdwXAm5c68ue354eQGsk6ivbCwOGkRXO3
         JRGvpmrSFGF38tI8Zd/+/bqOlYC/PXH7RZOuCkfo=
Date:   Fri, 20 Nov 2020 09:59:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 5.4] powerpc/8xx: Always fault when _PAGE_ACCESSED is
 not set
Message-ID: <X7eFjrnW6pK9MA52@kroah.com>
References: <d18243335a9a31763ab5455a31a0345707771dec.1605774898.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18243335a9a31763ab5455a31a0345707771dec.1605774898.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 08:47:54AM +0000, Christophe Leroy wrote:
> [This is backport for 5.4 of 29daf869cbab69088fe1755d9dd224e99ba78b56]
> 
> The kernel expects pte_young() to work regardless of CONFIG_SWAP.

All backports now queued up, thanks.

greg k-h
