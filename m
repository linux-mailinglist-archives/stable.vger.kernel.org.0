Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3B2D81EB
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389957AbgLKWXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:23:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388813AbgLKWXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:23:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBM2m2n169769;
        Fri, 11 Dec 2020 17:22:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JlFw1VlwtLPl5QDtvhRbMMw2kQ1tZB6tPq+V7/YfDLA=;
 b=lN/zWAQCpQes1e5LwrYIcIjvv94H7Nxx3ELMXMOaphMULaWCLn0KMTHPJ46RUWs3YbDS
 rXs6Sr0cxoI510C/RwIvgux5emxBdrvMIzH8rtQ+GP2YKtyW7EMNwXJRpAIA8ee6s7Nq
 S385TPpgbhGN2wbZjRvFXC61oiOMI91WS2APOB5jkVpQWNEWq7p5P0o8zMHVqmtg3B+W
 X1AoUwoXWVozIBd2ZxoERSai9TilQmM7vI34ojzMFiY3tef1u/ezDkGJDCLsyQUaD9dW
 1DCQHBtVzqZAekOcFk1oWgX2RZiE9V+deXkHHfiLNlLeUeIt3SRDfw6/owJlZprHQL1J IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ch7fgdb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:24 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBM4GJ4173569;
        Fri, 11 Dec 2020 17:22:24 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ch7fgdau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 17:22:24 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BBMCjsE002174;
        Fri, 11 Dec 2020 22:22:23 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3581ua7jbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 22:22:23 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBMMMlj23724332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 22:22:22 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 160B2C6059;
        Fri, 11 Dec 2020 22:22:22 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E5A7C6055;
        Fri, 11 Dec 2020 22:22:20 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 22:22:20 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 1/2] s390/vfio-ap: No need to disable IRQ after queue reset
Date:   Fri, 11 Dec 2020 17:22:10 -0500
Message-Id: <20201211222211.20869-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201211222211.20869-1-akrowiak@linux.ibm.com>
References: <20201211222211.20869-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_06:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=11 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012110142
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The queues assigned to a matrix mediated device are currently reset when:

* The VFIO_DEVICE_RESET ioctl is invoked
* The mdev fd is closed by userspace (QEMU)
* The mdev is removed from sysfs.

Immediately after the reset of a queue, a call is made to disable
interrupts for the queue. This is entirely unnecessary because the reset of
a queue disables interrupts, so this will be removed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 -
 drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
 drivers/s390/crypto/vfio_ap_private.h |  1 -
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..ca18c91afec9 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..c854d7ab2079 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -25,6 +25,7 @@
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -49,20 +50,15 @@ static struct vfio_ap_queue *vfio_ap_get_queue(
 					int apqn)
 {
 	struct vfio_ap_queue *q;
-	struct device *dev;
 
 	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
 		return NULL;
 	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
 		return NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (!dev)
-		return NULL;
-	q = dev_get_drvdata(dev);
-	q->matrix_mdev = matrix_mdev;
-	put_device(dev);
+	q = vfio_ap_find_queue(apqn);
+	if (q)
+		q->matrix_mdev = matrix_mdev;
 
 	return q;
 }
@@ -1114,24 +1110,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static void vfio_ap_irq_disable_apqn(int apqn)
+static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 {
 	struct device *dev;
-	struct vfio_ap_queue *q;
+	struct vfio_ap_queue *q = NULL;
 
 	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
 				 &apqn, match_apqn);
 	if (dev) {
 		q = dev_get_drvdata(dev);
-		vfio_ap_irq_disable(q);
 		put_device(dev);
 	}
+
+	return q;
 }
 
 int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
 			     unsigned int retry)
 {
 	struct ap_queue_status status;
+	struct vfio_ap_queue *q;
+	int ret;
 	int retry2 = 2;
 	int apqn = AP_MKQID(apid, apqi);
 
@@ -1144,18 +1143,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
 				status = ap_tapq(apqn, NULL);
 			}
 			WARN_ON_ONCE(retry2 <= 0);
-			return 0;
+			ret = 0;
+			goto free_aqic_resources;
 		case AP_RESPONSE_RESET_IN_PROGRESS:
 		case AP_RESPONSE_BUSY:
 			msleep(20);
 			break;
 		default:
 			/* things are really broken, give up */
-			return -EIO;
+			ret = -EIO;
+			goto free_aqic_resources;
 		}
 	} while (retry--);
 
 	return -EBUSY;
+
+free_aqic_resources:
+	/*
+	 * In order to free the aqic resources, the queue must be linked to
+	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
+	 * must be available.
+	 */
+	q = vfio_ap_find_queue(apqn);
+	if (q && q->matrix_mdev && q->matrix_mdev->kvm)
+		vfio_ap_free_aqic_resources(q);
+
+	return ret;
 }
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
@@ -1177,7 +1190,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			 */
 			if (ret)
 				rc = ret;
-			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
 	}
 
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..0db6fb3d56d5 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -100,5 +100,4 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

