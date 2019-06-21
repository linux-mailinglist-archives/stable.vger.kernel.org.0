Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB454E8A4
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 15:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFUNLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 09:11:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbfFUNLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 09:11:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LD8CFn135954
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 09:11:42 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8y881swk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 09:11:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Fri, 21 Jun 2019 14:11:40 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 21 Jun 2019 14:11:37 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LDBbOO60489948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 13:11:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EED8642045;
        Fri, 21 Jun 2019 13:11:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5E6142042;
        Fri, 21 Jun 2019 13:11:36 +0000 (GMT)
Received: from osiris (unknown [9.152.212.21])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 21 Jun 2019 13:11:36 +0000 (GMT)
Date:   Fri, 21 Jun 2019 15:11:35 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        stable <stable@vger.kernel.org>,
        Major Hayden <mhayden@redhat.com>
Subject: Re: Request for 4.19.x backport (with conflicts)
References: <0fc1a3e6-59ef-6390-38c4-55e7c48bee78@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc1a3e6-59ef-6390-38c4-55e7c48bee78@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19062113-0008-0000-0000-000002F5D798
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062113-0009-0000-0000-00002262FC3D
Message-Id: <20190621131135.GB11296@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210109
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Laura,

> We're attempting to build stable kernels with gcc9. 4.19.x fails to build with
> gcc9 as 146448524bdd ("s390/jump_label: Use "jdd" constraint on gcc9") is missing.
> This doesn't apply cleanly to 4.19.x as it needs changes from 13ddb52c165b
> ("s390/jump_label: Switch to relative references")
> 
> Which is better, taking both 13ddb52c165b and 146448524bdd or doing
> a backport of 146448524bdd?

I don't know which kernel version you are referring to exactly,
however 4.19.53 from linux-stable does not contain the common code
infrastructure for relative jump labels. The infrastructure was merged
with 4.20: commit 50ff18ab497aa ("jump_label: Implement generic
support for relative references").

Therefore a backport of only 146448524bdd seems to be the way to go.

