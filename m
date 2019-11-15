Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0BFD479
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 06:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfKOFho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 00:37:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfKOFho (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 00:37:44 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF5XqY4053607
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 00:37:43 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9nsdru88-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 00:37:43 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Fri, 15 Nov 2019 05:37:41 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 05:37:38 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF5bbib53281012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 05:37:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DD73A405B;
        Fri, 15 Nov 2019 05:37:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E133CA4062;
        Fri, 15 Nov 2019 05:37:36 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 05:37:36 +0000 (GMT)
Received: from [9.102.34.42] (unknown [9.102.34.42])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 3C680A00EC;
        Fri, 15 Nov 2019 16:37:34 +1100 (AEDT)
To:     stable@vger.kernel.org
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Subject: [4.14] Backport request: powerpc/perf: Fix IMC_MAX_PMU macro
Date:   Fri, 15 Nov 2019 16:37:34 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111505-0016-0000-0000-000002C3CCC6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111505-0017-0000-0000-0000332571CD
Message-Id: <607891ba-9a95-fe0c-6185-2cb2406870f3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 mlxlogscore=932
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150049
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable team

Please backport the following patch.

Commit: 7029d1eb0c2c7ee093dc625c679fc277c8eb623b
	("powerpc/perf: Fix IMC_MAX_PMU macro")

Stable tree targeted: 4.14 (applies cleanly)

Justification: This fixes some Oopses observed on boot on one of our 
POWER9 boxes. Fix was identified by bisection, the other patch in the 
2-patch series has already been applied to 4.14 but this one wasn't for 
some reason.

Thanks,
-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

