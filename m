Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6D25A993
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 12:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgIBKjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 06:39:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726210AbgIBKjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 06:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599043152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8IAkgTE/fwEs9nIZM+CoUsncWzQn4mbPIMrHlPysyw=;
        b=K+ovdZQN2LT4gYLOAprZL+RvKIu2OUc4BjDxsFE3fmm7cfApVEUy/B3RIXdaxVrkkmJi1y
        HiiFd/4Hw8Ps8JVl/Rttz8Sa7RWAmW+i+AkCWQZ/7CUGMscjvajPs2h7V1K2nj26yOayv3
        mazsS6i+J0+l/GYdZsL0xChR0RD3gg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-htpOL-5rP3-FO1HruBKlNg-1; Wed, 02 Sep 2020 06:39:10 -0400
X-MC-Unique: htpOL-5rP3-FO1HruBKlNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 247131005504;
        Wed,  2 Sep 2020 10:39:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE9CB7EEB4;
        Wed,  2 Sep 2020 10:39:07 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 643F218095FF;
        Wed,  2 Sep 2020 10:39:07 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: base64
From:   David Hildenbrand <dhildenb@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Date:   Wed, 2 Sep 2020 06:39:07 -0400 (EDT)
Message-Id: <A8A8D5FE-86C3-40B4-919C-5FF2A134F366@redhat.com>
References: <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        Roman Gushchin <guro@fb.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>
In-Reply-To: <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
To:     Vlastimil Babka <vbabka@suse.cz>
Thread-Topic: The new cgroup slab memory controller
Thread-Index: 6Y0CdB2ht3ejeo8nqIlGbso/nBgHtw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gQW0gMDIuMDkuMjAyMCB1bSAxMTo1MyBzY2hyaWViIFZsYXN0aW1pbCBCYWJrYSA8dmJh
YmthQHN1c2UuY3o+Og0KPiANCj4g77u/T24gOC8yOC8yMCA2OjQ3IFBNLCBQYXZlbCBUYXRhc2hp
biB3cm90ZToNCj4+IFRoZXJlIGFwcGVhcnMgdG8gYmUgYW5vdGhlciBwcm9ibGVtIHRoYXQgaXMg
cmVsYXRlZCB0byB0aGUNCj4+IGNncm91cF9tdXRleCAtPiBtZW1faG90cGx1Z19sb2NrIGRlYWRs
b2NrIGRlc2NyaWJlZCBhYm92ZS4NCj4+IA0KPj4gSW4gdGhlIG9yaWdpbmFsIGRlYWRsb2NrIHRo
YXQgSSBkZXNjcmliZWQsIHRoZSB3b3JrYXJvdW5kIGlzIHRvDQo+PiByZXBsYWNlIGNyYXNoIGR1
bXAgZnJvbSBwaXBpbmcgdG8gTGludXggdHJhZGl0aW9uYWwgc2F2ZSB0byBmaWxlcw0KPj4gbWV0
aG9kLiBIb3dldmVyLCBhZnRlciB0cnlpbmcgdGhpcyB3b3JrYXJvdW5kLCBJIHN0aWxsIG9ic2Vy
dmVkDQo+PiBoYXJkd2FyZSB3YXRjaGRvZyByZXNldHMgZHVyaW5nIG1hY2hpbmUgIHNodXRkb3du
Lg0KPj4gDQo+PiBUaGUgbmV3IHByb2JsZW0gb2NjdXJzIGZvciB0aGUgZm9sbG93aW5nIHJlYXNv
bjogdXBvbiBzaHV0ZG93biBzeXN0ZW1kDQo+PiBjYWxscyBhIHNlcnZpY2UgdGhhdCBob3QtcmVt
b3ZlcyBtZW1vcnksIGFuZCBpZiBob3QtcmVtb3ZpbmcgZmFpbHMgZm9yDQo+IA0KPiBXaHkgaXMg
dGhhdCBob3RyZW1vdmUgZXZlbiBuZWVkZWQgaWYgd2UncmUgc2h1dHRpbmcgZG93bj8gQXJlIHRo
ZXJlIGFueQ0KPiAodmlydHVhbGl6YXRpb24/KSBwbGF0Zm9ybXMgd2hlcmUgaXQgbWFrZXMgc29t
ZSBkaWZmZXJlbmNlIG92ZXIgcGxhaW4NCj4gc2h1dGRvd24vcmVzdGFydD8NCg0KSWYgYWxsIGl0
4oCYcyBkb2luZyBpcyBvZmZsaW5pbmcgcmFuZG9tIG1lbW9yeSB0aGF0IHNvdW5kcyB1bm5lY2Vz
c2FyeSBhbmQgZGFuZ2Vyb3VzLiBBbnkgcG9pbnRlcnMgdG8gdGhpcyBzZXJ2aWNlIHNvIHdlIGNh
biBmaWd1cmUgb3V0IHdoYXQgaXTigJhzIGRvaW5nIGFuZCB3aHk/IChBcmNoPyBIeXBlcnZpc29y
Pyk=

