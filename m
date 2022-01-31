Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E0C4A4F4F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 20:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiAaTU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 14:20:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235454AbiAaTU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 14:20:26 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VHcgTC016494;
        Mon, 31 Jan 2022 19:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=aDTwYpmcoZyK+955pUPN/Okv23O0tyd1fhGzfHXBoHw=;
 b=ULr8gzad6YLNEVXV69QxgoHQNB1lapemssaqADHK52oVygqkLEFfIwamFYZF4WSxlcjw
 pFg2pf6DY6DYnepECEazRKm50afEzdlYmtbUJrsONHM6yxuoI2HIJQgQ1wWrunNsoKYz
 qRZJaV22AqsE+6C0O34D0UGA28FaBg5/Uav17QGRtgN/A678+ViBCuDUITFDPAfYp6GG
 it/buhoJPymOA81ozwJM8yNkfpwOj8k5YxpDnyz4+1dWRmtePc2TMM/pRgDNN0jgdvUC
 HCBJUbDZmgcte3JQnrdpP7/l856leKiQCYRjh4GKNpvVWrUR2x0D0zduLBME+LueAVnv EQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dx98uh5qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:20:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VJ8PH3010151;
        Mon, 31 Jan 2022 19:20:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79eg5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:20:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VJATKU49217880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 19:10:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2429D11C05B;
        Mon, 31 Jan 2022 19:20:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C91A11C058;
        Mon, 31 Jan 2022 19:20:15 +0000 (GMT)
Received: from sig-9-65-69-222.ibm.com (unknown [9.65.69.222])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 19:20:15 +0000 (GMT)
Message-ID: <09c63b7bfb7e58702f7dcfc71a2e79b866ad9e7d.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Allow template selection with ima_template[_fmt]=
 after ima_hash=
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, guozihua@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 31 Jan 2022 14:20:14 -0500
In-Reply-To: <20220131171139.3024883-1-roberto.sassu@huawei.com>
References: <20220131171139.3024883-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CHQAydc0mmQnMNRBhdQQRiFTKY874JrU
X-Proofpoint-GUID: CHQAydc0mmQnMNRBhdQQRiFTKY874JrU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-01-31 at 18:11 +0100, Roberto Sassu wrote:
> Commit c2426d2ad5027 ("ima: added support for new kernel cmdline parameter
> ima_template_fmt") introduced an additional check on the ima_template
> variable to avoid multiple template selection.
> 
> Unfortunately, ima_template could be also set by the setup function of the
> ima_hash= parameter, when it calls ima_template_desc_current(). This causes
> attempts to choose a new template with ima_template= or with
> ima_template_fmt=, after ima_hash=, to be ignored.
> 
> Achieve the goal of the commit mentioned with the new static variable
> template_setup_done, so that template selection requests after ima_hash=
> are not ignored.
> 
> Finally, call ima_init_template_list(), if not already done, to initialize
> the list of templates before lookup_template_desc() is called.
> 
> Cc: stable@vger.kernel.org
> Fixes: c2426d2ad5027 ("ima: added support for new kernel cmdline parameter ima_template_fmt")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks, Roberto.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

Mimi

