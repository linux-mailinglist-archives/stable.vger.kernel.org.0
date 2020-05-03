Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE1F1C2F29
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgECUUY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 3 May 2020 16:20:24 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:52747 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729080AbgECUUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 16:20:23 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21101043-1500050 
        for multiple; Sun, 03 May 2020 21:20:21 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200501180731.GA2485@infradead.org>
References: <20200430221016.3866-1-Jason@zx2c4.com> <20200501180731.GA2485@infradead.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available before using SIMD
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bigeasy@linutronix.de,
        tglx@linutronix.de, stable@vger.kernel.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158853721918.8377.18286963845226122104@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Sun, 03 May 2020 21:20:19 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Christoph Hellwig (2020-05-01 19:07:31)
> On Thu, Apr 30, 2020 at 04:10:16PM -0600, Jason A. Donenfeld wrote:
> > Sometimes it's not okay to use SIMD registers, the conditions for which
> > have changed subtly from kernel release to kernel release. Usually the
> > pattern is to check for may_use_simd() and then fallback to using
> > something slower in the unlikely case SIMD registers aren't available.
> > So, this patch fixes up i915's accelerated memcpy routines to fallback
> > to boring memcpy if may_use_simd() is false.
> 
> Err, why does i915 implements its own uncached memcpy instead of relying
> on core functionality to start with?

What is this core functionality that provides movntqda?
-Chris
