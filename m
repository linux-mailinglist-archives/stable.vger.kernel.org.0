Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB132509B
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 14:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBYNhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 08:37:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhBYNhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 08:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614260149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TqbClLww0jYsrZPj0F6LBKw/kskLLANoye0Js1zpjAI=;
        b=DCaSlULe7M/pL9qUIwCshKASB68EDmRtmcLw2dLXqpIWg+viedRyr3HdT42EzPvEAWiweZ
        x160Z9TiiK8qtimlY49mx7aBykvrXi4jQ/ln11cXw6u4lVKoEhAzrzoXGHMPdtiIUrlnmf
        Ul/GtXondJibD6v7n1naVVhvGaoalKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-3iVgiyz5Ov-PynIaYkdF3Q-1; Thu, 25 Feb 2021 08:35:47 -0500
X-MC-Unique: 3iVgiyz5Ov-PynIaYkdF3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A691936B60;
        Thu, 25 Feb 2021 13:35:46 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-2.ams2.redhat.com [10.36.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 262DA6A900;
        Thu, 25 Feb 2021 13:35:45 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: [PATCH stable 0/1] Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working
Date:   Thu, 25 Feb 2021 14:35:44 +0100
Message-Id: <20210225133545.86680-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here is a cherry-pick of a bluetooth fix which just landed in Linus' tree.

A lot of users are complaining about this:

https://bugzilla.kernel.org/show_bug.cgi?id=210681

It would be good if we can get this added to the 5.10.y and 5.11.y series.
Older kernels are not affected unless the commit mentioned by the Fixes
tag was backported.

I've based this cherry-pick on top of 5.10.y, it should also apply cleanly
to 5.11.y.

Regards,

Hans


Hui Wang (1):
  Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.30.1

