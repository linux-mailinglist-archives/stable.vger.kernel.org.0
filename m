Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E00D2D81EA
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393962AbgLKWXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:23:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387557AbgLKWXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:23:23 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBM297J064781;
        Fri, 11 Dec 2020 17:22:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8SHFA+w9P/czyxvX214l3fdhHSK2bnKXKI2MqKjCnig=;
 b=SwlT1K/0e7uItl5MywCR1cp3wcXFGW1Tr+qfKR/u01WLK4AAQITB8+6Ii4GaOpV3K1Aj
 AQXMYwrjTbcVExawC8MeD5DWKp2qUvNfNehk1keQ36YKIJ1JcMi9HLGDLTwTP7XXDh0e
 pjoso7PHsTtfZtw+2hJubEyXzI1z8YB9B2L4V58Gzzc1+xFBNXLDfsUt8Yp4lGI5RB0c
 ruhyzQ/btaJQAlZc5pwwelnq8hmmCtH5V3eqW80suyIPlu4N4Z/TVdAJTWhaSBRL6Rqi
 MBF+7J8PawCBum9eNTyLVOZ917RXmXgUejj6yBRzsvgucz39giRW4jOMhO8cYqJ6RtAm +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35cgx0gsa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:23 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBM6ZUG103733;
        Fri, 11 Dec 2020 17:22:23 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35cgx0gs9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:22 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBMLmL9028635;
        Fri, 11 Dec 2020 22:22:21 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3581u9tvqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 22:22:21 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBMMKh223265704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 22:22:20 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55472C605B;
        Fri, 11 Dec 2020 22:22:20 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7524C6057;
        Fri, 11 Dec 2020 22:22:18 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 22:22:18 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 0/2] Clean up vfio_ap resources when KVM pointer invalidated
Date:   Fri, 11 Dec 2020 17:22:09 -0500
Message-Id: <20201211222211.20869-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_06:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=3
 clxscore=1011 priorityscore=1501 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110142
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vfio_ap device driver registers a group notifier with VFIO when the
file descriptor for a VFIO mediated device attached to a KVM guest is
opened. The group notifier is registered to receive notification that the
KVM pointer for the guest is set (VFIO_GROUP_NOTIFY_SET_KVM event). When
the KVM pointer is set to a non-NULL value, the vfio_ap driver takes the
following actions:
1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
   of the mediated device.
2. Calls the kvm_get_kvm() function to increment its reference counter.
3. Sets the function pointer to the function that handles interception of
   the instruction that enables/disables interrupt processing for the
   KVM guest.
4. Plugs the AP devices assigned to the mediated device into the KVM
   guest.

These actions are reversed by the release callback which is invoked when
userspace closes the mediated device's file descriptor. In this case, the
group notifier does not get called to invalidate the KVM pointer because
the notifier is unregistered by the release callback; however, there are no
guarantees that userspace will do the right thing before shutting down.
To ensure that there are no resource leaks should the group notifier get
called to set the KVM pointer to NULL, the notifier should also reverse
the actions taken when it was called to set the pointer. This patch series
ensures proper clean up is done via the group notifier.

Tony Krowiak (2):
  s390/vfio-ap: No need to disable IRQ after queue reset
  s390/vfio-ap: reverse group notifier actions when KVM pointer
    invalidated

 drivers/s390/crypto/vfio_ap_drv.c     |  1 -
 drivers/s390/crypto/vfio_ap_ops.c     | 80 +++++++++++++++++----------
 drivers/s390/crypto/vfio_ap_private.h |  1 -
 3 files changed, 50 insertions(+), 32 deletions(-)

-- 
2.21.1

