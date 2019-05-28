Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C5A2C5A1
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfE1LoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:44:12 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55736 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbfE1LoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 07:44:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 584FF341;
        Tue, 28 May 2019 04:44:12 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B1733F59C;
        Tue, 28 May 2019 04:44:11 -0700 (PDT)
Date:   Tue, 28 May 2019 12:44:09 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, marc.zyngier@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: errata: Add workaround for
 Cortex-A76 erratum #1463225" failed to apply to 4.14-stable tree
Message-ID: <20190528114409.GF20809@fuggles.cambridge.arm.com>
References: <1558965280196247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558965280196247@kroah.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 03:54:40PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Urgh. I'm going to punt on this unless somebody requests a backport to
a kernel prior to 4.19 explicitly. The issue is that our syscall entry
code was moved to C after 4.14 and this workaround relies heavily on that
work. A backport would therefore necessitate a rewrite of the workaround
that hooks the assembly directly. Whilst do-able, I'd rather know that
(a) somebody wants this (b) they plan to deploy it on real devices and
(c) they can help to test.

Sound reasonable?

Will
