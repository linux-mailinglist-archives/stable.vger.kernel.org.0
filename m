Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7536FB9D
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 15:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhD3Njr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 09:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhD3Njr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 09:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD8061424;
        Fri, 30 Apr 2021 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619789937;
        bh=d+Dzt8He0qBnrkS9bXwKGmUsIq3BT1pCuBb6gASunn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KOul2uPng2kaT7CISwU7mdqqZ+fg9rjC9bgR59gjpN5MXik7wXoSIuC3vYYp0/HYD
         eOCb0bhd7dzrgRqTi5mUZIh44o82iFhNIQmaRAK672cYZFXuaPeZKEQSjMqOa6DFG8
         YyMd/QyjfpV7pdnk8z3+l+oAoNHf76dYp2dh4FkA=
Date:   Fri, 30 Apr 2021 15:38:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Message-ID: <YIwIX2mB/+tR0AuG@kroah.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429220839.15667-1-fllinden@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 10:08:31PM +0000, Frank van der Linden wrote:
> This is a backport of the BPF verifier fixes for CVE-2021-29155. Original
> series was part of the pull request here: https://lore.kernel.org/bpf/20210416223700.15611-1-daniel@iogearbox.net/T/
> 
> This wasn't a complicated backport, but copying bpf@ to see if
> there are any concerns.
> 
> 5.4 verifier selftests are clean with this backport:
> 	Summary: 1566 PASSED, 0 SKIPPED, 0 FAILED
> 
> The individual commits:

Many thanks for these, now queued up.

greg k-h
