Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F490481A22
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 08:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhL3HKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 02:10:23 -0500
Received: from mout.gmx.net ([212.227.15.15]:39265 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236760AbhL3HKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Dec 2021 02:10:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640848218;
        bh=R8evLSAicxdetQ/tZ4sLJgFCakvJoKWXsRE+gjERA1g=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=KrDUylvgKsMvMgMTpF1iBVvXREvB9Dne/dRPeyzVY71T4U0hZxc16jqd3jQXmG3ue
         TzMzAYeri6oV0XB68CZQ4sVDT/j1lX0hLovSOlPabSo64dOOvFcKc7xH7HbxutreNk
         Y5u7Mtfakt4AV6KaPg12YXZYsAqBk9+dwZbYUP/s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MbzuH-1mQjry2CEB-00dUhs; Thu, 30
 Dec 2021 08:10:18 +0100
Message-ID: <6766e94a-37ba-6635-1e4d-1e256739e195@gmx.com>
Date:   Thu, 30 Dec 2021 15:10:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
 <Yc1X/HqU8zK85xFd@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Should write-time tree-checker backported to v5.10?
In-Reply-To: <Yc1X/HqU8zK85xFd@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dTJ9wzZr31r//pneIn06wdDUZehDKwFJVXAW6R57CH1fkSQPnLL
 GUR5qQd1uFjonUeHkfTdWQUugs1qZhlPh94Q6w/mYBoJjfcFUJmfzod21kZD/Zn6f+fSJqd
 sa5tL5A0K6FCUOFr8jfCF6xikQC62p+LQVXzZ/zqM5uRoDw9IJVgwofz6ypDvc629+DwWj7
 8lD1AlL3Zz6l765hEKRHQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PRFZM3dU8zs=:J0cW0VVySfiybpuoFEXKI8
 2KdDPV0gZuGf1CpIejD5Y+gmfoR6CzK8nODYYQW68EDCkJkrsQMZ8+hB0Rnr0rQIQRI8ygJua
 0I0QdhJ0vGWU5ZvIVgsPm1dM+JUFa4K36+qeM0LOJoVny7lc6E6ot30O0sdCe8XqWq75nS3jY
 m9Rh9vYJGeQ8veRUHnV0k2M7JX6AUy66L4Stp+/HeuKHB4ntI2EN+KqkMvR3KH9FHbzEeMHl7
 KHDCRjhUxarwznN1tR1sqbmiWr5nfy8bOnXq2iARnmW5Soo2I5iUKpZUBeRLsR8LH3gg00z5V
 8kXJ5TA7aeMpGja7yiJUs/xoVyySGebA3h/cswybsl5+46QDeHdi/+ooT/B+pPikIptE1jvKK
 3Mq3a8n2NqY3OdAnVGAQALE5CO20meG0jJtRgrasq7ZsxozyFbZKdAe1Bm020IbHOoYnLAQ1G
 XGdLWlBm/h57gKkP6WF7o07hcJKcyWBy2+DgFj1nmUVmNUnyPepuciwOTI5yufMm0SUSQnfM+
 VLyHCf4HsLshfWL6sPwi878b3a1nmR+gAKetdGJim5wS+YDDXVkA51r0R0FXfN73vbvX17zj1
 qGnY4OVti9nvxPGtv4uYOIDuKKN6qB2If2K4AAVy8ftmvXb8Ten9DCUgsupItVZLxfQGvdq0r
 SjnqwTztziZugdQUYlbx1qc4ARQN/W+5ew++9wUC4HlP5MLBkaThH4f35oGGVXXkOtOsCcE0b
 KD0PBNZpU8CvCaIPyfEfMwch42+iWcZ8FykeWWHgWjKqKRjVTVHclivGpemBAns/4GBxNUF0Y
 ePQR2lwu2TEWvmLiRQCsNtWQiF/4dpIn1uXvCQY759j5jDSd9F82OU5FlC0M7adH3okLbnok+
 3+pAoxFAVbplNnklhrEca5GdRce0KYvLI/qEHvB91+bXFQOvA8hVBOaMeWgNkZHcdnENJVv1q
 kJcfLrSMyoWIaf2XXQnBo7S3HJQWROxBh19wkn4YmzDCbQwkhzwXHk/rh6o9KwPHkn8udhmR7
 s6DFAmFb9XfWn2JR4JZ7zyf2KCyYPBAQ/HEgHlPHcks6h4iqlb+fZUjnb0PDHfUGL5qaTVeFk
 XG2QcmDnNh1EZQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/12/30 14:55, Greg KH wrote:
> On Thu, Dec 30, 2021 at 08:06:49AM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> Since v5.10 is an LTS release, I'm wondering should we backport write
>> time tree-checker feature to v5.10?
>>
>> There are already some reports of runtime memory bitflip get written to
>> disk and causing problems.
>>
>> Unfortunately write-time tree-checker is only introduced in v5.11, one
>> version late.
>>
>> Considering how many bitflips write-time tree-checker has caught (and
>> prevented corrupted data reaching disk), I think it's definitely worthy
>> to backport it to an LTS kernel.
>>
>> Or is there any special requirement for LTS kernel to reject certain
>> features?
>
> Stable/LTS kernels do not get new features, sorry.

OK, sorry to hear that.

>  If someone wants this feature, why not just use 5.15?

One thing is, this is not really a feature, but more like an extra
safenet to catch hardware problems.

In fact, just according to the reports in btrfs mail list, memory
bitflip is not that rare in the real world.

And any undetected bitflip reached disk will be later rejected by the
read time sanity check, causing a possibly unmountable fs.
(even we output exactly the reason why we reject the metadata, and with
those error messages, one can easily know it's a bitflip, it's still way
worse than rejecting the corrupted data at write time).

So I guess the only way to get full runtime sanity check is waiting for
the next LTS.

Thanks,
Qu
>
> thanks,
>
> greg k-h
>
