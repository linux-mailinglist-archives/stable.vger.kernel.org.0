Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69242382B68
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhEQLqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhEQLqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 07:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3304D60FD7;
        Mon, 17 May 2021 11:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621251903;
        bh=ZUCD5BnWO3seA+WAi3C2/un11t+PK5WRrrEMaosZ2pc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U42VORYxrc0QNjnlooiYOYjP4nL3PJL/ZfawtBOprpIwpYwJygGSvcQVtConstiSR
         IwmowJeS91RhW8OAJkUsJjGGueGvd4yzXbK3TnhHHkbobOqvRFbaMLmHRnnRYywr1I
         fgqwXBzN8je5r16BWK7waum7fEN8W0gpVlHxRF7k=
Date:   Mon, 17 May 2021 13:45:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     stable@vger.kernel.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <YKJXPUJr48jmNQLi@kroah.com>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621251453@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 01:38:34PM +0200, Christoph Biedl wrote:
> Greg KH wrote...
> 
> > Hopefully now fixed in the stable queue, I'll push out new -rc releases
> > today for people to test.
> 
> Thanks for taking care, unfortunately no improvement with 5.10.38-rc1 here.

There is no -rc kernel out yet.

Ah, you must be looking at the stable-rc tree, here, let me push out a
newer one...
