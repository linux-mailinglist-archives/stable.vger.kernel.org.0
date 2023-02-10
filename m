Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23E56927DF
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbjBJUTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjBJUSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:18:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FED9BB80;
        Fri, 10 Feb 2023 12:18:29 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0KQD017186;
        Fri, 10 Feb 2023 20:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bWwTDkraNTzxeWJjcZrJsMFWqrvOUuxhKoR5fnqlfag=;
 b=tdTC5VrCnFeXnh+zoCLt4xb9vP5DazkIJNxumj8ppFekJ8t8dDlTWXmt/RfMzj3s4H60
 EWndWoPUM97WfZ9mRk++9ja6Xs7kSDR60YNM4yYFB9IfS6AJAbxwLysTH6CTXjCMfruo
 KD/+Yivy1TTFXN/1Hl57jTVI1juHFhvnmAfu7bAMr/t+vQEtICDebg+vQjA0ludLm/uO
 Pcyq+buchPzFzwJ7luvOPk6qJ+OAGj/sxhqDrI7LJoXVyz7ykrRXnfiYbZEjTYiOnjlt
 8kxBjplU1uxDPGGZGlnm7cqQt1w/5MIQjGtzH4LgCx7jPGUKJQgMsIugFmVS1CYBbnIf hQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9np5n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJg6aB003017;
        Fri, 10 Feb 2023 20:17:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtb7fr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V877TJnu0GbGckfwiaJECALhEMRBw1SrXNmwj1CujrB9pW+KdBAn9EsYoNYLc3gA2meei4Yyl7KmTJwWssqpfscBUcFANINZ6jrTzpLnfo14rdy6bORDKN2ImePhSI6/afPozLevpCOn/bRWjEdzXEpZJrYfCG2SlYqwPOvsiY64ATIpqXhePkY2Fz0zwMFF9rPbQZdAueZ80a6Ni6CKx+C5rB0b1X8uJRBlTH74cruN3kHtpW8sqgP2SCALGe9GAxWurCe8eWn21PWIr4UDImsgho296HR5UDAS/0BMLJoAGRt5WocxyXvJbkcnLxTNGuFNPcOTrPTjAWnIvIgdDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWwTDkraNTzxeWJjcZrJsMFWqrvOUuxhKoR5fnqlfag=;
 b=BT+msafWhT9mylhj3Dm6WvwCGfPZTBuhweWfp94X5iqyrUrqlMIZ8NGwKo5MYjL/4FfP1rEUp88vZzxFOEtjrfuG8/IR+r2ww5CjZZ79tTRq6De+/klOP4jTzDbVfggLXY/ej0iGIUGbGpmP6obl15PqB5p3/hHC3Tw1HcGIkAArayHBaDCqWjwgdbjTN8UNRwA7FLMpvXPP0FegnvViLx5b8+nAHXJ5Z8TZznp/4yQzBlh8RC3Lh8bJEeENJw7APUlSvSYnEq+RL/6cdzSdudAtdkcr6Cwyj8cL2yalnDy4MuuZPe2zel8J52cToq2IMVh1Y2MzVJ2TYDJEyjY6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWwTDkraNTzxeWJjcZrJsMFWqrvOUuxhKoR5fnqlfag=;
 b=ZWGM5bi7hA1S9lGoBXNh9RZWbpOm8GU7gsIPfUsi22oY48gVtU174iKerizAkyDcXGNbfFPT7wR0rCrSjrxUgfFH72e3a9DGGCy/EsE/PnfoYWocvK6+BHlggGXz/PAhDjFPfgHGMBm8rOc42IhP6NwSJXkpFzR45eVMmiAvvVA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SA3PR10MB7093.namprd10.prod.outlook.com (2603:10b6:806:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 20:17:50 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:17:50 +0000
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
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 v2 6/7] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Fri, 10 Feb 2023 13:17:21 -0700
Message-Id: <20230210-tsaeger-upstream-linux-6-1-y-v2-6-3689d04e29fc@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:32b::20) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SA3PR10MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 16eba4ef-d3ab-4e7c-fad0-08db0ba3e1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkWHLYDwXsgAt0c8ePyzz9U5ig6nhWdnyGVENddx5UW0Iy4OFXC78aY8UG26OZarQpHYUN6DOYBoE3EjhkCNDVn4b/nC6JPm/1FXLfpgFXk8z4Max6+jNBQTOtNkHX8lNlqo/v0c+ljSgy/uoOVNkRQSRUW1SxtLJqJIEtHaq9q7O70CWH+86ptGptYp2LlniwrUGUKHOI/or3dZI8ebd4lVaFXwJRqJFYdhR76fX1pMapL/KUfH3znQRcdC3FKxgE+L4cia+XNck8pofFTCcuWcTJ3idFhwtrlU+DCrPvDZ3dk5bOs4i8JyUh00REsxEpMacbMBrL+/E09TlWpCF20REiF8BohXhHYA8VOKsAwqCcHS3ScjuTOrSPrdaAtmadIWT+SVusi+xEGoKeJxmlQY4sICczzHdaCInElMarwU2t9GQn2gmtyMH0U1+mpmZvFEZqWs1ZVLfoa4Ub0lbP07KrLFWiYAU4TR04p3xzddYBqvyelbTImDRZPAvxUTt0skWfB49iJcQ3SCJ1PP4z8Yz4xiJJh1fMlkPXZfWFeyXw12UNJG0dxnrvHfxFjiATJKRnnrobrNCzoEZ4R82jEqVqgEWRG3QOHe2LWSxJkNuZSGORIz4z8qS3WYoFQz8nZ4MxI2fNW0iEXBLDCVdh9c+3U3CBeSDQ3pKHsLmgi1TgzW4qcjs4b5IUzErtYGEhrbrbQFMSkumQ91uKYMiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(44832011)(6506007)(5660300002)(7416002)(186003)(6512007)(8936002)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(54906003)(6486002)(966005)(478600001)(66899018)(41300700001)(6666004)(66476007)(4326008)(66946007)(8676002)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTJOeElXOTZ0c2I2VCsvbHRLRWRNaDUrVjV5TXM1aW9KVjJBKzdpMHE4Y2FG?=
 =?utf-8?B?UWZmdW1zaGJ6ckUxcW5uTmg3a0d3S3Z3WWZzQm9FcWJmbnVYekh3cmFPY3hl?=
 =?utf-8?B?NXBhYWlTNFR1QmF0UU5CVndWTmVzbitXaHFJNWtCSjRHWWkxQTdLNTNNUElT?=
 =?utf-8?B?ejBmd0p0cVZKTHMyZEEyNk80dVgzanMxSGZ0bFp3TDRZMjhFOHZpYkh1Nlpy?=
 =?utf-8?B?Y2dzNFQwalM5azN6UStXNHJMZEJxTUpCRUQrMUxWZXJVclZGTStKOXBLSHhO?=
 =?utf-8?B?bVZWeHJiTzJYRkpHTW5ZRklCak1tRE1YR2w2OHljcUYwbzR4WWdQZ2t4UUpZ?=
 =?utf-8?B?OGZHUWR3YWMyN3N4T3hiaGhuWFVnamZyL1ZCN2dNN2RqQ0NmT2l1NlYySm1P?=
 =?utf-8?B?anYwS01QSkdsb25iOVNJZWN2amFLZ3d1WVlnbW5leUViVTNRbGI3a1BvWXVp?=
 =?utf-8?B?N2ZRQkhFSk9qZ1J0akRYZWp1L3NXSFlqOWs0amcyOHd2TUo3SDBTNWs3QWxw?=
 =?utf-8?B?Z01lQ1c2RWx3ZHhpejFZNnp6TlBTd2pQTzhWbVpCeVFITDRIZUtMemZucnJV?=
 =?utf-8?B?c0ZjQmY4RmpRaFhwWXhXRUR3Z2ZobmhZUTNUcEdUOUh5aE0wOVRUK1pPemFz?=
 =?utf-8?B?bTZiS2V5ZXRLL0xqcGt2bFZQQlUzNkxER2Z2QTZsZXB4Sk9WRTUySVJCUXV4?=
 =?utf-8?B?YWprUXFsZ0pCWXlZM3hZakovcGxIQjdEVkhDVFprcVUyRDR1Z3BvOERHcGhP?=
 =?utf-8?B?RUNrT2xGUFJuYnlEd3dNSXFXRlh5OUQycm9mQVVMTUtyaGg1ekk2T1REd1VZ?=
 =?utf-8?B?ZHgxclVCaTBtNjFUUTYwam5yYkF0MCtiYU5rWGdOaG50eFgrWE1uWlNHQTJR?=
 =?utf-8?B?MUc1NHB1T3RxVm9ETmtBY0VPS3VCSkRGRWsycHhWa09VdGdnaUpSUGRYQ05M?=
 =?utf-8?B?VDdTeXpERUdGditKcFhVeTNSTGticnUwNFFyT3ViRnEvYWVCQ3BKQWZ3bkZs?=
 =?utf-8?B?Y25aN2VBcmlncURHYzNKUzUvTThETEtuZ3Z3aisrTGpIeFB6cGcwTHByWW1O?=
 =?utf-8?B?WkpnVEF3RzNUUFdrbGU5MjYzRkU0SFZRYXhJQTJlM2hVdW5CZVdkVllaNGJx?=
 =?utf-8?B?Z0R5V3lOaVN5enJqN3NlTzFSUEVsTFJlUVNuZWhDUEJhZTJIN0tlRHdoWE0w?=
 =?utf-8?B?dFhGZ0VVTFVKdXZVaHNHWmNHUTRlQmd3YTJ2YktCaFNxbllJRmRYdmRxYlJ6?=
 =?utf-8?B?Y01VbDJWUU1JQ3ZPR0ZwODBuVCsrcEhrc1VlRGNpKzJlSEtQSmgvQ2NzbmRm?=
 =?utf-8?B?VUU3a0FlNnlxS25pWTJzaDhBeXhPVit6MlRDZzRISThtQS9IOFE1UnJzcHJ4?=
 =?utf-8?B?WjZybUdHeWR2Qi9TQllPMnRRK2RONkpTd0RVMHF0U3lHSlk1d1NhNnR0SVl6?=
 =?utf-8?B?dXMwQmd2c1VOYUJDb2FNS1hvajEwNHhxY0pHZk9UVmpMUjhYN1NaamxoWkc5?=
 =?utf-8?B?V2ZvNytzdWFBM3lvdEtQTXBhdDlBaEI5clRKRTFvWkVZOU1PZkRSYVd1ZVcw?=
 =?utf-8?B?d21lQVozTHJJZ2RDMlJ5M1ZRVTBMdFF2c0JpU3NHZU9xZEZhdm9RZTR4eXda?=
 =?utf-8?B?MDNOVVJ1cGlRSEdvYXJIYXRBVmhwVExhVkNUaW03ZXc4eFByeWt3UDRVdXdQ?=
 =?utf-8?B?VmxxdDZRMWtRSDBHSDdsb3hlWllKeUtVN1U5RUJaTk9nSkJPTlV0RDRPdlJi?=
 =?utf-8?B?V3paTjdTSFJzWmcyZjNxYlA4aGhxTkFCYUd2aDhsOThRK09BNm5PdkRPNjdw?=
 =?utf-8?B?TlRqUUdCT2QzcWxkamdXd04rTHpEb014aWZ6a2Z4d3AwNUdYMTRhNFpzSHVx?=
 =?utf-8?B?Q3puOGxTSVgydDJwbGtiNzVSc0lsSnFPMUFGVHlEcERmNlZ6RFp0L0JaS1U3?=
 =?utf-8?B?aENyWmxUYk92b1hKMXd0NkNpcmhxUFBjSktGcXBGUHFSTW5pcEs1c0EweU9Z?=
 =?utf-8?B?dWdyaEZGNXZ4RUxnQzRIRGdBMzMwb0NIZ2JVbERhZ2txMXhUeUVRK2s4SEly?=
 =?utf-8?B?RXNtUVNrQUFza2RWTm51bjMzYW1NNlJKOVZhMlNDaE9hYTBwamFVVHNBNzYz?=
 =?utf-8?B?b0RvYlVPb29KRGphTmF1QVJ6RjJsZmliTmVMdWFBaCszVklkSStNaUtONzNl?=
 =?utf-8?Q?T4esKuz6u+8ehGedPMZhHq8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UER5YUFMY3NlK0pCVS9kcGNkbjh3OUxaWXhXcGd3bERtb3J0eEJvbjFSenJp?=
 =?utf-8?B?Z0IwWk9pY2xFZ0dXOFhsenAxRVd4c3F1UGtUTHlUdzVHbW9Na0VUeDB1ZFNB?=
 =?utf-8?B?NkxWN05kVTNyelNwakJiNmRuOEtpY3h0S05GMWpSTXR4OHE0ejFvaVlmeDlk?=
 =?utf-8?B?bGRIU1I3dGpIbjArZ01CUTBUemtYSGtnVnVwRTBPVnFRalFYMTE5S2RxNHRm?=
 =?utf-8?B?VWV4OGQrSUhwdkcwNmdDY1FsbDhQWFhkR0M5aEJSMmNDWXM0OXl0OU5QVnlv?=
 =?utf-8?B?di8wN3RhbjhrSDl2YWRmaVdoUkc1SExzYkxlZmxxanV2UkJPbDNDYStKTkRJ?=
 =?utf-8?B?Z0JxckVoWm5PQjM0U3V4TzZtSlI1bzBwcXlmMTN4Z3VMUVBabXBIcXhHbzU3?=
 =?utf-8?B?aElpZ00xQWZ1VXEyR0ZrbGlUUTFUSHJZbGs2U0pyUmF6WjlmQ0hUWkVEU0xZ?=
 =?utf-8?B?bTZ1SndWbC8ra28yc2prbHdvMXFoL2h2ZHdkbWpBVUorUGJmUEs1U0VCRjB5?=
 =?utf-8?B?eFV5dmJaQ1d4cFROVlorM01TekhVYzU0d2hUUy9XZTJkWTRJU1c0NEp1UmxD?=
 =?utf-8?B?U1g5Q2cxTHFwek1xaGxXeTRtYzJ5M3pLSjVMVHJDb2VTNS9EVE1vZW1QOXdC?=
 =?utf-8?B?NCsyQS9kbWdKbkovZzdzRU1odmQxRnlOazdNSHRYVFJVKy8vZjZsK1IrSExC?=
 =?utf-8?B?N01DRU8rSFphcXlpY1ovZEdRZ3h6NmllZVROaTdwcmJBcStpTE8wUjhmR09D?=
 =?utf-8?B?czZhcVdsR1RTd0prVkM5UkZHK2xvd1VQYkdMUVJaVEcwdnh4MnpGTmpha3hJ?=
 =?utf-8?B?Y1Z4bk5wTGVnTUtPdE9WRDVmRVZzNlJ1OExxTlI2OUh5cGlaT1NLaUpvSEJu?=
 =?utf-8?B?emVyUi9TNXZDM2U1dGNrNW8wYWNoa3JUUUlFdzh1bW80TDZET0oxT00zcGc5?=
 =?utf-8?B?NmdMcS9jaTRZSjd4My92bjZvandvOVdwMVNMWGx1bFVnaEd4SUJlZlJ0OEt1?=
 =?utf-8?B?RzFudW1ETDRtSjVaM1lHaHNGcG43azVndm5PWlhKMTdGN0RCZmZjUWdCbE03?=
 =?utf-8?B?OGFIQ0lqdUZPbUJjdlROZXJZSjh0OTA1aU0yOC9oRXdBblNiVm1LVHhXWDhQ?=
 =?utf-8?B?TlRZbmFVaFc1Rm5tY2ttTGd3bUFuSHZKSEMvc2lienVqU01wajdDM243OWJL?=
 =?utf-8?B?V2tqV1E0TktkL0lSOXZzSVB0T0plRnJYN3EzSmJxd1dKanhRKzd6OW5CeE85?=
 =?utf-8?B?YytUdHJDVmg4SE5PaTNKaXRvdWFJb3NsS0o3eVB6OGNCRmtEVWVOY1d5NnJS?=
 =?utf-8?B?S2kvRzJwMmg5dE9xanRHSzV2dFY4K2Vod1ZGR3QvK0N2SzVMcVVmWTZVRUZ5?=
 =?utf-8?B?dWluMjRRdVFRYkNKYmg1azRZRXlYQWl0VmZmRnM0K2hHTlFIMURQWXpxSG96?=
 =?utf-8?B?S3gxZ1M4SlJ5UWxqNWd6blF1OWFQaXJNdVRZdlhlZ1JWcHVjdWt3SUdmQkFL?=
 =?utf-8?B?anhhTHd3bzZZeVJvUkVsdEE4ZGF2N3FaOFh0VFZPcjB6OWFKYWhJakJ6T1Yr?=
 =?utf-8?B?aU1YalNGYjE4UU5GK0Fyd1RNYXo4WlpZSnNzQnRzNzkxVFRCTmFuTTBoaHp2?=
 =?utf-8?B?QWFlOGlIa0VSS3JqcXh1MmNKOW1ncFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16eba4ef-d3ab-4e7c-fad0-08db0ba3e1d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:17:50.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uz+tOWb0j4hWSKE9Ovt0k6pBeHhWKIhowTr96pmTIPIe80bjzKJlXfIChy+K+vrZTBv4Yl7Vn8VsmAuyMitCWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100172
X-Proofpoint-ORIG-GUID: YxTXEfjr7-fu0FZmY7DZ2KTx9fAqTm9t
X-Proofpoint-GUID: YxTXEfjr7-fu0FZmY7DZ2KTx9fAqTm9t
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index f81d96710595..cbf9c1b0beda 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.1

