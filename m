Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3E155B56
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 17:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgBGQCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 11:02:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgBGQCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 11:02:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 017FYG2Q110533;
        Fri, 7 Feb 2020 16:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jVJDunWLz+Xcykb4FZHQ3k/pcx9Ztn20GwEppCiHnKs=;
 b=wp0/tpkqr6Qc82F98givKiNRdarUsI7rzWUqzfPESObZhcyCxZfnHUBRoMnp6eTPEf4q
 92w/G9NiWBhj7KrsYjIINYuAxlUicIpKKTTucuG+6XVt0fYDKMZjBus1z4dV/zXTx+Dc
 vot12YREJXWMJAv5AKeSss3jJ+RlVBJug2LKDqWnyt8SdlZHYzsmxlv/cvmRwuOTXizh
 UJfljl8927R7XeK8TGbs2L3RS9uUQtvwTolbU1r42TmAavGbeRTdAGFRb4HCwhbS+DHh
 nXhrmm0kIPWXVzlDaXrYnJo3nKkjuiuhCjo7lXVik4E6z8Mh0sBRCfhaJcLBJ467RqZV 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xykbpgv1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Feb 2020 16:02:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 017FYJU4185404;
        Fri, 7 Feb 2020 16:02:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y0jg1s9nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Feb 2020 16:02:23 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 017G2MHS018274;
        Fri, 7 Feb 2020 16:02:22 GMT
Received: from [192.168.1.119] (/39.109.145.141)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Feb 2020 08:02:22 -0800
Subject: Re: [PATCH v2] btrfs: log message when rw remount is attempted with
 unclean tree-log
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200207151955.6647-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <047ee4db-1c94-6427-fd8b-9698d1dba7a3@oracle.com>
Date:   Sat, 8 Feb 2020 00:02:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200207151955.6647-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002070119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002070119
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Anand Jain <anand.jain@oracle.com>
