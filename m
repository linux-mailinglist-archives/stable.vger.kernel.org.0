Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048CB1007C6
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfKRPAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:00:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58129 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726739AbfKRPAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574089222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdovHduOZjHh4CShIpExiT481Sh30pWRYYVggRSMMew=;
        b=aZa9I38OO8cs037L8ZsC5nh+Ftd06wqJ3skvMoked0c5O5mI1OugVAQQ6KHnOP+9ExfOoq
        xPWHl1i+hEGcBVljx0kPh3iLHFMRAk8ycrGmPGzK1x5gB7vbCDIYnV/AUSM9S7k6akwlc7
        2JZ+mpcAc/GtggKhawq8JlBSU62bAto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-H9h_ehSkPcWZs-FjwtSmVA-1; Mon, 18 Nov 2019 10:00:20 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 747E7109213F;
        Mon, 18 Nov 2019 15:00:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-55.rdu2.redhat.com [10.10.121.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44E0260BE1;
        Mon, 18 Nov 2019 15:00:09 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e0-?=
 =?UTF-8?Q?rc7-e1918f0=2ecki_=28stable-next=29?=
To:     Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.FB80424DEC.V1BSM19IWA@redhat.com>
 <1987216338.12689847.1573913007381.JavaMail.zimbra@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <82b4311e-1d2f-8af7-22f1-2883b71a2a80@redhat.com>
Date:   Mon, 18 Nov 2019 10:00:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1987216338.12689847.1573913007381.JavaMail.zimbra@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: H9h_ehSkPcWZs-FjwtSmVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/16/19 9:03 AM, Jan Stancek wrote:
> ----- Original Message -----
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>         Kernel repo:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stabl=
e.git
>>              Commit: e1918f0cc92b - kcov: remote coverage support
>>
>> The results of these automated tests are provided below.
>>
>>      Overall result: FAILED (see details below)
>>               Merge: OK
>>             Compile: OK
>>               Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for download h=
ere:
>>
>>    https://artifacts.cki-project.org/pipelines/288750
>>
>> One or more kernel tests failed:
>>
>>      x86_64:
>>       =E2=9D=8C LTP lite
> Not a kernel problem.
>
> Rachel,
>
> You appear to be running LTP which doesn't have commit below.
> Host CPU where this failed is family 6, model 71 (INTEL_FAM6_BROADWELL_G)=
.
>
> commit 0807a8258fbcf216bdd79a8d74a34b07bb42d8d3
> Author: Jan Stancek <jstancek@redhat.com>
> Date:   Mon Oct 28 14:33:26 2019 +0100
>
>      pt_test: skip pt_disable_branch on Broadwell CPUs
>     =20
>      commit d35869ba348d ("perf/x86/intel/pt: Allow the disabling of bran=
ch tracing")
>      disallows not setting BRANCH_EN due to erratum BDM106 on Broadwell C=
PUs.
Thanks=C2=A0 Jan, I'm working on updating LTP to a recent commit now, I'll =
cc=20
you in the ticket.

