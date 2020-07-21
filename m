Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E465A22832A
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 17:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgGUPHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 11:07:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21310 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727941AbgGUPHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 11:07:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LF2lq7062987;
        Tue, 21 Jul 2020 11:06:59 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32e1vqt42x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 11:06:59 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06LF0VuT018746;
        Tue, 21 Jul 2020 15:06:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7v40a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 15:06:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06LF6sv924510804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 15:06:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E067B5204F;
        Tue, 21 Jul 2020 15:06:54 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.205.118])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 38B0C52052;
        Tue, 21 Jul 2020 15:06:54 +0000 (GMT)
Date:   Tue, 21 Jul 2020 18:06:52 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] io-mapping: Indicate mapping failure
Message-ID: <20200721150652.GI802087@linux.ibm.com>
References: <20200721141641.81112-1-michael.j.ruhl@intel.com>
 <20200721141641.81112-2-michael.j.ruhl@intel.com>
 <20200721144722.GH3703480@smile.fi.intel.com>
 <14063C7AD467DE4B82DEDB5C278E866301245DF505@FMSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E866301245DF505@FMSMSX108.amr.corp.intel.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_09:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 03:00:41PM +0000, Ruhl, Michael J wrote:
> >-----Original Message-----
> >From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >Sent: Tuesday, July 21, 2020 10:47 AM
> >To: Ruhl, Michael J <michael.j.ruhl@intel.com>
> >Cc: dri-devel@lists.freedesktop.org; Andrew Morton <akpm@linux-
> >foundation.org>; Mike Rapoport <rppt@linux.ibm.com>; Chris Wilson
> ><chris@chris-wilson.co.uk>; stable@vger.kernel.org
> >Subject: Re: [PATCH] io-mapping: Indicate mapping failure
> >
> >On Tue, Jul 21, 2020 at 10:16:41AM -0400, Michael J. Ruhl wrote:
> >> Sometimes it is good to know when your mapping failed.

I was going to say it's always a good idea ;-)

> >Can you elaborate...
> 
> Sure, guess I was too glib. 😊
> 
> Currently  the io_mapping_init_wc (the !ATOMIC_IOMAP version), function will
> always return success.
> 
> If the setting of the iomem (from ioremap_wc) fails, the only way for the 
> caller to know is to check the value of iomap->iomem.
> 
> Since all of the callers expect a NULL return on error, and check for a NULL,
> I felt this needed a fixes (i.e. unexpected behavior).
> 
> >> Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata
> >about the io-mapping"
> >
> >...especially taking into account that Fixes implies regression / bug?
> 
> The failure (in my case a crash) is not revealed until the address is accessed
> long after the init.
> 
> I will update the commit.
> 
> Mike
> 
> >--
> >With Best Regards,
> >Andy Shevchenko
> >
> 

-- 
Sincerely yours,
Mike.
