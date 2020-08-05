Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEB623D22E
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgHEUJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:09:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgHEQcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:32:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 075B3886136173
        for <stable@vger.kernel.org>; Wed, 5 Aug 2020 07:27:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32qssakugm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 07:27:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 075BOGVb027780
        for <stable@vger.kernel.org>; Wed, 5 Aug 2020 11:27:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 32mynham3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:27:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 075BQFuR54722986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Aug 2020 11:26:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BE134C058;
        Wed,  5 Aug 2020 11:27:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D2044C050;
        Wed,  5 Aug 2020 11:27:42 +0000 (GMT)
Received: from osiris (unknown [9.171.16.161])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  5 Aug 2020 11:27:41 +0000 (GMT)
Date:   Wed, 5 Aug 2020 13:27:40 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] s390/numa: set node distance to LOCAL_DISTANCE
Message-ID: <20200805112740.GD5275@osiris>
References: <cover.1596565862.git.agordeev@linux.ibm.com>
 <c87c17b99a710d1752a189180582afb6ced9efeb.1596565862.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87c17b99a710d1752a189180582afb6ced9efeb.1596565862.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_08:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=1
 bulkscore=0 mlxlogscore=636 spamscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050088
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 08:35:49PM +0200, Alexander Gordeev wrote:
> The node distance is hardcoded to 0, which causes a trouble
> for some user-level applications. In particular, "libnuma"
> expects the distance of a node to itself as LOCAL_DISTANCE.
> This update removes the offending node distance override.
> 
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Fixes: 701dc81e7412 ("s390/mm: remove fake numa support")
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/s390/include/asm/topology.h | 6 ------
>  1 file changed, 6 deletions(-)

It would have been nice if the Fixes tag would be correct, since then
there would be hardly any backport necessary. But unfortunately this
is broken since we support numa.

Older code had this:

int __node_distance(int a, int b)
{
	return mode->distance ? mode->distance(a, b) : 0;
}
EXPORT_SYMBOL(__node_distance);

And the distance function was only set for the emulation mode, but not
the default ("plain") mode.

I'll change that in the commit message.
