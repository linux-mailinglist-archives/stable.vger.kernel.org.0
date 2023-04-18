Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B996E6CEE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 21:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjDRT3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDRT3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 15:29:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5736F8A60;
        Tue, 18 Apr 2023 12:29:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IExZen013966;
        Tue, 18 Apr 2023 19:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=J7a4DEPLYUk8IWcYu10E8d0kYAUXEWGkEGs3IrzS0QQ=;
 b=k95qHDXpf4XMFApr1cN2SEZgIhDldaxH80tUOF5Tuo/CDk5N+tVfPC4uYKtupN9Ks+04
 sYid9EiirM06cgoMYKooowGiYqns3enl62offyMhPviNonyR5QdC3BH2Yx9EsEAxbpNd
 ACIj1Xu5LIPl+Jm6QuAE8WOdb3DuMYQAdhSveSPVZHfKAj0peJoQBMrWk3QA87S4Gudl
 QZpKgJT0JhIuoPOpxnYlw0qxfz9B/KIrrwS2lzNJ1zI1b3cBQhQ29+YkRTAsVe6q2G85
 18KtVANbHVImEf3IZ50+0Dsj9557Ut/JYKcbrOeV9LVOD2LFsK0SsUQOVg7Luw9p7L+L sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pymfuejdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 19:28:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33IIoSSr011054;
        Tue, 18 Apr 2023 19:28:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc5gfa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 19:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayppjPtIv/vymrIiYzbmt2OYK2C9uuXo4jECd3fxkQpsLGxR0pk93q68J34sQWXA/d/YZ4nELKjUnVTpZqJv3OC4tMIiK1egjNoQ7vv2YPlURBv9rANQe2NNeIOVrdj54WoG9RC6U1Lv4cEHZHRPCOD9sbMwF00HnL+jqYyld0RGItQWysnc+siEvj0VZV6lWKgYoDIteluSe3JvgvRoDRAdZCGC9wLxNJIzuQkKpOTT+GtWCqqp5vS2QeYAtCgSttHyalkdNLcGC0QfZGjO7ULy/mECqKJG7ZlCC9EzCGMnS4bGh88owlMoC6065t5OvoDjAyBennA7qbyG/knNwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7a4DEPLYUk8IWcYu10E8d0kYAUXEWGkEGs3IrzS0QQ=;
 b=iMmm3mz+zKpt+RO7HKM0Qkn5SVlYS0B+8qg0oDwBUF8nrEaG9284oqax3h0W98ksI2sm39gRek6RuwK2tHeLYHNFg0dbbhxOUklEEN+A/3ZN8i3TjaECSbbTahfPKwXfww8JTZ8vCUoq1iCRINQKhu3KwbtV1wybLZZMnaDIvj/dDcfhBdNV9trJDLoxUnG3YLA0o3JHkLNkSObUoSTqcayHTsLdlrYS5OlMfIvZgiiVjBvml5LREPobnl/hZY8echtDCS9CJsRaaR02+9wA3R18XxteH5xCF5I0SRmEpX0jv8Fg+0+ikEv9SEyYMif84iK/FMWGcR8Nj6/Krz39JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7a4DEPLYUk8IWcYu10E8d0kYAUXEWGkEGs3IrzS0QQ=;
 b=N6VtWF5pglPVRw8oIH05T9SzJ6tCpDblZstLUTd7/27rjvXQYN7J+oNFalMY447plgDVNPBhZ24JsZDT+368zERmzR41/P1xr5Ivlh60tqVG18GKB1nlMcbMcNiShPBAqQ64rFKgao58Z99DinLZARmvn0QHl0K9Rx+IyYaLp4E=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 19:28:14 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 19:28:14 +0000
Date:   Tue, 18 Apr 2023 13:28:07 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Tejun Heo <tj@kernel.org>,
        Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Message-ID: <20230418192807.n3hggjak25tnat7i@oracle.com>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <76d8bf7a-20ec-481e-2c21-e456a29e731e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76d8bf7a-20ec-481e-2c21-e456a29e731e@redhat.com>
