Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9462595CEF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiHPNOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiHPNOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:14:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CB052099
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 06:14:46 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GCTX8S020589;
        Tue, 16 Aug 2022 13:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=4KDH2nYaXFWJoQjxcKf3QbuVRdxh5rtEdoCdiBNN5tU=;
 b=Nhgfxd6DT39fkfi9YH2Kg5qfJzJnr/7GYUN00pL4c5Pabgr3pi6/1EgxCAS5LYGXrfZE
 BPmzbltO/LUSMdgCL00qtLN447KxfgoxjOQmtBQVuoNLtUknaLVPnduLjYGCwN6tJW6O
 jJl8hSHubaADCllOLCltyb5EHSC7UHwKib6zGFd9zGizNO1EC73TYSFd+M4c2GY7VYuZ
 eBXYPiFIjqSFxlUlAlOpQZkuNiHahipctWztGXqTv38wG/c06c2CRaymtAWX3FpdxPuT
 o36Yvsxz86DdXAb0Y2d5LUWlTrxTPjsio9xvBMZebBaveLojCfwQM0QWnaJmrHNi743c vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0b9t1bs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 13:14:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27GDB29D021984;
        Tue, 16 Aug 2022 13:14:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0b9t1brd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 13:14:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GD6d91032345;
        Tue, 16 Aug 2022 13:14:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3hx3k92e27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 13:14:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GDEZjA24773006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 13:14:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72ADBAE055;
        Tue, 16 Aug 2022 13:14:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA95EAE04D;
        Tue, 16 Aug 2022 13:14:33 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.211.128.192])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 13:14:33 +0000 (GMT)
Message-ID: <f8266ed176b5eac096344c739ea86d756e6394c3.camel@linux.ibm.com>
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Coiby Xu <coxu@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        stable@vger.kernel.org
Date:   Tue, 16 Aug 2022 09:14:32 -0400
In-Reply-To: <20220816104559.xwovh5y4bcx6n37a@Rk>
References: <166057758347124@kroah.com> <20220816063256.qzc6jh744i2zc6ou@Rk>
         <YvtOfWDg2SXdcqgL@kroah.com> <20220816104559.xwovh5y4bcx6n37a@Rk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RaXFGWE5Os-lrfTyigeX2uJonv2CPrW1
X-Proofpoint-GUID: wCxoz6zLniFQIsu5tWoH-duzjQZSW65M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-08-16 at 18:45 +0800, Coiby Xu wrote:
> On Tue, Aug 16, 2022 at 09:59:57AM +0200, Greg KH wrote:
> 
> >Hopefully the git ids can be stable when they are merged to a
> >maintainer's tree.

A missing Ack was added to one of the commits resulting in a forced
rebase.

> 
> I notice the commit ids of these patches in current next-integrity tree
> are still different from Linus's tree. It seems there is no way to avoid
> manually backporting a patch for similar cases unless the commit ids are
> automatically fixed when Linus merges the patch or we could match a
> commit by its subject.

After "fixing" the topic branch merge message, I forgot to push it out
to the next-integrity branch. (Will be fixed shortly.)  Other than the
merge message commit itself, the commits in Linus' tree and the next-
integrity branch are the same.  The pull request was based on the
integrity-6.20 tag.

Tip of linux-integrity/next-integrity:
$ git log 1d212f9037b0 | head -2
commit 1d212f9037b035e638d53834bfe8d3094ca1d04c
Merge: c808a6ec7166 0828c4a39be5

Tip of the my local branch and what's in Linus' branch:
$ git log 88b61b130334 | head -2
commit 88b61b130334212f8f05175e291c04adeb2bf30b
Merge: c808a6ec7166 0828c4a39be5

The pull request tag:
$ git log integrity-6.20 | head -2
commit 88b61b130334212f8f05175e291c04adeb2bf30b
Merge: c808a6ec7166 0828c4a39be5

Mimi

