Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4381293918
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 12:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgJTKZh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 20 Oct 2020 06:25:37 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:57643 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388379AbgJTKZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 06:25:37 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22765413-1500050 
        for multiple; Tue, 20 Oct 2020 11:25:27 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.21.2010191506390.5579@manul.sfritsch.de>
References: <20201019101230.29860-1-chris@chris-wilson.co.uk> <20201019101523.4145-1-chris@chris-wilson.co.uk> <alpine.DEB.2.21.2010191506390.5579@manul.sfritsch.de>
Subject: Re: [PATCH] drm/i915: Force VT'd workarounds when running as a guest OS
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
To:     Stefan Fritsch <sf@sfritsch.de>
Date:   Tue, 20 Oct 2020 11:25:27 +0100
Message-ID: <160318952720.14137.17333330864672781597@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Stefan Fritsch (2020-10-19 14:08:17)
> Works for me and makes the fault messages disappear. Thanks.
> 
> Tested-by: Stefan Fritsch <sf@sfritsch.de>

Thanks for the report and testing. In hindsight, this should have been
obvious.

Pushed,
-Chris
