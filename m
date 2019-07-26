Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF67635F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 12:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfGZKUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 06:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfGZKUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 06:20:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E0E229F9;
        Fri, 26 Jul 2019 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564136417;
        bh=wuPxyatQ1ntgFgEXrwH5AO093BynmbAnbAZWIiXMcHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=voVfPsZz3erZ33xg4eaa3gZXfjbNWoH+Z42jsm31w/BoT6K8i8lhsoETn+ACgHOS2
         xOg3l4FDqYiQsPdLpwgjxu0hPjYeh+hg5kPhC1oE+UlwsJ2Z4gVYcvej5YCPKIBprd
         NShoT9YtP58nd8KeAC8VNAbdPtZxWQSYGSGErlHA=
Date:   Fri, 26 Jul 2019 12:20:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190726102010.GB22476@kroah.com>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> results in a firmware fault.
> 
> Fix:
> Driver will set 63-bit DMA mask to ensure the above address
> will not be used.
> 
> Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
