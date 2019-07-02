Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE02A5CE31
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 13:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfGBLNj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 2 Jul 2019 07:13:39 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57821 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725891AbfGBLNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 07:13:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17097737-1500050 
        for multiple; Tue, 02 Jul 2019 12:13:34 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190628120720.21682-3-lionel.g.landwerlin@intel.com>
Cc:     stable@vger.kernel.org
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com>
 <20190628120720.21682-3-lionel.g.landwerlin@intel.com>
Message-ID: <156206601183.2466.7357010939425742878@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH v7 2/3] drm/i915: whitelist
 PS_(DEPTH|INVOCATION)_COUNT
Date:   Tue, 02 Jul 2019 12:13:31 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Lionel Landwerlin (2019-06-28 13:07:19)
> CFL:C0+ changed the status of those registers which are now
> blacklisted by default.
> 
> This is breaking a number of CTS tests on GL & Vulkan :
> 
>   KHR-GL45.pipeline_statistics_query_tests_ARB.functional_fragment_shader_invocations (GL)
> 
>   dEQP-VK.query_pool.statistics_query.fragment_shader_invocations.* (Vulkan)
> 
> v2: Only use one whitelist entry (Lionel)

Bspec: 14091
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
