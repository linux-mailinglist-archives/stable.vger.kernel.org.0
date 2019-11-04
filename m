Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71863EE8E2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 20:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDToq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 14:44:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:59631 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbfKDToq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 14:44:46 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id xA4JhxDe009601;
        Mon, 4 Nov 2019 13:44:00 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id xA4Jhwlx009599;
        Mon, 4 Nov 2019 13:43:58 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 4 Nov 2019 13:43:57 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     "Alastair D'Silva" <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>, Qian Cai <cai@lca.pw>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Allison Randal <allison@lohutok.net>
Subject: Re: [PATCH v5 1/6] powerpc: Allow flush_icache_range to work across ranges >4GB
Message-ID: <20191104194357.GE16031@gate.crashing.org>
References: <20191104023305.9581-1-alastair@au1.ibm.com> <20191104023305.9581-2-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104023305.9581-2-alastair@au1.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 01:32:53PM +1100, Alastair D'Silva wrote:
> When calling flush_icache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.

Please send this separately, to be committed right now?  It is a bug fix,
independent of the rest of the series.


Segher
