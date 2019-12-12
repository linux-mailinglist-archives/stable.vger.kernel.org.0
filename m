Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D822311C95B
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfLLJia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbfLLJia (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:38:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 323BE24654;
        Thu, 12 Dec 2019 09:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143509;
        bh=zimHc15WU+W0eRyiofR3YV3nJ1Gr/jLG0Uhe8O3r9yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvnxKHNUBUkcnoKMIRJU5o9S1OskPv5AZ/IwfB6sdxUvw8A0NuBXbtVMgqfCCKblY
         AiiH23gBiVPFFxXd6cXjhuwh2gI28OBrAxD2s09yJlCEFn0yiKCvY1wpmpamQ4xLbL
         Usf5XN7SPfo7lnYxgmwUgE5idkAoZZfceZengrF8=
Date:   Thu, 12 Dec 2019 10:37:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: Re: [stable] net: qrtr: fix memort leak in qrtr_tun_write_iter
Message-ID: <20191212093737.GJ1378792@kroah.com>
References: <f2a2e4711db1903b927c9477cfb7703ca566317c.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2a2e4711db1903b927c9477cfb7703ca566317c.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:51:32PM +0000, Ben Hutchings wrote:
> Please pick this commit for 4.19 only (newer branches already have it;
> older branches don't include this protocol):
> 
> commit a21b7f0cff1906a93a0130b74713b15a0b36481d
> Author: Navid Emamdoost <navid.emamdoost@gmail.com>
> Date:   Wed Sep 11 10:09:02 2019 -0500
> 
>     net: qrtr: fix memort leak in qrtr_tun_write_iter
> 

Now applied, thanks.

greg k-h
