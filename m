Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB8F1CC5
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 18:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfKFRts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 12:49:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:47578 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbfKFRts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 12:49:48 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id xA6Hn9SQ005721;
        Wed, 6 Nov 2019 11:49:09 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id xA6Hn792005718;
        Wed, 6 Nov 2019 11:49:07 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 6 Nov 2019 11:49:07 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "Alastair D'Silva" <alastair@au1.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>, alastair@d-silva.org,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Allison Randal <allison@lohutok.net>
Subject: Re: [PATCH v5 1/6] powerpc: Allow flush_icache_range to work across ranges >4GB
Message-ID: <20191106174907.GR16031@gate.crashing.org>
References: <20191104023305.9581-1-alastair@au1.ibm.com> <20191104023305.9581-2-alastair@au1.ibm.com> <20191104194357.GE16031@gate.crashing.org> <74435ba6-51dc-1dff-b55b-cdcf85e2e302@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74435ba6-51dc-1dff-b55b-cdcf85e2e302@c-s.fr>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 07:04:04AM +0100, Christophe Leroy wrote:
> Le 04/11/2019 à 20:43, Segher Boessenkool a écrit :
> >Please send this separately, to be committed right now?  It is a bug fix,
> >independent of the rest of the series.
> 
> Patch 4/6 needs it, as it drops the function.
> 
> Or do you mean that the series should drop the assembly at once, and 
> this patch should only go into stable ?

I meant that you can say these patches (yes, 2/ as well) are bug fixes,
independent of the rest, and they can be picked up immediately, there
is no need to wait for v18 of this series.

> But I guess mpe can take this patch alone if he wants to ?

Yeah, but you can help him do that ;-)


Segher
