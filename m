Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2294852FEEA
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiEUTOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 15:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiEUTOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 15:14:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D014AE35;
        Sat, 21 May 2022 12:14:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LF9lKC007918;
        Sat, 21 May 2022 19:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Rsh1Dbkofw5EK7PaMPX8PVIEiZRulZj9SDq41qff4xw=;
 b=m94gokJuOhWukRr4rQM8z1GqhUufU/wahnsqQ8QcEFSyLFfVG3BLDaw/7faAZVOe9LWo
 A9W3ur7b3l97WW+lXoeBM/eED1EL4mj9VM0JddaQraWEX1nUn1lzZKuO8S6/nfM2vFEI
 +0bqySXErpWWcYgK6xuSawZv6fb7MaEVDWicR7TEPjd2hCsV0dMWYNijdYkdF43CKrwr
 13c0+rGV//Ee1q193018KizRCgR8Z9lTTduRWSwiDWKfpLxQ6AJvhBUASZQ/oTNFM+HT
 GAdhBq9q5ZsKLolxhieIeAAJd9PI1xTUkkwlOfhnpc62Woho4BqhfVPC66YER4BmByxq uQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qps0qqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 19:11:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LJ9v8K008180;
        Sat, 21 May 2022 19:11:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph0fqe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 19:11:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=km10ZmN4nz6weinJbbTpzsDlVAE7BRtvIineg1KhWxd9wZXCDDjgI+EGlbL691Fo3lNboTCYW2UXul/lDhDRzRzS8TA4dQlsMHZoO+h+lV7yiemGUvTNVx10u5J55rXA1+agylYi6rD48BGLnt8IQH2YWGIcorTd0IIYPKbdjrI7gxZRi6l87M1mTKEKQKDX4f6cBWRhmCealzBzUT9eAxTxdcrkQ/FYt3F9Pmu94rgqXY61BEOu20KowQb+vyy3uOL/0WW8PWkO+ku01rVHR9MjRgBWTFnzQDPZXMzvL+/rW7AsMFx/6vW1kY/Lsfvz+2lxJ72wXKF1g7TRjGf8Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rsh1Dbkofw5EK7PaMPX8PVIEiZRulZj9SDq41qff4xw=;
 b=hT/mG2MVCqI2/KEUfFEQ97WnzyAMaETKspW1vmTHAb3zv8M3IojiXxP1xvinkufo7z2JHff8U+Q5CNAipN70WW7UA31C3yp625YdSEgJ0PQvCmThngcDdeZvqafwGDlH4GMcmdGPJEEaDMqtmecPKbTVojHcC6WAdsllh+PrVG7GE3s3AOEnPdttnXHRBLQqQ3fGcihUBQAw6z2NKqoa1byXJ/6BhZ6wmbniJTC9ijaYX52mTJTlZQI/ERBxEFfYHddz1X02hUc8soBn26p4Rc9CVUFBVV3osWopoVm23g0/rCE0+gAoyYcMedE4cs2bGDAoFgq7yrfhIhd5xFHBXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rsh1Dbkofw5EK7PaMPX8PVIEiZRulZj9SDq41qff4xw=;
 b=RJwMdExj2qAsLkmYcFgfIc1QB2sPN/Ty6oPMHKdxvzGXotED2zS7DuwBgjpub0tIO/KkeP+ybd+VU4bRbXzUX8VDVUEETs2YZ2FBv3GelMlXi2zJVXN2rgYC6RsiqR9G6jY170CLd0sx0FZEeD3an0yD/QjnUVKhsLdYnET9MHM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM5PR10MB1242.namprd10.prod.outlook.com (2603:10b6:4:7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.13; Sat, 21 May 2022 19:11:49 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 19:11:49 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux@stwm.de" <linux@stwm.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgCAAAISgIAAA5uAgA41xoCAABHMgIAAVxMAgAAJFACAABXugIABJ+MAgAANoACAABEJAA==
Date:   Sat, 21 May 2022 19:11:49 +0000
Message-ID: <7831BCDD-00A9-42E7-A533-4D6AFA488AEF@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
 <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
 <3FE1F779-A2EC-4E23-BBCC-28C5E8AFCBB1@oracle.com>
 <1a38a01debc727a1e11243fd6207d915ac90c251.camel@hammerspace.com>
 <FB8CBEF6-07B4-416C-B9B4-56E03C7E6628@oracle.com>
 <40D1CC9F-1DA7-4134-9DBD-0C0DFA16A361@oracle.com>
 <78739abdf5fe7aa0aab9b7f3c9d660010868b0f4.camel@hammerspace.com>
In-Reply-To: <78739abdf5fe7aa0aab9b7f3c9d660010868b0f4.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5520099f-0e83-4ece-e6f5-08da3b5dc1ae
x-ms-traffictypediagnostic: DM5PR10MB1242:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1242922AF34A9EA525380BBE93D29@DM5PR10MB1242.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DspgCETLOqIns+TxXFYRSg+bkx5GAiLzzvY9JTXVCYkmpMM61fm03eUjnmRtXalaAcvC1VRRS1g0y3AE5Lex+YjIN2jjhPk7uNT2hazizgRKchvHtVBUbs2YOr88X9BnL0YlY1G1uJhAN4YEVO5MP5CXxt2WX4wsRaVFqMnu47MUDwuf6oqkA5buiThXzs8cEnYCYsoULjHhfgZPh9qex52Hbx/E9gxge+B2jSBGzJO0UJ34Q0gWBbnstuP5FrEcJNeEr05Bb1VeBONpf+HDNCtweJ46A8TVFFcBEEDJQWb0IOYEZygP5ITbGefFONC9AXAV01dfn1om6d3cD/V0Lc1OP7TW3Q7cllsSXJlaz3hmjCqpmnxQhfUVZID1Cn/MMoSBHbIdUeSYyHowf0bKSqTAMUSg97Lw8gmS11x+ZE91CtElyIHUyfIsvXct+MsjU9kr7afNL5Thihjs9+06MlAhK8rVcl9W8YenQdy2C/mkeN7Jl5djaiO53dSbuEC9hn3yPVRJ0rNZwAYpKy3dkLvbkcGlQjMd7dy5Djt+6S7TFmkRBoOXWjFtbOsmwEvz4ansUKg5KxlBHMT+mbntIMv5W2OJsCfGCCs7UeVU5jlzhKguYMiHDIjX7CGyOwWZJ/O9WDUIUH9A9V115abNifutodxAEzYBqbQWdZWz+CKvPxFgxpF2OCS4iB9xLc8gVjP2MCBI2NyNmUqhg0q4GeeiAGVwySI18U4c94JXPVsyc9qRNyZF/yWHdp+DpLB1AV8uTLW6Suowe5UnOIUo26bo11y6n0Agpb8WJsWrWh3ZJfbyC5jpS35hke3meX25cFWY9EBQTnDCsgRv76btl+vMRf/upRyMyBloxSQcPXg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(26005)(86362001)(66946007)(54906003)(5660300002)(122000001)(6512007)(6506007)(38100700002)(83380400001)(53546011)(76116006)(2906002)(38070700005)(91956017)(8936002)(64756008)(66556008)(66476007)(66446008)(4326008)(36756003)(8676002)(33656002)(316002)(186003)(508600001)(966005)(6486002)(71200400001)(2616005)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wV4Ufuhf77vIyhlo7PtleI9BVc49f/bTOLwdXfdEmvts4a9KcwZIRhh1ztX7?=
 =?us-ascii?Q?fUSH0mQ6HdmFQONMxrLaRaTEy+glh2/GTmAo7vbXquQ0XYurhZklp5VDkU6X?=
 =?us-ascii?Q?FMwV/8KP215xpqz4nJT31EGjeCBugGwNaFPu/mWFix5+Y1M3kkja15bsmcyT?=
 =?us-ascii?Q?nbgKtBvvlJvmN2l3BHF/9XvUPflzXTpLQqMidPCevt1dwtoRaB760xFGTHCq?=
 =?us-ascii?Q?TiiIJ8u3P8jn1mNvcU0ZcdHRo+/IlBg0LIv7G+187cah8w+nCGW+K5nyMhaD?=
 =?us-ascii?Q?sHtSLqKRXBfxbsUPuogHCqnih9An4ls8gjbc+4JTg/mk1swXTE42CZ5JAfai?=
 =?us-ascii?Q?euNlupVTTg3ccKBXdPVn5CNsk8K20WMUUmUtsJVSiChTVqF8+iJeEwpqQ7Bk?=
 =?us-ascii?Q?ZnyEGIqRS32BBM6EGGA1OBuKyxIwL7U+Wrp4xJrzua7h3CK23DXB6T/OHKBp?=
 =?us-ascii?Q?D8MQVqzgmpQ6wmegZovezVnhfcuJADdBFgwRumZAbKCWAU+TsndDmDkYhUDo?=
 =?us-ascii?Q?h0FcfIV6Ll1DO5+mYjV8HOVSHJKd0vXSEqVyUcphoQsofExPwueEJpG9nZIn?=
 =?us-ascii?Q?aqLcQngCMINNNz7LQgv60tk5/y3R2qNSD7EENqSyf5L1EZqplsgjI+NgibQL?=
 =?us-ascii?Q?xOHUAFSqCTBiFCAx+jPIJEzPa71yDigHeAtDhXOxDGTXfsgFxbGuqC/+Mte4?=
 =?us-ascii?Q?WXIP4SLG04w132PIp5NvuFPbKo0OiSlpN/lOb1MDr/kbhOOlXFnvMauZUQnD?=
 =?us-ascii?Q?Pt75Tc9sGOoxToO9hzRaZDAprGJEkfhl6ucAr0Qut+OnqxWAZ04v07Efh6Ql?=
 =?us-ascii?Q?PQU+khnWRWcQwgcsw4Ytt0rgCOEtQcfio7LoYBI/vNkZUOXJJIF7YWjtSBPk?=
 =?us-ascii?Q?wK3Y/Leo1kIhgptKsURtkYObfDp+z3VrdW+kdehpLlFHSEdBSMJD8Lae78jr?=
 =?us-ascii?Q?ySogdKjjDr7VmxXNQsg/NcvcMIN+0GtRwMBImGkcfNEKkgElQAyeCLbp45nY?=
 =?us-ascii?Q?wpqEBjNInD4R1CIJGmmGwSMmPrxE9bMC0HWxsJgRYGeuvq6u0oviRESf9HmT?=
 =?us-ascii?Q?59wbgB+K07uBcLae1MhgXFpWwkax1zNREkduIdl7Uqg+ikBf5Vg+kC6DUPaW?=
 =?us-ascii?Q?tL9ghHSJN825BE0ol8Mq/StDtdJ4cOTBVpXIpWTdHjX1MNCnzs+cyaTJwhy9?=
 =?us-ascii?Q?9vxTAeFjokyixdmtne22kfGKSTyG/A8v2Xysp+GkGSQYpZgjp7WX/QRSYyMb?=
 =?us-ascii?Q?PMka/WsxmNrlJNJ4JM5RgTYOUzMstr6bNCJ8acgqMk+EWqI5ttijcYGtCAPc?=
 =?us-ascii?Q?jZ+igTTE1VmLa4ZPYoNPqhfo2HLaOpsPTO5i3jBcg4VUW/yr3knv5bp9ROYJ?=
 =?us-ascii?Q?rXkyxIyWswpaZb3OWCCsq5fbXaNsGCrlEJdNeekQ/jmFfXia1Jaiah4ThwkK?=
 =?us-ascii?Q?L552PWzgByQKRB5n0GilknhX8ajqCg2DKvThCXcxRaZehuF4pAuzGynzO9T/?=
 =?us-ascii?Q?ZO+CH/hHV0YOgjwC+7W+A5yg0N8r63Sh9d9QbsHCBMqE071ga+Q9r1s920bV?=
 =?us-ascii?Q?hdyB96XUXkKj+udmTGm8ZeVstKw6Dp08omu5DVYU5XUAqcXeCZ1L/SAFgMsP?=
 =?us-ascii?Q?twioxdpaBL8IvUzgEqk7grthIvkLQ/a2+RqsTEWpyr0UInAa9RDYV8TsMbM+?=
 =?us-ascii?Q?IGiZRsEPraXkoAdzXHGz3gR5muKuzP9sMqwhsMDDKQZb1Um0mAaKPezE03V8?=
 =?us-ascii?Q?OtOuuOmY9v3EtT7lLRMaYX37jzxsCeE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB25B1A1F9AE7D4AA83CC2729BE3313C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5520099f-0e83-4ece-e6f5-08da3b5dc1ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 19:11:49.3340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88MpwRQM+UUmQzSmauQ02kOk7SUXjcezVzqm6VQzI3D47bIDW1nn84plpJ+QlP8ZZaOVxAJg+SstS5A2FDLLvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1242
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_06:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205210123
X-Proofpoint-ORIG-GUID: yjnfrspt2AoYoHpSlgmCdsefLRpylLgI
X-Proofpoint-GUID: yjnfrspt2AoYoHpSlgmCdsefLRpylLgI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 21, 2022, at 2:10 PM, Trond Myklebust <trondmy@hammerspace.com> wr=
ote:
>=20
> On Sat, 2022-05-21 at 17:22 +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 20, 2022, at 7:43 PM, Chuck Lever III
>>> <chuck.lever@oracle.com> wrote:
>>>=20
>>>=20
>>>=20
>>>> On May 20, 2022, at 6:24 PM, Trond Myklebust
>>>> <trondmy@hammerspace.com> wrote:
>>>>=20
>>>> On Fri, 2022-05-20 at 21:52 +0000, Chuck Lever III wrote:
>>>>>=20
>>>>>=20
>>>>>> On May 20, 2022, at 12:40 PM, Trond Myklebust
>>>>>> <trondmy@hammerspace.com> wrote:
>>>>>>=20
>>>>>> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>>>>>>> <chuck.lever@oracle.com> wrote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>>=20
>>>>>>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever
>>>>>>>>> III
>>>>>>>>> wrote:
>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>>>>>=20
>>>>>>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang
>>>>>>>>>>> Walter
>>>>>>>>>>> wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>=20
>>>>>>>>>>>> starting with 5.4.188 wie see a massive
>>>>>>>>>>>> performance
>>>>>>>>>>>> regression on our
>>>>>>>>>>>> nfs-server. It basically is serving requests very
>>>>>>>>>>>> very
>>>>>>>>>>>> slowly with cpu
>>>>>>>>>>>> utilization of 100% (with 5.4.187 and earlier it
>>>>>>>>>>>> is
>>>>>>>>>>>> 10%) so
>>>>>>>>>>>> that it is
>>>>>>>>>>>> unusable as a fileserver.
>>>>>>>>>>>>=20
>>>>>>>>>>>> The culprit are commits (or one of it):
>>>>>>>>>>>>=20
>>>>>>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd:
>>>>>>>>>>>> cleanup
>>>>>>>>>>>> nfsd_file_lru_dispose()"
>>>>>>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd:
>>>>>>>>>>>> Containerise filecache
>>>>>>>>>>>> laundrette"
>>>>>>>>>>>>=20
>>>>>>>>>>>> (upstream
>>>>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>>>>>>=20
>>>>>>>>>>>> If I revert them in v5.4.192 the kernel works as
>>>>>>>>>>>> before
>>>>>>>>>>>> and
>>>>>>>>>>>> performance is
>>>>>>>>>>>> ok again.
>>>>>>>>>>>>=20
>>>>>>>>>>>> I did not try to revert them one by one as any
>>>>>>>>>>>> disruption
>>>>>>>>>>>> of our nfs-server
>>>>>>>>>>>> is a severe problem for us and I'm not sure if
>>>>>>>>>>>> they are
>>>>>>>>>>>> related.
>>>>>>>>>>>>=20
>>>>>>>>>>>> 5.10 and 5.15 both always performed very badly on
>>>>>>>>>>>> our
>>>>>>>>>>>> nfs-
>>>>>>>>>>>> server in a
>>>>>>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>>>>>>=20
>>>>>>>>>>>> I now think this is because of
>>>>>>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050
>>>>>>>>>>>> though
>>>>>>>>>>>> I
>>>>>>>>>>>> didn't tried to
>>>>>>>>>>>> revert them in 5.15 yet.
>>>>>>>>>>>=20
>>>>>>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>>>>>>>=20
>>>>>>>>>> We believe that
>>>>>>>>>>=20
>>>>>>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance
>>>>>>>>>> regression")
>>>>>>>>>>=20
>>>>>>>>>> addresses the performance regression. It was merged
>>>>>>>>>> into
>>>>>>>>>> 5.18-
>>>>>>>>>> rc.
>>>>>>>>>=20
>>>>>>>>> And into 5.17.4 if someone wants to try that release.
>>>>>>>>=20
>>>>>>>> I don't have a lot of time to backport this one myself,
>>>>>>>> so
>>>>>>>> I welcome anyone who wants to apply that commit to their
>>>>>>>> favorite LTS kernel and test it for us.
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>>>> If so, I'll just wait for the fix to get into
>>>>>>>>>>> Linus's
>>>>>>>>>>> tree as
>>>>>>>>>>> this does
>>>>>>>>>>> not seem to be a stable-tree-only issue.
>>>>>>>>>>=20
>>>>>>>>>> Unfortunately I've received a recent report that the
>>>>>>>>>> fix
>>>>>>>>>> introduces
>>>>>>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare
>>>>>>>>>> cases.
>>>>>>>>>=20
>>>>>>>>> Ick, not good, any potential fixes for that?
>>>>>>>>=20
>>>>>>>> Not yet. I was at LSF last week, so I've just started
>>>>>>>> digging
>>>>>>>> into this one. I've confirmed that the report is a real
>>>>>>>> bug,
>>>>>>>> but we still don't know how hard it is to hit it with
>>>>>>>> real
>>>>>>>> workloads.
>>>>>>>=20
>>>>>>> We believe the following, which should be part of the first
>>>>>>> NFSD pull request for 5.19, will properly address the
>>>>>>> splat.
>>>>>>>=20
>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commi=
t/?h=3Dfor-next&id=3D556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>>>>>>=20
>>>>>>>=20
>>>>>> Uh... What happens if you have 2 simultaneous calls to
>>>>>> nfsd4_release_lockowner() for the same file? i.e. 2 separate
>>>>>> processes
>>>>>> owned by the same user, both locking the same file.
>>>>>>=20
>>>>>> Can't that cause the 'putlist' to get corrupted when both
>>>>>> callers
>>>>>> add
>>>>>> the same nf->nf_putfile to two separate lists?
>>>>>=20
>>>>> IIUC, cl_lock serializes the two RELEASE_LOCKOWNER calls.
>>>>>=20
>>>>> The first call finds the lockowner in cl_ownerstr_hashtbl and
>>>>> unhashes it before releasing cl_lock.
>>>>>=20
>>>>> Then the second cannot find that lockowner, thus it can't
>>>>> requeue it for bulk_put.
>>>>>=20
>>>>> Am I missing something?
>>>>=20
>>>> In the example I quoted, there are 2 separate processes running
>>>> on the
>>>> client. Those processes could share the same open owner + open
>>>> stateid,
>>>> and hence the same struct nfs4_file, since that depends only on
>>>> the
>>>> process credentials matching. However they will not normally
>>>> share a
>>>> lock owner, since POSIX does not expect different processes to
>>>> share
>>>> locks.
>>>>=20
>>>> IOW: The point is that one can relatively easily create 2
>>>> different
>>>> lock owners with different lock stateids that share the same
>>>> underlying
>>>> struct nfs4_file.
>>>=20
>>> Is there a similar exposure if two different clients are locking
>>> the same file? If so, then we can't use a per-nfs4_client semaphore
>>> to serialize access to the nf_putfile field.
>>=20
>> I had a thought about an alternate approach.
>>=20
>> Create a second nfsd_file_put API that is not allowed to sleep.
>> Let's call it "nfsd_file_put_async()". Teach check_for_locked()
>> to use that instead of nfsd_file_put().
>>=20
>> Here's where I'm a little fuzzy: nfsd_file_put_async() could do
>> something like:
>>=20
>> void nfsd_file_put_async(struct nfsd_file *nf)
>> {
>>         if (refcount_dec_and_test(&nf->nf_ref))
>>                 nfsd_file_close_inode(nf->nf_inode);
>> }
>>=20
>>=20
>=20
> That approach moves the sync to the garbage collector, which was
> exactly what we're trying to avoid in the first place.

Totally understood.

My thought was that "put" for RELEASE_LOCKOWNER/FREE_STATEID
would be unlikely to have any data to sync -- callers that
actually have data to flush are elsewhere, and those would
continue to use the synchronous nfsd_file_put() API.

Do you have a workload where we can test this assumption?


> Why not just do this "check_for_locks()" thing differently?
>=20
> It really shouldn't be too hard to add something to
> nfsd4_lm_get_owner()/nfsd4_lm_put_owner() that bumps a counter in the
> lockowner in order to tell you whether or not locks are still held
> instead of doing this bone headed walk through the list of locks.

I thought of that a couple weeks ago. That doesn't work
because you can lock or unlock by range. That means the
symmetry of LOCK and LOCKU is not guaranteed, and I don't
believe these calls are used that way anyway. So I
abandoned the idea of using get_owner / put_owner.

But maybe we can provide some other mechanism to record
whether a lockowner is associated with file locks.


--
Chuck Lever

