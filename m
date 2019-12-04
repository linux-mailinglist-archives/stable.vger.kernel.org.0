Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5ED112358
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 08:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfLDHMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 02:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfLDHMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 02:12:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A89206DB;
        Wed,  4 Dec 2019 07:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575443519;
        bh=XAm+cZKdWstTH4FCHJTHxBCBwdy9Bxo1Rfl1YAGYyHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XhEdEAkIrahMGAYcRkcUQkE+jKVJGfv4mDQjKr+KNH3THHFkgTQyS1LGF8tSUUP9p
         jt9PgQrJ8HswV+dShDxGcM91upRIk5yEoP8H1qpULT+wbsjm7M5QjeBGnSo30I0XOz
         Cn5up9NqHE3Uj559SN2EO49AEv6d3TaPmze95zVE=
Date:   Wed, 4 Dec 2019 08:11:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
Message-ID: <20191204071156.GA3513626@kroah.com>
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com>
 <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
 <CAPtwhKrCY4ZWFPYsr5N3LcAJOJVStN9Qb93-zk+GFRNVsfGxgQ@mail.gmail.com>
 <CAPtwhKoMk+AY2D9Akoh_v4fSTj9JtUT1k+DQ_qcuK=zbZSdpgw@mail.gmail.com>
 <CAPtwhKpjLswXm3fSZ6o0hiNxM2Zgj3zmfsLLPYtPpqmN91792g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtwhKpjLswXm3fSZ6o0hiNxM2Zgj3zmfsLLPYtPpqmN91792g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 03:37:36PM -0800, Xuewei Zhang wrote:
> Hi Greg,
> 
> I sent the backports which should apply cleanly to the 5 stable kernel
> versions: 4.19, 4.14, 4.9, 4.4, 3.16.
> 
> Does it work for you? Please let me know if I should submit them using
> some other formats. Apologize ahead if my current format is wrong.

That looks good, I'll queue them up later this week once the current
round of stable kernels are released.

thanks,

greg k-h
