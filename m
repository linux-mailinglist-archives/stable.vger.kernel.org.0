Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1EF6AF676
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 21:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjCGUNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 15:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjCGUNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 15:13:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489C7A0F32;
        Tue,  7 Mar 2023 12:13:28 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327JwneV018496;
        Tue, 7 Mar 2023 20:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BBU6Q9c0nutStbYGNP8MegdjkZ050GsfwiNc9NBPM1w=;
 b=cze5NZQzSeZtKWyWctd4UPAGAUHRrfeZyfXX2AaqPdjC/qj85oS1QhInNpjT3GANyEZ8
 HZpm1mIa3qTe2DL9SsHffakv7Uowa+c7yEfFkJBgCf3Qy71SaB9LIOSmsSLQagYNWaFC
 bPAIroDQBEen8XqN3FH1RonXtPg6SZ5idyiS/vq1DVzRtl0gBi34nNXoLm76tzvSACBI
 rrQavM3YAI3R9fbX9ORkaGh4rsxqZPFjUBkx3c21T1YnJvoO/RMo48eoYWGJYdo9qFEK
 9ClfDvV7c1bmM/q5JEc3Xk+bdx507YnOwr9hsU1strAwZPb1IMnvLxsjP9IhY0pL4Km4 1w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hxjyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 20:13:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327J8nhC025142;
        Tue, 7 Mar 2023 20:13:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4ttkh3u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 20:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiqBcXV9dzbjn6k8ztNsfgpjbXsix6bBfuBhtJQXGES6micBi8RpPmLlXuZf2c24umXTSLQbUmFLsAqPDwdHpqANpPzxxJG0u6lrKmb2e2R4+s2ZPpDjGHmr7nGhKyBq3TaIJ0EIbkzf1/6yTSvm/HhtYo5OKupl51qK00rrdmVjekk07GvroLSSUfqd3GfoHFo9k1/JGDUZypKXRRUsYd7sJ/qO+DQJySOA+JoGUXqNGE7Haegcf7SfrcegIiLc5AkPFZmVbKhlB4Q0aY+/XhoY/0yYzwk/K84jmW8IlF1uPoLnV2P9RihaZZftMG94PbUyOKG9sj9NIURVrD1tmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BBU6Q9c0nutStbYGNP8MegdjkZ050GsfwiNc9NBPM1w=;
 b=lQgF68p2L+xT83O38wsb0tSnEB8EBlJMMlGvxP9FOmxmFWBw0UUP25NQLNtM4KaCBY2TATZFUqLD5hmM2Pad/ItKAxe08ZR0fH2dlx0CgN34G85SIAYGZT6Bo9XA6Q0HWjCVXEYeU27AUFHhVuyPAntVhu9/Eko4DP+GA8ZxMpsAtA0TxKn870aNOCnfbg8KxMVO9jOYddxDE/v9fILwOXieQxDTMMw9wSnXI0/kK1f36w9zY/a7aqzsxzJkv2z2Od1YBWYFfsgorWrR7C4TgE4wMJfBaNtgS9CCiW/B/jrnm8wvujd0E2pGvm/x4IUHASxw84ed/6NYoZHE2LqbYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBU6Q9c0nutStbYGNP8MegdjkZ050GsfwiNc9NBPM1w=;
 b=yD93K5YPKZmAv7HH0VE/sFi3wLIopfM0TPtO6XU60ryYDAA8ltwhq9s34zooGajmffAgDbz8huYG2BQCLloJjMW2W8ayzLtW3MlyfyrqQJ4OhKdmUsXrIsBCW0QcOfun1cZgNlPIljTinpyZ9UYyU30QQj1vGnCXWKNby4oxGYk=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB6988.namprd10.prod.outlook.com (2603:10b6:510:27d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Tue, 7 Mar
 2023 20:12:58 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43%6]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 20:12:58 +0000
