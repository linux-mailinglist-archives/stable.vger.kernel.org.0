Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F10BAF0E9
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 20:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfIJSKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 14:10:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728222AbfIJSKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 14:10:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8AHuwmY004777
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 14:10:53 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uxfrvjdjv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 14:10:53 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Tue, 10 Sep 2019 19:10:51 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Sep 2019 19:10:46 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8AIAjNQ39321930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 18:10:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C32AE06A;
        Tue, 10 Sep 2019 18:10:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3DD3AE059;
        Tue, 10 Sep 2019 18:10:44 +0000 (GMT)
Received: from osiris (unknown [9.145.57.86])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 10 Sep 2019 18:10:44 +0000 (GMT)
Date:   Tue, 10 Sep 2019 20:10:43 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, cohuck@redhat.com, frankja@linux.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
References: <20190910130215.23647-1-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910130215.23647-1-imammedo@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19091018-0028-0000-0000-0000039A9C5F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091018-0029-0000-0000-0000245D0143
Message-Id: <20190910181043.GB4313@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=477 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909100172
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 09:02:15AM -0400, Igor Mammedov wrote:
> Make sure that ms->dirty_bitmap is set before using it or
> print a warning and return -ENIVAL otherwise.
...
> v2:
>    - drop WARN()
...
> +		if (!ms->dirty_bitmap)
> +			return -EINVAL;

The patch description needs an update. ;)

