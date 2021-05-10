Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25D378F14
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhEJN2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245568AbhEJMUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620649148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=1E3vYfelT3VvyfETGj8waUJghkqxJvjAMZh3miXwTVA=;
        b=DdYU+nmxj0qKQOwJeAXS4qYhJr5pgz0Pt+Z6pE3NxVc+pt16zgB6s4Gqqfb/r9kGktM/Hi
        qinIT0URicebHSo0kZ299gvn+gIZUP4EMO6XPink88RCgVZBymLE8miwZ90iTnTOgmgo0v
        0gdfT+Sq62PBQV2ibDtoyv7csik0bok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-UOdAofLWMpuGfhcdLyzPvw-1; Mon, 10 May 2021 08:19:06 -0400
X-MC-Unique: UOdAofLWMpuGfhcdLyzPvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95ED28042B4
        for <stable@vger.kernel.org>; Mon, 10 May 2021 12:19:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 546F15C1BB
        for <stable@vger.kernel.org>; Mon, 10 May 2021 12:19:04 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id A17AA18000B9; Mon, 10 May 2021 14:19:01 +0200 (CEST)
Date:   Mon, 10 May 2021 14:19:01 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     stable@vger.kernel.org
Subject: qxl fix
Message-ID: <20210510121901.wrfep3vywrcbrzda@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  Hi,

Can you please cherry-pick 4fff19ae4275 ("drm/qxl: use ttm bo
priorities") from 5.13-rc1 into stable branches?  It is a clean
cherry-pick for 5.12 and 5.11.  Looking into 5.10-lts right now,
will eventually follow up with a backported patch.

thanks,
  Gerd

