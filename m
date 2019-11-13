Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77508FA7CD
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKMEH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 23:07:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKMEH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 23:07:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD39E4j105913;
        Wed, 13 Nov 2019 03:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=0uycHj1hnQzwFGbzXvkxe6k9HMxfe6ttpDQFwoIQ6ig=;
 b=oyrnK84K2lFalULpBohYNELqp5uWFq4H4bNYTd5O+HL+HohkNKKn4yBkDhRIexvWhkBP
 h6pM/s7KHtwVZNSb7WJJgWpip1ghFTmIuUd3u7Jg3GVcz1S0HPbOMJNLGmzUzcAsEUOo
 7g1tqS0T9Qi8pfq07LO1MfU6HLaMsJxugqI3ynla/s0535IVhPiadUt+miRPYdLy+otF
 o+z8VKq8/v6b7er0P9YcYd3Q/YfVO4ex1Hrt4d9KJRW3b/8PremoFZ2Trk/xYooHqPy4
 38a034x/8XZRbQcuMryqoQxIYmQELbakQIPTs12hFAR9DRL8wh5IJ+2LXWr7brPGxp6y Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvts7kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:12:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD399jU167983;
        Wed, 13 Nov 2019 03:12:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w7vpnfw09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:12:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD3CUEJ031961;
        Wed, 13 Nov 2019 03:12:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 19:12:29 -0800
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Jonathan Corbet" <corbet@lwn.net>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Viresh Kumar" <vireshk@kernel.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        usb-storage@lists.one-eyed-alien.net, linux-doc@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] SG_NONE fix and cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1572656814.git.fthain@telegraphics.com.au>
Date:   Tue, 12 Nov 2019 22:12:25 -0500
In-Reply-To: <cover.1572656814.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Sat, 02 Nov 2019 12:06:54 +1100")
Message-ID: <yq1lfskpizq.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130026
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Finn,

> These two patches address some issues stemming from scsi-mq conversion.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
