Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFE55CCA1
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiF1I33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 04:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245275AbiF1I31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 04:29:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF1120F4F;
        Tue, 28 Jun 2022 01:29:25 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S8Mxn2000892;
        Tue, 28 Jun 2022 08:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=H66WiVgYJSfTkHDmL3/sFeorS3m4uX8oKcUy2teFCuk=;
 b=Q+as9L48PKczmUJiCKfE5nUu+K/6m8AyyRyh4e98mfFRenjNk7AuxttuqKR+W/oZMWM8
 JtOf+MSk+T+bvZyneLbBImvrAoVDeumF3+7eRDJL8RT/D98H7TlKddlCaMyEfsIQ/Bdy
 hQUOePbg3FrCPyXnqIq+YggMlvWJJvwBKfkwSN65Uu+w7K+UUymKDPgPzml09G+SFIUj
 L7aeHPCJ4o5XcyAgH0XLoAOdT150UcScc/4y8Gfm8WPoIRGzlv9PJigyJLNPj0We6x+4
 aAbWcdwZfYYTG/qwA1TxrTgs51Px5pN7940NIjUcBQpQC5vv3qArHnWwc9yWOdLDIqzF gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyx37g3bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 08:29:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25S8QELD021800;
        Tue, 28 Jun 2022 08:29:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyx37g3an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 08:29:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25S8LikJ006126;
        Tue, 28 Jun 2022 08:29:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt093bbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 08:29:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25S8T6kL21430654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 08:29:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D44E4C044;
        Tue, 28 Jun 2022 08:29:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C55B24C052;
        Tue, 28 Jun 2022 08:29:05 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.7.238])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Jun 2022 08:29:05 +0000 (GMT)
Date:   Tue, 28 Jun 2022 10:29:04 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Baoquan He <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 5.18 112/181] vmcore: convert copy_oldmem_page() to take
 an iov_iter
Message-ID: <Yrq70Ctw3UYPFnzC@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.945731832@linuxfoundation.org>
 <YrnaYJA675eGIy03@osiris>
 <YrqpEZV3yu31t6E2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrqpEZV3yu31t6E2@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X9f3dPd963n_9EjhM7D0NyKbsc1XVVis
X-Proofpoint-ORIG-GUID: wbQFeLqpb4lU4rwBL1-sV31_x19UzbDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_09,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1011 adultscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=740 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 09:09:05AM +0200, Greg Kroah-Hartman wrote:
> > This one breaks s390. You would also need to apply the following two commits:
> > 
> > cc02e6e21aa5 ("s390/crash: add missing iterator advance in copy_oldmem_page()")
> > af2debd58bd7 ("s390/crash: make copy_oldmem_page() return number of bytes copied")
> 
> Both of them are also in the 5.18-rc queue here, right?

Yes, these are:

	[PATCH 5.18 113/181] s390/crash: add missing iterator advance in copy_oldmem_page() Greg Kroah-Hartman
	[PATCH 5.18 114/181] s390/crash: make copy_oldmem_page() return number of bytes copied Greg Kroah-Hartman

> thanks,
> 
> greg k-h
