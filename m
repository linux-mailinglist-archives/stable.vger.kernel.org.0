Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25645126523
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 15:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLSOrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 09:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfLSOrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 09:47:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B9B32053B;
        Thu, 19 Dec 2019 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576766828;
        bh=rVU1vC8HYIGK4Bl9VIZXc8ZtnzCOjjAeV/VU/SErGSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wJ8Ca1khvjJ6ocW0pM/u3sZEopoXP5g1qjSeyee10ml6KC0EauO4xLwJf1N3c4VEc
         1/w5Vbr0tmknXMRMKKWz20JMLivZ59Nk9VnetoBzqKu3kBubgjT3Q1ccKvemYQG3qB
         Tx1GmZWPLrM9AMqg/nNq4RnnOHtrKe72chv+vUnk=
Date:   Thu, 19 Dec 2019 15:47:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     stable@vger.kernel.org, Lee Hou-hsun <hou-hsun.lee@intel.com>,
        Lee Chiasheng <chiasheng.lee@intel.com>
Subject: Re: [PATCH backport 4.9 4.4] xhci: fix USB3 device initiated resume
 race with roothub autosuspend
Message-ID: <20191219144705.GA1960287@kroah.com>
References: <20191219120632.4037-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219120632.4037-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 02:06:32PM +0200, Mathias Nyman wrote:
> commit 057d476fff778f1d3b9f861fdb5437ea1a3cfc99 upstream
> 
> Backport for 4.9 and 4.4 stable kernels

Thanks for these, all 4 of them now queued up.

greg k-h
