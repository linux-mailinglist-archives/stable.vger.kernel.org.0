Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A700153DB3
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgBFDtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:49:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgBFDtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:49:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163mOLJ183918;
        Thu, 6 Feb 2020 03:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XhALtvuOwBbUvPhD614HLn2yUqcjfzQFIk94wyXOAWY=;
 b=WWiF53KzC37ywr8JrBbD2kw4Kc0gx4O7iUyoyhjBJNvpyhvhjO7MsZEPHf2EJvXid9jF
 jnW+sGcwkcnNMGxUyHuZ6Np6u4VGXUa9pSl9+rm2IUGCbXfo3KEpxhs8goXPDVUDCI3J
 vBbbdcJKMVPMJI/zN+/nI7HM5I29m6dd4hfeeyOrl8jj5GcR3kcB9KiNIYmpzmT//lEi
 vgRZIstKVsX8/U3rMCU9nSyVeI6M8i8llutNRxB56dtt386QsiEVO7Vvq4d8U27D5dG1
 arLBHVG+IN30Kp2A3sKrBENJZSSnruFs9OnGAdQwQ1dbnpZ8hqRya58kGi05M2NBwumd /Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=XhALtvuOwBbUvPhD614HLn2yUqcjfzQFIk94wyXOAWY=;
 b=Q6YWn5wM1qjQj4Q7v+eeA/CncNgxvOI5RgREvyQ+O/sqkyQPOkuioQXoWKrQkAVFYe+B
 I6FWSd32Zwaz90Zhk4PsA91B8nqlmyLEGk65o9r27XJIQLCeU12WFG5SMW0xlup5ewKU
 VNkOTcnWwAaGvBmS1WKHrUGo/QnR8Ec0VKgFp1qAYG+iIGYFbz7nwlaFwctVqtXvIdzA
 7y6Xgnd3jIc7/c2OBlcM6D5yZdEB0Wg+FnkpVYopRycDf0gASEz1y4SqvxaK4PkzBCnu
 K8KQXd/U6gUtd+FiRrZdpdtKlmcWyY8u45JzL2D81Jr8fAnP80bcuFNgSF173FG7Jr+X Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp72w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:49:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163n5Js084210;
        Thu, 6 Feb 2020 03:49:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xymuucffd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:49:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0163mWE1003342;
        Thu, 6 Feb 2020 03:48:32 GMT
Received: from [10.190.155.136] (/192.188.170.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 19:48:32 -0800
Subject: Re: [PATCH] btrfs: print message when tree-log replay starts
From:   Anand Jain <anand.jain@oracle.com>
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
References: <20200205161216.24260-1-dsterba@suse.com>
 <69682127-4580-8795-5d8f-fc18d6d840fd@oracle.com>
Message-ID: <f9291224-ec67-f54b-3b09-5938c81e1568@oracle.com>
Date:   Thu, 6 Feb 2020 11:48:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <69682127-4580-8795-5d8f-fc18d6d840fd@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060026
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/6/20 11:45 AM, Anand Jain wrote:
> On 2/6/20 12:12 AM, David Sterba wrote:
>> There's no logged information about tree-log replay although this is
>> something that points to previous unclean unmount. Other filesystems
>> report that as well.
>>
>> Suggested-by: Chris Murphy <lists@colorremedies.com>
>> CC: stable@vger.kernel.org # 4.4+
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>   fs/btrfs/disk-io.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 28622de9e642..295d5ebc9d5e 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3146,6 +3146,7 @@ int __cold open_ctree(struct super_block *sb,
>>       /* do not make disk changes in broken FS or nologreplay is given */
>>       if (btrfs_super_log_root(disk_super) != 0 &&
>>           !btrfs_test_opt(fs_info, NOLOGREPLAY)) {


>> +        btrfs_info("start tree-log replay");

btrfs_info() needs struct btrfs_fs_info as first arg.

>>           ret = btrfs_replay_log(fs_info, fs_devices);
>>           if (ret) {
>>               err = ret;
>>
> 

> Reviewed-by: Anand Jain <anand.jain@oracle.com>

Sorry hit the send button too early.

Thanks, Anand
