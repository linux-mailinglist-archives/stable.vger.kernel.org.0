Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7524A616
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHSSht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 14:37:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgHSSht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 14:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597862266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxgGSDryJkDh70y6QnKbqwJ0hEwpPii7jSAnMjdWcFI=;
        b=Zr6JXrlyimAYuI6cubeWBHPKsaZlWJljhBCeGI0GqCaOUdzS3mFnqKI3hc2PMSrBy3+R+B
        GiKf5NVf9a2CfgMNvKV49b5ypNlmjMfnstTORK2J1xfmA4cwQczdNCOYBpYrGB0g4Te3qF
        GZFi+mqOfPsizvaKMg4ebtptPQ1rTPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-amnHkRbnP_aU14m6cUfJXw-1; Wed, 19 Aug 2020 14:37:31 -0400
X-MC-Unique: amnHkRbnP_aU14m6cUfJXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1A161885D81;
        Wed, 19 Aug 2020 18:37:30 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-232.rdu2.redhat.com [10.10.114.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D769810013C4;
        Wed, 19 Aug 2020 18:37:23 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e8=2e2-?=
 =?UTF-8?Q?ad8c735=2ecki_=28stable=29?=
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        David Arcari <darcari@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
References: <cki.81A545788B.TQBX9O8LVS@redhat.com>
 <3774b716-4440-f6c7-0c9b-60d3b599196e@redhat.com>
 <20200819165013.GB3698439@kroah.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <6bbf4acf-46f3-6269-e6ce-489a13c49c20@redhat.com>
Date:   Wed, 19 Aug 2020 14:37:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200819165013.GB3698439@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/20 12:50 PM, Greg KH wrote:
> On Wed, Aug 19, 2020 at 11:54:18AM -0400, Rachel Sibley wrote:
>>
>>
>> On 8/19/20 11:48 AM, CKI Project wrote:
>>>
>>> Hello,
>>>
>>> We ran automated tests on a recent commit from this kernel tree:
>>>
>>>          Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>>               Commit: ad8c735b1497 - Linux 5.8.2
>>>
>>> The results of these automated tests are provided below.
>>>
>>>       Overall result: FAILED (see details below)
>>>                Merge: OK
>>>              Compile: OK
>>>                Tests: FAILED
>>>
>>> All kernel binaries, config files, and logs are available for download here:
>>>
>>>     https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/08/19/612293
>>>
>>> One or more kernel tests failed:
>>>
>>>       s390x:
>>>        ❌ LTP
>>>
>>>       ppc64le:
>>>        ❌ LTP
>>>
>>>       aarch64:
>>>        ❌ LTP
>>
>> For both s390x/aarch64 failures looks like we're missing the following kernel fixes for stable:
>>
>>       1	<<<test_start>>>
>>       2	tag=ioctl_loop01 stime=1597824830
>>       3	cmdline="ioctl_loop01"
>>       4	contacts=""
>>       5	analysis=exit
>>       6	<<<test_output>>>
>>       7	tst_test.c:1245: INFO: Timeout per run is 0h 05m 00s
>>       8	tst_device.c:88: INFO: Found free device 0 '/dev/loop0'
>>       9	ioctl_loop01.c:85: PASS: /sys/block/loop0/loop/partscan = 0
>>      10	ioctl_loop01.c:86: PASS: /sys/block/loop0/loop/autoclear = 0
>>      11	ioctl_loop01.c:87: PASS: /sys/block/loop0/loop/backing_file = '/mnt/testarea/ltp-4l1XyCNbu8/h6pPv5/test.img'
>>      12	ioctl_loop01.c:57: PASS: get expected lo_flag 12
>>      13	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
>>      14	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 1
>>      15	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
>>      16	ioctl_loop01.c:75: PASS: access /sys/block/loop0/loop0p1 succeeds
>>      17	ioctl_loop01.c:91: INFO: Test flag can be clear
>>      18	ioctl_loop01.c:57: PASS: get expected lo_flag 8
>>      19	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
>>      20	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 0
>>      21	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
>>      22	ioctl_loop01.c:77: FAIL: access /sys/block/loop0/loop0p1 fails
>>      23	
>>      24	HINT: You _MAY_ be missing kernel fixes, see:
>>      25	
>>      26	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=10c70d95c0f2
>>      27	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6ac92fb5cdff
>>
>> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_aarch64_redhat%3A958531/tests/LTP/8699601_aarch64_1_syscalls.fail.log
>>
>> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_s390x_redhat%3A958533/tests/LTP/8699609_s390x_1_syscalls.fail.log
> 
> 
> That doesn't make much sense as 10c70d95c0f2 ("block: remove the
> bd_openers checks in blk_drop_partitions") was in the 5.7 kernel release
> (and 5.6.11) and 6ac92fb5cdff ("loop: Fix wrong masking of status
> flags") is in the 5.8 kernel release.
> 
> So if you were testing 5.8.2, those hints aren't that relevant :)

Oops, should have double checked the hints to confirm it's truth, following up with the LTP folks now, sorry for the noise :-)

> 
> thanks,
> 
> greg k-h
> 

