Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0767846B19C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 04:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhLGDtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 22:49:35 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48662 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhLGDte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 22:49:34 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5SKJ016355;
        Tue, 7 Dec 2021 03:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=/V6ds9RTQSQcSiPpLpqUpHfXCm6gnwACCBLM4JiRY84=;
 b=xiO2xX626o5184vWxuW5E4KBDt5DyMGGz6uhfUk+JbWXkkZ+HYLk7f6UxKwZR5uEZV4k
 Ga7KS7sZvQruCD8BsL04R/0wCKhx9VcCjDjSGgiMoTMSw7Vz9Hzh4zRQRlD0QJCnb4aV
 mjMOaXFCyhyAcL7W4xyYETBIjazVR+l57+CaiJzeCpTjtVhQteP4YA8rHZy7Z41tpo4g
 Og4G0LRNiNDMJm4eLbL/ddQeFVJaegWSLD090hoSqCEiCWEvmwdslfTr7ruksA/ZXI/H
 knpPdbuh7utVW7wDzuBb4dLTdNlLMIwweuUVbtvzN94DNVPuVVna07T1+xI1AyqJx9Rz qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwm5s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73fCcr174255;
        Tue, 7 Dec 2021 03:46:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cqwex0gk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:01 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B73jxGB183597;
        Tue, 7 Dec 2021 03:46:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cqwex0ghy-2;
        Tue, 07 Dec 2021 03:46:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH] scsi: qla2xxx: Format log strings only if needed
Date:   Mon,  6 Dec 2021 22:45:57 -0500
Message-Id: <163884867622.17909.10048645834482460757.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112145446.51210-1-r.bolshakov@yadro.com>
References: <20211112145446.51210-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: zHjLczqO8QsFlvLZHhkueET2jAXUTqg8
X-Proofpoint-GUID: zHjLczqO8QsFlvLZHhkueET2jAXUTqg8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Nov 2021 17:54:46 +0300, Roman Bolshakov wrote:

> Commit 598a90f2002c4 ("scsi: qla2xxx: add ring buffer for tracing debug
> logs") introduced unconditional log string formatting to ql_dbg() even
> if ql_dbg_log event is disabled. It harms performance because some
> strings are formatted in fastpath and/or interrupt context.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Format log strings only if needed
      https://git.kernel.org/mkp/scsi/c/69002c8ce914

-- 
Martin K. Petersen	Oracle Linux Engineering
