Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011C15B6F18
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiIMOHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiIMOHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:07:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8F65246C;
        Tue, 13 Sep 2022 07:07:18 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DDplcK002230;
        Tue, 13 Sep 2022 14:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0y2Y0czkO0bjZjwSM1IpUT8rB+wyqI9stwPJyVRF1zo=;
 b=LrMRDLeVv2u0uy5RxYCi1mmzDERYqKMH25lAKJs6tA3EjVXpnETuDHjXfk2+UGOPOFxO
 VHThKJQTcdPWysUgQkJQH5jxdg6eqzgkFD3FFtr6Q5unVjkibJEzFrq/+BuS+7Sh+f5R
 xdRPCALldlllbY/0N4dDE3NaGCF7Qj+HioXppumcQ2mNlxZLYoe3EBvt9BzTKQVuyV4g
 AO1SdziEne5V72ol8kjeGV7UdS/ez0aOsAIkeQuW1NIRXn7c6deVPiO1nrSxeAouSrcu
 fuOBcV9XhGe5cUZ+235z+yKTMSMdbgiuHbS8oGZBpkOZC1ull2jXIvSa/zdUEveBgQ74 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jju4c8mt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:07:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28DDqYp0005114;
        Tue, 13 Sep 2022 14:07:17 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jju4c8mr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:07:16 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28DE6I2D020729;
        Tue, 13 Sep 2022 14:07:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3jgj792v8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 14:07:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28DE7A2730998794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 14:07:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC0614C044;
        Tue, 13 Sep 2022 14:07:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54D894C040;
        Tue, 13 Sep 2022 14:07:10 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.152.224.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Sep 2022 14:07:10 +0000 (GMT)
Date:   Tue, 13 Sep 2022 16:07:08 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 2/2] s390/vfio-ap: fix unlinking of queues from the
 mdev
Message-ID: <20220913160708.50466335.pasic@linux.ibm.com>
In-Reply-To: <20220823150643.427737-3-akrowiak@linux.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
        <20220823150643.427737-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: su6iy7UpQX6SfCWV74kA_zNrbHSpwIcB
X-Proofpoint-GUID: sBLCl6E-IGtYbNT9Q4c9Oh-Zq2Cau9nG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_06,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209130064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Aug 2022 11:06:43 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap_mdev_unlink_adapter and vfio_ap_mdev_unlink_domain functions
> add the associated vfio_ap_queue objects to the hashtable that links them
> to the matrix mdev to which their APQN is assigned. In order to unlink
> them, they must be deleted from the hashtable; if not, they will continue
> to be reset whenever userspace closes the mdev fd or removes the mdev.
> This patch fixes that issue.

I'm not so sure about that!

> 
> Cc: stable@vger.kernel.org
> Fixes: 70aeefe574cb ("s390/vfio-ap: reset queues after adapter/domain unassignment")
> Reported-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index ee82207b4e60..2493926b5dfb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1049,8 +1049,7 @@ static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
>  		if (q && qtable) {
>  			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>  			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
> -				hash_add(qtable->queues, &q->mdev_qnode,
> -					 q->apqn);

Careful qtable->queues is not supposed to be the same as
matrix_mdev->qtable.queues it is rather a function local
qtable that you use to know which queues were unlinked and
need resetting.

Have a look at vfio_ap_mdev_hot_unplug_adapter()

> +				vfio_ap_unlink_queue_fr_mdev(q);

IMHO this change is completely bogous. BTW
vfio_ap_unlink_apqn_fr_mdev() a couple of lines above in the source
(not seen in diff context) calls vfio_ap_unlink_queue_fr_mdev().

>  		}
>  	}
>  }
> @@ -1236,8 +1235,7 @@ static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
>  		if (q && qtable) {
>  			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
>  			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
> -				hash_add(qtable->queues, &q->mdev_qnode,
> -					 q->apqn);
> +				vfio_ap_unlink_queue_fr_mdev(q);

Same as above...

Regards,
Halil

>  		}
>  	}
>  }

