Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFD67B3EC
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 15:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbjAYOJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 09:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjAYOJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 09:09:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A044684;
        Wed, 25 Jan 2023 06:09:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PDjYAY000573;
        Wed, 25 Jan 2023 14:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=i0PKYbWlIKbsbm6W7qzncTjfNGDCHKbgqxa2lRmBTY4=;
 b=TedO2RrlKJaun4VGMtpDdqPUYuvrYOr46sszv0vmsOyOFvCcbrf7U3+2FnzPt5i12+I8
 rlLhQs3jeNPvkgOWX2i09Dz/4JQTYi5lwFXE8zwNpzVJVDWSDg4fPY+aYyAD5Qq1DqJN
 qUvw3Dsw/XX5y9E79lrd+StFKcs7vd40YCllOwanDLL4YKMej5aEsBLEgY+jxec6NvM8
 dX/EhA6GrC4MOKJS9vSfmXj8Ggb0iWtnNSaIRBIrO+4S7+2TwwvEsj2Up7pNCxZboIIE
 D9UxZTmACMPBG1QAbZD6xr3w9HcTH8yIOwW+VMJqrBleFUaoXi9HOudDcSh5pELqogXE xQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktyvra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 14:09:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PDCdjM024935;
        Wed, 25 Jan 2023 14:09:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gdcvu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 14:09:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/gz9d+EXNvq7RqEhmRclh3GWmkiF1BEj8FpVUEB2VO4WBW+p5tihFjz1iu5c2fMT95OzVADLpu8dbRuF0MKUZoEAkHFnNEzeu/YhPf6U17Kwg/1Smy7PhapS9aWgZ4hYweVL20UFyaKt9Oe9AkgNzSEHfXh7C93hm23W4Fky7teI6Dz6b/kEkNPVD7Z0rb7vxuV9v3SUPbmtP0GkKaahnBogf+25qGunDaFYRVzy5e96cMg89Ifgfs/aLUlVF17Vc1Bbt12MZWiB0VAbMIk9pF2PwTVJCIjyryOteklOJUvG+fX+448YMDHLJiaylrvRf3YRE9YD7bQRhh9b5CgpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0PKYbWlIKbsbm6W7qzncTjfNGDCHKbgqxa2lRmBTY4=;
 b=JewOoBv1SKsl0HV5KzEmgTDVv9nMcDRmEreW2F8lnsoFIQ14cgHxCyGn0oAj0VKrPphWwUn293BtCOM+Cx+A3+DK+rpEMw8lB7247zw5RJcdn43EMW3usO7pdysgeudsX2B3BShqMSHsrWDmadTwBsj28q6sNqnXXvbHvoUYO44I2jPgMvhHy37eGC8FoIn7cRKaX5clnqPIrKjGXSvIrzGRnMCKQhzH/XTPRlQKx9KT0pIGTtsA5hgTPM/9HFpAAVrpQhUQdB7/bS9KVR6ohfeSu+nZR78y7Mnq8mqLx31nDUOaNUDL+Q04UfwZrdXvIVBojbatHbJu7i1TUez+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0PKYbWlIKbsbm6W7qzncTjfNGDCHKbgqxa2lRmBTY4=;
 b=lwASRRYJUA20xcJv1r++UTpjUGJLr/p8tHX6YHv8YUIyE4cezgm4bTp5sqP4TQyyujM7/0/1wpzBjfq5VeesTtmvkrcdZK5tnAg7APEju8pu43I6Wemvz/uSX9ckbcMWHnkBSAgIZZoGLoFN/Km71D/qeVw9sjfM3VQNQ0wgS7M=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Wed, 25 Jan
 2023 14:09:22 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::554f:d29d:4f76:7c5e]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::554f:d29d:4f76:7c5e%7]) with mapi id 15.20.6043.020; Wed, 25 Jan 2023
 14:09:22 +0000
