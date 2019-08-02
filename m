Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054EA7ED6E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbfHBH1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388053AbfHBH1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:27:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C4B20657;
        Fri,  2 Aug 2019 07:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564730855;
        bh=nT9MuE/jPUuxa7z24RZYsp93w96+LAvXnn1wx7I7eBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFgwAQ1DyV2tvHHcjGglQCu1XTD5WI/gBlKYv6hwTkDfpDO7Rz8C5Xy20qT6N8PzK
         CTtd6a3wMzb0n0kCBgcAABt4K6oraKuyknTZgZKpX1tiaEoLYZYaCCISIDsg41WhDP
         sQqIFlafkxBnHNZgksqfcSoEzj9ITBkOU5NPCTuc=
Date:   Fri, 2 Aug 2019 09:27:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [stable-4.19 0/4] CVE-2019-3900 fixes
Message-ID: <20190802072733.GB26174@kroah.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 03:03:09PM +0200, Jack Wang wrote:
> Hi, Greg, hi Sasha,
> 
> I noticed the fixes for CVE-2019-3900 are only backported to 4.14.133+,
> but not to 4.19, also 5.1, fixes have been included in 5.2.
> 
> So I backported to 4.19, only compiles fine, no functional tests.
> 
> Please review, and consider to include in next release.

All looks good, sorry for the delay, now queued up.

greg k-h
