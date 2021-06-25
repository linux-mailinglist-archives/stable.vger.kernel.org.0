Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB333B415F
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFYKVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhFYKVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199D36142D;
        Fri, 25 Jun 2021 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624616331;
        bh=CNaEmIhbID67NBlp/4FVMl+gJjL3+d7/GcFD+3noIGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MY1GB1+WN65l8fAAfZT82q0p3eMDE61g4kXLxnOFD0dOZZpTUVQTWWqmwF8zhJNog
         8S0NkrPUUOhB4Gz+9x4R0BjKlcQJEi15TFKmydCEVwu9JRnrLu9mwKSKtJz390nDcj
         Dt7M6ayoet/40TsnmROukB+Dmg/bkhnX6S/ddT74=
Date:   Fri, 25 Jun 2021 12:18:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Backport of e607ff630c60 for 4.14 to 5.10
Message-ID: <YNWtiDumQRz7/BZj@kroah.com>
References: <YNOVzjEBTwiuB8I4@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNOVzjEBTwiuB8I4@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 01:13:02PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please find attached backports for commit e607ff630c60 ("MIPS: generic:
> Update node names to avoid unit addresses"). It has already been applied
> to 5.12 but it is missing from all other branches that need it. Let me
> know if there are any issues with applying it.

Now queued up, thanks.

greg k-h
