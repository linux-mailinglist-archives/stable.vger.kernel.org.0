Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3FE286207
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgJGPYc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 7 Oct 2020 11:24:32 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63226 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728250AbgJGPYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 11:24:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22648474-1500050 
        for multiple; Wed, 07 Oct 2020 16:24:18 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201007151718.22710-1-chris@chris-wilson.co.uk>
References: <20201007151718.22710-1-chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Exclude low pages (128KiB) of stolen from use
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     intel-gfx@lists.freedesktop.org
Date:   Wed, 07 Oct 2020 16:24:17 +0100
Message-ID: <160208425729.1580.11605027399270723556@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-10-07 16:17:18)
> The GPU is trashing the low pages of its reserved memory upon reset. If
> we are using this memory for ringbuffers, then we will dutiful resubmit
> the trashed rings after the reset causing further resets, and worse. We
> must exclude this range from our own use. The value of 128KiB was found
> by empirical measurement on gen9.

Probably should double it to 256K, just to be on the safe side?
-Chris
