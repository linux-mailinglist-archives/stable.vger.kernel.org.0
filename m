Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602CC1C46CA
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 21:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEDTJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 15:09:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37202 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgEDTJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 15:09:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J9TrV095487;
        Mon, 4 May 2020 19:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=m9cwG9HGuBvud61LkxUBAl2mqDGnYZg/+tL5tc41mYI=;
 b=oIILggnNj1n859JbPJjwGNWqiZFWgLkpgHIgXzuphWWlinllCOMKGUmqOHffDJiH2jAT
 XuCxWqQ+wi59Z8/hfdZxWIyJQ4PqiI8yy8X6JqtWgL7QxAR81U83P0zP7YG1ajdGQosf
 8GK6PqIQjRNZz22NNpikliBTr8u68Lr2koJr0pjtnBj1Na7BzU2aPrnI0BVTp/ORRey+
 BWONalSKrY2jxNlPhyw1pmUgKpjfVH+P6dJg+OIWEr0LjbwfR5qLH3dg85WMm76ZMc0O
 9/HU8bhNQV/MY+65tBLNWrruLneMS72+tbzo3Q0TJz3pb/GuoLYhp7TGDFfHFJ5ISCkD VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tm8tjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 19:09:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J7Nmu009014;
        Mon, 4 May 2020 19:07:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnbkauc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 19:07:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044J7Bhr018655;
        Mon, 4 May 2020 19:07:11 GMT
Received: from [10.154.152.113] (/10.154.152.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:07:11 -0700
Subject: Re: [PATCH] scsi: qla2xxx: Do not log message when reading port speed
 via sysfs
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com
References: <20200504175416.15417-1-emilne@redhat.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <d36541d4-3ff4-ffe9-e5dc-7e61c918f6d7@oracle.com>
Date:   Mon, 4 May 2020 14:07:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504175416.15417-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040149
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/4/20 12:54 PM, Ewan D. Milne wrote:
> Calling ql_log() inside qla2x00_port_speed_show() is causing messages
> to be output to the console for no particularly good reason.  The sysfs
> read routine should just return the information to userspace.  The only
> reason to log a message is when the port speed actually changes, and
> this already occurs elsewhere.
> 
> Cc: <stable@vger.kernel.org> # v5.1+
> Fixes: 4910b524ac9 ("scsi: qla2xxx: Add support for setting port speed")
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3325596..2c9e5ac 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1850,9 +1850,6 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
>   		return -EINVAL;
>   	}
>   
> -	ql_log(ql_log_info, vha, 0x70d6,
> -	    "port speed:%d\n", ha->link_data_rate);
> -
>   	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
>   }
>   
> 
Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
