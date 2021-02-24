Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778EE3239BB
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhBXJm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 04:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhBXJkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 04:40:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD1464E2B;
        Wed, 24 Feb 2021 09:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614159602;
        bh=eZkhdFaPoF89849CHrWc0dnMlIlf6pjxAGm2CpzSo6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4RRNRF5wAy6ZdUbIObM13HEP/p6T5EsXnqVGR64dwsNlfxcSO+63tqsioeNAjiKL
         eTXzVeW73/fpZSiyw9ekXWBWAR58UISR0+zpj5vllaBPTCuBnuDlhYQm0Z5ENjLHu0
         NT5IiYB7rV3j+zeOLa7fj6Pz+eghbF25jkE3y294=
Date:   Wed, 24 Feb 2021 10:39:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zelin Deng <zelin.deng@linux.alibaba.com>
Cc:     Artie Ding <artie.ding@linux.alibaba.com>,
        alikernel-developer@linux.alibaba.com,
        Jiang Liu <gerry@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Evan Green <evgreen@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH CK 4.19 1/1] x86/apic/msi: Plug non-maskable MSI affinity
 race
Message-ID: <YDYe7iV7UpB6Na7v@kroah.com>
References: <20210224090824.39024-1-zelin.deng@linux.alibaba.com>
 <20210224090824.39024-2-zelin.deng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224090824.39024-2-zelin.deng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 05:08:24PM +0800, Zelin Deng wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> task #32972991

What is this?

> commit 6f1a4891a5928a5969c87fa5a584844c983ec823 upstream

This is already in the 4.19.103 kernel release, why do you need to
backport it again?

Why are you not just merging with the 4.19.y kernel tree directly?
Doing random cherry-picks is a sure way to end up with a totally broken
and insecure kernel tree.

thanks,

greg k-h
