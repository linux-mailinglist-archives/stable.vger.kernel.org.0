Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18B92B724B
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 00:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgKQXYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 18:24:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10272 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgKQXX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 18:23:59 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHN79Cv010767;
        Tue, 17 Nov 2020 18:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=QnPu4M8D5+1fcks5LVus2SVKUlv/MYaX277pWEPDS/c=;
 b=U6V6H2PwYDjRSO7UdIRQnF1bWmOV18qCPipv2I26DmyqF7vUVP1B6cWx2eWE0YJszsOP
 LWmOJkO3TWPTZTom7yOV+4l2ooJPAOylT0Aigx3Y2mx/yZt6r1EJkOQxiDq4AQTLjLpF
 Y9rrCs+IMaj3TDXE83aGaM5GGlw1hobLDeXPHN3P4cCrqrC5+iseHsu+otmt2DQCARQL
 J9cyNLMs/M+osx8CcbnvL+uJaAfrJvpJ3FLGuTu9CgoZ66PoIG79P/rTbRj9T7JrSZlP
 ZTiKkVCOgy837pYu/ApWwt0ItSiAQ7TL1ppzXH1KRmvyeBNXTN4zHSIp7gHs601Vl7Tz GA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34veevjy77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 18:23:48 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHNNUIO016714;
        Tue, 17 Nov 2020 23:23:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8bj7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 23:23:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHNNi1C63766994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 23:23:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43D3B11C04A;
        Tue, 17 Nov 2020 23:23:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 186C311C052;
        Tue, 17 Nov 2020 23:23:42 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.75.12])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 23:23:41 +0000 (GMT)
Message-ID: <5d8fa26d376999f703aac9103166a572fc0df437.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Tue, 17 Nov 2020 18:23:41 -0500
In-Reply-To: <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
         <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
         <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
         <20201116174127.GA4578@infradead.org>
         <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
         <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
         <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_12:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=737 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170167
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-11-17 at 10:23 -0800, Linus Torvalds wrote:
> On Mon, Nov 16, 2020 at 10:35 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > We need to differentiate between signed files, which by definition are
> > immutable, and those that are mutable.  Appending to a mutable file,
> > for example, would result in the file hash not being updated.
> > Subsequent reads would fail.
> 
> Why would that require any reading of the file at all AT WRITE TIME?

On the (last) file close, the file hash is re-calculated and written
out as security.ima.  The EVM hmac is re-calculated and written out as
security.evm.

> 
> Don't do it. Really.

I really wish it wasn't needed.

> 
> When opening the file write-only, you just invalidate the hash. It
> doesn't matter anyway - you're only writing.
> 
> Later on, when reading, only at that point does the hash matter, and
> then you can do the verification.
> 
> Although honestly, I don't even see the point. You know the hash won't
> match, if you wrote to the file.

On the local system, as Roberto mentioned, before updating a file, the
existing file's data and metadata (EVM) should be verified to protect
from an offline attack.

The above scenario assumes calculating the file hash is only being used
for verifying the integrity of the file (security.ima), but there are
other reasons for calculating the file hash.  For example depending on
the IMA measurement policy, just accessing a file could require
including the file hash in the measurement list.  True that measurement
will only be valid at the time of measurement, but it provides a base
value.

Mimi

