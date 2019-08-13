Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC238C0AD
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHMSgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMSgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 14:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDAB820665;
        Tue, 13 Aug 2019 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565721405;
        bh=5dAs59udVWVmSxeGs4RyVGtbQHZxy6EDnItvs6BkeKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ktAMofz2S1VxEEisTpYIz0zNxtCRwBDsA20vw8yuok6dP/2gNsz/irtBWkmfYAvpW
         CHeBuzl/C2nUDC+D0qqmr3XV6V7j4+VkPBp2JAbFhEfhU3wLlKNnM4Au9XKpd/DGil
         sNZfZF3KB02r0QKdoJRfMamJdpLvycLk4SOvbDmY=
Date:   Tue, 13 Aug 2019 20:36:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 0/3 5.2-stable] Sync mappings in vmalloc/ioremap areas
Message-ID: <20190813183642.GC6582@kroah.com>
References: <20190813152814.5354-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813152814.5354-1-joro@8bytes.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 05:28:11PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Backport commits from upstream to fix a data corruption
> issue that gets exposed when using PTI on x86-32.
> 
> Please consider them for inclusion into stable-5.2.

Thanks for these.  Based on the Fixes: tags on the commits, I've taken
them all the way back to 4.4.y.

greg k-h
