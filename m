Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3952E33271A
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhCIN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhCIN0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 08:26:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615296375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HC0nzCXaJbY+HB1b2FhhkL3ATOpYfur6xlD16lZpXWo=;
        b=NJFjAj1I+xX2q5nnApEfUg48Q40yrAxZdUdxcXB6id4bYFxeUg8Lj9uiH7rkIb43JK0VJa
        PshiYPUDYvey8pa7UaNDv4dWIi8h1solZyJmp23RDlnSHVNCqCAuQx+R+er88iFbmKWhwz
        zMDjWr8AXmiztnqFD/So7oUvS9U8uUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-gOQvsVWaNHOu9Sr3dd6xFw-1; Tue, 09 Mar 2021 08:26:11 -0500
X-MC-Unique: gOQvsVWaNHOu9Sr3dd6xFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA19D800D55;
        Tue,  9 Mar 2021 13:26:09 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-201.ams2.redhat.com [10.36.112.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC04D10013D6;
        Tue,  9 Mar 2021 13:26:08 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 0/1] ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling
Date:   Tue,  9 Mar 2021 14:26:06 +0100
Message-Id: <20210309132607.13158-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here is a fix for a race in ACPICA which has been present for a long
time, but has only recently been discovered. It would be good if we
can get this fixed added to the various stable series.

Regards,

Hans


Hans de Goede (1):
  ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region
    parameter handling

 drivers/acpi/acpica/acobject.h  |  1 +
 drivers/acpi/acpica/evhandler.c |  7 ++++
 drivers/acpi/acpica/evregion.c  | 64 ++++++++++++++++++++++++---------
 drivers/acpi/acpica/evxfregn.c  |  2 ++
 4 files changed, 57 insertions(+), 17 deletions(-)

-- 
2.30.1