Message-ID: <583f7dd7-dc40-724e-aa49-33287754cc5c@oracle.com>
Date:   Tue, 7 Mar 2023 21:12:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Darren Kenny <darren.kenny@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20230307165905.838066027@linuxfoundation.org>
 <6f792ece-b7c0-3af0-b1c0-631f1cc4f5fb@oracle.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <6f792ece-b7c0-3af0-b1c0-631f1cc4f5fb@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0080.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::20) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|PH7PR10MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: efd29742-bc62-4746-37cc-08db1f485828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aC4bNv3iBiwCpq5LiREuT/RVyPvsGJu7fS2fFgKAx2vApGBlMVkw/eYBZhlvof5i4m14/2pFwoWm+YC4+4FHMEBB+5Wy2vHbe8FGlungEvwB8nAvEk0FiMYPsDhOjKMccc1yFsdIYryT54ISuodtH4e4cyFUAxijPMUMoPzT6g82fer6T5q0pxmAbypTKdiputP6XmH8dt7BvYJce/lQDFm6pSHSbqJfOOUKkFetmmDm8H1RkPkq6AP+A37bauAFOefJ/dUPjjj8gquhbQ9/0OtTjDhibYWjTn7idu/GkhYNba3PYHrsO7mXDTImsRS5z9PBUUeWIXiGRwrtQJJgRIHXhanvZaxgvu47CJr9zgzx4j5DtTBT/Rhh34SW9fJF8effLV4G961L5+V9+2Z9EVDYOsos9BwgZMy4vp6qUJT6AdJDMgRv5foZDYPG7APxhcOoje2su1TWEYaVzfMCd68txrcJlY9E6sRc0uGQ2Qx6IXGuQzVvlrU++ZmeD5cMQ7rq3gUT1sjkuFS9dJNb7w/pLR4/5ul92UnEnn2qoeylnRqW9hxqe/85yFAnTOxoeHNO388XMs2PBlH+MVFUPQQiOMCRoG0116rkQiE/azL+z/1thXYEbpu8sH04dgYR1q7AtDLx/twoQTfbzlVrLmkxV7auZvaUZIeLuzQGvqP3Z4XmFKz8od1Hxc0VxogmtWlQZlrG9elT//ikOVNtvEnaRDLQ2EEPjcSkdy7Gd0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199018)(31686004)(36756003)(38100700002)(7416002)(478600001)(8936002)(5660300002)(2906002)(86362001)(31696002)(2616005)(186003)(6512007)(6506007)(53546011)(6666004)(6486002)(26005)(4326008)(316002)(66946007)(8676002)(66476007)(44832011)(66556008)(110136005)(54906003)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkRQRU9pU1N4YmNGRGZxOEpCUVRkcjNyRVI3dmdIblJLOFMxQmZiWEJsSUND?=
 =?utf-8?B?K0Q3S2hhQ3VIV29GVmdlbHRNcmZPTFpXQk90bFFhajhrTk1YMWpKR2FLOTZ6?=
 =?utf-8?B?OGFjL0xDUmZsRjRkcmgrOGlLUUxON05Bd2d1QVJnSE5HaFI4UjBYZFBSM214?=
 =?utf-8?B?TlRiOGxkelFMb3g2QjJacUVjZnlxTGpDWlpOSE82a3BkNVFzT1pvU3laemE3?=
 =?utf-8?B?MkdmelNocTB0S0hHb0dGc2NWSWp3RTVQYkhES1pDWExXWXN1VGdxMEVDVDBw?=
 =?utf-8?B?VFpGOXYzRThZZUxpMWd2QVEySVQ3d1dRVnAvZDdEM0lkMlN4eHh6ZnRqQmNE?=
 =?utf-8?B?M3Y2RHpzVnlvRkY5QWlyMWQ0blpENzRTV3Y0YldXYXEvblRLKzZ1TWFWZEJT?=
 =?utf-8?B?bzJqQ3g1dGRDMDRhamVOYy8xb3VYQjdIWmpscEpacnFSdTNOTHRwS3BIazBC?=
 =?utf-8?B?c3EySGVNSHFiM2s3UytPRVJDZldQdVRweUZaN1FxR3JSbnlvMFZjZ2ttNUVD?=
 =?utf-8?B?dDNWV0FNT0pEamtreVdhakowZXBpZHNmcTVYaWY1cUc1YWpxQnRNNW1GdDRB?=
 =?utf-8?B?Nm44Q3I4dkxYQXk5MjQrT3FPUXI4Yk8weW9wMitxRlFCcjBxeVhRTkRvb1ZP?=
 =?utf-8?B?cHdodDA1SVgwUEVCVWlaWmYxeEpDUWlobTljKzlENHV6K0hFQ2VOTllTS3oz?=
 =?utf-8?B?alNUQ2tUWlhIL29JZGdDNGdPeUx4dnIxamNIVTdXM0lsZWl2SnQ3aDNZcEdQ?=
 =?utf-8?B?L0xnZmhjV2FNMm5wL21NZUloeE10cXQrcVl0QXcwZlVVYWRxSFVDOFQ1bytC?=
 =?utf-8?B?eE93bXZESW9kVG94ZUU5RmFLU2tZcHBhKzBWcUdFcERCSEdhU1F3bEpkRUFU?=
 =?utf-8?B?THFEUCs4ZENpeVU1QTg1NFdia3FVZDZJd0dVbEo0WU1SekRlcEpxRFJ2TXVT?=
 =?utf-8?B?TEFINlFZbXBnYTZFdG5oMUlNMnZUSzFtZTJVQUQ2d08zOVQ1SHJTTDVRay9y?=
 =?utf-8?B?enhLcnYxemMxVGY3eTA2YXBUVUVIMUY2U2tySjZZVUJEWDVkNUhJd1M0aXlD?=
 =?utf-8?B?Z2NkdWxaYVJCMjVtQXhHOXZVNjhKT3J2aGswL25yOFFibmlMd0x4NENoTlRK?=
 =?utf-8?B?WGduNitNRHRTb3FOc3hPYkc2eU4xTnkxLzA0T2Y0dFg1MzIzK2F2OFM5Vnlw?=
 =?utf-8?B?bk5nazd3SDNHaldDTWFZdC9zc3R0aXVxVXhFemU3QnJCMmllZlJ0OEJKcGhV?=
 =?utf-8?B?UnhsQTM1QmxwSnpuZHNkZkxKNHpDcllycFViRTNtMk1nSG02MjhUMDVxTmtP?=
 =?utf-8?B?S2ZWNEJCOXhFNGN0VGpUQWxMd21xejV1cjM3UWVrTWNxSkNpY3BJaW5ZSDM5?=
 =?utf-8?B?NndnV2l5ZFAvZlRXSFd3RUVLekpCNDAyQWtxbTVTOTZobGE0aHE4am9yWmI5?=
 =?utf-8?B?Q0lBakdmQ2w3VFpjdXZQdmdHNHNzeVN1L1U3NFlXRHBGdk1YdENyWFI0aVk4?=
 =?utf-8?B?clFvUVE4aUZXNkVqQU1mNE1OMFkvYXdSY3pRNVZ0NjcvdmhraUNMVkhJdjl3?=
 =?utf-8?B?TE12Nk9TdTlEbFRHRkdrY0FveGxGems1RFcwbmhncWEvbDFDVnZrd3A1ck1N?=
 =?utf-8?B?c2ZwMGtPK3lZZ1pVK00vejdKakh4cmF5eEIvMFZTWXJXLzJ2TitjVzZHMHZ0?=
 =?utf-8?B?NlF1Si84SURZY0x5ZzZxNkQ5T0YwUnpPVWF6RFNDUnIrL1VuVkFieFBRbEVG?=
 =?utf-8?B?YnAwWHZ1S015SldxZDkyRjNTTTBNSFNrQm94cnRwS2ozTEVZSTRjVDVaK3Bo?=
 =?utf-8?B?bnBSenplTWJLakgyS2JFZHJod2ZFWDdTZEVyd2tXSmh0enQ0QmJBMW5wY2I0?=
 =?utf-8?B?bWk3bGJSN1FaU2FQYk1JRTd0dWUvL3FCakNmRWtlOWdKdWUxUll5V2dWN3U3?=
 =?utf-8?B?TEI0Ty9hcElTTHZRMVhwbjBqdVhoRWw1L3hMZVlFNW4zRFlNejYva2d5Y1o0?=
 =?utf-8?B?ZkRPenMzVFZQOUdYb1BUVDBRc0xrYWFnZHg4KzZ2dDNJR0pKU254WTIwR3R6?=
 =?utf-8?B?bk5rWm9DcWNYTHYzamdtOTNLTW5WcUhWeHVUaG1OdElOZURRZkQzWWJqOHJB?=
 =?utf-8?B?VDhuWkdBaGdPb0IwSENERzFVcTZaT0ZrMVRsS2pLTjRONzFibzBOeEttWW9M?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VXNkRnZDbkREN0RnZXhNMUV4Nmc4cEpsdGNTYktQU0plOXVLMzZJT1orZ2N5?=
 =?utf-8?B?MG5nUzJhTkZSVHVVekxmWFlBTEZCeGdxb3dHZHRlcDUvQjdaSzlaU1BiU3pv?=
 =?utf-8?B?S3g1T2pGSjd4cXB0c2ljSHVyTlhVYVE4ZWxxak5uOXlybHc3WmFTWVhBb2VB?=
 =?utf-8?B?eUx2UzhsSThDa0E0Q2lZVDcyZU5GMWNYa3FuQ085RWErbG93Z2EzWFJsT0NF?=
 =?utf-8?B?T1Z2VVNtU05MRzVJR2hMWnRXQnRFSjBCdHZUUkVsSmNXdEE5NWhMeWlBZjJX?=
 =?utf-8?B?QW5kNG9hOGRURW9JV0RTQldsLy9zZ2dxVEE1YWNEZmx6SGVNaWp2R0dPbEZM?=
 =?utf-8?B?QXhPa1o2ZlNFTjAvT2pBVkZQcXhBanc1U3FFVHBkZWhyejBmc3V4SzRrRUZt?=
 =?utf-8?B?ck5lY29od3ZsTldrV0JreGh1dldaVnRGalhIeFlCbTlRRUE5MnJXVlV6eW5G?=
 =?utf-8?B?WHV4YzVlb3o1WkthSUl6YzNCSFJiU0lRNmVhZ2g2cHl6cDBvR3hnV2k2T0dV?=
 =?utf-8?B?WjBkMmw1VnpXR1Z1SHllVU9YY1BWUFF6N2xjczk0ZDFGQlVvOXFpbnVYaHFO?=
 =?utf-8?B?ZTkvQ2Npek50YUYraDNMeXlCV2dSNklEUUFDL2FHZGNwSFZzcXBvdWVBOW5y?=
 =?utf-8?B?RWJGWmdGekNjVCs4b3REeGFPK3g0M3g2TlRYcjZTNExKemZlL0FZeXNzQWhW?=
 =?utf-8?B?ak1DZSswNjNmUE54b3hUV2hyVS81Q1lmL2JmcjQ5KzAzTytuV1JmTVJJeDls?=
 =?utf-8?B?Tk9oV1A2NGNENU95aDJ1MVNJM3ZyblFhMUdzY21IUjVrbUtUaHR3MkY4Rzdy?=
 =?utf-8?B?MWdRQ0d6cGF5UGVSL1hMcER0SzlZaEdjTWVxQ0VKRU84OEhkQXhxQzMrR0t1?=
 =?utf-8?B?M0NuZ0RBVHBkRjcxT1Fwb3NkeHNubTB1QitTcFdybTRoUXV1VlU5MEh4STZr?=
 =?utf-8?B?NDhTeFJrWVhqZU9lcVFRVisrcWVEQ2ZLVEdjVjl0T29VdjQvdm9xOEtWZlBU?=
 =?utf-8?B?dTlhVUFrOVZPUnRuOEkxM05OMWlMdXJrWTlxTzhOckZNZjRBSjFaU2hOVUNw?=
 =?utf-8?B?M0tWYnlEaTAwWDJ3RmovVGNRNnM2bXFXWFZrc0NaOSt0SUM4SzFKS3VrMVNj?=
 =?utf-8?B?L05ZSW9zbFNlbGRXTzZ4Q3lDRWNMdjlyRjRpT2xsUm1ONklNQkZ4UWwyZzh0?=
 =?utf-8?B?TmtlcDNyVDRaUXhUUHFZRHNpOHE4S1hVNFZpUS8vU2hSMHRmdHpwRWprN080?=
 =?utf-8?B?M0I4WWVaTjBVdTNiN3l1SGlWZTJmWHFYT2xlQ1R0eThWbVlHcWVvOTF0Q1Ry?=
 =?utf-8?B?MUFBTVF4TlE5SkhscHZtSEF0eDVjTFVuZGpiK1V5VFcvNE5CZFc4V09JWlFv?=
 =?utf-8?B?cXJxV2pDV0ZjU1kzYWtYemg2ZXZPSE01UDBrQmJ0NVpsMlBBQTBBN1d1aWZi?=
 =?utf-8?B?SktmZnJ5U0dadDhNMzVlTGE1MmZQNTkvQnRvb2YvQ1pOREpXRzI0M2lncnUv?=
 =?utf-8?B?Qkp2RUduWDlUM3NmbUxjamR2eTU4d0trV1hSWFdpSS9ZRkI0eGxsWUk1ck90?=
 =?utf-8?B?Ymt1MUwvMTQyUGt2TlpXaitQQzF6dGVoSzBaZUR1bkp5bDlGMTJlUW90Tmp5?=
 =?utf-8?B?VlJDMkZ1VUtqTXNMSjVtcERmV3pOMTlBK2ZoRnAwc3hjNmxaalkzNUVCY2lh?=
 =?utf-8?Q?jconw3XhtfOMz2CFwgRG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd29742-bc62-4746-37cc-08db1f485828
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 20:12:58.3159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvaKFdXnsuCDzTlpgken2mEJYi+bCC2RUhwy1u+4jGwD61rzacN49TkvRI6cJ75ZdqjZbiUIvD1vjpYKStGvgQ7EO2jKiblHjCOOkUaUIeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_15,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070179
X-Proofpoint-GUID: dBAPprt2AKUIBjT8KDZipdzR8jeVzLYI
X-Proofpoint-ORIG-GUID: dBAPprt2AKUIBjT8KDZipdzR8jeVzLYI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/7/23 21:02, Harshit Mogalapalli wrote:
> On 07/03/23 10:25 pm, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.99 release.
>> There are 567 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
> 
> While trying to build 5.15.99-rc1 with
> * make -C tools/perf all
> 
> The following build errors are seen.
> 
> util/intel-pt-decoder/intel-pt-decoder.c: In function 
> 'intel_pt_eptw_lookahead_cb':
> util/intel-pt-decoder/intel-pt-decoder.c:1445:14: error: 'INTEL_PT_CFE' 
[...]
> 
> [PATCH 5.15 264/567] perf intel-pt: Add support for emulated ptwrite
> is causing this error.

In addition, cherry-picking this fixes the build (but we haven't done a
full test with it):

commit 2750af50a360b52c6df1f5652ae728878bececc0
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Mon Jan 24 10:41:39 2022 +0200

     perf intel-pt: pkt-decoder: Add CFE and EVD packets

Greg: Do you prefer this kind of error report go to the 0/N email (like
in this case) or to the specific problematic patch email if we've
already identified it?

Thanks,


Vegard
