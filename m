Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6D47D17D
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbhLVMIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A500C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 04:08:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F0B8619EE
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4D8C36AE5;
        Wed, 22 Dec 2021 12:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174884;
        bh=bOCxSf5g/+kilksedqjUUMBwm2ImYoHF3j+ecN/9/0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJsPioxrKb3tVJCxrtEw47iFhgJsomoFY1GyVn9n+woWy2QCId7YxtJZhKB/ErzzY
         blEiZ9n7mg9MxSckkiRxWKWt3z1zYEraJ3pml4jxmMOi9byrYSjLI0EcUH1ubSNiPF
         +A1poSAoC3ogQCox3jZyiKOr9OME6fa1GN+tN9Kk=
Date:   Wed, 22 Dec 2021 12:58:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Greg Jesionowski <jesionowskigreg@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Hardware IDs patch, requesting add to stable 5.15.10
Message-ID: <YcMS73rMT8wkjDHE@kroah.com>
References: <20211221174957.GA3233@devoptiplex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221174957.GA3233@devoptiplex>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 10:49:57AM -0700, Greg Jesionowski wrote:
> original patch subject: 'net: usb: lan78xx: add Allied Telesis AT29M2-AF'
> upstream commit: ef8a0f6eab1ca5d1a75c242c5c7b9d386735fa0a
> requested kernel: 5.15.10
> 
> Hello, 
> 
> This patch adds hardware IDs for an Allied Telesis USB Gigabit ethernet
> device. People with this device that want to use it need to
> apply the patch manually right now. 

Now queued up, thanks.

greg k-h
