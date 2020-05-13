Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088D71D0BF4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgEMJXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgEMJXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:23:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81367206A5;
        Wed, 13 May 2020 09:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589361805;
        bh=2/xmUMSsb5E5hryyabOav79SYxHREOVBG2IZ9FGPIDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vR3HSpFPwwaoRgAK4L0aEVxhAqssHkgUSBTeLllhIznD9zn8bxFudGaNBIwe8SpUM
         0x4ynUNewVKOZpNVAzR+1WXOB7HPmd83rZs//xcfs9uuQkix4MiPEZSyCr4WZgMt1g
         EMuFrhRYux2DgyNcgd3we0tEq2gKpZmTAXpqxAQQ=
Date:   Wed, 13 May 2020 11:23:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     stable@vger.kernel.org, dsa@cumulusnetworks.com,
        andreyknvl@google.com, davem@davemloft.net
Subject: Re: [PATCH] net: handle no dst on skb in icmp6_send
Message-ID: <20200513092322.GA798412@kroah.com>
References: <20200513090451.939095-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <OSBPR01MB29839259893D8DD04E08B61F92BF0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB29839259893D8DD04E08B61F92BF0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 09:15:34AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> I forgot to add the version to the subject.
> This is a patch to 4.4.y only. This is not needed for other kernels.

thanks, now queued up.

greg k-h
