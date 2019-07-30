Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F61E7AE5A
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfG3Qrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 12:47:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44124 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfG3Qrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 12:47:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UGj5Ea037135;
        Tue, 30 Jul 2019 16:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=3Lvf5l3PuwIQZBPFEa0S/5jsyNyEzSw2FH0i8ExleJw=;
 b=14gHRnWEvJT7qDzzi2NJH5QtaVJcu4EVUuov9igUPbthZ3fjoUqvujIuialHwAYvQSwA
 B+yfzD7gTX/dt4Uub1JlQVlfQlQObf5O3rNqIFJSMmkrHfEtTRJqBoSScZlpDnilXG1G
 Q3bKMVb+kI2Ikbunk49lpYHO5try4awHPeaoh5pgzULst4IF4O7fAq2jF2680puPdyZe
 yaBQezQNDG1smHtiWrlShBmnr3yrkhjhrUyg0NVOyee7nR3Ut933fPsMuGU0RwOVn/Qm
 wer+rKsvD8SIv4b2u7Ztksvb/j0PlxI49HAT/Ok39xxBklNLTUUo7JMA4NNRN328XnHn nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u0e1tqxu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 16:47:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UGgf74138056;
        Tue, 30 Jul 2019 16:47:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u2exabmx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 16:47:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6UGlZme029942;
        Tue, 30 Jul 2019 16:47:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 09:47:35 -0700
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v2] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1564472637-8062-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Date:   Tue, 30 Jul 2019 12:47:33 -0400
In-Reply-To: <1564472637-8062-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu's message of "Tue, 30 Jul 2019 03:43:57 -0400")
Message-ID: <yq1mugvmpui.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=623
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=690 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300174
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Suganath,

> Although SAS3 & SAS3.5 IT HBA controllers support 64-bit DMA
> addressing, as per hardware design, if DMA able range contains all
> 64-bits set (0xFFFFFFFF-FFFFFFFF) then it results in a firmware fault.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
