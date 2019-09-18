Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB6B5FF9
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 11:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfIRJSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 05:18:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59448 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfIRJSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 05:18:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8I98s17178458;
        Wed, 18 Sep 2019 09:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : content-type :
 content-transfer-encoding : mime-version : date : subject : cc : to :
 message-id; s=corp-2019-08-05;
 bh=gA/odFn87PvHOX3/sRNMnXipUhOglLsNrS+FR8K/TSg=;
 b=q0Ky/DDUCQYW4sVrsHOBH9Zv2pinj+y6aSvXJG81Ek4BgP87O1/fvm4B3xfMtAUcoLCF
 /AbeFbLC7MqxsM4qbWpE0C+lVFS/QcYHDehe0g+T9QeeZ1U//F00z1/GCxKtn6hSmHrU
 ADjQdafWE3988bUx9V1Qk/Del1LEd7TnpmYEcotJ8UTMxqPpIy1rW1eCKPJnOM7+7lsC
 V9co8IdESWV1RZziJ5giCngIvfY6YjCrkPS4Ay6jf19uwlo0vGdAXXxAEyyqqzQjWA5I
 I96hecXAWYphSQeWfH+4ZQwrqqJNaA8wB33ttn/5TdWVBixL6AYSqFK4O+Z/opU6Q3DX 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v385e2gss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 09:18:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8I98o2W173997;
        Wed, 18 Sep 2019 09:18:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v37m9xgpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 09:18:07 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8I9I4EM022343;
        Wed, 18 Sep 2019 09:18:06 GMT
Received: from dhcp-10-172-157-168.no.oracle.com (/10.172.157.168)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 02:18:04 -0700
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Date:   Wed, 18 Sep 2019 11:17:59 +0200
Subject: Stable branches missing ed7a01fd3fd7
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <880A1006-BF84-4691-8EE1-8E6D111BF09F@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=564
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=643 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180094
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,


Commit 00313983cda6 ("RDMA/nldev: provide detailed CM_ID information") =
is in the following stable releases:

  stable/linux-4.17.y
  stable/linux-4.18.y
  stable/linux-4.19.y
  stable/linux-4.20.y
  stable/linux-5.0.y
  stable/linux-5.1.y
  stable/linux-5.2.y
  stable/linux-5.3.y
  stable/master

It has a potential for a big leak of task_struct's, and if the case is =
hit, the number of task_struct entries in /proc/slabinfo increases =
rapidly.

The fix, ed7a01fd3fd7 ("RDMA/restrack: Release task struct which was =
hold by CM_ID object"), is in the following stable releases:

  stable/linux-4.20.y
  stable/linux-5.0.y
  stable/linux-5.1.y
  stable/linux-5.2.y
  stable/linux-5.3.y
  stable/master

Hence, this commit needs to be included in 4-17..4.19.


Thxs, H=C3=A5kon


