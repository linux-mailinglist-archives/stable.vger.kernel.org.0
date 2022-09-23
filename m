Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D435E8251
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiIWTEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 15:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIWTEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 15:04:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFAE2DFF;
        Fri, 23 Sep 2022 12:04:33 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NH6DdC025652;
        Fri, 23 Sep 2022 19:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=MuBSUJNz2EZLJFjx/Wk5ELtrb2nH5vloc/QhcYKQVkM=;
 b=FR/IRFY+xcS5+T96EwH2BEsei7I8INijO+y1CvmB0XLIxHsR+E/m3MRItHxgavaGJwcA
 KsyUmZFYDmvNH1P73Uj/EZEUYCMWsxAPZTpWNV+OGzjfa0xnaUBhmJrhAfoMzrE6Ey8N
 wxbf8fka4FoKcEJ9JcI4pQ5+ynBLMJs81tMVS+usEOsrKX5ZybA9ae0myEN7KxcCPtW7
 LtQRsfCCvfwaMgMtpR/nllUJxa8hKrM8msTJKGgBGo9NkEyi7hOoKneuqLC4fjGfbNHy
 OLg48NU4twXsjqFqCkqDOOMvZ7r/bn3RK7zpG4w0PSmEsU+ZIsoxVXv1L8IMsrf42V4L Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsam5pwyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:03:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NInoc6008637;
        Fri, 23 Sep 2022 19:03:42 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsam5pwwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:03:42 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NIo3SS026482;
        Fri, 23 Sep 2022 19:03:41 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3jn5va1m27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:03:41 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NJ3fLn7799506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 19:03:41 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F0E658059;
        Fri, 23 Sep 2022 19:03:39 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAF6E58043;
        Fri, 23 Sep 2022 19:03:36 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.173.46])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 19:03:36 +0000 (GMT)
Message-ID: <67337b60a4d3cae00794d3cfd0e5add9899f18b7.camel@linux.ibm.com>
Subject: Re: [PATCH 5.15 0/6] arm64: kexec_file: use more system keyrings to
 verify kernel image signature + dependencies
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Michal Suchanek <msuchanek@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Philipp Rudo <prudo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:KEXEC" <kexec@lists.infradead.org>,
        Coiby Xu <coxu@redhat.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Date:   Fri, 23 Sep 2022 15:03:36 -0400
In-Reply-To: <cover.1663951201.git.msuchanek@suse.de>
References: <cover.1663951201.git.msuchanek@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SsokmeIEOQvFjsuuW5hlsedfFQGtkcPI
X-Proofpoint-ORIG-GUID: xC2eJ1JrrMo3jvaPpOW6BQ5aqRsb_2NA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209230120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-09-23 at 19:10 +0200, Michal Suchanek wrote:
> Hello,
> 
> this is backport of commit 0d519cadf751
> ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> to table 5.15 tree including the preparatory patches.
> 
> Some patches needed minor adjustment for context.

In general when backporting this patch set, there should be a
dependency on backporting these commits as well.  In this instance for
linux-5.15.y, they've already been backported.

543ce63b664e ("lockdown: Fix kexec lockdown bypass with ima policy")
af16df54b89d ("ima: force signature verification when CONFIG_KEXEC_SIG is configured")

-- 
thanks,

Mimi

