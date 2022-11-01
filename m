Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735666153C3
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 22:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiKAVHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 17:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKAVHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 17:07:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C711DA78;
        Tue,  1 Nov 2022 14:07:44 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1K0bgv011530;
        Tue, 1 Nov 2022 21:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=tFHhevBTuVeibnGjbNPPIb8CHtAFDNMRfUu71KO8UeY=;
 b=Qm+NsJ51+Im8XWzN3Akue+SjanAA0ED81sCyGTTNa17E8tKerbqyzj/blekFvm/xyr14
 HUG/shLEno4Ov8xDIhXqeSkxN1FrgWnX3cetsHnKxVBS3FcqRpJiXdbz69MuI0zMwoh9
 um5Fo+OEE1ocAMj98KpR0afWkuRNSvfX3cKVw/p70Sr0M6GvKASevTXsOPkVBrE9Gu2m
 7OVvcJlum+sUVIEhsKFD/zkEZ5IFXsn0l7KI469k0aBx8sleygPhFBY0AWip0+v5jAZ0
 RnyZBriXM/A72qr/zWaWTqa0a0GtIYE4Nv1znDi+zdnQ4NGyEkSWNuBuYP4Vds+FIvuB Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjvbhem89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 21:07:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A1Iag3I019035;
        Tue, 1 Nov 2022 21:07:19 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjvbhem7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 21:07:19 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A1L6p7J028551;
        Tue, 1 Nov 2022 21:07:18 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3kguta3yk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 21:07:18 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A1L7K9L10289820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Nov 2022 21:07:21 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF28558058;
        Tue,  1 Nov 2022 21:07:16 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17A0E58059;
        Tue,  1 Nov 2022 21:07:16 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.106.109])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Nov 2022 21:07:15 +0000 (GMT)
Message-ID: <6d1f5204ad68fa34d55019790ce376167a0110a9.camel@linux.ibm.com>
Subject: Re: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "chyishian.jiang@gmail.com" <chyishian.jiang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Date:   Tue, 01 Nov 2022 17:07:15 -0400
In-Reply-To: <9D46D92F-1381-4F10-989C-1A12CD2FFDD8@live.com>
References: <8CB9E43B-AB65-4735-BB8D-A8A7A10F9E30@live.com>
         <cee0b0176edc942ecc0ce6f4d585c239f9b7c425.camel@linux.ibm.com>
         <9D46D92F-1381-4F10-989C-1A12CD2FFDD8@live.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: otuF8GVL0erMKE98_o_DPisopIAymoU4
X-Proofpoint-ORIG-GUID: YSB9X97RL2Qh1CzDBwDtkO-er7_dB7zc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_10,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=718 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

On Tue, 2022-11-01 at 14:06 +0000, Aditya Garg wrote:
> Hi Mimi
> 
> > I found this list of computers with the Apple T2 Security Chip - 
> > https://support.apple.com/en-us/HT208862, but not a list that
> > correlates them to the system ID.  With this update, is this the entire
> > list?
> 
> As per the link you sent me, the following are the system IDs of the T2 Macs mentioned in the list
> 
> 1. iMac (Retina 5K, 27-inch, 2020) - iMac20,1, iMac20,2
> 2. iMac Pro - iMacPro1,1
> 3. Mac Pro (2019) - MacPro7,1
> 4. Mac Pro (Rack, 2019) - MacPro7,1
> 5. Mac mini (2018) - Macmini8,1
> 6. MacBook Air (Retina, 13-inch, 2020) - MacBookAir9,1
> 7. MacBook Air (Retina, 13-inch, 2019) - MacBookAir8,2
> 8. MacBook Air (Retina, 13-inch, 2018) - MacBookAir8,1
> 9. MacBook Pro (13-inch, 2020, Two Thunderbolt 3 ports) - MacBookPro16,3
> 10. MacBook Pro (13-inch, 2020, Four Thunderbolt 3 ports) - MacBookPro16,2
> 11. MacBook Pro (16-inch, 2019) - MacBookPro16,1, MacBookPro16,4
> 12. MacBook Pro (13-inch, 2019, Two Thunderbolt 3 ports) - MacBookPro15,4
> 13. MacBook Pro (15-inch, 2019) - MacBookPro15,1, MacBookPro15,3
> 14. MacBook Pro (13-inch, 2019, Four Thunderbolt 3 ports) - MacBookPro15,2
> 15. MacBook Pro (15-inch, 2018) - MacBookPro15,1
> 16. MacBook Pro (13-inch, 2018, Four Thunderbolt 3 ports) - MacBookPro15,2
> 
> The system IDs of the Macs can be seen from official Apple’s documentation form the links below :-
> 
> https://support.apple.com/en-in/HT201634 - For iMac
> https://support.apple.com/en-in/HT202888 - For Mac Pro
> https://support.apple.com/en-in/HT201894 - For Mac mini
> https://support.apple.com/en-in/HT201862 - For MacBook Air
> https://support.apple.com/en-in/HT201300 - For MacBook Pro
> 
> After cross-checking only iMacPro1,1 seems to be missing.

Thank you for double checking.  The patch is now queued in next-
integrity.

Mimi

