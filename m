Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A331040BD
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 17:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfKTQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 11:26:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727885AbfKTQ0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 11:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574267172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPZKFcOjb++YEVI3iE/uLx6tfas9/AXkVZjWZ+0OLVw=;
        b=GDvw218pTmO107JVa+Wig3d3y6K9vdaFGOu82ZUZqhYApiMQ8VeFOB0RLEgZ3ad6jUt8Ev
        1RwxkzpUpFIGSHEZQ6cC45Z6uCNFZcCj3E6jKRvoRCdpvXhT/MiB4Usd5B/mNeOTxXLVaV
        kRoyBxA32Oxmj+A4pKye/uI7VxjGEyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-hUKLwo3kNhicvnCPAjqCNw-1; Wed, 20 Nov 2019 11:26:11 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C02EA107ACC6;
        Wed, 20 Nov 2019 16:26:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-122-154.rdu2.redhat.com [10.10.122.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05E842AAB5;
        Wed, 20 Nov 2019 16:25:58 +0000 (UTC)
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.0-rc8-4b17a56.cki
 (stable-next)
To:     Cyril Hrubis <chrubis@suse.cz>,
        CKI Project <cki-project@redhat.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.6D94BD5731.3IAGHB25D8@redhat.com>
 <20191120113534.GC14963@rei.lan>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <57f8e29e-1d49-e93f-2b03-75a3fd3e6e21@redhat.com>
Date:   Wed, 20 Nov 2019 11:25:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120113534.GC14963@rei.lan>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: hUKLwo3kNhicvnCPAjqCNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/20/19 6:35 AM, Cyril Hrubis wrote:
> Hi!
>> One or more kernel tests failed:
>>
>>      ppc64le:
>>       ??? LTP lite
>>       ??? xfstests: ext4
>=20
> Both logs shows missing files, that may be an infrastructure problem as
> well.
>=20
> Also can we include links to the logfiles here? Bonus points for showing
> the snippet with the actual failure in the email as well. I takes a fair
> amount of time locating them manually in the pipeline repository, it
> would be much much easier just with the links to the right logfile...
>=20

Thanks for the feedback Cyril, we did have links to each failure listed
before but we were told it made the email look cluttered especially
if there are multiple failures.

The test logs are sorted by arch|host|TC, is there something we can
do to make it easier to find related logs ?
https://artifacts.cki-project.org/pipelines/296781/logs/

Maybe we can look into adding the linked logs to the bottom of the
email with a reference id next to the failures in the summary, so
for example:

     ppc64le:
      =E2=9D=8C LTP lite [1]
      =E2=9D=8C xfstests: ext4 [2]

We could also look into merging the ltp run logs into a single file
as well.

-Rachel