X-ClientProxiedBy: DM6PR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:5:174::32) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SN4PR10MB5622:EE_
X-MS-Office365-Filtering-Correlation-Id: 33ff8c20-e3e4-47f8-0a08-08db40430d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gal1uxr/ehseGPJUEcWDC96d6F9d8mH3pQPOMDyBONrXyrjGOu/h1s3L8xdb6Sq54oHwVcqhZHyyKPCmt6u4Gz49Q84ePU9rQ1hXrHgJOiFwbqw1etKG5X4oNy37wwJaxxjNOw2YkY97lMZrQOo+4WnLirWn2MIiOUWqq8v7iKKSIlt6RaGBDKNvtDcifAFVBNNXsRwrdpSCeOoQOA74wuS95ViGIVrbysUsqytXTfgdaVXqFQKm0T/lq5buTgiau8LWbr5xOFYPTl3eFXOdOACyVSN5USvU5GvPQ2kK1zDpx3mZCwEPH6ubrLQcjeQ4wzw5OUPrLFGlnkabhbkmhBg1FTP0u8jhc6Uawb+VAEDSNW//5BtnlJrJ31Z7T/hlLZgQAj5xhTbm7Ve1zb6PJ21mE12cgP5rOoMgaP8L1UUrWpHL5lqSY8tUl5DcGjydh2MCF1Tz7nCpFNFQppGl0TlH8xYVA+SgMq6nD/HPGa68IHLLAybaQghn2aTsA/Yz2DYIsL0yg4IbEBh/0qdEmgXV6CAOq4u2cBh08izBiYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(6916009)(316002)(54906003)(966005)(66556008)(66476007)(66946007)(4326008)(186003)(53546011)(1076003)(6506007)(6512007)(26005)(38100700002)(2616005)(83380400001)(41300700001)(8676002)(5660300002)(8936002)(6666004)(478600001)(6486002)(36756003)(86362001)(7416002)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2RPVnA5M0Exc3ZWcEV1TmRMakZ0TXNNa2tMak0vQktGRDNrS1M4VjhjTzV6?=
 =?utf-8?B?dWdjdlNYb0d4R01vYnh6dlAzWFJHMXpDeXRFTXI5OWpydGVTMnZNelV0T3RB?=
 =?utf-8?B?cW0wMGRDOXg5cEdsOHc5dFZON3FlY2pOK1crVThkNFk2OEw5VjhvWlIvcE1n?=
 =?utf-8?B?ZTZuWWdkVTRRZVAzWitad2xiNmFlT3lXMTN0OHNibXQzQWx0RkNJam45S0p2?=
 =?utf-8?B?UlRMZlg5aEMya0RYTXRtYy9VMFJ1dzdwbmUyVFhtMlhtR0l3TThKaTdHb1JY?=
 =?utf-8?B?L0dCZCs3K0ZkanhJN2Q1SDNqaE5JWnFLcHYzbzRqamc0RUVhWmkyckxMelZx?=
 =?utf-8?B?KzZIbnlMcWRPNUxnQ0NnRUZDWjZWSUtSbG5BbktEUVpPSVkzVGYyS3pnVHNh?=
 =?utf-8?B?ZzZLVnJ5NTFIaFpSR2VUVnFUUUZ3U3pHYnlLb1B4UVliaTJwRk9PTjhTVCs0?=
 =?utf-8?B?ZlBiUStlSVU0M0xYa0g4UjYxb2pzN2FaU1MrR2xKU3g4QkJIMnVFa3g4blRZ?=
 =?utf-8?B?SXVLOTIrSmNsWHdWRVpkNHIzc3FWelB4RzlxRytScFJGa3pNc2FWeHcranZB?=
 =?utf-8?B?dEt1bldmL2RrNXJSMXRvc0JIc3dxUFIvNU5EY3NsRDg4aGEvK05VUUZ0bFg5?=
 =?utf-8?B?RllzVER0VlBOZzk2M2NaZm1PZEFWbVFYWnRpSCs3d1hKVDczUjhIb2dkNW9Y?=
 =?utf-8?B?TzRIOVZNWUpWMTdmU0tFLyt1UmN0NmZ2ZHN1S1NVQVJFc2JjUW1YemFpZDRT?=
 =?utf-8?B?MjVYbFFkRFBsa002aSt0MVNzRnVqeVFObTVSeUVVQ29naGRCNjcrZW12c3cr?=
 =?utf-8?B?bXp5ZkxvdFdpVEZSRHBlNDFQaHdvSjNUQWphRzZYbkFEQVk0bHZTMWk3NHdM?=
 =?utf-8?B?cUYyMkRUaVY4MTE1TUo2eW1PODlkU3JJUW9Oemp5NHFYaHBBTHExRC8wK2V1?=
 =?utf-8?B?L1hjTjZWZUxmdFFVTFVOaTN4SWdwUDJGLzJTamtLT1lvR0ZHZjBDWGh0TXo2?=
 =?utf-8?B?TUZ2YTFXc3Q3RkhOSmdRRm04QWc5MnFHYkxuKzBjbVZuM2JjdlI5ZDR6by9M?=
 =?utf-8?B?eldoREFkUlRweVZtUVNPaWRSNFdiVGRoWlI5SG0vQ0p4ejZsY0d1NFNYWWpz?=
 =?utf-8?B?c2hhNWVvWHp3SU9xanlsQllaZVBqKzVNSTVLUXkzSkMwKzVRdlUrWTJsZlNY?=
 =?utf-8?B?Zzh5S0RJQmtUN2JkM3JoLzd1Q1ltTVQzODlSWTlSYk5uMkdLVDNYZE42aTlz?=
 =?utf-8?B?NHZpUTJiTENJWi9mVW16ajBlaTVxWkNLVEFsWjR3cXl5OVJHVlo5MTdDTmVz?=
 =?utf-8?B?NGVPR1NnWWl0bC9MNGlndmJuK0l2Vi80QldnSlFabDVueGhUKzlITjZNNzZ0?=
 =?utf-8?B?QzdCblBlbGxIZHFpTmZQYjlqeVdLMC93R3RxeVZ5TThvZVJRRjhxQkdvRmNN?=
 =?utf-8?B?dVlCdktwY05HSFBTMlNtODhFNE5vT05BeEVSM002Q2xXdkJFVDI4ODBQVHRy?=
 =?utf-8?B?OHdBNDZ0TkpQY1l3RWJOb3lZYkg0b1oxM25pTWdpdzJ3QWE0M2VCSFFlTzhh?=
 =?utf-8?B?b2tXV0hyRVpJOFZoYW5PU0lyZG1uNnhMSUtwY2I3eW5zaWFiRmtNcXg2bFZx?=
 =?utf-8?B?YnV2ZTFMQlpoOVo2WFZRanBjRFZ0YkxrOW51d0h1dUw4dFhlNFptUTVjUUJW?=
 =?utf-8?B?T2xTN1dkdWhTSHVmd3lRNUhXbGNNdkdrQTFtb1RzSG92aDF5SjBLVm5lVVlP?=
 =?utf-8?B?ZEI5ZXJrTDFvcG93azErZXNRWFhYRDE2ZHc5L1krQ0h6dnovSjBSSjhYRUQ3?=
 =?utf-8?B?TDZNWXo2cDUvd2VTNmJHNHdjdU5mRVg3SitpalJ4WDNQdWFTcnpZdFZ5emRa?=
 =?utf-8?B?V3BzM2hTdkMxeWRDcndoRTJlVzZ5TlpKMFhlTzBwZHc2U1NaNEh0Tko1N0hn?=
 =?utf-8?B?WE5YZzNVT1pNMURYaGt3enV0OW1JOEdUUWEreTZyMHVUKzRqdTFkN1hmaVpv?=
 =?utf-8?B?NGxWZnltWGN4aTYrbWNqTHJmcit2Y3pTdUd1OVNWYU1BZTVCYks3Vkw0aFM5?=
 =?utf-8?B?K3pZTGNQcDlPQncwKzU3citwQWkxRHVDeXhtQ1RCb0QyZXkxRzhpZmt5R0dh?=
 =?utf-8?Q?F5HaQ03uteXw+dnWW2qslNnXP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UU5uRlRxVFo2NHJhN3ZDNXBLa3hTMDFNVXFiYVNlNXJGMkFJbm1GV0RkNmdm?=
 =?utf-8?B?T3dOM3FnNklGeVExYnlTaG1wdDVjUGdCWnZXNGIwbHNSajYxQm1zZWtqV2gr?=
 =?utf-8?B?VmRYVythOUtPRkpBK1I0eXh4eFhNby9TOEZlVWhHN1cxd01ENW5XY084WkhH?=
 =?utf-8?B?ejdFdXlDT1ZpcjdHamR1c2hiZDRHUWNWcitZc3RSZmZFYkxWTjhNaCt1RG1q?=
 =?utf-8?B?L3JWS1puQ2JyRFJtVElVVkxmNFpIVmFXckRCeDdRSFZUbmtHV1NPdnJEcERT?=
 =?utf-8?B?QUM0N0pnKy9zdk1UUmV6SnJSbkh2ZWtpTmNwTGFtTERNWVNtU1g3K0x1eGdO?=
 =?utf-8?B?UmZ1WlkxMFVhTlQvdXlvQ0p6bFRBMHNJdmpkQ3JUbzZGUnpVQW1ZSWQwdENE?=
 =?utf-8?B?MHNUbDF6OTBuTGh5UzY3RW13NlJ2cVY0VUpIcGtoS05pNWJFeXlmSXVxTnpL?=
 =?utf-8?B?VFZoaGVzalBCZlQ5OFFWNE5iWDlDMnFZTjBUVVdRZHlxazUyS2NvWm0wZjZ3?=
 =?utf-8?B?c1ZpdXk3bndxMFRUYzB2d01mTFJSeExpS0tOd0wzN1g2STZQZmpUYlYrUko2?=
 =?utf-8?B?QndaTW5OUnF6d0drNFdCelJEYmtjT3RxRjd4T21qQjQrUG9oRkx4L2lublpZ?=
 =?utf-8?B?UmdUTXJYMkVSUk5hSVc1eG9ibEZkN2d5eTkvL2o1dkVuaTZuMFA5RHczRUdC?=
 =?utf-8?B?Qm5UWndFYWtBTlB6MThBWTJsNzY0dmFrNld0NjQ3Mkd6VWlHYTA1WVhrK1hp?=
 =?utf-8?B?bDNQTjRPSENaMEVTQ2lhVmNabCtoQkcrOTVNbzJjRmFHRXBrdkxQTTNUNFpK?=
 =?utf-8?B?MHRrSUVvRXhOVTBrZFEwOEt2bkh2dks0UU1meEJQR2gzOUVRb2JkQjN3SytV?=
 =?utf-8?B?M1ZyYU5ZbUZPc21pU0tOdW1STWo5RWFhT2lLcDdHVEI3T1FVRFhLWFQ1dTg0?=
 =?utf-8?B?Z2tkQW5RVGNXTy9sZDdzYzgzMkluaU5FL2JERGhTWU9SVjE1NnRTUVFGaXJ1?=
 =?utf-8?B?SUQ0anBrNEJNbkxoWVIxV1RxNGZRQ2YwYkZDSmlSQ000S3d5c3hRT3FzODBX?=
 =?utf-8?B?N1Jza1R6QXkxTkdLY2MyOGl5NUZTVkZnTEdUQ3dmNmRGTlExMFo4Yng4QUc5?=
 =?utf-8?B?M3lEMkljUG9vd3lUbzBlM1dDWlNpUXdBdWNCbDRtMXliZ2ZKa01sY01IQlcv?=
 =?utf-8?B?RVh0NzZ3SzNLbWpuUTBWTUQ4TmlUZVhVRmZBaXF3SjdWNGdiQlpNQjhNNVlv?=
 =?utf-8?B?VGtEb2VZc1RvRld1S0NYWDkxemdtUGlHN01UZUlXVE4zeEM3UnpSVUFGV1Y4?=
 =?utf-8?B?OE9lVzVnVGdodTNOYVA3a0tXbVRBcGNxQnlGL0tQYURBQ01CaGtVaFpZN3pa?=
 =?utf-8?B?QUlVYkR0ejA5eStqZ1ZGMWFZVEFETVpncVVNYXVxK2ozWEFpZldQazFrN05C?=
 =?utf-8?B?TUpxemI1Q3JQWEJRYjFMY1daeTJoNHBPUGJRSGdXaktPR3BvNWNySTl6ajI3?=
 =?utf-8?B?aFZpN2JGRFJSd3pxQ0kzVGR2UEQ1b0t1bWV1WVMzNTc4RE50QUEraElvc0lv?=
 =?utf-8?B?cHpIQVNZU2lBdlBiYTlvMW1UWGNYMlYvdCt2SllaakJhZEIrc2NCdGFnRk1C?=
 =?utf-8?B?OHBjUlNqYnZYSG41eWdxNFVmeG5ZaTk4WHBNN3MvN2FmNTBFaS9mWmdGRWtl?=
 =?utf-8?B?akU5djNuYTBMNDZ0ZVlES0JGZ2pOTy8zVHgzdStNWFVkUlVFSStlR053PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ff8c20-e3e4-47f8-0a08-08db40430d89
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 19:28:14.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tksxzxu2WJPQ/s+8wLzIoTE9khS1RuBqAlg9b/gsEoQ9b4+jQSxwjNFj3/JV//5AQimwOcDHhrr/5jPQoBhxJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_14,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=872 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180160
X-Proofpoint-GUID: XNh2Mby7l3UChX4SyuwyhBIXUUF79htN
X-Proofpoint-ORIG-GUID: XNh2Mby7l3UChX4SyuwyhBIXUUF79htN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 01:24:12PM -0400, Waiman Long wrote:
> 
> On 4/18/23 11:08, Naresh Kamboju wrote:
> > On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 5.10.178 release.
> > > There are 124 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > Following build errors noticed on 5.15 and 5.10.,
> > 
> > 
> > > Waiman Long <longman@redhat.com>
> > >      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
> > kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> > kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> > (first use in this function); did you mean 'cgroup_put'?
> >   2941 |         lockdep_assert_held(&cgroup_mutex);
> >        |                              ^~~~~~~~~~~~
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Suspected commit,
> > cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> > commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.
> 
> Oh, cgroup_mutex needs the recent commit 354ed59744295 ("mm: multi-gen LRU:
> kill switch") to make it available in include/linux/cgroup.h. I did my
> testing with a debug Kconfig and so didn't catch that. This line can be
> safely removed.
> 

I can confirm removing just this line fixed 5.15 x86_64 build for me.
Thanks!

--Tom
