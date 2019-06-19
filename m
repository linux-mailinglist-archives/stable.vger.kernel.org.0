Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939214B035
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 04:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfFSCkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 22:40:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSCkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 22:40:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J2Z4c7055041;
        Wed, 19 Jun 2019 02:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=UBq4dVb/yGNxx/nIjeQCABVn3daS+MyzXu6IPurCzSg=;
 b=2v56QvCI9B8VSHPDIuE3cR54AdkkAVI1yczdRDRjEtkreysInPeoci63DeiposS2Ml4S
 locuIgIh8awTEXO9yn+1pfTUQxaf7tRzsIRK66ikT7Nm3smMcPK7MWQZ7O/zHQGoBJjH
 CNd/E+0liXZqO5MIgUorGpcYC193uksP40waxfhfVvuX/wg6mlAWo5z8+UjocPbAaPA4
 544Z5CbCi+aQOiMUTvP0WAOjlPtSIdymY6iW8f9jt+seBGNL5Sh5/H4CGIccskTL4kmx
 ZpCfJ7vT9Mhfk8oRULeUXdygmN5t4beR1K9efd2+kJ1/bbMS5otmd0sp5g9cd0CSNn6J vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t78098pj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 02:40:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J2d70V144695;
        Wed, 19 Jun 2019 02:40:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77ymtsf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 02:40:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5J2eYxX031384;
        Wed, 19 Jun 2019 02:40:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 02:40:33 +0000
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Joshua Thompson" <funaho@jurai.org>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH v2 0/7] NCR5380 drivers: fixes and other improvements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1560043151.git.fthain@telegraphics.com.au>
Date:   Tue, 18 Jun 2019 22:40:31 -0400
In-Reply-To: <cover.1560043151.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Sun, 09 Jun 2019 11:19:11 +1000")
Message-ID: <yq1lfxywb4w.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=636
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=680 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190019
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Finn,

> Among other improvements, this patch series fixes a data corruption bug
> in the mac_scsi driver and a bug in the EH abort routine in the core
> 5380 driver.
>
> For consistency I have ignored certain checkpatch.pl complaints about
> the indentation in mac_scsi.c. The remaining complaints seem to be
> false positives.
>
> Some of these patches are not trivial to backport. Those patches have
> been nominated for recent -stable branches only.

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
