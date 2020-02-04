Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC42F152034
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 19:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBDSHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 13:07:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727355AbgBDSHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 13:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580839620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWKVifPvzk7nGZkW2Rkc9lnH/1uQ5csPYFLkasrtOuc=;
        b=N0J8HOCLhxYUGQzPFiHIuttpNA7m7HipbuohNnAij/PuuMgHEO16CpViB64jowu+PTzOCb
        xNmEYLJR5hOmRwDxXmivxKsNHzU06pFLQ7OyogkTyfgjZ+Q+egMBJfF7FPQ1R93yuRJPjn
        4ZTGWO8kViK69yMWsI0swBILxKVIyU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-PGVruzOkOEWd4QzH82xiKA-1; Tue, 04 Feb 2020 13:06:35 -0500
X-MC-Unique: PGVruzOkOEWd4QzH82xiKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECDC8014CE;
        Tue,  4 Feb 2020 18:06:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-102.rdu2.redhat.com [10.10.121.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FE9B87EFF;
        Tue,  4 Feb 2020 18:06:28 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=5bLTP=5d_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_?=
 =?UTF-8?Q?5=2e4=2e18-rc1-6213eed=2ecki_=28stable=29?=
To:     Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>
References: <cki.A43C5F6701.3LH2WNZUVM@redhat.com>
 <1905459596.5574249.1580806970915.JavaMail.zimbra@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <fd899990-b29d-7b5d-208c-aa89e5d67859@redhat.com>
Date:   Tue, 4 Feb 2020 13:06:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1905459596.5574249.1580806970915.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/4/20 4:02 AM, Jan Stancek wrote:
>=20
>=20
> ----- Original Message -----
>>
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>         Kernel repo:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git
>>              Commit: 6213eed0e444 - Linux 5.4.18-rc1
>>
>> The results of these automated tests are provided below.
>>
>>      Overall result: FAILED (see details below)
>>               Merge: OK
>>             Compile: OK
>>               Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for download=
 here:
>>
>>    https://artifacts.cki-project.org/pipelines/419091
>>
>> One or more kernel tests failed:
>>
>>      ppc64le:
>>       =E2=9D=8C LTP
>=20
> b45d82cfbabc ("max_map_count: use default overcommit mode")
> should address that. CKI job is currently at LTP commit:
>    baf4ca1653a9 ("syscalls/capset01: Cleanup & convert to new library")

Thanks for the reminder :-) I will update LTP to a recent commit today to=
 pull
in this change.

-Rachel
>=20
>=20

