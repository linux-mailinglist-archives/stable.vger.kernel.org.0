Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3FC4CE1BA
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 01:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiCEAoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 19:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiCEAoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 19:44:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5540172E6A;
        Fri,  4 Mar 2022 16:43:20 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224KE5Zw019015;
        Sat, 5 Mar 2022 00:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=unLmegORgTqQP18ephKn5ovwRrDAmzIrqKCM25UePpk=;
 b=qiKwIAM3pZLUfzV5zBxsjUEXnSubJ1GMdoJFImZ2IS/md9W8x/wx/NQ2ePIqqReEOQUs
 v980OG6jEPDyNHMrcaFQOJdAUMgR0JLqSePT2gD6dDxVlcsQEvGWI6h/eq18KBHYZeK0
 1xTPU64nUNzhrWW7uWx0X+tS6v+u7Ns3sBWEbE4T4CcAj3uNq6GKUd4DDZF0vhIr+j0E
 w1i7KX00qc2PgErG8WkA3O+Ni/vc6QHFx01KcrXCrq1b6kRfy3hm1BrA2iNjTvX50JxD
 GQxVU5ZC1WFtFFuzAqOcBhU9+QP/tIJJ+zQry0QeUI/r5RJiw1ZdZILoux3Stie5lWDp fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eksma3njx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Mar 2022 00:43:06 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2250h5vU019817;
        Sat, 5 Mar 2022 00:43:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eksma3njj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Mar 2022 00:43:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2250S3GK007323;
        Sat, 5 Mar 2022 00:43:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ek4kgay5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Mar 2022 00:43:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2250gxsi20840924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Mar 2022 00:42:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACCD6AE051;
        Sat,  5 Mar 2022 00:42:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA5B9AE04D;
        Sat,  5 Mar 2022 00:42:58 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.94.215])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat,  5 Mar 2022 00:42:58 +0000 (GMT)
Date:   Sat, 5 Mar 2022 01:42:56 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: Re: [PATCH 1/2] Revert "swiotlb: fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <20220305014256.687c77aa.pasic@linux.ibm.com>
In-Reply-To: <YiJEjLdpXoGxtJsO@kroah.com>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
        <20220304135859.3521513-2-pasic@linux.ibm.com>
        <YiIiHD7uA1o7Sj1X@kroah.com>
        <20220304173447.27dc0798.pasic@linux.ibm.com>
        <YiJEjLdpXoGxtJsO@kroah.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _KGvmWxgYA9bjO_iRD2EW5fQtLgEy9Or
X-Proofpoint-ORIG-GUID: P21Y3rHEKAzPfl_buFJc9ZSaEfiGpiU2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050000
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Mar 2022 17:55:40 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Mar 04, 2022 at 05:34:47PM +0100, Halil Pasic wrote:
> > On Fri, 4 Mar 2022 15:28:44 +0100
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> >   
> > > On Fri, Mar 04, 2022 at 02:58:58PM +0100, Halil Pasic wrote:  
> > > > This reverts commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e.    
> > > 
> > > Why???  
> > 
> > TLDR; We got v4 merged instead of v7  
> 
> That makes no sense at all to me, you need to describe it in detail.
> 
> You know better than this :(
> 

I have described the why in the cover letter of the series. Let me
copy-paste it here:

Unfortunately, we ended up with the wrong version of the patch "fix info
leak with DMA_FROM_DEVICE" getting merged. We got v4 merged, but the
version we want is v7 with some minor tweaks which were supposed to be
applied by Christoph (swiotlb maintainer). After pointing this out, I
was asked by Christoph to create an incremental fix. 

IMHO the cleanest way to do this is a reverting the incorrect version
of the patch and applying the correct one. I hope that qualifies as
an incremental fix.

The main differences between what we got and what we need are:
* swiotlb_sync_single_for_device is also required to do an extra bounce
* It was decided that we want to defer introducing DMA_ATTR_OVERWRITE,
  until we have exploiters 
* And anyway DMA_ATTR_OVERWRITE must take precedence over
  DMA_ATTR_SKIP_CPU_SYNC, so the v4 implementation of DMA_ATTR_OVERWRITE
  ain't even correct.

Describing it in the revert commit would have been a wiser choice, I
agree.

BTW the consensus seems to be, that a revert should be avoided, so I will
send a single-patch version of this fix soon(ish).

Sorry for the inconvenience!

Regards,
Halil
