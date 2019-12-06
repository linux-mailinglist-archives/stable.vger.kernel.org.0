Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786041151E4
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 15:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfLFOFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 09:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLFOFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 09:05:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBE7B20706;
        Fri,  6 Dec 2019 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575641136;
        bh=/2VJO08J5aslDYe3mcysmUsr4zuH51dfSpSuAlL5yiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khNZNSUW7W5QcJwq3tlDvnVxtjo+61f8tfpFTucZ0H0WtVMXKKjMHXum1WWZsIxiB
         q+cM/ynzt88mVQz1/Tr4GaoqqJDPoFTjLPusCadQjOnl+6wnw+6T8FU5zDE82TqXoX
         mQhIKx+Mq2fvGmrRtSVTRp7d8RQdGppnHUITZWuQ=
Date:   Fri, 6 Dec 2019 15:05:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Narron <comet.berkeley@gmail.com>
Cc:     jbeulich@suse.com, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4] x86/apic/32: Avoid bogus LDR warnings
Message-ID: <20191206140534.GA8314@kroah.com>
References: <alpine.LNX.2.21.1912060523520.6537@joy.test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1912060523520.6537@joy.test>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 05:40:10AM -0800, Richard Narron wrote:
> This patch fixes my bug in 4.4.206:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205729
> 
> It could use testing by someone who exercises the code in a virtual
> machine environment...

Now queued up, thanks.

greg k-h
