Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025933D5622
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhGZIZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhGZIZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846F560249;
        Mon, 26 Jul 2021 09:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627290372;
        bh=RoxUUmzXLDHMRzw9bnwchbeZKdOVaGzPr/A8EB11wl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTVum3ZlUa/hdAoQiZjOQDnZ1wwFlsJEsLMfyNalEoX2g9p7Ve5Glpq0Id9JQNZ/R
         nz6n/bbaeyPVW0E9Fm0Knrveo/vddxQU5rQe59TWPoXLqOO1IaB9ak+tw/AU+iEaC0
         FXxWELKDUh2Dt5xQMvY7l5vjSdFU1uTPryXgiCno=
Date:   Mon, 26 Jul 2021 11:04:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Mtk Spi fix for stable
Message-ID: <YP56uH0IjiK4KS2x@kroah.com>
References: <3122A872-7168-4D60-8F65-DDAA9E1AB3D1@public-files.de>
 <BFD312E8-7AAE-4A86-A599-9A81904F56A6@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFD312E8-7AAE-4A86-A599-9A81904F56A6@public-files.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 24, 2021 at 09:29:58AM +0200, Frank Wunderlich wrote:
> Hi,
> 
> I noticed i've missed stable tag :(
> 
> Can you please pick this up for at least 5.4/5.10?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43

Now queued up, but needs a working backport for the 4.4.y queue if you
want it there too.

thanks,

greg k-h
