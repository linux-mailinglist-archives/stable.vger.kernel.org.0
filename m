Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99556ABC86
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjCFK2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCFK1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:27:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706E226863;
        Mon,  6 Mar 2023 02:26:58 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3269LSLw001500;
        Mon, 6 Mar 2023 10:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=iMb4Xi2Co2oFwwWqjKXGwvtACKJMW3+qiWgyiZ9Bku8=;
 b=JtZF2ee7BGmb5rSjsYtJkBSJb5PkzkvxWj8aZQkMdmgKNtZlLt3U005PDJPJLHj8rMTZ
 4Vhi7U7hYkXlZXKwV1nafh87KO/R/jEJQtp3dO2tLLm1he/x/sMeyoxy5TQIA6l9R+JG
 /gc5YvtAf57qgrpt/NVb1xZzNEEbQAlfBm4SsqS/iE+Kw0BOArzQPgTsd8t9KMi2ZwRb
 vjqeZp2MRGMde6GASbfyTZAlN55NMHp1d1JQyqHp72nyrwZIiF1mWgKqfoYZDRvaQLCB
 WSgseMkxGibr/N9V01c7U6GqXrLfJjXxaJjHvNegSGtuyKR2U2sR9T7LlDXxU+LRXVjI dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p507nr7vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:26:47 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326AAgom031155;
        Mon, 6 Mar 2023 10:26:47 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p507nr7v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:26:46 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 325Nhx13031465;
        Mon, 6 Mar 2023 10:26:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p418v21sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:26:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326AQf4A41484574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 10:26:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1827720078;
        Mon,  6 Mar 2023 10:26:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E59962007A;
        Mon,  6 Mar 2023 10:26:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.46.225])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 10:26:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230305135207.1793266-5-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org> <20230305135207.1793266-5-sashal@kernel.org>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH AUTOSEL 6.2 05/16] s390/virtio: sort out physical vs virtual pointers usage
Message-ID: <167809840006.10483.605220541481258700@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 06 Mar 2023 11:26:40 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jzOHDmhuvYJVEW3LJ2NlFChf12DKY5XK
X-Proofpoint-ORIG-GUID: 27xfKDkcR_DFoAg0KOcLk-zgWOwvohCA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_02,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=890 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1031 impostorscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha, s390 maintainers,

Quoting Sasha Levin (2023-03-05 14:51:56)
> From: Alexander Gordeev <agordeev@linux.ibm.com>
>=20
> [ Upstream commit 5fc5b94a273655128159186c87662105db8afeb5 ]
>=20
> This does not fix a real bug, since virtual addresses
> are currently indentical to physical ones.

not sure if it is appropriate to pick for stable, since it does not fix a b=
ug currently.

Alexander, Janosch, your opinion?
