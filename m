Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340AE2FE771
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 11:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbhAUKV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 05:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbhAUKVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 05:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72231221F8;
        Thu, 21 Jan 2021 10:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611224429;
        bh=+0DXGOkstAp9Y1z5fipCz6pXmZyivbXiSrKXT4jjD1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wCQKxsJGQpdCdn3qGqHIxdLea4bYcCQUMPmhtJ5q+6B3z1KUH/ZtZyS4GeBulL/ci
         FRlt/y1QIkZOSonc/C8aBr4GVepLzoHF85N6rRJXRmdf/6GE+L/I8I8UZiJTlbSIFb
         RnxCRqEoXpPQ371VUHO7wX5g1Qs0v5uet4xbedac=
Date:   Thu, 21 Jan 2021 11:20:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     stable@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Please backport "bpf: Fix selftest compilation on clang 11" to
 5.10
Message-ID: <YAlVatnr4o/3h3dI@kroah.com>
References: <CACAyw9-1HzyJikX7xfN9ixC=asjVzRO25+Wz3bGpausBqmvTJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-1HzyJikX7xfN9ixC=asjVzRO25+Wz3bGpausBqmvTJg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 21, 2021 at 10:11:59AM +0000, Lorenz Bauer wrote:
> Hi,
> 
> Can you please apply commit fb3558127cb6 ("bpf: Fix selftest
> compilation on clang 11") to the 5.10 tree? Without it, compiling
> selftests/bpf with clang-11 fails.

Now queued up, thanks.

greg k-h
