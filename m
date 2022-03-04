Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1076A4CD920
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 17:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiCDQaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 11:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiCDQaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 11:30:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA5A148937;
        Fri,  4 Mar 2022 08:29:33 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224FJOLu010359;
        Fri, 4 Mar 2022 16:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IL+VWTIPQ3j6xGTOOsrsIIrVRc8PdvkQHCT9sWI1nk4=;
 b=C8gzfYV8fZEwexUhUq/lYkk/koIpnQPZWAELeS9bp75MBQuginOdpP2XRxJFP0FDGJxL
 2ywHZWNUSesKz6fd+dorgYmcEyx4LYAPu5DQYF/h5Bnixm4JkJgx0idNj4+pLYCps/7D
 rmNOkimVC21PkFMP7lB0xk7I0u7jDNJDbzBidU++8bv+ZoZAGcspOzWU4Z/BjuJSHsVr
 AlhFyKWSrLxviTjHK6dew3pKx3Vpfez3Z0D73YZNqZVhIEeE/SCVViHx/7IqGxqEgiCU
 snhBebj8a/hmAOiUaIhyhGQMd1KDgkyJ6M0YM5/KTCA+mlhgCvdC49xu+Wje2Q3W/PWF kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eknae1d5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 16:29:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224FZ2Z8002766;
        Fri, 4 Mar 2022 16:29:18 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eknae1d58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 16:29:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224GHCeu013271;
        Fri, 4 Mar 2022 16:29:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3ek4k3hx27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 16:29:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224GIBGd47776052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 16:18:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 050694203F;
        Fri,  4 Mar 2022 16:29:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2999342041;
        Fri,  4 Mar 2022 16:29:11 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.94.215])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  4 Mar 2022 16:29:11 +0000 (GMT)
Date:   Fri, 4 Mar 2022 17:29:08 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 0/2] swiotlb: rework fix info leak with DMA_FROM_DEVICE
Message-ID: <20220304172908.43ab261d.pasic@linux.ibm.com>
In-Reply-To: <YiI2DPIrNLKwanZw@infradead.org>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
        <YiI2DPIrNLKwanZw@infradead.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tNfSGfEP4uLov8R8L2q7BvqqGLkldnZk
X-Proofpoint-ORIG-GUID: 3S84OGo6w6kSTSeKENgrp7gsrPLWKL8A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_07,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Mar 2022 07:53:48 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Mar 04, 2022 at 02:58:57PM +0100, Halil Pasic wrote:
> > Unfortunately, we ended up with the wrong version of the patch "fix info
> > leak with DMA_FROM_DEVICE" getting merged. We got v4 merged, but the
> > version we want is v7 with some minor tweaks which were supposed to be
> > applied by Christoph (swiotlb maintainer). After pointing this out, I
> > was asked by Christoph to create an incremental fix. 
> > 
> > IMHO the cleanest way to do this is a reverting the incorrect version
> > of the patch and applying the correct one. I hope that qualifies as
> > an incremental fix.  
> 
> I'd really do one patch to move to the expected state.  I'd volunteer
> to merge the two patches, but I've recently shown that I'm not
> exactly good at that..

No problem, I can do that. It isn't hard to squash things together, but
when I was about to write the commit message, I had the feeling doing
a revert is cleaner.

Any other opinions?

Regards,
Halil
