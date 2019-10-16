Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D356FD8A95
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 10:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfJPIMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 04:12:33 -0400
Received: from foss.arm.com ([217.140.110.172]:60114 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfJPIMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 04:12:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E63828;
        Wed, 16 Oct 2019 01:12:32 -0700 (PDT)
Received: from arrakis.emea.arm.com (unknown [10.1.196.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAC933F68E;
        Wed, 16 Oct 2019 01:12:30 -0700 (PDT)
Date:   Wed, 16 Oct 2019 09:12:28 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.0-rc2-d6c2c23.cki (stable-next)
Message-ID: <20191016081228.GB49619@arrakis.emea.arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
 <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
 <20191016042933.bemrrurjbghuiw73@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016042933.bemrrurjbghuiw73@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 05:29:33AM +0100, Will Deacon wrote:
> From 517d979e84191ae9997c9513a88a5b798af6912f Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 15 Oct 2019 21:04:18 -0700
> Subject: [PATCH] arm64: tags: Preserve tags for addresses translated via TTBR1
> 
> Sign-extending TTBR1 addresses when converting to an untagged address
> breaks the documented POSIX semantics for mlock() in some obscure error
> cases where we end up returning -EINVAL instead of -ENOMEM as a direct
> result of rewriting the upper address bits.
> 
> Rework the untagged_addr() macro to preserve the upper address bits for
> TTBR1 addresses and only clear the tag bits for user addresses. This
> matches the behaviour of the 'clear_address_tag' assembly macro, so
> rename that and align the implementations at the same time so that they
> use the same instruction sequences for the tag manipulation.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/stable/20191014162651.GF19200@arrakis.emea.arm.com/
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
