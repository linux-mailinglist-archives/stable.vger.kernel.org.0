Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20453654F4
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfGKLIT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 11 Jul 2019 07:08:19 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57640 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727865AbfGKLIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:08:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17220401-1500050 
        for multiple; Thu, 11 Jul 2019 12:08:14 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190711110201.GD9599@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        stable@vger.kernel.org
References: <20190711092254.1719-1-chris@chris-wilson.co.uk>
 <20190711110201.GD9599@intel.com>
Message-ID: <156284329225.12757.17426687065171875375@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Revert "drm/i915: Enable PSR2 by default"
Date:   Thu, 11 Jul 2019 12:08:12 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Rodrigo Vivi (2019-07-11 12:02:01)
> On Thu, Jul 11, 2019 at 10:22:54AM +0100, Chris Wilson wrote:
> > Multiple users are reporting black screens upon boot, after resume, or
> > frozen after a short period of idleness. A black screen on boot is a
> > critical issue so disable psr2 again until resolved.
> > 
> > This reverts commit 8f6e87d6d561f10cfa48a687345512419839b6d8.
> > 
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
> 
> I agree it is critical, but unfortunately this revert won't solve the issue.
> 
> [    1.954886] [drm:intel_psr_init_dpcd [i915]] eDP panel supports PSR version 1
> [    2.003686] [drm:intel_psr_enable_locked [i915]] Enabling PSR1
> 
> Users are claiming the regression is only on 5.2 with 5.1 working well
> and PSR1 is enabled by default since 5.0.

Hmm, which panels are psr2 and is it being accurately reported?

If you suspect psr1, just revert both for now.
-Chris
