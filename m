Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814126ABED9
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 12:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCFLz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 06:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCFLzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 06:55:51 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3510BAD2E
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 03:55:47 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326BrbE1006017;
        Mon, 6 Mar 2023 11:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=5iKGqbbKqG7zAvvyyUQ37nHTqHeWJRH/V5RGj/yicsw=;
 b=QOa1YeyOATrJ6PsjnjDKkZAfroQnAE/dknHhD1XZ6SpBkQpHqCWGm1ABWW8b0I2cIux3
 0uxM0fX8ZRof91zF/Ewk9C/Qc1c3YhgcThXPLNqLN1VnIMkhPCHsUtRaFgODZiTU2eB/
 HDV55WveryxYeGJ1qyEvoKzljdax3XovjN3Dn064oxj7qC7vkH1qHMoHuXw7sJXWvC0n
 MwI1S7U4b4Ay22ga3dkoklgXtIQjAh4Y1ROU2SkkziZNmhrPnxCGbZmIphfM/VuzmxXO
 SGstxsZhbIW+DMXCikQlg8xehhV7vIHx6HJhFdkldG0ijO+C6YbAYNAj6yVHNyFESriw rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n41qur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 11:55:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 325LjESH030497;
        Mon, 6 Mar 2023 11:55:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p418ctnf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 11:55:44 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326BtfVv40698270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 11:55:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECFFE2005A;
        Mon,  6 Mar 2023 11:55:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1C142004F;
        Mon,  6 Mar 2023 11:55:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.86.118])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 11:55:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <167810000922119@kroah.com>
References: <167810000922119@kroah.com>
Cc:     stable@vger.kernel.org
To:     frankja@linux.ibm.com, gregkh@linuxfoundation.org,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: FAILED: patch "[PATCH] KVM: s390: disable migration mode when dirty tracking is" failed to apply to 4.14-stable tree
Message-ID: <167810374029.10483.17692950333286019427@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 06 Mar 2023 12:55:40 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A1vviydHaTmBQF17p-oxXi9b3Pu6oQJM
X-Proofpoint-GUID: A1vviydHaTmBQF17p-oxXi9b3Pu6oQJM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=821 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting gregkh@linuxfoundation.org (2023-03-06 11:53:29)
>=20
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The Fixes tag of the original git commit is imprecise and would better have=
 been (sorry for that):

Fixes: afdad61615cc ("KVM: s390: Fix storage attributes migration with memo=
ry slots")

Since afdad61615cc is not present in the 4.14 tree, no backport is needed h=
ere.
