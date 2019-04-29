Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B733E20E
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfD2MQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:16:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfD2MQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 08:16:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TBxEek174530;
        Mon, 29 Apr 2019 12:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=B1oht0ZDwvaguBnKrF+K0MYiqzlUfmJHFgAiOGTu+fE=;
 b=kNC/7V8CSJvghv72xg7/u4Pjtov8WZAw3hyi/AF2fQHwC9zY0iykl2HNknejpheV9a16
 7hBiYbvSEhDbPaYUxgj8VKX3nai8FlDZNRPnqn16UevhPig1EJ8ATZwTQhN7k2VZ7QBV
 1mK92zQo+U2qrVW/p2BvEVvx/rfn/yZkbTEdmqifTNhhdZ9MyD/Y1Q1rSC67OFK4G129
 IxQ6Gog2FVq4auU26Fgidqe/nqEFNgiWZMWuiUmbqDjjq3sGL+cy2u759ppXdTxbbnfr
 j70CGLVBjqSMPE9rlBnHzR8TK7FT3ttrQ2MoAEqxm0fddb0JoTbDtb9EeACU8iLM3bp/ BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s5j5ttmt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 12:16:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TCGfxu194795;
        Mon, 29 Apr 2019 12:16:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s4ew0mqag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 12:16:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3TCGll5015216;
        Mon, 29 Apr 2019 12:16:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 05:16:47 -0700
To:     Pedro Sousa <PedroM.Sousa@synopsys.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
Date:   Mon, 29 Apr 2019 08:16:45 -0400
In-Reply-To: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
        (Pedro Sousa's message of "Thu, 18 Apr 2019 21:13:34 +0200")
Message-ID: <yq1a7g90zwy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9241 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=516
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290088
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9241 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=559 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290088
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Pedro,

> Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
> according to MIPI Alliance MPHY specification.

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
