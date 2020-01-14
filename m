Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363DD13B25A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANSux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:50:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57200 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726450AbgANSuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:50:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579027851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGNsKVi6Jeh9krazQIzPI0LM722kddKE8mgvokkntp0=;
        b=fulB89/GJFzbA5VA+tDV2pLVh254l59f67I6woaREHrBdc2KyVZI8pdkoN5IZ3WB9qurdh
        uitwZMo7SeBWrhBsuTvMvnwdrkQ5tUbKwVEECmJ1gZLXEZQmMMcbUwFegX6PAtaYwrJi+J
        gN8QGqJTwHd5vWOpdV9Fe8VkrjPBZuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-BcNVDbQVP_OjSOetYnmCOg-1; Tue, 14 Jan 2020 13:50:44 -0500
X-MC-Unique: BcNVDbQVP_OjSOetYnmCOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59383107ACC5;
        Tue, 14 Jan 2020 18:50:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D10A60C18;
        Tue, 14 Jan 2020 18:50:43 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3EECD18089C8;
        Tue, 14 Jan 2020 18:50:43 +0000 (UTC)
Date:   Tue, 14 Jan 2020 13:50:43 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <278993309.1964298.1579027843196.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.63107281D5.F4HIWEIQDO@redhat.com>
References: <cki.63107281D5.F4HIWEIQDO@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l_5.4.12-rc1-fc79c22.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.8]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.12-rc1-fc79c22.cki (stable)
Thread-Index: XwdgyZrD3xwF6XqOIHtAkpUycQFloA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
>     x86_64:
>      =E2=9D=8C LTP

This looks like false positive. Temp path that appears in dmesg
contains "BUG" substring, which is probably what triggered the report.

[ 4199.295202] xfs filesystem being mounted at /mnt/testarea/ltp-qWqNYXdbNM=
/4T0BUG/mnt_point supports timestamps until 2038 (0x7fffffff)

