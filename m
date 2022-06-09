Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8754584B
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 01:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiFIXP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiFIXP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 19:15:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB2F165379;
        Thu,  9 Jun 2022 16:15:51 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259N9lNa030155;
        Thu, 9 Jun 2022 23:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=6rV25bVukC0FzXp8C+eOvheKB/Ow7ad3IEMVII0+WpA=;
 b=RHOtXYOZ9bsKZLp7BpFsh8xAA1w+ADlN0/KyiaOLAfMUmEKpvIjNaVHmuM1ixTKXz3u3
 8rdap9v1Q7WMGgOkjy64pZ9O5wfQQ8c1XhuMnzbzTiQhPKj29mhNrTf9+wJ/p52qpHmb
 pjZxUs48VW1ROKzR6CVJRGFMjYGXI6eKG7a46MN/FlE2B5fRj2odL0WLZNqUGrI0Ht54
 XHIU52qptcQW51LeTjIuao6Wo0lnRXj++JfG6rO2y66mItDojOgbHHNnaPLOqYra9/zI
 9rSPPP9+QStbwwfbnHyJGHAnENcJzUhuZnhPQYAg4V67J1yclMLjXx6cTR+BVAmR9J1P vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gks69gysn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 23:15:36 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 259NAuRn009191;
        Thu, 9 Jun 2022 23:15:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gks69gys6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 23:15:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 259N5ubN001267;
        Thu, 9 Jun 2022 23:15:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3gfy19fft3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 23:15:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 259NFUKJ21496240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jun 2022 23:15:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DE6D11C04C;
        Thu,  9 Jun 2022 23:15:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AF8011C04A;
        Thu,  9 Jun 2022 23:15:28 +0000 (GMT)
Received: from sig-9-65-64-6.ibm.com (unknown [9.65.64.6])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jun 2022 23:15:27 +0000 (GMT)
Message-ID: <e44bb6b11573838417b5d561173c27a1571c94b6.camel@linux.ibm.com>
Subject: Re: [PATCH v8 3/4] arm64: kexec_file: use more system keyrings to
 verify kernel image signature
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 09 Jun 2022 19:15:27 -0400
In-Reply-To: <20220512070123.29486-4-coxu@redhat.com>
References: <20220512070123.29486-1-coxu@redhat.com>
         <20220512070123.29486-4-coxu@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AZVfSAyGR6zReIne5Uk26XJVLhnwfpqj
X-Proofpoint-ORIG-GUID: mzxr_bl7MDVagn9LqpV5ZEpivnd1vDN9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_15,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999 clxscore=1011
 malwarescore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206090085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-05-12 at 15:01 +0800, Coiby Xu wrote:
> Currently, a problem faced by arm64 is if a kernel image is signed by a
> MOK key, loading it via the kexec_file_load() system call would be
> rejected with the error "Lockdown: kexec: kexec of unsigned images is
> restricted; see man kernel_lockdown.7".
> 
> This happens because image_verify_sig uses only the primary keyring that
> contains only kernel built-in keys to verify the kexec image.

From the git history it's clear that .platform keyring was upstreamed
during the same open window as commit 732b7b93d849 ("arm64: kexec_file:
add kernel signature verification support").   Loading the MOK keys
onto the .platform keyring was upstreamed much later.  For this reason,
commit 732b7b93d849 only used keys on the  .builtin_trusted_keys
keyring.   This patch is now addressing it and the newly upstreamed
.machine keyring.

Only using the .builtin_trusted_keys is the problem statement, which
should be one of the first lines of the patch description, if not the
first line.

> 
> This patch allows to verify arm64 kernel image signature using not only
> .builtin_trusted_keys but also .platform and .secondary_trusted_keys
> keyring.

Please remember to update this to include the .machine keyring.

> 
> Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")

Since the MOK keys weren't loaded onto the .platform keyring until much
later, I would not classify this as a fix.

thanks,

Mimi

