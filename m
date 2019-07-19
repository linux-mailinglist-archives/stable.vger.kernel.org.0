Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A586E1EA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 09:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfGSHr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 03:47:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726135AbfGSHrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 03:47:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6J7l3h3014181
        for <stable@vger.kernel.org>; Fri, 19 Jul 2019 03:47:54 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tu8ggjwq8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 19 Jul 2019 03:47:54 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 19 Jul 2019 08:47:51 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 08:47:48 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6J7lkXC27394200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 07:47:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDAFB11C069;
        Fri, 19 Jul 2019 07:47:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EF0C11C04A;
        Fri, 19 Jul 2019 07:47:46 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.115])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jul 2019 07:47:46 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.2 149/171] s390/dasd: Make layout analysis ESE
 compatible
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20190719035643.14300-1-sashal@kernel.org>
 <20190719035643.14300-149-sashal@kernel.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Fri, 19 Jul 2019 09:47:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719035643.14300-149-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071907-0008-0000-0000-000002FEEC80
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071907-0009-0000-0000-0000226C6D6E
Message-Id: <a8ad62c7-383a-a890-ca20-4348d8ab9dec@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190088
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The comment is true for all stable versions.

This patch is part of a larger series that enables ESE volumes.
I think it should not go alone as other patches like 
5e2b17e712cf s390/dasd: Add dynamic formatting support for ESE volumes
are needed to actually work with ESE volumes.
So I suggest to drop this patch.
Jan, Stefan, do you agree?



On 19.07.19 05:56, Sasha Levin wrote:
> From: Jan Höppner <hoeppner@linux.ibm.com>
> 
> [ Upstream commit ce6915f5343f5f2a2a937b683d8ffbf12dab3ad4 ]
> 
> The disk layout and volume information of a DASD reside in the first two
> tracks of cylinder 0. When a DASD is set online, currently the first
> three tracks are read and analysed to confirm an expected layout.
> 
> For CDL (Compatible Disk Layout) only count area data of the first track
> is evaluated and checked against expected key and data lengths. For LDL
> (Linux Disk Layout) the first and third track is evaluated. However,
> an LDL formatted volume is expected to be in the same format across all
> tracks. Checking the third track therefore doesn't have any more value
> than checking any other track at random.
> 
> Now, an Extent Space Efficient (ESE) DASD is initialised by only
> formatting the first two tracks, as those tracks always contain all
> information necessarry.
> 
> Checking the third track on an ESE volume will therefore most likely
> fail with a record not found error, as the third track will be empty.
> This in turn leads to the device being recognised with a volume size of
> 0. Attempts to write volume information on the first two tracks then
> fail with "no space left on device" errors.
> 
> Initialising the first three tracks for an ESE volume is not a viable
> solution, because the third track is already a regular track and could
> contain user data. With that there is potential for data corruption.
> 
> Instead, always only analyse the first two tracks, as it is sufficiant
> for both CDL and LDL, and allow ESE volumes to be recognised as well.
> 
> Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
> Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/s390/block/dasd_eckd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index c09039eea707..c7aec1b44b7c 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -157,7 +157,7 @@ static const int sizes_trk0[] = { 28, 148, 84 };
>  #define LABEL_SIZE 140
>  
>  /* head and record addresses of count_area read in analysis ccw */
> -static const int count_area_head[] = { 0, 0, 0, 0, 2 };
> +static const int count_area_head[] = { 0, 0, 0, 0, 1 };
>  static const int count_area_rec[] = { 1, 2, 3, 4, 1 };
>  
>  static inline unsigned int
> @@ -1823,8 +1823,8 @@ dasd_eckd_analysis_ccw(struct dasd_device *device)
>  	if (IS_ERR(cqr))
>  		return cqr;
>  	ccw = cqr->cpaddr;
> -	/* Define extent for the first 3 tracks. */
> -	define_extent(ccw++, cqr->data, 0, 2,
> +	/* Define extent for the first 2 tracks. */
> +	define_extent(ccw++, cqr->data, 0, 1,
>  		      DASD_ECKD_CCW_READ_COUNT, device, 0);
>  	LO_data = cqr->data + sizeof(struct DE_eckd_data);
>  	/* Locate record for the first 4 records on track 0. */
> @@ -1843,9 +1843,9 @@ dasd_eckd_analysis_ccw(struct dasd_device *device)
>  		count_data++;
>  	}
>  
> -	/* Locate record for the first record on track 2. */
> +	/* Locate record for the first record on track 1. */
>  	ccw[-1].flags |= CCW_FLAG_CC;
> -	locate_record(ccw++, LO_data++, 2, 0, 1,
> +	locate_record(ccw++, LO_data++, 1, 0, 1,
>  		      DASD_ECKD_CCW_READ_COUNT, device, 0);
>  	/* Read count ccw. */
>  	ccw[-1].flags |= CCW_FLAG_CC;
> @@ -1967,7 +1967,7 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
>  		}
>  	}
>  	if (i == 3)
> -		count_area = &private->count_area[4];
> +		count_area = &private->count_area[3];
>  
>  	if (private->uses_cdl == 0) {
>  		for (i = 0; i < 5; i++) {
> 

