Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E4E9095
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfJ2UIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 16:08:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46949 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726535AbfJ2UIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 16:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572379720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WVMR/1qX6q2o8+G1jONU+fXGcDMObD5fAQeZ0YhInKg=;
        b=V86NcpS6Om4RSDNglbICVPXxtM+JTqQYclGymgt9KoP/AQE2PBUm2y+dVNCC5mPG+5TgHA
        gbqtgf1Jr1x6kIPMQhSO/FHvl0I4hAHV8PLNR3yjHqku5zTvRmjYP3gr61fUOYm1XdSJQN
        2s7wf4EM+X7QYdlq2vCmfXKwsbvV5Lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-ZEttjrsGPEKzvwW2uTU6jQ-1; Tue, 29 Oct 2019 16:08:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4FBA1005500;
        Tue, 29 Oct 2019 20:08:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-15.rdu2.redhat.com [10.10.121.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 206741001B09;
        Tue, 29 Oct 2019 20:08:28 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e3=2e8-?=
 =?UTF-8?Q?rc2-96dab43=2ecki_=28stable=29?=
To:     Greg KH <gregkh@linuxfoundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, lkft-triage@lists.linaro.org,
        CKI Project <cki-project@redhat.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com>
 <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com>
 <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
 <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
 <20191029181223.GB587491@kroah.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <114dc6b2-846b-240d-db33-dd67aac51d30@redhat.com>
Date:   Tue, 29 Oct 2019 16:08:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191029181223.GB587491@kroah.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ZEttjrsGPEKzvwW2uTU6jQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/29/19 2:12 PM, Greg KH wrote:
> On Tue, Oct 29, 2019 at 07:57:05AM -0700, Deepa Dinamani wrote:
>> The test is expected to fail on all kernels without the series.
>>
>> The series is a bugfix in the sense that vfs is no longer allowed to
>> set timestamps that filesystems have no way of supporting.
>> There have been a couple of fixes after the series also.
>>
>> We can either disable the test or include the series for stable kernels.
> I don't see adding this series for the stable kernels, it does not make
> sense.
I'm not sure what the final decision is here, but I've moved the test to=20
a waived status for now,
which means it should stop causing the job to fail. However, you may see=20
a few lingering
reports sneak in before I made this change. Once resolved, I'll remove=20
the waived tag.

Thanks,
Rachel
> thanks,
>
> greg k-h
>

