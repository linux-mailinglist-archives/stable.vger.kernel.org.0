Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7341ACD
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 05:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFLDlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 23:41:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFLDlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 23:41:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C3YeOu102530;
        Wed, 12 Jun 2019 03:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=jWxMh7j0z4pw49LCXSlQU+UovVDYkyY0V/wrY5Hpml0=;
 b=vKBe7eRCI7zS4PAL9KpRsb5EeiiZEmPcry1Bl4vCKP3P0YjNJ8ZNjFSxeYzcmIQrJ9Ri
 4TpVTctmoalveRBPyWcBQb9dFHpze+D8Z8kTFvJmteljixOrJa3hoGKDV/P4KuSxVOz0
 A0YhJspob14zmz4x70utjcRBhJJo8YtXFWXDEf/pmOewadpWkaN9/mTGAyB3lHgY22ai
 TApsS/YiXxirRtwq+xligXdwOnt5i1HVIHAfov3MSfyg6ixlAoUJJm50njWyWTaes7j3
 wX7E4H8p6FgVhaTVtVhYvBIhZkto1zADnyFeQK3niCyeNidQlYX7dzv3oq9M5SRaF6OK ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t04etru0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 03:40:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C3d3HD049247;
        Wed, 12 Jun 2019 03:40:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t04hypr9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 03:40:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C3eV52030379;
        Wed, 12 Jun 2019 03:40:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 20:40:31 -0700
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190611143259.28647-1-hdegoede@redhat.com>
Date:   Tue, 11 Jun 2019 23:40:29 -0400
In-Reply-To: <20190611143259.28647-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Tue, 11 Jun 2019 16:32:59 +0200")
Message-ID: <yq1d0jjeaj6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=827
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=875 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120022
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hans,

> -	/* drives which fail FPDMA_AA activation (some may freeze afterwards) */
> -	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
> -	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
> +	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
> +	   the ST disks also have LPM issues */
> +	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
> +						ATA_HORKAGE_NOLPM, },
> +	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA |
> +						ATA_HORKAGE_NOLPM, },

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Slightly orthogonal, and I know it's been discussed before, but I think
it would be worth considering just blacklisting all firmware revs for
this model.

There were several firmware releases for these drives. And while it's
conceivable that post-2BA30001 may fix the issues, I think it's safe to
say that all the intermediate releases between the two we have are
equally broken.

-- 
Martin K. Petersen	Oracle Linux Engineering
