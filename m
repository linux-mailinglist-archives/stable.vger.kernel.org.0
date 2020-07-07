Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1B216739
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 09:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGGHUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 03:20:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGHUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 03:20:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0677IRoD009856;
        Tue, 7 Jul 2020 07:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=byjPc4hqCTlcHQfWBSUDmZOjADuGIE/3j/fv9vyId40=;
 b=pTwLAI/QUfMmd8QlYMRv9sQpcvHIM7WGIvHpFCBILsHp6HuazqvdUTMU5uy0smFGrEGh
 wgRCjHTK5lJ48pY/McZj+6nik8caU1BvTGVQC7dKVnOkvr1gVFeDe4IC/DaD7SOfolMT
 1f4mfIHCkfR0fAo1apgKSmjGGZKyPJaUCDI1cV2xhpnEyaz6eRZedUgjs8nI5I/S4Z0N
 J4NPR3IhmSwHZzl2RIgwMmkzBEsQ6OGjAwjKsNcLbMQoFzN7NM8AfgBuFQBP98Nz82vQ
 c5orTBk+HD/3lFa6b4GFXbBUMISsDf20IqBVMia7CZsws+eInloSlHG/7hMqdeTSgqAb 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 323waceemb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Jul 2020 07:20:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0677JARc027918;
        Tue, 7 Jul 2020 07:20:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3233bnp7s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jul 2020 07:20:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0677Kgnt026844;
        Tue, 7 Jul 2020 07:20:42 GMT
Received: from [192.168.1.102] (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 00:20:42 -0700
Subject: Re: [PATCH v5] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org,
        Hans van Kranenburg <hans@knorrie.org>,
        stable@vger.kernel.org
References: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <9ca06611-8adc-2a1b-106c-1bc983a27576@oracle.com>
Date:   Tue, 7 Jul 2020 15:20:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706150924.40218-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070055
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=0 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007070055
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> pahole -C btrfs_ioctl_fs_info_args fs/btrfs/btrfs.ko
> struct btrfs_ioctl_fs_info_args {
>          __u64                      max_id;               /*     0     8 */
>          __u64                      num_devices;          /*     8     8 */
>          __u8                       fsid[16];             /*    16    16 */
>          __u32                      nodesize;             /*    32     4 */
>          __u32                      sectorsize;           /*    36     4 */
>          __u32                      clone_alignment;      /*    40     4 */

>          __u32                      flags;                /*    44     4 */
>          __u16                      csum_type;            /*    48     2 */
>          __u16                      csum_size;            /*    50     2 */

>          __u8                       reserved[972];        /*    52   972 */
> 
>          /* size: 1024, cachelines: 16, members: 10 */
> };


Newer progs shall read the value of flags/csum_type/csum_size from the 
updated kernel and zeros from the older kernel. Nice fix.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.
