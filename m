Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B9153DB9
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 04:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgBFDvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 22:51:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgBFDvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 22:51:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163mTjE184046;
        Thu, 6 Feb 2020 03:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aMGCiXgLlAd4b4ic2P+ZnNQs/IhCHZ9+384DVheqdqI=;
 b=RW8soaPyrCwbd5ydVvM77q0s0/FVUO7lPj6k9unWDFcgR1P1vE9g2L8Lh9Kpu7PpKKyN
 sPAtcONGDZ5yV88Umxk4uTZbBptXcGw+eEe3SiPDqtWg2fDURoQq7NKWIDvtkxpBTtdH
 NiDx6S/SCcTU4+VD8R8tIoSjYSuVGAsw9l8m/8rhV0BA/i3k1puQpczzi7lDnl5BQShc
 0vpkbXbiujp+bz3EdkdC6eskzwJlawQR6zcvSW0vMjQdi0E0n9zOjwXoMlv0DQ0JA+p4
 XxMsT3AcVXNKJP0Ye4nBt5b3om7mct3ZpfvbCNjHjoaJ2qPJcl8yI+2pVGqNqz/C04Bv VQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aMGCiXgLlAd4b4ic2P+ZnNQs/IhCHZ9+384DVheqdqI=;
 b=DSPzjoyZ+zxlcfGiJoq7hSXJ/M8xfxE28oSe4jOjRBknCHYuVf9LWV79zVl6XYKhm22F
 hyj4zc6u2Uap4HqiEyZb/PauOY4TRR6TgbLonco/2VuNPlKRCf2qwVORItTHv6s5RX8Z
 xlEg9ELEnGEeO9yTCdX3V9jcEWqy8Sy2jA4DMages5k5Tbjy/9/pYyR4wkIchMbChmRM
 R5xDh+RcEBuoszjFZZSh695U2h4UbfyLERbpZp+rWU/HiYxiXUrXhK94gZ/uBYz3xJRY
 0+nPcYmic/tMhmjNwpefPFXkvHYTalDU3SRUjf2j9VCnCZdpnTFIYzupa4c7jnnQqnpd 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xykbp731s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:51:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0163mwPL075049;
        Thu, 6 Feb 2020 03:51:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xykc4ja9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 03:51:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0163p8al032402;
        Thu, 6 Feb 2020 03:51:08 GMT
Received: from [10.190.155.136] (/192.188.170.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 19:51:08 -0800
Subject: Re: [PATCH] btrfs: log message when rw remount is attempted with
 unclean tree-log
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200205161228.24378-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <9a74f394-8afc-bd34-08a1-e194440746d5@oracle.com>
Date:   Thu, 6 Feb 2020 11:51:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205161228.24378-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

On 2/6/20 12:12 AM, David Sterba wrote:
> A remount to a read-write filesystem is not safe when there's tree-log
> to be replayed. Files that could be opened until now might be affected
> by the changes in the tree-log.
> 
> A regular mount is needed to replay the log so the filesystem presents
> the consistent view with the pending changes included.
> 
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/super.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 580ba7db67e5..a2554c651548 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1834,6 +1834,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   		}
>   
>   		if (btrfs_super_log_root(fs_info->super_copy) != 0) {



> +			btrfs_warn(f_info,

                                  ^^^^
                               fs_info,

Thanks, Anand

> +		"mount required to replay tree-log, cannot remount read-write");
>   			ret = -EINVAL;
>   			goto restore;
>   		}
> 

