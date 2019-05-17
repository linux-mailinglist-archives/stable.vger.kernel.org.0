Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3EF21149
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfEQAal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:30:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbfEQAal (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 20:30:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H0RI8w020735
        for <stable@vger.kernel.org>; Thu, 16 May 2019 20:30:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2shhkhhd3a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 16 May 2019 20:30:39 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Fri, 17 May 2019 01:30:37 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 01:30:33 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4H0UWJM43974822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 00:30:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB9AEA4062;
        Fri, 17 May 2019 00:30:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADCA5A4065;
        Fri, 17 May 2019 00:30:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 May 2019 00:30:31 +0000 (GMT)
Subject: Re: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Sasha Levin <sashal@kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com
Cc:     linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 16 May 2019 20:30:20 -0400
In-Reply-To: <20190517001001.9BEF620848@mail.kernel.org>
References: <20190516161257.6640-3-roberto.sassu@huawei.com>
         <20190517001001.9BEF620848@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051700-0008-0000-0000-000002E786DE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051700-0009-0000-0000-000022542EB9
Message-Id: <1558053020.4507.32.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_19:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=875 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170002
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-05-17 at 00:10 +0000, Sasha Levin wrote:
> 
> How should we proceed with this patch?

Yikes!  This was posted earlier today.  I haven't even had a chance to
look at it yet.  Similarly for "[PATCH 4/4] ima: only audit failed
appraisal verifications".

Mimi

