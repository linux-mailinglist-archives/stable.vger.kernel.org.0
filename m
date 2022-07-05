Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C632566A4E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiGELyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiGELyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:54:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652AF17AA6;
        Tue,  5 Jul 2022 04:54:24 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265BM13d010362;
        Tue, 5 Jul 2022 11:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=8CHLSpOyGtHfVEN8PmGyC9+PyRtlgkvNXgWIGIzvReM=;
 b=OlWPC2TbiJM+O1ADSzuCbg3cTWlMTviNS/YzWM6un6Fk33Ik3rsX0mOZNBK9/9Phr8CH
 l4zjTNDgclkeXjog2/mFiZs9Dyz0811Gau4XIzFBf2Wqa9p+/unJOWIvAe2RpkSbKzeH
 T5z/+GR/so+TOaqbafcE41B/IT3KLMWTLyJV+YiUaOrzeVX1q7cvIrS6lbQfYzeuY1AM
 MTa3/YwbTvpn/XbvY51Ux5QdkOP/39xZJEXCY4A5uUUI1O2LVMluRTbHSaZ8qKAAvPr7
 TviOrDZtW8wKylZBMDZgH9fW4cDGFS7fvzIrrZqhMyBAS85R4RzdfaDYO9V4lcGhAzGt 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4mbvgpgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:54:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265BrAcD030687;
        Tue, 5 Jul 2022 11:54:06 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4mbvgpfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:54:06 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265BpeC0024891;
        Tue, 5 Jul 2022 11:54:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3h2d9jbyp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 11:54:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265Bs9lO32899368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 11:54:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A201D4C04E;
        Tue,  5 Jul 2022 11:54:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 191094C046;
        Tue,  5 Jul 2022 11:54:00 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.48.113])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 Jul 2022 11:54:00 +0000 (GMT)
Date:   Tue, 5 Jul 2022 13:53:58 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Baoquan He <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 5.18 112/181] vmcore: convert copy_oldmem_page() to take
 an iov_iter
Message-ID: <YsQmVlnNDiMNsjD+@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.945731832@linuxfoundation.org>
 <YrnaYJA675eGIy03@osiris>
 <YrqpEZV3yu31t6E2@kroah.com>
 <Yrq70Ctw3UYPFnzC@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <YsMisFQdaUZpxroY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsMisFQdaUZpxroY@casper.infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WGMQlDIouX2O3FIdH8_aIbjl_QBqMUTJ
X-Proofpoint-ORIG-GUID: D9AKQ_ZLiTRB1BnKEJ7l-vq-B36qtFGd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 06:26:08PM +0100, Matthew Wilcox wrote:

Hi Matthew,

> > > > cc02e6e21aa5 ("s390/crash: add missing iterator advance in copy_oldmem_page()")
> > > > af2debd58bd7 ("s390/crash: make copy_oldmem_page() return number of bytes copied")
> > > 
> > > Both of them are also in the 5.18-rc queue here, right?
> > 
> > Yes, these are:
> > 
> > 	[PATCH 5.18 113/181] s390/crash: add missing iterator advance in copy_oldmem_page() Greg Kroah-Hartman
> 
> It's generally considered polite to cc the original author when you
> fix one of their patches.  I wasn't aware of this patch.

Apologies for not doing that - I did not realize this patch could be
of interest for non-s390.

> While the code change looks right, the commit message is wrong;
> copy_oldmem_user() and copy_oldmem_kernel() need to GO AWAY.  You
> need to be more like the other architectures and end up calling
> copy_to_iter().  I have no idea what this memcpy_hsa_kernel()
> and memcpy_hsa_user() are all about, but I was hoping that somebody
> from the s390 team would react to:
> 
>     s390 needs more work to pass the iov_iter down further, or refactor, but
>     I'd be more comfortable if someone who can test on s390 did that work.
> 
> Maybe you'll do it.

I considered going with copy_to_iter(), but unfortunately getting rid of
copy_oldmem_user() and copy_oldmem_kernel() is not an easy thing to do,
if possible. At least for the time being we have to stay with these two
and handle copy_oldmem_page() on our own.

Yet, a hope that a single-segment iterator on s390 would be enough
turned out to be wrong and a follow-up fix is coming. Hopefully, it
will make s390 code one step closer to others.

Thanks!
