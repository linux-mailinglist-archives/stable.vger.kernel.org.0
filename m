Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE03910D7
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfHQOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 10:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfHQOkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Aug 2019 10:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A400421783;
        Sat, 17 Aug 2019 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566052812;
        bh=4YilNUyanbDMBFPBRqv1JHg8VkDrXZjKNssBnISZrAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2+ujwlhyqeb0RMXY3B/A4lZyykQmo2DhXT/9weMrUtpLhw05dKDaKjmOLoH8GWo/
         I6neouJirdkF9kRhk+S4jUmqfF9qiCYJxqHXNXZpmU/iIj4PUGGjl9bAB3Bw1r+G8w
         KtgUAZlCmAzZlkS1kdmo8Mik06hVD3Lkd7c4+QNo=
Date:   Sat, 17 Aug 2019 16:40:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please apply commits f0f1b8cac4d8 and 7fafcfdf6377 to v4.4.y
Message-ID: <20190817144001.GA11753@kroah.com>
References: <9bac68d5-834c-ec63-a196-1b7ec33d6fdc@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bac68d5-834c-ec63-a196-1b7ec33d6fdc@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 07:02:21AM -0700, Guenter Roeck wrote:
> Commit 7fafcfdf6377 ("USB: gadget: f_midi: fixing a possible double-free in f_midi")
> fixes CVE-2018-20961. Commit f0f1b8cac4d8 ("usb: gadget: f_midi: fail if set_alt fails
> to allocate requests") avoids a context conflict when applying 7fafcfdf6377,
> and fixes another minor problem.
> 
> Commit 7fafcfdf6377 is present in v4.9.y and v4.14.y.

Both now queued up, thanks!

greg k-h
