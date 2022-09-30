Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B815F1191
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 20:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiI3SZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 14:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiI3SZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 14:25:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960F34F1AD;
        Fri, 30 Sep 2022 11:25:27 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UH9lap002536;
        Fri, 30 Sep 2022 18:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bknH+dbcboDXEWTRzFi/K8Jjc4/8maT6NVgSJREjqvY=;
 b=fw10nc8p6Rx4Qh29g3SuoH7w0qTrs3dgZHPRkhvccqSIYlZVQfvsMniniwdAprYwb+sb
 YqhoZLJNgUYmQGVHabIUSnfvDhQ+9XxxFA6Fwuf8xTK756naywDPYnQ8OCLysi+nF3w2
 gVWoXHbnR91sH9YJM6WrTZJX13HaWgXNzBtlyOQ5UaGwntWXbF1vQk0NIbS14FxAIl1P
 EdPXsldiBZEPmMVUwrZ7gRZT2ZYtDUkZgL4ML14ehY0YHhUtG8E7SeERJkagqyj+Xu6e
 OsZkxxGIcHKk3vCc4qvVDD+78qfhDtrKSRhphTJXwmy86JGkkagt58A9dUJ6LmeHw1/F sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx4cca6wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 18:25:14 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28UHoeXD023220;
        Fri, 30 Sep 2022 18:25:14 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx4cca6wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 18:25:14 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28UIL0j9013539;
        Fri, 30 Sep 2022 18:25:13 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3jssha23mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 18:25:13 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28UIPDRG46006616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 18:25:13 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169F958058;
        Fri, 30 Sep 2022 18:25:12 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55CE25805D;
        Fri, 30 Sep 2022 18:25:11 +0000 (GMT)
Received: from sig-9-65-252-31.ibm.com (unknown [9.65.252.31])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Sep 2022 18:25:11 +0000 (GMT)
Message-ID: <fbce35c31f543527d171dd9988b29248d740fb17.camel@linux.ibm.com>
Subject: Re: [PATCHv2 RESEND] efi: Correct Macmini DMI match in uefi cert
 quirk
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Orlando Chamberlain <redecorating@protonmail.com>,
        linux-kernel@vger.kernel.org
Cc:     jarkko@kernel.org, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com, gargaditya08@live.com,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Samuel Jiang <chyishian.jiang@gmail.com>
Date:   Fri, 30 Sep 2022 14:24:32 -0400
In-Reply-To: <20220929114906.85021-1-redecorating@protonmail.com>
References: <20220929114906.85021-1-redecorating@protonmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 18Q1LshBfFbh_D6A_7OEMP3ptjxfwuII
X-Proofpoint-GUID: C6t5GrmqtwZ5DyzMtwDQEyoEciFaE2g3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 impostorscore=0 mlxlogscore=718 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209300113
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Orlando,

On Thu, 2022-09-29 at 11:49 +0000, Orlando Chamberlain wrote:
> It turns out Apple doesn't capitalise the "mini" in "Macmini" in DMI, which
> is inconsistent with other model line names.
> 
> Correct the capitalisation of Macmini in the quirk for skipping loading
> platform certs on T2 Macs.
> 
> Currently users get:
> 
> ------------[ cut here ]------------
> [Firmware Bug]: Page fault caused by firmware at PA: 0xffffa30640054000
> WARNING: CPU: 1 PID: 8 at arch/x86/platform/efi/quirks.c:735 efi_crash_gracefully_on_page_fault+0x55/0xe0
> Modules linked in:
> CPU: 1 PID: 8 Comm: kworker/u12:0 Not tainted 5.18.14-arch1-2-t2 #1 4535eb3fc40fd08edab32a509fbf4c9bc52d111e
> Hardware name: Apple Inc. Macmini8,1/Mac-7BA5B2DFE22DDD8C, BIOS 1731.120.10.0.0 (iBridge: 19.16.15071.0.0,0) 04/24/2022
> Workqueue: efi_rts_wq efi_call_rts
> ...
> ---[ end trace 0000000000000000 ]---
> efi: Froze efi_rts_wq and disabled EFI Runtime Services
> integrity: Couldn't get size: 0x8000000000000015
> integrity: MODSIGN: Couldn't get UEFI db list
> efi: EFI Runtime Services are disabled!
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get UEFI dbx list
> 
> Fixes: 155ca952c7ca ("efi: Do not import certificates from UEFI Secure Boot for T2 Macs")
> Cc: stable@vger.kernel.org
> Cc: Aditya Garg <gargaditya08@live.com>
> Tested-by: Samuel Jiang <chyishian.jiang@gmail.com>
> Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>

Thanks!  The patch is now queued in the next-integrity branch.

Mimi



