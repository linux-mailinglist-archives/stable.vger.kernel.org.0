Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EA72B1F3C
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgKMPxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:53:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgKMPxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 10:53:39 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADFgQOv001669;
        Fri, 13 Nov 2020 10:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=3kL6l2FHVjUYAjyXMCRCHnUHf/ZCbsy2OYnrcqRqQXc=;
 b=PMqvv56aKMWatQCnSnmA09JPKVpDu+3Hf2eTSw3ph0mjwhKI3AXngFs0sZTnMZTQmLMY
 RZm2Z0PmI6hFIFAha3EJh1yR3icOFSSUBM+pdTS1lGXSss3j9IwjYZ04CCyUWeUavpxD
 sBO44i7uLwW8+6Q55Ovxs9Upn9qNr6di4XAo+cfgRjS4XCqCGmR9lPzt/3XtmHPi4p0s
 rS5LQNU3csJSPu6YFrbj8HdTl711fzYZYsz2DZ6R1eVlQRyiuDMeigzB5O1JvW6tfkBj
 IInKlVbdtuV98VN9on2G4NARGK5FvcuFojwlVTWWv9b1RPxn2o4a7Y020OeKGnDO+kSd CA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34sw138axm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 10:53:26 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADFqZxt026344;
        Fri, 13 Nov 2020 15:53:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh6ut2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 15:53:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADFrM9W59900268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 15:53:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A3911C04A;
        Fri, 13 Nov 2020 15:53:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91C6E11C052;
        Fri, 13 Nov 2020 15:53:20 +0000 (GMT)
Received: from sig-9-65-233-212.ibm.com (unknown [9.65.233.212])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 15:53:20 +0000 (GMT)
Message-ID: <04d8b0b3876eba71d58295d24e403505d6d77b55.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Fri, 13 Nov 2020 10:53:19 -0500
In-Reply-To: <20201113080132.16591-1-roberto.sassu@huawei.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 bulkscore=0
 mlxlogscore=627 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 clxscore=1011 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Fri, 2020-11-13 at 09:01 +0100, Roberto Sassu wrote:
> Commit a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> replaced the __vfs_read() call in integrity_kernel_read() with
> __kernel_read(), a new helper introduced by commit 61a707c543e2a ("fs: add
> a __kernel_read helper").
> 
> Since the new helper requires that also the FMODE_CAN_READ flag is set in
> file->f_mode, this patch saves the original f_mode and sets the flag if the
> the file descriptor has the necessary file operation. Lastly, it restores
> the original f_mode at the end of ima_calc_file_hash().
> 
> Cc: stable@vger.kernel.org # 5.8.x
> Fixes: a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks!  It's now queued in next-integrity-testing.

Mimi

