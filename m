Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445EC4A2E56
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbiA2Lp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:45:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37586 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiA2Lp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:45:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD16CB82699
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EBDC340E5;
        Sat, 29 Jan 2022 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643456725;
        bh=/UQWD9iirmbDVNEyaQUDKen2FBZkGW+6+6nMUzvxzOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vaku795AtLNmZMhxhet1acADfcrCNJ7YMmQekHQrM+djXu5yiqkptpxJIxmeBIvm+
         p3+vJ15hi+wHnRVr12bJz36FlN4cJZqFelSuOCeq7Cgk57U1taZHuVPn/DtQ+BlKHb
         pN+g52/lKK+EZKrw7ymMGk1p1vkDyeKzapFVZ0z8=
Date:   Sat, 29 Jan 2022 12:45:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     syphyr <syphyr@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Bluetooth regression on 5.10.94 LTS
Message-ID: <YfUozcQ9Ovx/HSov@kroah.com>
References: <608b625e-9eb0-8320-c45c-e5671b44e58b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608b625e-9eb0-8320-c45c-e5671b44e58b@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 07:42:52PM +0100, syphyr wrote:
> The following commit causes a regression in Bluetooth by creating false
> positives for malicious data:
> 
> Bluetooth: stop proccessing malicious adv data
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.10.94&id=ffc9019bd991707701273c2e5d8aed472229fc4d
> 
> 
> This commit fixes the issue above:
> 
> Bluetooth: refactor malicious adv data check
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.17-rc1&id=899663be5e75dc0174dc8bda0b5e6826edf0b29a
> 
> 
> Please add to the stable release queue.

Now queued up, thanks

greg k-h
