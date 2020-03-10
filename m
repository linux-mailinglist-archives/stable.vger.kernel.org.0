Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E902C17F154
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 08:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCJH67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 03:58:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgCJH66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 03:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583827138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvdwdmFoveOmXx6N2YNTgQ9BaySVLSe+YS3FnsZUDO8=;
        b=iopU8CW8Imqc3cwIMddoKWDDjhH2zFPicMI13WOxfvmLN3MgIMGiXurVQGPyXuyWnAGxLB
        IXr0tbOx1uRcgU2o3a0VL6BGI7R7OcWU5wfIXTulpHou6uDjj64cZ2cpZQImBXX9B9ESLs
        7XEwNcqowufMNUjQpFvvNsh2PBKsSEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-kzrpJ8wVP72Xwfw4JdSvWQ-1; Tue, 10 Mar 2020 03:58:49 -0400
X-MC-Unique: kzrpJ8wVP72Xwfw4JdSvWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABBBCA0CBF;
        Tue, 10 Mar 2020 07:58:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A261060C05;
        Tue, 10 Mar 2020 07:58:48 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B44F18095FF;
        Tue, 10 Mar 2020 07:58:48 +0000 (UTC)
Date:   Tue, 10 Mar 2020 03:58:48 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Ondrej Moris <omoris@redhat.com>,
        William Gomeringer <wgomeringer@redhat.com>
Message-ID: <1743314452.221557.1583827128244.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAFqZXNugDTJ8MQePK1Cyz2TOJiPcPrq3ohmNZngJjaTCq1Y6mQ@mail.gmail.com>
References: <cki.411617A928.D7E40QQCW6@redhat.com> <20200309215305.GV21491@sasha-vm> <CAFqZXNugDTJ8MQePK1Cyz2TOJiPcPrq3ohmNZngJjaTCq1Y6mQ@mail.gmail.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_PANICKED:_Test_report_for_ker?=
 =?utf-8?Q?nel_5.5.8-c30f33b.cki_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.25, 10.4.195.28]
Thread-Topic: =?utf-8?Q?=E2=9D=8C_PANICKED=3A?= Test report for kernel 5.5.8-c30f33b.cki (stable-queue)
Thread-Index: SiOoaWByeX9gaTy7dD3aEMxB2reMOQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> > Following the link above I got to
> > https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/09/480158/audit__audit_testsuite_test/,
> > but it shows that all tests are passing? The console log looks fine too:
> > https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/09/480158/x86_64_5_console.log.
> > Where's the panic?
> 
> The panic happened during the LTP test on s390x (note the lightning
> symbols under s390x, Host 1). The backtrace is at the end of
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/09/480158/s390x_1_console.log

Which looks like same panic reported for last couple days. See:
  https://lore.kernel.org/stable/976629603.10711789.1583698043547.JavaMail.zimbra@redhat.com/
  https://lore.kernel.org/lkml/20200224030007.3990-1-cai@lca.pw/

