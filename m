Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EE44E927B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240234AbiC1K21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240232AbiC1K20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 06:28:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DF23B2AE;
        Mon, 28 Mar 2022 03:26:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SAEEil018693;
        Mon, 28 Mar 2022 10:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=NTudMMXM/2VbRKK7tifX00G280bSD7nwhFpzsJUlv9k=;
 b=qqzl3Excr55CsWnAkZfjVa1W4ETPjU9OGcO0aRFeY7LmyVEpoJXtWS+5aFcN+93vJ076
 HYJzoE/vs8exnkYiR53kOj6PUj6mpsbGuJtKMmGfLg3x5IxlmZb92gmq4faIizEr/4D5
 TA1U3rHvPHbRQnGq/Dc76vjx3z2ZmadlLNlVYCKJxrwVv42/w7eSRgt+fRnykxso2hvg
 05SVZT4Ea4lwkCAcodQt7j587LHKmoUS9YLmIPBbCHub5c/0UUJ/D+pUJMQuOZ0Cy3So
 Wd1TUKqKSGyDBrJg/hHzluz2SucX7M+yXUFrSpMg1yMzrg6mA1It3+EwAnwsrxiWKG5j oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3b3c06sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:26:40 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SAQdMr031194;
        Mon, 28 Mar 2022 10:26:39 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3b3c06s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:26:39 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SANj3Q031436;
        Mon, 28 Mar 2022 10:26:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hu60f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:26:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SAQejN41288064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 10:26:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06DCF52054;
        Mon, 28 Mar 2022 10:26:35 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id A64FF52051;
        Mon, 28 Mar 2022 10:26:34 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, gregkh@linuxfoundation.org,
        jcmvbkbc@gmail.com, elder@linaro.org, dsterba@suse.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] char: tty3270: fix a missing check on list iterator
References: <20220328093505.27902-1-xiam0nd.tong@gmail.com>
        <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org>
Date:   Mon, 28 Mar 2022 12:26:34 +0200
In-Reply-To: <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org> (Jiri Slaby's
        message of "Mon, 28 Mar 2022 12:09:59 +0200")
Message-ID: <yt9d8rsucqzp.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nMTN3N-IOmQFTN2SxoerQHKuNvTLHmyk
X-Proofpoint-GUID: UccP9BdvNjv2GJAXYw09B8Bjg9uBy4xq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_03,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=737 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jiri Slaby <jirislaby@kernel.org> writes:

>> Cc: stable@vger.kernel.org
>> Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> That's barely the commit introducing the behavior.
>

Well, that code was introduced way before linux switch to git - not sure
whether it makes sense to provide a Fixes: header in that case.
