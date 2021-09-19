Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1778410C83
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhISRGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 13:06:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhISRGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 13:06:16 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18JFaoSY031571;
        Sun, 19 Sep 2021 13:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Pq1JFnHUyg3KhLSsrvWh9qTLBifrzPfFDh0UNrgB0CQ=;
 b=n6YKp/xQn65U2fmRax/kUGJjkEvSqIFrFn0/3zfYoeeMhNwyBF7H5G7ruC2BcROLpz3O
 X6WMm6R8wJy2/TIIgMnEr3hPklTfRv8wwpeAMCu8hMtT4104FOFci3og3+oCJOAk2qPv
 qZJpGuC/6H/GTZuzz7iadIj1NSeApUCgISoS36iGVtXY1WYED9MlVj3pAYYHSrhfNWwc
 zK80DsWq1XqcbRmy8eSzj1ImiQgyuc1GQxrlQKEygIkuxwoSMhkrmx87pNlRg50MnZps
 U/6Qs3zYI05kEz31r65P7QU2rbVuoTjW/0cCPUFTXNm1Ck6hI0TTZlVMHchzrLTp/SeU bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5wa0rn1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Sep 2021 13:04:39 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18JH0OgJ007453;
        Sun, 19 Sep 2021 13:04:39 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5wa0rn0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Sep 2021 13:04:39 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18JH3VW6017742;
        Sun, 19 Sep 2021 17:04:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b57r8r27h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Sep 2021 17:04:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18JH4UsE15401428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Sep 2021 17:04:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9882D11C058;
        Sun, 19 Sep 2021 17:04:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA1FD11C050;
        Sun, 19 Sep 2021 17:04:29 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.169.193])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 19 Sep 2021 17:04:29 +0000 (GMT)
Date:   Sun, 19 Sep 2021 20:04:27 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mike Galbraith <efault@gmx.de>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUdtm8hVH0ps18BK@linux.ibm.com>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lHFHZ1Rq3S5A4eMAzkNhiTPagTrRNdUA
X-Proofpoint-GUID: iyVWhj5nX7KEK9o9d1ACU6sWoDdtTKfd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-19_05,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=786 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109190126
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 19, 2021 at 06:55:16PM +0200, Mike Galbraith wrote:
> On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
> > The following commit has been merged into the x86/urgent branch of
> > tip:
> >
> > Commit-ID:     1c1046581f1a3809e075669a3df0191869d96dd1
> > Gitweb:       
> > https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d96dd1
> > Author:        Juergen Gross <jgross@suse.com>
> > AuthorDate:    Tue, 14 Sep 2021 11:41:08 +02:00
> > Committer:     Borislav Petkov <bp@suse.de>
> > CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00
> >
> > x86/setup: Call early_reserve_memory() earlier
> 
> This commit rendered tip toxic to my i4790 desktop box and i5-6200U
> lappy.  Boot for both is instantly over without so much as a twitch.
> 
> Post bisect revert made both all better.

Can you please send the boot log of a working kernel up to 

"Memory: %luK/%luK available"

line for both of them?
 
> 
> 	-Mike

-- 
Sincerely yours,
Mike.
