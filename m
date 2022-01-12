Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD6048C434
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 13:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbiALMuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 07:50:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232738AbiALMuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 07:50:18 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CCH6La009461;
        Wed, 12 Jan 2022 12:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : references : date : message-id :
 mime-version : content-type; s=pp1;
 bh=84yMe6rRBfA52Z2j/OjzLDtqFnKfO03Ab7IOMM83A88=;
 b=Mxd0t7rJ9NpDxHIFHdrOyfiEAhCzu0ialeyAJeLCsRwedRAIW4wgnYkZSIA9zwNPKx3K
 creWC2Asm5K7q77pcALVzkE8Z4wU9Ii6OoAyDo4OHHXltLrnsJJ6K0Cp+e1Dm0QqExxV
 IIxIWzJrCFD7FAcV1xcizkznAAckR6Lr/7JRi3Sgqxy2D9e4pp5XVQkI2nq+iJWTk3hX
 41JMqf+sE4gEuCadJUH1ky6eKXG5OeKVxsuZF05bX1ZAbdJ9hJrWqZbA8vWYwgiMW+Mc
 xKXrUR1KouSv25jGPa1+rbj4WrAoj2LMqg1qUXHIBvzhSLF89RPnOaAAeJeygf6cimuz nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhwkuuw38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:50:17 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20CClYRd011777;
        Wed, 12 Jan 2022 12:50:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhwkuuw2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:50:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20CCgx5k019097;
        Wed, 12 Jan 2022 12:50:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3df289bpxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:50:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20CCf9Wh37224888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 12:41:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 934D911C05E;
        Wed, 12 Jan 2022 12:50:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7262311C06E;
        Wed, 12 Jan 2022 12:50:12 +0000 (GMT)
Received: from localhost (unknown [9.171.34.68])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jan 2022 12:50:12 +0000 (GMT)
From:   Alexander Egorenkov <egorenar@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     hca@linux.ibm.com, ltao@redhat.com, prudo@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/kexec: handle R_390_PLT32DBL rela
 in" failed to apply to 5.15-stable tree
In-Reply-To: <Yd6v5Ob3a883gCX+@kroah.com>
In-Reply-To: 
References: <1639748305210135@kroah.com>
 <8735lt8gs9.fsf@oc8242746057.ibm.com> <Yd6v5Ob3a883gCX+@kroah.com>
Date:   Wed, 12 Jan 2022 13:50:12 +0100
Message-ID: <87tue96ruj.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aF6Le9drEodeP6J55-7W7y2lTbLReZ1i
X-Proofpoint-GUID: bIWR4Rue-2Tw9jEtFScValiQyyMXLetc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Jan 12, 2022 at 10:06:14AM +0100, Alexander Egorenkov wrote:
>> Hi Greg,
>> 
>> <gregkh@linuxfoundation.org> writes:
>> 
>> > The patch below does not apply to the 5.15-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> 
>> please apply the following upstream commits (in this order):
>> 
>> 1. edce10ee21f3916f5da34e55bbc03103c604ba70
>
> This commit fails to apply.
>
>> 2. 41967a37b8eedfee15b81406a9f3015be90d3980
>> 3. abf0e8e4ef25478a4390115e6a953d589d1f9ffd (the failed commit)
>
> Can you please send a working set of backported patches that we can
> apply?
>

I tested the stable branch 5.15.y and discovered that
the fix 41967a37b8eedfee15b81406a9f3015be90d3980 is already present
there.

Please try to apply just abf0e8e4ef25478a4390115e6a953d589d1f9ffd again.
I think you probably tried to apply
abf0e8e4ef25478a4390115e6a953d589d1f9ffd before
41967a37b8eedfee15b81406a9f3015be90d3980 was present ?
And now that is there, everything works.

Regards
Alex
 

