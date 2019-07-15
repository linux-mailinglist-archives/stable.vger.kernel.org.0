Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB0699ED
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 19:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbfGORal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 13:30:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33982 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731881AbfGORaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 13:30:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FHTOSk117620;
        Mon, 15 Jul 2019 17:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=oNLfqyrTB5tOhBrKek1L8dysumby1TT8eG8esbeAM/w=;
 b=s9dc4iLlLw9cbHmOyCR4+YxfFQ95oECKyCifuCkSOH10DdF41oZDdGdZNMMj5arIqHCI
 bBPxxl5cWcdV/geQG6Wofz12AcO2geHKQqvwVNWj1z0/ILXGTnMQ9oEU5G1KiYaBbrnL
 TCCtqsm+nEG5MpmGMq/FgMYJOnw59GLhwMRrF8UmVluu8a6ES2Zas9aOD48ybbTtNNjV
 dduI2iH3XV7UVv3YJIRKwr3m84q8POOTVzTHDL5hKP3sX+306eUlL2w3E/fhbnxSIUL2
 qw9wW8gLUVGN1KoMXsTxtexFm+lc6GpxW87Yb1pd6ugE6O2QnhRJN/yH8OiBWL2SdNHR lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tq6qtg042-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 17:30:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FHSWTW120586;
        Mon, 15 Jul 2019 17:30:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tq4dtekkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 17:30:31 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6FHUTfk011882;
        Mon, 15 Jul 2019 17:30:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 10:30:28 -0700
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-ide@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190714224242.4689a874@natsu>
Date:   Mon, 15 Jul 2019 13:30:26 -0400
In-Reply-To: <20190714224242.4689a874@natsu> (Roman Mamedov's message of "Sun,
        14 Jul 2019 22:42:42 +0500")
Message-ID: <yq1y30z2ojx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=766
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=833 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150204
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> My Samsung 860 EVO mSATA 500GB SSD lockups for 20-30 seconds on
> fstrim, while dmesg is repeatedly flooded with:

Is that specific to the mSATA model?

FWIW, queued TRIM works fine on the 2.5" form factor. So it would be
best if we could limit the blacklist entry to the mSATA version (or a
particular firmware rev).

-- 
Martin K. Petersen	Oracle Linux Engineering
