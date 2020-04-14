Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1E1A75EA
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436677AbgDNIYI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 Apr 2020 04:24:08 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60448 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436653AbgDNIYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:24:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20891897-1500050 
        for multiple; Tue, 14 Apr 2020 09:23:57 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200414061312.GA90768@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain> <20200407064007.7599-1-sultan@kerneltoast.com> <20200414061312.GA90768@sultan-box.localdomain>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <158685263618.16269.9317893477736764675@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 14 Apr 2020 09:23:56 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sultan Alsawaf (2020-04-14 07:13:12)
> Chris,
> 
> Could you please take a look at this? This really is quite an important fix.

It's crazy. See a266bf420060 for a patch that should be applied to v5.4
-Chris
