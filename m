Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414CB1EEB3B
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 21:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgFDTfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 15:35:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23274 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbgFDTfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 15:35:54 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054JZcWQ180917;
        Thu, 4 Jun 2020 15:35:46 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31c542sjs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 15:35:46 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054JZcEd181711;
        Thu, 4 Jun 2020 15:35:38 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31c542sjj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 15:35:38 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054JWcf1012568;
        Thu, 4 Jun 2020 19:35:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf482mxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 19:35:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054JZMnY54395258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 19:35:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF48811C052;
        Thu,  4 Jun 2020 19:35:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E915C11C04A;
        Thu,  4 Jun 2020 19:35:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.133.34])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Jun 2020 19:35:20 +0000 (GMT)
Message-ID: <1591299320.5146.53.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in
 ima_eventdigest_init()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, tiwai@suse.de,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 04 Jun 2020 15:35:20 -0400
In-Reply-To: <20200604191207.GR2970@glitch>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
         <20200603150821.8607-2-roberto.sassu@huawei.com>
         <1591221815.5146.31.camel@linux.ibm.com> <20200604191207.GR2970@glitch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_12:2020-06-04,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006040132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-06-04 at 16:12 -0300, Bruno Meneguele wrote:
> On Wed, Jun 03, 2020 at 06:03:35PM -0400, Mimi Zohar wrote:
> > Hi Roberto,
> > 
> > On Wed, 2020-06-03 at 17:08 +0200, Roberto Sassu wrote:
> > > If the template field 'd' is chosen and the digest to be added to the
> > > measurement entry was not calculated with SHA1 or MD5, it is
> > > recalculated with SHA1, by using the passed file descriptor. However, this
> > > cannot be done for boot_aggregate, because there is no file descriptor.
> > > 
> > > This patch adds a call to ima_calc_boot_aggregate() in
> > > ima_eventdigest_init(), so that the digest can be recalculated also for the
> > > boot_aggregate entry.
> > > 
> > > Cc: stable@vger.kernel.org # 3.13.x
> > > Fixes: 3ce1217d6cd5d ("ima: define template fields library and new helpers")
> > > Reported-by: Takashi Iwai <tiwai@suse.de>
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Thanks, Roberto.
> > 
> > I've pushed both patches out to the next-integrity branch and would
> > appreciate some additional testing.
> > 
> > thanks,
> > 
> > Mimi
> > 
> 
> Hi Mimi and Roberto,
> 
> FWIW, I've tested this patch manually and things went fine, with no
> unexpected behavior or results. 

Thanks, Bruno!

> However, wouldn't it be worth add a note in kmsg about the
> ima_calc_boot_aggregate() being called with an algo different from the
> system's default? Just to let the user know he won't find a sha256 when
> check the measurement. But that's something we can add later too.

There's no guarantees that the IMA default crypto algorithm will be
used for calculating the boot_aggregate.  The algorithm is dependent
on the TPM.  For example, the default IMA algorithm could be sha256,
but on a system with TPM 1.2, the boot_aggregate would have to be
sha1.

This patch addresses a mismatch between the template format field ('d'
field) and the larger digest.  We could require the "ima_template_fmt"
specified on the boot command line define an appropriate format, but
Roberto decided to support the situation where both "d" and "d-ng" are
defined.

Mimi
