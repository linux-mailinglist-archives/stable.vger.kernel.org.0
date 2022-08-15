Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F8593489
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiHOSL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiHOSL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:11:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A8913E2C
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:11:56 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FGxT6M006275;
        Mon, 15 Aug 2022 18:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=9LC9fGtGYUwYhCZbszqRZL5tq98ISZ56FUfZr9+PFsI=;
 b=old0SpHc9IaYZnObxwbT4ocAGw4gv64DdUCc01cOnAOdeFBaxulNaTxiA8xIQ828pEMX
 TW3nBulZ3Wk3acJBsRDWw8CzxQ7WXf3+EW4iYyK3lMn6s4hQ9sKFyuJz3Si8ZY5+lVil
 Fb/C65lmXRV6ZbkMOpawwXn5A4zbOgPwrGCjJJwfKL4IPydzUPrHyduAKr+l6bLjMyee
 Mb1r8cG82tgtbiKjhYBuCe4KGKs7WWdP4J0+29HWJ/uaKwfevXmR33qJkQOtCkVYm/Fj
 Xjw51d83dtMxuBkYPpjKYXm3ZbChZLf3BAhsm28HAyqAlvDMzQ6arZSsyCniGoNBXWd8 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hyrda5bjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:11:50 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27FHu0hq008517;
        Mon, 15 Aug 2022 18:11:49 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hyrda5bhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:11:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27FI6O9i022736;
        Mon, 15 Aug 2022 18:11:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8t8h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:11:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27FIBj2D31982056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 18:11:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F543A404D;
        Mon, 15 Aug 2022 18:11:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B72A4040;
        Mon, 15 Aug 2022 18:11:44 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.watson.ibm.com (unknown [9.31.98.41])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Aug 2022 18:11:44 +0000 (GMT)
Message-ID: <ebb3e67f78a8d7ab0e359517eadb3f39247a358f.camel@linux.ibm.com>
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     gregkh@linuxfoundation.org, coxu@redhat.com, bhe@redhat.com,
        msuchanek@suse.de, will@kernel.org
Cc:     stable@vger.kernel.org
Date:   Mon, 15 Aug 2022 14:11:44 -0400
In-Reply-To: <166057758347124@kroah.com>
References: <166057758347124@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qRnV7S2-d9sDkzufe-OYf1DdRoA8DBsd
X-Proofpoint-ORIG-GUID: C4OcwCSNxNE0jKCRwxBqcDe-7T4Z9s4N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 2022-08-15 at 17:33 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The commits contained in the 88b61b130334 ("Merge remote-tracking
branch 'linux-integrity/kexec-keyrings' into next-integrity") should be
applied in the proper order to avoid merge conflicts.  

The third patch has a dependency on the first two commits, which were
initially in Andrew's tree.   The third commit says, "Note later
patches are dependent on this patch so it should be backported to the
stable tree as well."

thanks,

Mimi

