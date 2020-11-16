Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123752B4FE3
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388628AbgKPSf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:35:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388539AbgKPSf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:35:29 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIUWTM119603;
        Mon, 16 Nov 2020 13:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Dbn/rFOSSjETkmlwnkjOpFVHw+8xDL5UdBr5TOeMcc4=;
 b=YfRKP7FzwQqY3pgnpsooX8T5kWEyUWaUbvgJ7OwP26zAy72VC+HkSnCgJrxkEpleVhDd
 3GFPxwlSVFC6AEnG9YA7Z70ZXOd52kxCNOP4iY0GdaiG64MWVNpkigEHPi4IFlqyA7no
 2ObRaNUhCzsk44lw4of71PI4EpWZXHvjXdAPt7UtyWMHftur0fy0UyPcVNdzPnnugjwp
 Y2B2dIyVOVbd/taWaAzTruLgMQhZp32uDTjmXl9lHq0wEP/1MRhFE1CmkkyG+4CSdhQx
 BsBhbey1dbiCHopa4O0TdVhWRtO7A5SRR+7hpp+hDFZnd0MgrzF9aOHeEP6JPjmSK+D3 dw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34uvbccf5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:35:18 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIQmTi005168;
        Mon, 16 Nov 2020 18:35:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8ac2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:35:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGIZEmr60817766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:35:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C416611C050;
        Mon, 16 Nov 2020 18:35:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D12D11C04A;
        Mon, 16 Nov 2020 18:35:12 +0000 (GMT)
Received: from sig-9-65-243-37.ibm.com (unknown [9.65.243.37])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 18:35:12 +0000 (GMT)
Message-ID: <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date:   Mon, 16 Nov 2020 13:35:11 -0500
In-Reply-To: <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
         <20201114111057.GA16415@infradead.org>
         <0fd0fb3360194d909ba48f13220f9302@huawei.com>
         <20201116162202.GA15010@infradead.org>
         <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
         <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
         <20201116174127.GA4578@infradead.org>
         <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=631 clxscore=1015 priorityscore=1501 suspectscore=3
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-16 at 10:09 -0800, Linus Torvalds wrote:
> On Mon, Nov 16, 2020 at 9:41 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > The "issue" with IMA is that it uses security hooks to hook into the
> > VFS and then wants to read every file that gets opened on a real file
> > system to "measure" the contents vs a hash stashed away somewhere.
> 
> Well, but that's easy enough to handle: if the open isn't a read open,
> then the old contents don't matter, so you shouldn't bother to measure
> the file.
> 
> So this literally sounds like a "doctor, doctor, it hurts when I hit
> my head with a hammer" situation..

We need to differentiate between signed files, which by definition are
immutable, and those that are mutable.  Appending to a mutable file,
for example, would result in the file hash not being updated. 
Subsequent reads would fail.

Mimi

