Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D13CF410
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 07:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhGTFDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:03:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38092 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhGTFDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 01:03:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K5YhL2072274;
        Tue, 20 Jul 2021 01:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : content-type :
 mime-version; s=pp1; bh=f7Q5yspJe6r0GqwG/nqAUZN5kcItfRIYBbEwe620rc4=;
 b=JeDNi3bmnJR8nIPEvfMD5SxoZUMz/M9DZ/OYfq7JH3uCrgh1Mc/XhoK24+RFb+PITBkS
 UYCXnOZsx9v8eriLFza9ZLrwgGYtQDdCDI4/axao3xCHnj6rm/ufr7ySolyfM4zmJ9Ug
 PUEMZPvBEHDaqjnMkXXbGa6QxyiYkVnRaujJaXRXFXD2prkcz7VBKf+1NZS9cNOSzHs2
 0Em6e4s+q5Aa1jxu0/LMEkZmDiuLecr4dnqXtlPOOhU4jykjSqXx+xzFzrXLZ/t1JS2/
 ygEXLbVDuy4IzNUhikwk9jI4D0XcsoAnR8KjcAu1ohOPA0+1JWgTsCWHqWY8lJsnztcS bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wngubydy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 01:43:18 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16K5ZEP5075470;
        Tue, 20 Jul 2021 01:43:18 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wngubydd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 01:43:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K5b29F006997;
        Tue, 20 Jul 2021 05:43:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 39upfh8m7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 05:43:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K5hDKR21889510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 05:43:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8A9611C04A;
        Tue, 20 Jul 2021 05:43:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2172511C054;
        Tue, 20 Jul 2021 05:43:13 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Jul 2021 05:43:13 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel =?utf-8?Q?D=C3=ADaz?= <daniel.diaz@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>, hca@linux.ibm.com
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
References: <20210715182551.731989182@linuxfoundation.org>
        <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
        <yt9dim16lv3u.fsf@linux.ibm.com> <YPUXPEiTrpKoKf+t@kroah.com>
Date:   Tue, 20 Jul 2021 07:43:12 +0200
In-Reply-To: <YPUXPEiTrpKoKf+t@kroah.com> (Greg Kroah-Hartman's message of
        "Mon, 19 Jul 2021 08:10:04 +0200")
Message-ID: <yt9d4kcp1qxb.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SXYwiLKqLJLZYYD1-cHgywxYB8wqlGx5
X-Proofpoint-GUID: T9LCOnltkCscTYODk6h6WUIIWTlF-WHY
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_01:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200030
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Jul 19, 2021 at 07:40:21AM +0200, Sven Schnelle wrote:
>> If https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1428532107
>> is the logfile for this problem, than i see the following in the log:
>> 
>> make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc' 'HOSTCC=sccache gcc'
>> /bin/sh: 1: /builds/linux/arch/s390/kernel/vdso64/gen_vdso_offsets.sh: Permission denied
>> 
>> However, in the patch this script is 755, and other architecture are
>> using this for a while now - can you check what the permission are when
>> you're trying to build the kernel?
>
> Yes, the problem is that when handling patches, we can not change the
> permissions on files.  That causes this file to not be added with
> execute permissions.  This has generally been considered a bad thing
> anyway, and other scripts that relied on being executable have been
> changed over time to not be that way and be explicitly run by the
> calling script.

Hmm, right. I didn't thought about patches. So i'll adjust the patch and
sent it again. I guess prefixing it with $(CONFIG_SHELL) is then the way
to do it, at least i see a lot of location doing it that way.

> But it looks like th gen_vdso_offsets.sh script has not been changed on
> any arch to do that yet.  It is one of the few hold outs.
>
> Also, this feels like a HUGE change for a stable tree, adding new
> features like this, are you sure it's all needed?

Yes. This fixes syscall restarting in combination with signals coming in
on s390, which is broken since the conversion to generic entry. There's
no easy way to fix that, and we don't want to introduce another
workaround that is userspace visible, as we would have to carry that
forever.

Sven
