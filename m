Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241E95B9DF2
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 17:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIOPD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 11:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiIOPDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 11:03:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E7585FD4;
        Thu, 15 Sep 2022 08:03:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FE0oGw025208;
        Thu, 15 Sep 2022 15:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lN36wMv+b1e3Y0jJ3JfDDlO8HJyvghRjKzs9dtd5UhY=;
 b=o0T2AWFb6UaloaVp7o32Yx/PmuefGHcQEzQwD4RPkuNAsB9av18yaY5xU8pnhJs1XIrP
 rEkiqZS4vsdGl1Ar1Y/qfNmbQ0O1Jgchfjst71pTBrOUIimvEfJ/4OFdSHxlwYqzBKtn
 O1Ewgk0ERj3yUv7QNc9rwxua7i7EQYanREJDVAwr3Sq2S0I7d9BmlwCgv60U6AVdRL9W
 84CwpcflcdkF6MaLXZU3hesU3kHxelQetPvwvR9UC51oh6SCdYJe/FXxLuPdjgXwC4VK
 SW6QCXp7B6BfpUhA6gSF6XZiN8lvCGJXpRW8kogPh9MDVcvoHivENGo2QKHEYvkrxAcP RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm5em2cr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 15:03:50 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FExldw010170;
        Thu, 15 Sep 2022 15:03:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm5em2cpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 15:03:49 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FEpulu015877;
        Thu, 15 Sep 2022 15:03:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3jjy25sy5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 15:03:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FF49nv33423626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 15:04:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA1F2AE056;
        Thu, 15 Sep 2022 15:03:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45676AE051;
        Thu, 15 Sep 2022 15:03:44 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.145.93.150])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 15:03:44 +0000 (GMT)
Date:   Thu, 15 Sep 2022 17:03:35 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] s390/vfio-ap: bypass unnecessary processing of
 AP resources
Message-ID: <20220915170335.1743b645.pasic@linux.ibm.com>
In-Reply-To: <4e89ff00-aac2-7c8e-14cf-add426853e9d@de.ibm.com>
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
        <20220823150643.427737-2-akrowiak@linux.ibm.com>
        <20220915050018.37d21083.pasic@linux.ibm.com>
        <4e89ff00-aac2-7c8e-14cf-add426853e9d@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6GOZBM6ibUtGtEuFU0JMkLYPIiPSrKcb
X-Proofpoint-ORIG-GUID: MbnveZ2oYLDj_JsQOBmm5ayM9fPBSNRb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=838 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209150085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Sep 2022 16:53:51 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > Reviewed-by: Halil Pasic <pasic@linux.ibm.com>  
> 
> Shall the patch go via the s390 tree (still into 6.0 I guess)?

Yes please! 


