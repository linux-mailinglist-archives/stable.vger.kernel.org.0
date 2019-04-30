Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBDEF452
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfD3Khx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 06:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfD3Khx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 06:37:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E2B2075E;
        Tue, 30 Apr 2019 10:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556620673;
        bh=Adu11RItFO9r3zbk9rSrJJtqi4RFZUGpULMOz/Q7ZYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKUhQ4MogALpSxrHfUf7rFOuqBWh+34klKvQZtG0PgimMow5iy/0M0BS8lX1pujPb
         GybpKK51XER9LDcQB5X4bJkRZVMRt7qPLLmHEux7yGRLeqmV4tY5hshC/6/s789phS
         rRwqpC7yUjdDDRUEUHdBKOZAkSkZanMzysY0w5xg=
Date:   Tue, 30 Apr 2019 12:37:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diana Craciun <diana.craciun@nxp.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH stable v4.4 7/8] powerpc/fsl: Add FSL_PPC_BOOK3E as
 supported arch for nospectre_v2 boot arg
Message-ID: <20190430103750.GA10539@kroah.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
 <1556552948-24957-8-git-send-email-diana.craciun@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556552948-24957-8-git-send-email-diana.craciun@nxp.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 06:49:07PM +0300, Diana Craciun wrote:
> commit f633a8ad636efb5d4bba1a047d4a0f1ef719aa06 upstream.

No, the patch below is not that git commit :(

I'll stop here in applying these patches.

thanks,

greg k-h
