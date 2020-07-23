Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6922B5C8
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGWSfX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jul 2020 14:35:23 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:50895 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726666AbgGWSfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 14:35:23 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21911343-1500050 
        for multiple; Thu, 23 Jul 2020 19:35:18 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200723183348.4037-1-chris@chris-wilson.co.uk>
References: <20200723183348.4037-1-chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/gem: Delay tracking the GEM context until it is registered
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     CQ Tang <cq.tang@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
To:     intel-gfx@lists.freedesktop.org
Date:   Thu, 23 Jul 2020 19:35:17 +0100
Message-ID: <159552931718.21069.13813749151778428706@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-07-23 19:33:48)
> Avoid exposing a partially constructed context by deferring the
> list_add() from the initial construction to the end of registration.
> Otherwise, if we peek into the list of contexts from inside debugfs, we
> may see the partially constructed context and change down some dangling

s/change/chase/

> incomplete pointers.
