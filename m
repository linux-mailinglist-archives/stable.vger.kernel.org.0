Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6082C5BBA
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 19:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404883AbgKZSKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 13:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404406AbgKZSKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 13:10:39 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B1F320B80;
        Thu, 26 Nov 2020 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606414238;
        bh=gYyFqYj7SYe38VKIBuS9np4f38ojFV2Q5kbW/65dZLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U1MTExAaor2rufgcgwiG1HTsOQlFxZPYV/ULW8cELFK/K2gVoaOmefuRi4eooUyQy
         fCYJ32UVdOJKLkAZcKh8tEf/i1mDgoBJlgxMpON51+slKFiAv/NvwE+IAShGIne6H5
         ULVdLpQla9Z7oeMn6ttH//BAWjftUCNpZB8mZ1LY=
Date:   Thu, 26 Nov 2020 19:10:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@google.com>
Cc:     balbi@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        EJ Hsu <ejh@nvidia.com>, Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/4] USB: gadget: f_rndis: fix bitrate for SuperSpeed and
 above
Message-ID: <X7/vnKU+QlWdES50@kroah.com>
References: <20201126180235.254523-1-gregkh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126180235.254523-1-gregkh@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 07:02:32PM +0100, Greg Kroah-Hartman wrote:
> From: Will McVicker <willmcvicker@google.com>
> 
> Align the SuperSpeed Plus bitrate for f_rndis to match f_ncm's ncm_bitrate
> defined by commit 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descriptors
> for CDC NCM").
> 
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: EJ Hsu <ejh@nvidia.com>
> Cc: Peter Chen <peter.chen@nxp.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sent from wrong email address, will resend from proper one so they will
go through the lists and validate the sender properly, sorry about
that...
