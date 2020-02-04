Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96CA152294
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 23:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgBDW7u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Feb 2020 17:59:50 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:56949 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726320AbgBDW7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 17:59:50 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20118416-1500050 
        for multiple; Tue, 04 Feb 2020 22:59:43 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Alex Deucher <alexdeucher@gmail.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <CADnq5_N7azVKP0iB1NMWz7KM79cU7HvR7Ssh1nbLDyBP946hxw@mail.gmail.com>
Cc:     Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
References: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
 <CADnq5_N7azVKP0iB1NMWz7KM79cU7HvR7Ssh1nbLDyBP946hxw@mail.gmail.com>
Message-ID: <158085718138.1394.5219439535106159931@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH 1/5] drm: Remove PageReserved manipulation from drm_pci_alloc
Date:   Tue, 04 Feb 2020 22:59:41 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Alex Deucher (2020-02-03 21:49:48)
> On Sun, Feb 2, 2020 at 12:16 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
> > facilities, and we have no special reason within the drm layer to behave
> > differently. In particular, since
> >
> > commit de09d31dd38a50fdce106c15abd68432eebbd014
> > Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Date:   Fri Jan 15 16:51:42 2016 -0800
> >
> >     page-flags: define PG_reserved behavior on compound pages
> >
> >     As far as I can see there's no users of PG_reserved on compound pages.
> >     Let's use PF_NO_COMPOUND here.
> >
> > it has been illegal to combine GFP_COMP with SetPageReserved, so lets
> > stop doing both and leave the dma layer to its own devices.
> >
> > Reported-by: Taketo Kabe
> 
> Needs an email address.

None provided, I don't insist that they opt in to potential spam
harvesting.

> > Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
> 
> Should be Bug: rather than Closes:

We're using Closes for gitlab, since we hope to integrate with gitlab
someday. (Or at least some integrated bug/source management, of which
gitlab is the current forerunner.)
-Chris
