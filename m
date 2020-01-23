Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6CC1473E0
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 23:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAWWeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 17:34:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728760AbgAWWeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 17:34:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579818851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xt1Sx4CJFCZ6eLyvybjIeqLZeBCJ8vZON841MCa4624=;
        b=KbulWEVE1gsb6Gv/6er43LPp0vuy/8dB67Ilx8s9d9Bybg/xacXdAeqrChdk99sZu/X9kR
        D1QQVIwsAxvILP+QTedESMhHncbeAuCNsdthrmL3ncqzTaP6vTiazkCs8fTezTJTKMa5q/
        x8SBPBqQwcPTwXkrDGTr3bTr7agHNhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-EoAvUN-wMP-8V5_ZWRUBpQ-1; Thu, 23 Jan 2020 17:34:07 -0500
X-MC-Unique: EoAvUN-wMP-8V5_ZWRUBpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 909FB107ACC4;
        Thu, 23 Jan 2020 22:34:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87BD186457;
        Thu, 23 Jan 2020 22:34:06 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F13A38A1;
        Thu, 23 Jan 2020 22:34:06 +0000 (UTC)
Date:   Thu, 23 Jan 2020 17:34:06 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <600201642.3600472.1579818846276.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.03B22F835F.RSIEVD547K@redhat.com>
References: <cki.03B22F835F.RSIEVD547K@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_ker?=
 =?utf-8?Q?nel_5.4.14-0fce94b.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.13]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.14-0fce94b.cki (stable)
Thread-Index: TykMIIsk7/3a5DegolQzVCTDuj77RA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
>   ppc64le:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Podman system integration test (as root)
>        =E2=9C=85 Podman system integration test (as user)
>        =E2=9D=8C LTP

This is safe to ignore.

I can reproduce on affected system, it doesn't hang on anything specific,
it's just that test is taking longer than expected and hits timeout.
I'll look into proposing LTP patch for this issue.

