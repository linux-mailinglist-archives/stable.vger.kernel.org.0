Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D447F124DBC
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfLRQdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:33:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727345AbfLRQdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 11:33:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576686825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q+5QD91C+SW86HgkLOm9SN18FIZGpw7PnLehmVnuEws=;
        b=YJWs9LChurYKcF/xkCvoQWEccwpxIpZufgJL9PAQMoPcAGFaWvN2Xwa75nb35bPneRBZTJ
        datKMjFXzDBBNJwYjwo4dcYUssyHDWQ35W7Qf7767gEKM+RmFR4NslzLZL7Ltm0NM93Tpv
        cZ1qxdh7thbOT/aFj79gNbukiPiAVf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-_59wX13uOAuIYbYRzaq-6A-1; Wed, 18 Dec 2019 11:33:43 -0500
X-MC-Unique: _59wX13uOAuIYbYRzaq-6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 494858017DF
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 16:33:42 +0000 (UTC)
Received: from black (ovpn-116-158.ams2.redhat.com [10.36.116.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3231026DC5;
        Wed, 18 Dec 2019 16:33:38 +0000 (UTC)
Date:   Wed, 18 Dec 2019 17:33:37 +0100
From:   Michael Hofmann <mhofmann@redhat.com>
To:     stable@vger.kernel.org
Cc:     cki-project@redhat.com
Subject: CKI Project Shutdown: 2019-12-23 to 2019-12-30
Message-ID: <20191218163337.GD7800@black>
Mail-Followup-To: stable@vger.kernel.org, cki-project@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello there,

The CKI team is planning to shutdown the kernel testing pipelines
including stable kernels during the holidays.

Shutdown timeline:

    2019-12-23 16:00 CET: CKI kernel testing pipelines are disabled.
    2019-12-30 12:00 CET: CKI kernel testing pipelines back online and te=
sting.

FAQ:

Q: What if a test is running for one of my commits when the pipelines
   are disabled?
A: All of the tests that are running when the pipelines are disabled will
   be allowed to finish.

Q: What if I commit patches to one of the tested kernel trees after the
   pipelines are disabled?
A: The tip of those kernel trees will be tested as soon as the pipelines
   are back online.

Q: I have more questions about how this shutdown will affect me.
A: Email us at cki-project@redhat.com.

Thank you! Michael Hofmann and the CKI Project Team =F0=9F=A4=96

