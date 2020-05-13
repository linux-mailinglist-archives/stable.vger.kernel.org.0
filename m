Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD71D08CC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 08:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgEMGl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 02:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgEMGl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 02:41:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA8E206A5;
        Wed, 13 May 2020 06:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589352089;
        bh=uRTpqnKoq2y/0IEppiPjVG2nzz/Z1d3nUknlc3qiuYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2BHogCsUrLOnpEtsMGWpS/xWB/wk/kXDITYGh5MrqREDk9vDNQhdXttS6YIvr9O+
         6W2ToVEkgLK5ARCgbP9wByBPmkFIaBGIuPkMDqasiPqAHXQTlrSel0bbLnXl+Ka8/F
         ZRl8P3KtP2ksGMwZyt36bqpbMxksqxGulz8vxy54=
Date:   Wed, 13 May 2020 08:41:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.4-stable] Security fixes
Message-ID: <20200513064127.GA760931@kroah.com>
References: <7e20d8b5d48106dff7020ba0eec6f79d675b17c2.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e20d8b5d48106dff7020ba0eec6f79d675b17c2.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 10:59:36PM +0100, Ben Hutchings wrote:
> Here are some fixes that required backporting for 4.4.  All of them
> are already present in (or queued for) later stable branches.

All now queued up.  Turns out Sasha applied them, and then I applied
them again.  I've fixed up the mess in the tree, my fault...

greg k-h
