Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6688A592FC2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbiHONWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 09:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiHONWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 09:22:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F2E18B0E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 06:22:50 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FCmt3f016988;
        Mon, 15 Aug 2022 13:22:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=6hqDguV+VfeIGLWoJg3WOL/XGWW+6Q2+Ki6tMLbHyQQ=;
 b=oj5XAol8G+rZJc+/l8+m7bnmFxbyP10B2Srvt9buVLRJXrOeI9m4zKzejWjcX32gJXFG
 ohDZ6EAxDUht0Lh3y3sovKAiXoAgaXxHtJCJSN+sn+ihxqtTPIAApWI5yzqzBQhK8OrN
 YrJf2sbtaXCW6ZnZXkDTpv0iuiSDslynvapkTBtT+AZcBOPvnBsg6UsDsZeA11+DXaf3
 p90QdoOHWnAJkluyFjbdUOna6J5znS/HF31kk1BhOFWD8KDKCzjOF5n9SNOyeVs614pq
 x0erKjDTbx6kujZNpqbPGs0uMwUzslgF62Tn142+ycjWn9hdnKIlFVC86FHKMOKvBm7C vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hypfvgy0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:22:47 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27FCoj6r021334;
        Mon, 15 Aug 2022 13:22:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hypfvgxyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:22:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27FDKQJ1000618;
        Mon, 15 Aug 2022 13:22:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hx37ja23h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 13:22:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27FDMgG828180882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 13:22:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 423A64C046;
        Mon, 15 Aug 2022 13:22:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7950A4C040;
        Mon, 15 Aug 2022 13:22:40 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.163.10.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Aug 2022 13:22:40 +0000 (GMT)
Message-ID: <4b217b8801fe66a0fd71dad62571059d67f784bc.camel@linux.ibm.com>
Subject: Re: FAILED: patch "[PATCH] kexec: clean up
 arch_kexec_kernel_verify_sig" failed to apply to 5.15-stable tree
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Michal =?ISO-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     coxu@redhat.com, bhe@redhat.com, ebiederm@xmission.com,
        stable@vger.kernel.org
Date:   Mon, 15 Aug 2022 09:22:39 -0400
In-Reply-To: <YvpEPMGebrrhp8Yf@kroah.com>
References: <1660564084173149@kroah.com>
         <20220815124125.GD17705@kitsune.suse.cz> <YvpEPMGebrrhp8Yf@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8PluMxRAD5MD_PZRvzVD6vNFjk5Ks4S-
X-Proofpoint-ORIG-GUID: FkXMpouuA49Hg4ZCfpgAclxNg0cAsch5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxlogscore=925 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-08-15 at 15:03 +0200, Greg KH wrote:
> On Mon, Aug 15, 2022 at 02:41:25PM +0200, Michal Suchánek wrote:
> > Hello,
> > 
> > it applies on top of 105e10e2cf1c
> 
> I see no such commit id in Linus's tree, what am I missing here?
> 
> confused,

0738eceb6201 kexec: drop weak attribute from functions
65d9a9a60fd7 kexec_file: drop weak attribute from functions

thanks,

Mimi

