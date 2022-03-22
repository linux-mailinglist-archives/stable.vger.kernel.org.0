Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3ED4E3C72
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiCVKaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiCVKaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:30:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8EEBF57
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:28:54 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M8aenB011195;
        Tue, 22 Mar 2022 10:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wp+j1d0WvXqflzhz15E/9PZ7lp0bI2v11WQZEHRPatg=;
 b=nvs4IgDJC96Vz15IRwhvowXngfvRJ0Xt7CdRJw14jKBzEHkcr+Pz3FBIQAU4OEhKUZT5
 efmng9gc7qwnPItDB3gugO0p+VDDNELMwHWqIZ+7JaIEMgc4vsJUG1qwGxUZL7lzmcut
 6XcuXVEw5YOxY0YIwtBg5Usx0lAeJW6VSC0EDtwfI4Cvu4H25jHWhYFCImWnW39GHjzv
 3Ji/rlrq4TpDocIoSfn75BSGaMy7noSnaKjXI8fp+Gwjt0YfMPLkbvXlFfENgppkGorv
 PYSODwxFXwR3aft5YgkUR2B5pYvnGex6VkwIdlq0q4wtGg6Cq0izqaF6V0DPcorb0xmf jA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ey5wc88ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:28:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MAJG8s027114;
        Tue, 22 Mar 2022 10:28:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t953rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:28:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MAGulP48824804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 10:16:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 441EFAE055;
        Tue, 22 Mar 2022 10:28:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9231AE04D;
        Tue, 22 Mar 2022 10:28:36 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.47.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 22 Mar 2022 10:28:36 +0000 (GMT)
Date:   Tue, 22 Mar 2022 11:28:34 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH for 5.10.x 1/2] swiotlb: fix info leak with
 DMA_FROM_DEVICE
Message-ID: <20220322112834.6103451e.pasic@linux.ibm.com>
In-Reply-To: <YjmgeVPQxzvpV6m6@kroah.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
        <20220322100218.2158138-2-pasic@linux.ibm.com>
        <YjmgeVPQxzvpV6m6@kroah.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S6TkcUOrw219JEsG15Yar245DbwPk8xS
X-Proofpoint-GUID: S6TkcUOrw219JEsG15Yar245DbwPk8xS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_03,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Mar 2022 11:10:01 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Mar 22, 2022 at 11:02:17AM +0100, Halil Pasic wrote:
> > The problem I'm addressing was discovered by the LTP test covering
> > cve-2018-1000204.
> > 
> > A short description of what happens follows:
> > 1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
> >    interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
> >    and a corresponding dxferp. The peculiar thing about this is that TUR
> >    is not reading from the device.
> > 2) In sg_start_req() the invocation of blk_rq_map_user() effectively
> >    bounces the user-space buffer. As if the device was to transfer into
> >    it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
> >    sg_build_indirect()") we make sure this first bounce buffer is
> >    allocated with GFP_ZERO.
> > 3) For the rest of the story we keep ignoring that we have a TUR, so the
> >    device won't touch the buffer we prepare as if the we had a
> >    DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
> >    and the  buffer allocated by SG is mapped by the function
> >    virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
> >    scatter-gather and not scsi generics). This mapping involves bouncing
> >    via the swiotlb (we need swiotlb to do virtio in protected guest like
> >    s390 Secure Execution, or AMD SEV).
> > 4) When the SCSI TUR is done, we first copy back the content of the second
> >    (that is swiotlb) bounce buffer (which most likely contains some
> >    previous IO data), to the first bounce buffer, which contains all
> >    zeros.  Then we copy back the content of the first bounce buffer to
> >    the user-space buffer.
> > 5) The test case detects that the buffer, which it zero-initialized,
> >   ain't all zeros and fails.
> > 
> > One can argue that this is an swiotlb problem, because without swiotlb
> > we leak all zeros, and the swiotlb should be transparent in a sense that
> > it does not affect the outcome (if all other participants are well
> > behaved).
> > 
> > Copying the content of the original buffer into the swiotlb buffer is
> > the only way I can think of to make swiotlb transparent in such
> > scenarios. So let's do just that if in doubt, but allow the driver
> > to tell us that the whole mapped buffer is going to be overwritten,
> > in which case we can preserve the old behavior and avoid the performance
> > impact of the extra bounce.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Cc: stable@vger.kernel.org
> > [pasic@linux.ibm.com: resolved merge conflicts]
> > ---
> >  Documentation/core-api/dma-attributes.rst | 8 ++++++++
> >  include/linux/dma-mapping.h               | 8 ++++++++
> >  kernel/dma/swiotlb.c                      | 3 ++-
> >  3 files changed, 18 insertions(+), 1 deletion(-)  
> 
> What is the git commit id of this patch in Linus's tree?

ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")

What is the best way to state the original commit id for backports? I
used the cover letter this time, but it does not seem to be the right
choice.
