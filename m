Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367CC6D940
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGSDAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:00:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGSDAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 23:00:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6J2xREW116877;
        Fri, 19 Jul 2019 03:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=TPmAbO2xfTXRlVOJn/FWTOSn9D/wh3ANJTPaokkj00U=;
 b=4Lz/OvJVFIPHScBtB/jeeIaBRgLaoRLJxtq38wB7AgkVypLxCwtS69HALoCZdi5ySvGU
 9vxzuPAdNOjCt7R62O8MSX5u+KQBSjSJtsuENrlmcDpbt/dhb8mxXkdfOq70yoI5grYp
 h3srv4v6k0nDDrqJ8clyt20fvxmWcyLJSsQJeCVThfzPMyStEq1HUlWA+CtoJ1BaGfeN
 7YqwL/Y2NI+K3yzIodR0bw0JW5f34vnDgPq+1eSBZrAo6TpaqQFoxhsh8rDeo7QsxjQ6
 Uv7qRtA/2Pnl3hAD6l6H7Ra2Ganj85m6PscOVgv69voUJKCCThhF63nTyqSdRtB4/oDF Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tq78q458f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 03:00:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6J2vupA040625;
        Fri, 19 Jul 2019 03:00:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tsctyp04h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 03:00:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6J30XsH023949;
        Fri, 19 Jul 2019 03:00:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jul 2019 03:00:33 +0000
To:     Roman Mamedov <rm@romanrm.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190714224242.4689a874@natsu> <yq1y30z2ojx.fsf@oracle.com>
        <20190715224215.2186bc8e@natsu>
Date:   Thu, 18 Jul 2019 23:00:31 -0400
In-Reply-To: <20190715224215.2186bc8e@natsu> (Roman Mamedov's message of "Mon,
        15 Jul 2019 22:42:15 +0500")
Message-ID: <yq1lfwuwwxc.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9322 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=948
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907190032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9322 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907190033
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> I do not have other Samsung (m)SATA models to verify. On the bugreport
> someone confirmed this to be an issue for them too. Let's try asking
> if they have the mSATA model too, and what firmware revision. Mine is
> RVT42B6Q and there were no updates available last time I checked.

I have tested two mSATA 860s on two different systems, both with Intel
AHCI controllers, and queued trim works fine for me.

I'll try a few more things tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering
