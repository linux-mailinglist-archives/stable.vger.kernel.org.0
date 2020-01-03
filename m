Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA312FBA5
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgACRew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:34:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgACRew (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:34:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003HTk6G129188;
        Fri, 3 Jan 2020 17:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fYzuHY5/xmbEDIXl7hvjfaQELjdiy9iozp4oXzR/mwY=;
 b=rcRsXDV1uMrn/vhtTvSHwP7qE/t1eYDgTWxaZ4fQTZ9jlnaO0cDTedjOcBOP98piLrWT
 B9aS+CCmzgF9PKfpDXlwBKkvGdbKYJL+vrTayuxC1RqVu+svKncvLzbNS/5GoG5qkBze
 4gD5I/gbJTGd4GXE3X2kfQz9glWk8MsAiaCmuGQsoWl2ZdfyVWEzUHAPWKZmRox/trlw
 qu6E71vRsUsvPBlB1maW/M+dBUXdTKoJmLM6tVAG3jihxaaGxihfNdGn4+2tpjLeDJzG
 xYW9Te2pYVWo4/bwQTUCyKyQyJnytViJBZ9NB/zTdry7bf20NfVvz4xxx6rdJ+eWRBtV sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqwd46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 17:33:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003HXlmx196296;
        Fri, 3 Jan 2020 17:33:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xa7tyfhk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 17:33:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003HXLtQ014107;
        Fri, 3 Jan 2020 17:33:24 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 09:33:21 -0800
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
References: <20200102215829.911231638@linuxfoundation.org>
 <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
 <20200103154518.GB1064304@kroah.com>
 <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <a2fc8b36-c512-b6dd-7349-dfb551e348b6@oracle.com>
Date:   Fri, 3 Jan 2020 09:33:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030160
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/20 7:56 AM, Arnd Bergmann wrote:
> On Fri, Jan 3, 2020 at 4:45 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, Jan 03, 2020 at 04:29:56PM +0100, Arnd Bergmann wrote:
>>> On Fri, Jan 3, 2020 at 4:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>>>
>>>> On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>>>
>>>>> On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> -ENOENT is what you get when hugetlbfs is not mounted, so this hints to
>>>>
>>>> 8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9
>>>
>>> I see that Mike Kravetz suggested not putting this patch into stable in
>>>
>>> https://lore.kernel.org/lkml/befca227-cb8a-8f47-617d-e3bf9972bfec@oracle.com/
>>>
>>> but it was picked through the autosel mechanism later.
>>
>> So does that mean that Linus's tree shows this LTP failure as well?
> 
> Yes, according to
> https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-syscalls-tests/memfd_create04
> mainline has the same testcase failure, it started happening between
> v5.4-10135-gc3bfc5dd73c6 and v5.4-10271-g596cf45cbf6e, when the patch
> was originally merged into 5.5-rc1.
> 
>> This does seem to fix a real issue, as shown by the LTP test noticing
>> it, so should the error code value be fixed in Linus's tree?
> 
> No idea what to conclude from the testcase failure, let's see if Mike has
> any suggestions.
> 

Thanks for isolating to this patch!

There are dependencies between arch specific code and arch independent code
during the setup of hugetlb sizes/mounts.  Let me take a closer look at the
arm64 code and get access to a system for debug.

-- 
Mike Kravetz
