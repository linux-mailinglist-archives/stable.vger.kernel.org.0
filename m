Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC16153DAA
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbgBFDpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:45:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60074 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgBFDpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:45:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163cFBB185930;
        Thu, 6 Feb 2020 03:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PRsxjB7iCsa/6G0Al//G+kaBCcUpsvjSEvecOPwZyDA=;
 b=cVYp8aQGlCWJeiGiQh8biuHnYZ825vYJRAi6KYsUeVN4K7X70jPWpbHQvvbwLmjsjUJ/
 xYrC6vxhEt4077sLAEEYObdgyNQUxbzKJnFj6HyHynUTRCMCqKGCzlx7kevp5XMBePee
 /ScYACi5hzOkj+sQ6Mn71BdIMaS+zKDF/4BLdgBFVNo+fc3lUnmmZZD2cdRvGUVH7i9a
 qaA/spTjy/HRH1vMfToa6oSjhOsX+rcycYL0ORcXopy+RI4XZKZL5nY0KCPGrsnK9off
 TOSW5TwH60WHHAnftYskT94x1fXfyADIgl4PXY0tY/XXjXAztVmxgsex2d+79V0iZ9AN Tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PRsxjB7iCsa/6G0Al//G+kaBCcUpsvjSEvecOPwZyDA=;
 b=l6xeDsmwqsTQ5Jbg47KOcV4xQIFSTY+aHy1pel6/5eaHqr/Oyy5oWBPnU3GQWJwFGuvn
 iP16Y/462aGJX0NsPNAOd5ldIUN0VnNfi7FlgjKd6XdRX54QfRBspsWFSEJCw+ehD95L
 DhPlJa1ckLBvL9qPWdOutRO8fg8kblNIYX9MwlYSfHCE/jS8xQ1A8eJeQD1ZdtI115ux
 qir8nJwlybhBWYmKHlR0RnLYWjPmBKLXo5WPpQnU1LosoPv0JX4vUwmlk2xJqo/1jsoo
 xl/+/ynYibIahUO0IzBExA2EMyjzjX+BurLsh9yDpEJsfDRPp7XZ5aBztfLDuBYFvbWH 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xykbpf2nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:45:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163htjn129103;
        Thu, 6 Feb 2020 03:45:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xykcah7ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:45:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0163jP2f031115;
        Thu, 6 Feb 2020 03:45:25 GMT
Received: from [10.190.155.136] (/192.188.170.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 19:45:25 -0800
Subject: Re: [PATCH] btrfs: print message when tree-log replay starts
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Chris Murphy <lists@colorremedies.com>, stable@vger.kernel.org
References: <20200205161216.24260-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <69682127-4580-8795-5d8f-fc18d6d840fd@oracle.com>
Date:   Thu, 6 Feb 2020 11:45:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205161216.24260-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060025
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/6/20 12:12 AM, David Sterba wrote:
> There's no logged information about tree-log replay although this is
> something that points to previous unclean unmount. Other filesystems
> report that as well.
> 
> Suggested-by: Chris Murphy <lists@colorremedies.com>
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/disk-io.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 28622de9e642..295d5ebc9d5e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3146,6 +3146,7 @@ int __cold open_ctree(struct super_block *sb,
>   	/* do not make disk changes in broken FS or nologreplay is given */
>   	if (btrfs_super_log_root(disk_super) != 0 &&
>   	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
> +		btrfs_info("start tree-log replay");
>   		ret = btrfs_replay_log(fs_info, fs_devices);
>   		if (ret) {
>   			err = ret;
> 


Reviewed-by: Anand Jain <anand.jain@oracle.com>
