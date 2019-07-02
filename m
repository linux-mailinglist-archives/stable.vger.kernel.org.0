Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C518A5CE35
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 13:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGBLOL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 2 Jul 2019 07:14:11 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:58278 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725891AbfGBLOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 07:14:11 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17097748-1500050 
        for multiple; Tue, 02 Jul 2019 12:14:09 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190628120720.21682-4-lionel.g.landwerlin@intel.com>
Cc:     stable@vger.kernel.org
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com>
 <20190628120720.21682-4-lionel.g.landwerlin@intel.com>
Message-ID: <156206604662.2466.5892487834399036431@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH v7 3/3] drm/i915/icl: whitelist
 PS_(DEPTH|INVOCATION)_COUNT
Date:   Tue, 02 Jul 2019 12:14:06 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Lionel Landwerlin (2019-06-28 13:07:20)
> The same tests failing on CFL+ platforms are also failing on ICL.
> Documentation doesn't list the
> WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
> applying it fixes the same tests as CFL.
> 
> v2: Use only one whitelist entry (Lionel)
> 
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Tested-by:  Anuj Phogat <anuj.phogat@gmail.com>
> Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
