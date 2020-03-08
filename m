Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6519317D606
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 21:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgCHUHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 16:07:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43416 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726322AbgCHUHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 16:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583698048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0/LDG05JWH6iH3DreWtZMhkaDBJPjuzVf5hq+aAXnk=;
        b=NHAPiYDu6Au6PEr0AS9qrR6mUD/Y7CE8Nqpy9EHzB8nbdiwSkNyrMHrnivRa07zAd90nf8
        Z5dG4RdEZGoiN70RRVx37fGuqBRcBXMvVoS2s+ttI+xzCzhZEjQ+weC6//gVm9wlZrCk1B
        NawSfMq8WU8thmFNQwoaLaTyTjyUyWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-JEHTQzQpNIK3Eca2uovIZQ-1; Sun, 08 Mar 2020 16:07:25 -0400
X-MC-Unique: JEHTQzQpNIK3Eca2uovIZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA628184C800;
        Sun,  8 Mar 2020 20:07:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF16D5D9E2;
        Sun,  8 Mar 2020 20:07:23 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CCCE81809563;
        Sun,  8 Mar 2020 20:07:23 +0000 (UTC)
Date:   Sun, 8 Mar 2020 16:07:23 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <976629603.10711789.1583698043547.JavaMail.zimbra@redhat.com>
In-Reply-To: <173385062.10432633.1583427362328.JavaMail.zimbra@redhat.com>
References: <cki.EED856DF66.LLEP90YP5M@redhat.com> <2065777364.10425170.1583425488638.JavaMail.zimbra@redhat.com> <173385062.10432633.1583427362328.JavaMail.zimbra@redhat.com>
Subject: =?utf-8?Q?Re:_[LTP]__=E2=9D=8C_FAIL:_Test_report_for_ke?=
 =?utf-8?Q?rnel_5.5.7-60528b7.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.25, 10.4.195.16]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel
 5.5.7-60528b7.cki (stable-queue)
Thread-Index: kkuOJFuqhkSqHy2lWMvJx4dG0KzmcTW74Dzw/2E6cwI=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> 5.6.0-0.rc3 crashed as well. On s390x I'm using it's enough to
> "cat /sys/fs/cgroup/cpu.pressure" to trigger.

Fix has already been posted:
  https://lore.kernel.org/lkml/20200224030007.3990-1-cai@lca.pw/

With this patch applied, I no longer see crashes with 5.6.0-rc4+.

