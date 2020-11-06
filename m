Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E82AA171
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 00:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgKFXar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 18:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729132AbgKFXa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 18:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604705428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqQN/DwASLSwBaj/2yQjpp86Hx5P0sidKJCWI09z4eM=;
        b=ObE+E+pBAA3IZbiwtnoe3pW9szkOEK94+ejCse8pOSGZUFIbfmd+UCU5UZI9BILt2brhx5
        Mj/Ksd2ugR5uPPf3NLpSnMVQLpBAHHzfVC/4Wpu7m/NU7GcQRZjydGqTx0rFdRcGQf2WuK
        Fm5lNyru1b9Mg1wm/7/1TKSMrh1Yv0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-cF6Dcnd5Py-fvcnLLCC4_g-1; Fri, 06 Nov 2020 18:30:23 -0500
X-MC-Unique: cF6Dcnd5Py-fvcnLLCC4_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 338391868421;
        Fri,  6 Nov 2020 23:30:22 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8876162A15;
        Fri,  6 Nov 2020 23:30:21 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 0/2] drm/nouveau: Stable backport of DP clock fixes for v5.9
Date:   Fri,  6 Nov 2020 18:30:13 -0500
Message-Id: <20201106233016.2481179-1-lyude@redhat.com>
In-Reply-To: <160459060724988@kroah.com>
References: <160459060724988@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just a backport of the two patches for v5.9 that you'll want to apply.
The first one was Cc'd to stable, but I forgot to Cc the second one as
well.

Lyude Paul (2):
  drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()
  drm/nouveau/kms/nv50-: Fix clock checking algorithm in
    nv50_dp_mode_valid()

 drivers/gpu/drm/nouveau/nouveau_connector.c | 36 ++++++---------------
 drivers/gpu/drm/nouveau/nouveau_dp.c        | 21 ++++++++----
 2 files changed, 24 insertions(+), 33 deletions(-)

-- 
2.28.0