Message-ID: <033ca877-5091-cbfb-6e6c-e49c4adb9a10@oracle.com>
Date:   Wed, 25 Jan 2023 19:39:10 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 13/20] exit: Put an upper limit on how often we can
 oops
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <20230124185110.143857-1-ebiggers@kernel.org>
 <20230124185110.143857-14-ebiggers@kernel.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230124185110.143857-14-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0172.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::16) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea25dd4-f1fc-4b21-37cd-08dafeddc1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzFLc1hpeTaF3MMBjySCWeBB5m+5QsFUbiFrO34oECScE+JnfBGYu1UJMFt6iGOme4iPq0uZf+/OP6nJtIdTK7TZLYf768i7CXU4Y9hop7TZUfIeYzko1Ty0aOIYQkdaJCj5n/D5hs6y38d7C4CkCmtAekrGig0Q5LpB8Zr6T87BA/mcgpm+tsxXXCby/uWGC8d5kz6JlPybJ6qTTsh/kukdhw/aOuq5poPZxiFJxx6+aswQLtPODpheRJtdMQEcERkfA9vDl5L2tZJQjdI9EboaYnUs8G+Bne1d8IdXOcY34mBcUA6d8DEfEKqh2URUDCMHkQsiI7M1oWnFkDe7RUdpb3g35QUO0m2cIBkXytpp/z6UZ7MQvJtfuPEumnS1qBX/uDAyhCOZ6Z4SbXGUaG13TwPXiAMX938OE3eb1YxVHDFitOBIzJhIbyzxrg/8PG3EOpB3GZ3amyw2ya/59i5ixDCnh5+6HyEa+1zeIl7ovFEc3N0HYdtlpeV2h7ai3LPcsCcIpogk3HtqcoyvDndseVqxSSwipBdVsW0BdfDVVDjUS0pCxwg6KniODzdPg+O68qDxXsy6nZHniItYcZsImqHUz4Ag/DBDiOaakg2v127q62ddp/aNPjbZmevw6Pgh3jgzzTBnCgcFEn3eDcDDKStTgt9np/oEDvobmP+Ygsl83FdRsLZa4Vc0rv7GhREAs7EFqVfRWlylg0yfzT01k6rVhBxI7uuUYV2Anqla/k6j+LJm7HSnuxNtdTI45UpcH8DXlqQU6mungWW3tuTqi40qoObVvv1jeOcfTSTgcq1pJmjQ8Uj5fI8qqIuW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199018)(5660300002)(7416002)(8936002)(83380400001)(4326008)(8676002)(41300700001)(36756003)(86362001)(31696002)(38100700002)(2906002)(478600001)(6486002)(966005)(2616005)(53546011)(6506007)(186003)(26005)(6512007)(31686004)(6666004)(107886003)(66476007)(316002)(66946007)(54906003)(110136005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFU2L3hWT2xTQmszNjFpTnlzQ2c0Q2ZOV0NNZzl5Qk02bDVrZXk5c05ybkM2?=
 =?utf-8?B?L0hyNmFaVDJnd1MraU1KV2VsR1owL1JYM1dlTDlBVTdwN3VoZUpxODhvQUJM?=
 =?utf-8?B?bHJ5aUhXeS9YaWIwcmhLNi9EUGJ2cS9zcGVBeEJMT2NkNXJZTDV5Ujd2SkRn?=
 =?utf-8?B?ZjBhT0pxYVhrZzdQaHpiZHVhWVY5eVBsQ3RBMGVKaktRdjVJME04L3FaWkdh?=
 =?utf-8?B?ZDFpaXV3TE5uMGd6Y09oYWdIWEhsWVYwOUZ0UTh0c2k2QzdxVXhjVzF4Z1Yw?=
 =?utf-8?B?MEJyQTMxbjNKbVRSSkVNZEVkQUZYRVBTM3k2VWlNTWFqRVByQ2VsaE1YWmFz?=
 =?utf-8?B?YjZTY2pWdmtESVpneHhVUFRxQnZsTkpTeEt6cEUwbzNyTWUxL1R1RjVEb3dO?=
 =?utf-8?B?alNuWVk2T1MyeWFvczVhYnY2R1ZORmtSdjJlK1c4T0ZVVDlQTk9lVXZSdVNp?=
 =?utf-8?B?Mks3R05UZDhsZHpNWnFzRFhpbEl2eElqUkZMS051Ym9lejZJZXhJWUFpTHdk?=
 =?utf-8?B?L1FDZ2t1aUwzUDhJWDgvYXNtRDJvOXByMXZUMDNyMDZCczVxUGV2WUUxVlhL?=
 =?utf-8?B?bmFZRHhaUFpwcXdiUzRkdjdIblVKWlhRWHBsTjI1a0hrbDlaUy9MRUNqT0Yr?=
 =?utf-8?B?U2hYZlhpdUZHUjNoMEdFQWFiMUFFSWdvbjNkSFd1anFUVHpjTmtOVklldlNq?=
 =?utf-8?B?ZW5ybDR3cDhFR2k1VFFHS3dvN0ZOS20wdHhsa3pBRHNlWG4xV0VhOXlGaGVv?=
 =?utf-8?B?eGh0cFZ0S0ZJUDBpWWlhU0JxTXFJak5NWHl4ckpub1B2b08rZjJRODNEeU9n?=
 =?utf-8?B?ckJvSU9MdlZGYTIrZjYraG5qSHkzQXUzbCtObTdvVmRBZTlzZUFwaUt3MURU?=
 =?utf-8?B?Vk1WYlNTUUI1VXJ6Z3FzMlRNbnNBZWNiR2dGQ3BqK1hOYmZvK3FDUGkzUjB3?=
 =?utf-8?B?V2xUTVA2WnA4c2RzNnc4eDBzSW9PeWE0bTZYZjczcStreGNyZGZUbjY0NGU1?=
 =?utf-8?B?cFV3akxVeEErRjgzaStRNmV0R1VmS2VacTByaVl1SFozNXRMemorenMzZDNV?=
 =?utf-8?B?TXQ1Z0lOY1pvMlgzb2dZdlA5SlkvVVNiQWFFZWZseW4zY0FlRnV6Sm9Zemdu?=
 =?utf-8?B?bE5FNHQwOUxSZWRKNVNhYW5QbmozNXNkNmVYY2FqYXEwL2dGS0NwSmIrYUor?=
 =?utf-8?B?elQzVzdIL1U0VFJhekphUEZ0N2lUNkNDZ0xmekcrYjJseURsNVc3RERQcGk4?=
 =?utf-8?B?QjlkZ1BlOCs5SkRqVzZuYjdPMW90akIzWlhiejJNbElrNzJ5ai92NFdwTnZu?=
 =?utf-8?B?TDJxTnRIQlZlbkVaVTBqbFZDQmhUY0JESlVXR1VGM1M0cTZwUmdaOGt3cERF?=
 =?utf-8?B?RUU1cExrb0hMV1lYckoreSsxWXBzdGZSL1JMM3h5Rm95VnBtSjNobGgrTmJt?=
 =?utf-8?B?UVBtaHMrbzFxMWNBaWtZdU8xWUNqNGlLQXYrTlg5VTYwVDYvUUJBdTBiVi95?=
 =?utf-8?B?WTFMK0pSVWFJcWtrN09hUTNOSkhzMy9zdnlkdnY1aXIzOHp6VXBLUWhxVFpU?=
 =?utf-8?B?VUZ2R3pxbHJYUXdWa2Z6eWFiNHNNTkZTYzltUUc5SGFtU05OY2RCbnRuUW5S?=
 =?utf-8?B?aVJ3dDZSRmZRbTVNUXpEeHNXWmM3dlFNRVpsMXppWEtLa2dhRVh6bGxRb24x?=
 =?utf-8?B?ZlA0anpjVjQzM2d2SDhndEJrQjNaZU5VVGdabWhQL1JKcXV6dXdSSkt3ZkVC?=
 =?utf-8?B?emY1ZEVRcE1OcEF6eVcvY2piVHFrQlR1clY4OSs2ZENFNlAwak4xN0ZDNTB2?=
 =?utf-8?B?bXM2VURnSGVTZ1QrZ3A0bnR4RjRTNm53ZVBxdHdlVUFVL3k1SXN5ekM3Zzdx?=
 =?utf-8?B?NW9XKzN4YnNoWXYrSTZKRm5lek9WTUY4NjhNKzJGanJtaTgrS0xUTnJ5MUlP?=
 =?utf-8?B?YU5lZjFJb1dxamluZDdocXc2Y2xJWjlXUHk2NXlDUklVbkZFVUQvZzFCRDNX?=
 =?utf-8?B?aVplUTI1dHpZdnQ3RTJJbWk2a1RqQnEzZ1M1NURhSHJpaWpHZXJ0YzBXMjkz?=
 =?utf-8?B?S09JVFBwdmhwY2hYeFo0M3c3NTJsMzdmRGpHR1lHMHZQVHh6VTZQRE05YmxJ?=
 =?utf-8?B?aExVUVpUQUU0QlFYaFNxQzlkMUJ1bkJIcERmUk1LV3pnUnhCeWlMTHhZK0px?=
 =?utf-8?Q?PAf8N9y8dNxxql9Wvs6oH1Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?blFVSjkvb24xUEsyVFlkYmFvSVI4OWpra3NsTWdiQVZxS3BNbXlvVm1rdTJa?=
 =?utf-8?B?KytHcVNrUTNuajY2VU5tcUVDQldac1NuY0RwUmZrWEJTNzNIVnl2UmRwVUtI?=
 =?utf-8?B?ZlVGcDRpbzgvclU0emYvWFVsV3VJajFlK0ZOTnFJVExPT3lOa1dlYkN1cklE?=
 =?utf-8?B?RWg2RGxZS0haNUdxNUZwZ25vRi95dU1UcFJiRU83UERWbEFBcGFrS1Q2MUtH?=
 =?utf-8?B?amxyYWZwS0YvMVVFT21xTDhoWnpqbFQ4UkVoOHgxRkcwTXZCUkhWVjV6bWRK?=
 =?utf-8?B?T21XRGs2bjNUZ2pzZEFIU0hZK2svdEFid3diMFFRbHlFMmdvcldab3lIRzh3?=
 =?utf-8?B?aTc2aTNRQ0lZMjRVcG04ams5anlSdkdlc3hEMU1pZC9VZ3N4dDYxZ2xFVVF3?=
 =?utf-8?B?S3dYcERqU1RjN05RYW9weVEwSlIwbHgreWVyTldUdlBXY1Q4OXYyR0Y3RUFm?=
 =?utf-8?B?eFBhZmxDS0tYRi9sOGVVUVpuWm9ncTZ6WmJsbmx2a0g1T2gyWS9ibnQybE9D?=
 =?utf-8?B?MnN1TlhTeUdiOTlKbEg1amFNQjFYdHhpSThvR2pidjJ1OXN3NThUVFNqeUpK?=
 =?utf-8?B?K3Q2blMyL3l0SWM1dEMyR3JGdDRMMFhVcW10ank2R2NmZStKNmVWbEwvaXBp?=
 =?utf-8?B?aFhZUUR4cjRpOUFvZFE1QVNSWTFEc2xPR0xpNjV5SlVSek93cjh6OGNya1Y2?=
 =?utf-8?B?RDVLYlpCUHg3MXJUSzNBNEpPTWJhRWx4M1VEc3Z5aXFDcWxBUUI4YkR6NDda?=
 =?utf-8?B?OU03dVlpWHZUY0xGRENMcTgwTElkejNmUVFnNW1sUlNwb2wxTHYxVEZLdUls?=
 =?utf-8?B?SHJHU0hsUWJSOTNCTzh5dnpIUEZhcWFQajVrVi9mTkVmenJ5cHV6UGI1WG05?=
 =?utf-8?B?bWloU0t3dGhNR3Z1UEJNZytaWTRyM3VlM1M4KzN6OGFZbm1XN3FNYVljM3BZ?=
 =?utf-8?B?cU0xSTgwY0pnL29lV3lQZkxscU9GNVRPVTRLTFg1bG5sdGphd0Z4TkZQR2U5?=
 =?utf-8?B?ZGZXMVRzeXRRUG9xZ00xcWtJa0hTL09mL1dmejA3VTdXNWpaendtTXdFNDBY?=
 =?utf-8?B?TFFabk5vUlJkOTVscm9jVHVIcmd5ZVBuRFlaWGh0NzY2TUxKV1ZVYjBMT01s?=
 =?utf-8?B?YU53M1I1anppMW9GRzR0Sk9lQTZoQ0hpUVcxTWNXdTZ4a3h1WHFCZzlMMyt2?=
 =?utf-8?B?ckNweGx3L2o4N0t4NnUvaHJnSGdNN2hTV3JxK2oxKzRuaHcwQW5zdW8rWEhi?=
 =?utf-8?Q?CZpD4VIuSi6tB8T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea25dd4-f1fc-4b21-37cd-08dafeddc1fb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 14:09:22.5633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VrTOeKLjZNCHkhVdm6gKl3/vOJA7qUVe87Xn9cJaRJf2NoKTU0kAyq8cYawireVf/jywfSnLKOuEmlFfX5jV+yo3VmAvxKJTEpX3Z45k3c+cVGb1YxNwptMRs/8UA19
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_08,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301250127
X-Proofpoint-GUID: QE0_4LNWfuSwDSlLgAJwpwpq-GHdjMxv
X-Proofpoint-ORIG-GUID: QE0_4LNWfuSwDSlLgAJwpwpq-GHdjMxv
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 25/01/23 12:21 am, Eric Biggers wrote:
> From: Jann Horn <jannh@google.com>
> 
> commit d4ccd54d28d3c8598e2354acc13e28c060961dbb upstream.
> 
> Many Linux systems are configured to not panic on oops; but allowing an
> attacker to oops the system **really** often can make even bugs that look
> completely unexploitable exploitable (like NULL dereferences and such) if
> each crash elevates a refcount by one or a lock is taken in read mode, and
> this causes a counter to eventually overflow.
> 
> The most interesting counters for this are 32 bits wide (like open-coded
> refcounts that don't use refcount_t). (The ldsem reader count on 32-bit
> platforms is just 16 bits, but probably nobody cares about 32-bit platforms
> that much nowadays.)
> 
> So let's panic the system if the kernel is constantly oopsing.
> 
> The speed of oopsing 2^32 times probably depends on several factors, like
> how long the stack trace is and which unwinder you're using; an empirically
> important one is whether your console is showing a graphical environment or
> a text console that oopses will be printed to.
> In a quick single-threaded benchmark, it looks like oopsing in a vfork()
> child with a very short stack trace only takes ~510 microseconds per run
> when a graphical console is active; but switching to a text console that
> oopses are printed to slows it down around 87x, to ~45 milliseconds per
> run.
> (Adding more threads makes this faster, but the actual oops printing
> happens under &die_lock on x86, so you can maybe speed this up by a factor
> of around 2 and then any further improvement gets eaten up by lock
> contention.)
> 
> It looks like it would take around 8-12 days to overflow a 32-bit counter
> with repeated oopsing on a multi-core X86 system running a graphical
> environment; both me (in an X86 VM) and Seth (with a distro kernel on
> normal hardware in a standard configuration) got numbers in that ballpark.
> 
> 12 days aren't *that* short on a desktop system, and you'd likely need much
> longer on a typical server system (assuming that people don't run graphical
> desktop environments on their servers), and this is a *very* noisy and
> violent approach to exploiting the kernel; and it also seems to take orders
> of magnitude longer on some machines, probably because stuff like EFI
> pstore will slow it down a ton if that's active.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20221107201317.324457-1-jannh@google.com__;!!ACWV5N9M2RV99hQ!N-JMN1iGq4TzLl-KgssGXKoBeTEyN5-Qqf4WKpkP9dPj5DpMQejZFXq92OuEL0fWts4dfsuyqTLPWHXVEhx3tDFCvFE$
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20221117234328.594699-2-keescook@chromium.org__;!!ACWV5N9M2RV99hQ!N-JMN1iGq4TzLl-KgssGXKoBeTEyN5-Qqf4WKpkP9dPj5DpMQejZFXq92OuEL0fWts4dfsuyqTLPWHXVEhx3qFbFrr8$
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   Documentation/admin-guide/sysctl/kernel.rst |  8 ++++
>   kernel/exit.c                               | 43 +++++++++++++++++++++
>   2 files changed, 51 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
> index 609b891754081..b6e68d6f297e5 100644
> --- a/Documentation/admin-guide/sysctl/kernel.rst
> +++ b/Documentation/admin-guide/sysctl/kernel.rst
> @@ -671,6 +671,14 @@ This is the default behavior.
>   an oops event is detected.
>   
>   
> +oops_limit
> +==========
> +
> +Number of kernel oopses after which the kernel should panic when
> +``panic_on_oops`` is not set. Setting this to 0 or 1 has the same effect
> +as setting ``panic_on_oops=1``.
> +
> +
>   osrelease, ostype & version
>   ===========================
>   
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 5d1a507fd4bae..172d7f835f801 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -69,6 +69,33 @@
>   #include <asm/unistd.h>
>   #include <asm/mmu_context.h>
>   
> +/*
> + * The default value should be high enough to not crash a system that randomly
> + * crashes its kernel from time to time, but low enough to at least not permit
> + * overflowing 32-bit refcounts or the ldsem writer count.
> + */
> +static unsigned int oops_limit = 10000;
> +
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table kern_exit_table[] = {
> +	{
> +		.procname       = "oops_limit",
> +		.data           = &oops_limit,
> +		.maxlen         = sizeof(oops_limit),
> +		.mode           = 0644,
> +		.proc_handler   = proc_douintvec,
> +	},
> +	{ }
> +};
> +
> +static __init int kernel_exit_sysctls_init(void)
> +{
> +	register_sysctl_init("kernel", kern_exit_table);
> +	return 0;
> +}
> +late_initcall(kernel_exit_sysctls_init);
> +#endif
> +
>   static void __unhash_process(struct task_struct *p, bool group_dead)
>   {
>   	nr_threads--;
> @@ -879,10 +906,26 @@ EXPORT_SYMBOL_GPL(do_exit);
>   
>   void __noreturn make_task_dead(int signr)
>   {
> +	static atomic_t oops_count = ATOMIC_INIT(0);
> +
>   	/*
>   	 * Take the task off the cpu after something catastrophic has
>   	 * happened.
>   	 */
> +
> +	/*
> +	 * Every time the system oopses, if the oops happens while a reference
> +	 * to an object was held, the reference leaks.
> +	 * If the oops doesn't also leak memory, repeated oopsing can cause
> +	 * reference counters to wrap around (if they're not using refcount_t).
> +	 * This means that repeated oopsing can make unexploitable-looking bugs
> +	 * exploitable through repeated oopsing.
> +	 * To make sure this can't happen, place an upper bound on how often the
> +	 * kernel may oops without panic().
> +	 */
> +	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit))
> +		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
> +
>   	do_exit(signr);
>   }
>   

Hi,

Thanks for the backports.

I have tried backporting the oops_limit patches to LTS 5.15.y and had a 
similar set of patches, just want to add a note here on an alternate way 
for backporting this patch without resolving conflicts manually:

Here is the sequence:

* Patch 12:  [panic: Separate sysctl logic from CONFIG_SMP]
--> Cherry-pick Commit: 05ea0424f0e2 ("exit: Move oops specific logic 
from do_exit into make_task_dead") upstream
--> Cherry-pick Commit: de77c3a5b95c ("exit: Move force_uaccess back 
into do_exit") upstream
* Patch 13 which is Commit: d4ccd54d28d3 ("exit: Put an upper limit on 
how often we can oops") upstream, will be a clean cherry-pick.

The benefit may be making future backports simpler in make_task_dead().

This was the only difference, so your backport looks good to me.

Regards,
Harshit



