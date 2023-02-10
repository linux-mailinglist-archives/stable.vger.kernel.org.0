Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EF692817
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjBJUVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbjBJUV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935737F83D;
        Fri, 10 Feb 2023 12:20:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0Bsw020866;
        Fri, 10 Feb 2023 20:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=ndbkicgIkXcJ3JUazI2hcsLh5JT5tUISjlarLInMtto=;
 b=IjIDT9vTG2h45tjSAr7wdWIIp5DMfUZN1l4u3CcUXOUjUTdMS0Zi8M1/mBXrzIqBEdk8
 82HjbVA8cfeJP1Wtek+7w84KeDmb9RhtRtzJMUaysq6LuidCGx4TT80it2q/e4wDIYZM
 KE49PIV/e97V/tPDTY44M42ep9SgSjx6pa4tCVZFhsHH9n38vJC+jQ841u7PAGbOlrTs
 5LDYwXp3dLmSq5Ss24hBBSOnbZ2EqjW6RFPcx4g/SS1F2Ff+j/sBUuw6cjdWjep3gICV
 JNQrvRWNSrGZYAnE9fZCy/2UjrNnftSx3OPZZFVS0YpqVqYsm/Yblz3zycLz656MhtkB MQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwue4fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJX0UZ002975;
        Fri, 10 Feb 2023 20:19:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7hdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ/kt/348hARB3HbCgRgxh9H2JW8IX9EmR5Byo1bcrDVDBGwWEqZEUr9qpufgktx7b8KC9fIRcMTaQ2UXbLAxd1T+BKA3wNgq2q3ApGra6H6/VyaRKaHZ8xY2VeSPHbQLGB5DWlSHtTyG5EmTpx7t8VMmGPhPJ0sRuptFBQGDQl2tgGgZvi5QPgW3J2css3sQ5t32lThjRnQPbwUQetkYm6cfGsfqPSNZPZQ3F9Qr2IE8NJW+adTMmJ9Hge61soUnglAW7s1N6VCxBATlI1AMb07XqPutqBfrwejQlxc1e9CHydwTt+T42B7w0vRY8xzNR4HJ92f/1h20C5xrK3hzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndbkicgIkXcJ3JUazI2hcsLh5JT5tUISjlarLInMtto=;
 b=n4XAElFfeBdCrmhxkcSrYWghGA927jsu9TXuakiu4p+WhC2NbuS0OsejP0lrG+/tvoQ2njHsQIuwVCWmeWJ1x1udWMf0DgybzbgriDBjRtgSsiinztbQgjEMYH2IuDjYkSTXthhHN5bbfYnFww4U//P7jCviTiKVCdMR2D8K0M4UNuUN6CkDVRA1F1F660lJGB75PVEPcslIb+GdEwvrbzsCjCum4bYExi/5okVtclvG+Df+uYksshahZcNrawvS0j+4FyCOPqRp7f2wiwc1mkJl+Y6fKF2e/MylCYvUXUNvz4GJny3pXQddUyAAGugAUICaZj7L5qg23KYf5HIQZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndbkicgIkXcJ3JUazI2hcsLh5JT5tUISjlarLInMtto=;
 b=J6jSHxFPHmpiipEbIDJviubfPBbeODjBEFt0peW5lqpV36L2YcTfRmsgnZvu+20tI38UL0Kl+WsH6l9J0Qf9NBG6qDvjm3j1WW/UDNz+7KoCvyugi0L1UqsMueDbfeyaRvuqaZ8+jsEhQ7Pe8tGTBltRs6h1hiBOQaLI4+yo1I4=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:44 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:43 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.10 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Fri, 10 Feb 2023 13:19:34 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 162c504e-62e5-4f21-6111-08db0ba42585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrKrk1AqzJ3U3moEY68ndgFfTZKjZaezTLOZr6wQyO8fd/paWTIdBwe0r3IEIMOi6C61BI5OEN9oYw21whrnLcgpLdn6tCI6DK6Wwk97VtpeMociKM7++XegSNgwnUlmIItvtOioqybODAMWbfx+w2VUjf9nbZinDz53CpPKt8OlzEiDFXSWGyx7u3DZ+RSOPUzKqS5Rk9uF48p/e35NmK4iXX+jbypms+9pwp3nif1mRZgzWRpd9o/Y8INkIjKj6aFh6KLyNgPJmgIO5a/xvJuEZUiisksfDi0W9PmoDkQUipW81RUBRmaDCGzz905UB1k3wR6mMFWZAjGGcBWkynn5LvuB9KlVhe8oqfNKq13iTWGYDH5KECoVEYOrUc+WAdT/3B78yjBHZw7ekiHN4FlQLmyGT0OBS+rPt6dVqR2fFoK5nMqg5VcC8//Wtyoazu1BrKGdRa0yW13EwItwszSTqFhfBsMDCz7WYQ7WF0ohILEbKxYCqgw3GLRh3u+VD7nvc2278+Z9Fa+MkAc7IKDQb04RavXEXQVRRn+Av/9LiUEskCj6Xzk8I0M8r48RSBTLFZ1Uvu1lA9FLBUdl8jT2rM4QXnNGBg1ZcRIr4haIjPNRgCW9jADjMrf1oPA0nNOFDrrQTQrKXRhgZ+yd7TqYX7FdBXLQr1WKiouNZqbbHSCsj4N7XAqPLyUuydYGTOmFP5+DFwqlx9fQlhSdiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cllUdU1HYlZGTjd4MXhLeUxUN2FkSlpLWHFLN3pYbHJPdE1sOHRuYkJKZUFX?=
 =?utf-8?B?d0FzcUZDZUgyZFVMK0RKWXl2aEFwNVZncTNNQTlyZEVuNVVIR2pZeFRzWTNv?=
 =?utf-8?B?TkJTWHd4ZkhjSWM3RXdUbGJZMk9Yc0NiM0ZnTlB5VTVnV3l0SUptSWZtNzhL?=
 =?utf-8?B?Rzk5TDZmOTJ0UWg4bHF6eHlMTklObmVNSnpweVhQSUJ4eEx3blJjeEpnSUYx?=
 =?utf-8?B?U0dZMW90WnRxR3RYTzhIN3lKZngxMzZWUGlCRUhtSm9UenUvTDhlQU1yR3I1?=
 =?utf-8?B?akErTCtiZWVDQjgrL25tMU1wVUcvZU1sUzNzSnF3R1hDeC81R1FnK1k3c2dF?=
 =?utf-8?B?RVhJV2MyMXVGSHJpbDlMb1pkTzIrTkdiT1ovcldwb29GcXlOT2NwcVFXTGtW?=
 =?utf-8?B?TUorblUwY3pYN0JXVlhleDJMZzVhelRsVUM1KzlPNmtsR3BLYUtsb1Q4S25Q?=
 =?utf-8?B?TENSTURmYWx3d3J3S0J1TnhpYkZLM3UxKzRTVkQvczI1b0pEZCtHMWVHSGNW?=
 =?utf-8?B?QmVOckZTcHZwbzlPLzZidWlPZTlHeEdZcUxnaE9idWNPVzJYZzVnL2hVN3hq?=
 =?utf-8?B?MzJ3cjh4MVN6TkR0Ylk3WStLRW1jMmxTRVdITTVlVWQ1V1NSUGZicWFNTHNY?=
 =?utf-8?B?UDhUM2kxK21lSjkxVWZHMkdSaTZPRVUxMVhTcFRzcUJVUzVQTm9SY01xZGc2?=
 =?utf-8?B?NlluQS95NjRqaysrSDliT2dhVkV6eER4YkIzS2Rhbk5nUXo2UFV2RDNwbDc5?=
 =?utf-8?B?YzlTMGpya1Foa0E5UThwZjBNMk9icXk3OUZ6WGNtU2dqSDZodU9rWlFUeWlW?=
 =?utf-8?B?c3FPcE1BSHhNMXo5b2R6cXZDVC8xei8zZFB6UTFNc2pacVRwRTJmL0R4QXlN?=
 =?utf-8?B?cXVyYWVYRFExUmE5eG4va0huK2tSOWZtd0lrWDUrNS9sYTNZbUpyZWRTYWZF?=
 =?utf-8?B?bTkveFFmM2JzTGZXbHpYdmsyUnJseVl4MUdBWTV4YUdFd2kyYlI3U2p5ck5j?=
 =?utf-8?B?bWNYeVZneDFrVmdwQS9UYmtvd0pZLzdxSmovYWw1ZlIweFlTUFFDRWZGVmJw?=
 =?utf-8?B?VnIyN2doS1R5akRwNGVUSzlTQ3dqSVd3YW40R3dkczJSZmFJbzFCYWpLRW81?=
 =?utf-8?B?WjJZWXdRUGhBY0dFWDZMRWg0QW83QnVOK0NXVk16ZUZiTEdXVk9WMDF4MFlG?=
 =?utf-8?B?VzM3M2MraTZXWktuRXQ3OHdlZWZKYnk3TnpacmViWEhwa2tOY2RMU1NJVFJh?=
 =?utf-8?B?dnBkNmdpUzJlK0srOEUxZzNURjViSDAyMVppQ29pQy9oenhFV3hRRVpkZGdP?=
 =?utf-8?B?ZHZGcjdwbE1DRjMvUkVEYlgvVTIxaWNLT216MTVUc1NwY2lMNnVVdTF5UGJh?=
 =?utf-8?B?ZCtXZUprcVlNbXFXZnE0VDFrYUNLeS93OHdqNGgwQ2Y1ZVpscEZaVWxTS3pv?=
 =?utf-8?B?VEhZa0V1dG5KQ01pdk5Cb0FVcEdDQ3NFaFJNTUk3a1JvU3k4UDZPV3NsSmI3?=
 =?utf-8?B?aDFRWDMvNXJCRFdBajJhRkFHYkVMT3RDWDVBd0pnQWlQM1ZlSmJIL3FnOG1G?=
 =?utf-8?B?bWNyL3BrQ1M1ZzE5U0dPdjZhUHNyRVRSMVAwb3VMMVRtUFBaYUNqQW16cjhs?=
 =?utf-8?B?NlJyLzBZR3VQcXExbEszcWc1V3VXQXN6NmJqaVVRM3pkb1pvTnVkTjZqNjdR?=
 =?utf-8?B?RlJ6KzNnSjhScmk0UjhEalVvYUxCa084ODVrcE1KU0FFejFVK21KRlpjeVBD?=
 =?utf-8?B?TmpQMlRDQlA1QTEyaEZGRUZmdmtRV1ZtbU42SHppMU5CYkF4Y3NKcVc3aWRw?=
 =?utf-8?B?TkhPVDRwUDZYN0xkKzY1M0NySUpLN1JlUUdGc21pdUhhdHJWbnhVYlROcnB1?=
 =?utf-8?B?SVU2TU54TExITzhCQnJKaWFqTHNJd2lRdHd1RzhHaWx4SmE2KzUvTCtRbFRE?=
 =?utf-8?B?Sm9rNmdDSWhHNGNrR2RndEFmZVhENENHTDErNnJ3a2ZObm90WFV6dVgrOWdB?=
 =?utf-8?B?NC82WlpJNlpaWkFOZ3BaNmNUVUd1VlNBZ1NZYTF0N3ZRL0Eydk1Gbm80S0hM?=
 =?utf-8?B?U2xiOXVBMkNaSExUMy8zTURCWDFIQ3BPQ09ORWc1UEJ6cW9Cc1A1amZZSzNK?=
 =?utf-8?B?SFJqUWNUbUM4eGpoV2ttenQweEgzWlloV2FPcDJDWnM5ZzhhL2xzZjNGZ3JI?=
 =?utf-8?Q?3aRUDxyuGBHx2XgvCR7W36Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YWROT3E0QzhJTXdxM3JVT292bW1NTWhvOHRCM1ppeGoyZDU1SkxyV0krenYz?=
 =?utf-8?B?WXIySmVmaVExSko2cUtkTk1JZE9Cc0lHRkc4M2xUZUpkVDhPbHIrUzZwallk?=
 =?utf-8?B?dzBPQmhtb2xEYkVLRzZpTHdTSFg0VVNnTkpSYzJpV08yVUptdTEzbDQ4WGxm?=
 =?utf-8?B?Q0NaUjRNc0tVY0xLc1gvdmRFcGxVeSt2Z09jdEdOK0VDN1NIZlpnalhyb1RV?=
 =?utf-8?B?NmhTTXducTJoeFVEQUVneGNoQVpMV3lCYjZPSE5LWFdIZ3dqb09qeVg3WUdU?=
 =?utf-8?B?SHZCTEZqdVRXRWRwRVpGb08yTU90OU1ocGJMRGFXbWNyOTRTdS84QnhGMWcv?=
 =?utf-8?B?R2pSemJRMzNRamJHUEdFSVdsNjFXRFp4cFljN3pCQytYc1MxMlpwV2d4bStX?=
 =?utf-8?B?MzR6aHVXcEV1VVpIdWw3ZFdZeWV4N1ZHMS9XR1p2ZFFFZFJmWWtqZ2NKUmlT?=
 =?utf-8?B?cUtqZWpYZlNSWjZQUzBwV1pueW1ybWU2Qm11UXB3QkQ0TlNzWDRnWUxtYmRU?=
 =?utf-8?B?UjNkWTR5VUxncXFpY2NjV2hTQSsvNnRnVmoxQXB4akFzeTFYa1owQkJzcTBL?=
 =?utf-8?B?Mnk1RS8vOXlRTWZaZWE4RXpTOTBjaWorWWFzK2lQaVREVVVMTElEbk8vS01L?=
 =?utf-8?B?N0dnbXFRSDF1QUM4ak12L1BWSFpSMm9mQlF4dXJmOTJ5dVNISHUyTXhpeExi?=
 =?utf-8?B?Zi9tZFpUQ3F3WUREUjhCcWhSWitubEZjNWNTMzZTcEdlSEJBbCtWT3dmWTU0?=
 =?utf-8?B?RFp6dFdKbEJ6Q2JMZ0V3TCtJRmlCdDlKVmMvbE41RTBaVGRXRm9qUG9LZ0cx?=
 =?utf-8?B?ckx4T28rZlViU3NxTHNPZE9qc1dGUzZXY2VEbjRkVzFRM29PRTRPZTRnN0dz?=
 =?utf-8?B?VXl0NGZUdXI1VHFTK3o4eHlVU3R3azVkcGE4ZWxoMlFCdmM1VEl0SVRGYWZV?=
 =?utf-8?B?M2lBRm9meXUzNXhBY0F1Q1JycHJVbUZQVGFmekoxV09kKzNVVnNWWktQRkVW?=
 =?utf-8?B?dWt4ZXB4SjhZQmtxZXpWcXBPNGo5M1pOM0c1N2t2cWpEZW5yQzB2Vk13bnpy?=
 =?utf-8?B?eVZ3TUQ3MkRqclZvWHA5OGkvTGRBYzh1L3FrVDVneTk3dll1MkFlR09XRVda?=
 =?utf-8?B?U3JIVU1DWmZ5cXNHRHMyM29LV0Vvc2ZtOUViUkdwMFYrdU0yejlHNEN0TFNK?=
 =?utf-8?B?QTdPVnV3clFWaG9MZ0hXTlhXd3pCWElkYzVqQjYrN3VhYW5IOUt4SEkwMEMz?=
 =?utf-8?B?MFAvVUZKa0NzYnJPbmhPNFpSZWdwYzBTc0hvN21LUzViWi8zRkVqN0k0SlJ1?=
 =?utf-8?B?QzMxWnVONjNOWkNjTDNpczF4UHEyTFNmT2NaZ3hxTlR5N2M5VUdOOUsyVC9j?=
 =?utf-8?B?bjM4VU1QZ2s5TFZTTi8wVWY4QnZqS0kraUk4ZDlvOWs3bk1wTUZaZll4SGcw?=
 =?utf-8?B?aGhrcHlpVW5ud3N2YW8waTBLdS8zV2RsVURkOUloZUVwRE1lam5Nb3BRWnhi?=
 =?utf-8?B?Ym5IZEF2UkNPL1V3QXhQTmtzWjhOalBVRXF1M0I2MFFyYjJwNW9QaGlEaXpU?=
 =?utf-8?B?MjVNVmNQOGF2LzNnQ1V6NG5zMSt6Y1R0UVYwQTFkZDFDVHpOejRkNm02anYy?=
 =?utf-8?B?S1RFZjVuczN3aWd4SjZwSGZ0TmluTlhUckNMRzF2TDJodEhEOGZONTdDQldT?=
 =?utf-8?B?OElQWHJqZXJpOVJvT0dHTXZ1ZEVjdW05UjZHSU5hWXBXY2pIZFdCVE5OZktM?=
 =?utf-8?B?bFp0dWJZK1RqSTNKT00vaXRyV0hXbHNZVnZya0MvMFNjZldSV3BYVzlrQlBS?=
 =?utf-8?B?TWM2aW5pTkV2WW81RlR5dz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162c504e-62e5-4f21-6111-08db0ba42585
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:43.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHOYX+s/XKAUqtWNHFWKn5zifKFIZvEH7rmwRlw35qcRVFInL2klDrmNxsGe2UJFpwARamH5Htw9+WqGP4J0zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100173
X-Proofpoint-GUID: Xka0D4qzGO9ZzSJ-YNa_p8KclKum6cTb
X-Proofpoint-ORIG-GUID: Xka0D4qzGO9ZzSJ-YNa_p8KclKum6cTb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
on 5.4, 5.10, and 5.15

Backport BuildID fixes.

I've build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.

  # view Build ID
  $ readelf -n vmlinux | grep "Build ID"

Changes for v2:
- rebase 5/5 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream

Previous threads:
[1] https://lore.kernel.org/all/cover.1674850666.git.tom.saeger@oracle.com
[2] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
[3] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
Masahiro Yamada (2):
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
 arch/s390/kernel/vmlinux.lds.S    | 2 ++
 arch/sh/kernel/vmlinux.lds.S      | 1 +
 include/asm-generic/vmlinux.lds.h | 5 +++++
 4 files changed, 13 insertions(+), 1 deletion(-)
---
base-commit: a5acb54d4066f27e9707af9d93f047f542d5ad88
change-id: 20230210-tsaeger-upstream-linux-5-10-y-e443820440f6

Best regards,
-- 
Tom Saeger <tom.saeger@oracle.com>

