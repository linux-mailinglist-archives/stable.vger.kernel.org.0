Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB4267E6F0
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjA0NlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjA0NlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:41:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D5A7BE69;
        Fri, 27 Jan 2023 05:40:59 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R9TIR1020948;
        Fri, 27 Jan 2023 13:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=6EqlwfWxdWcLsgrqgIbRCsRjouDXXq+3buYkODgy0l4=;
 b=vK5s95x18LpQyQQSEs6an2ozo6o40e/hSkeFkyZICRDMmYGqvnCUD1MafZPOHDFf6w4Z
 1c1dWRjRnW6tevzzquRpL31R8XWSUasKEbrnr0k+6hhb0tOpMt3y8QlUHxxz96fXrTcB
 aIIQ7Q09ppVPRg64eUD0QoAlV3SqHYanGFIQsGB1A9HZTcInr8hs63Hm9KKFUi2LWE5B
 S0xQvccUGp0o6rOSdZRKnk+R38/vjaUlDBH3/J3c5B4Iv9MZyzorcoQ0YadsZd1+WOWO
 9TlbWjZfDeuNC//e1NYF+8U6v++5ktQYDLRfyWmkwtM/JK/3eIqRMYPXW0zWIIJTMZah bQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xacqqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 13:40:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RBrTYo010798;
        Fri, 27 Jan 2023 13:40:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g97b0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 13:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTXdlgS2RKbvi192jxA2datt7nuj3kbii8zbG2cl/8bXfBlEfT/wN0qU7fGUzQDGTu9FDhsnSX/RBsfvstrGf0v2N3ZMoulixnrhSPoHCr7CCtzCqsNEEnozMpPBcdw9q/xBCRkE2nLTVzemhZY51TzoOleusMazNfOgzyDTDT3TK42NuUTiZBQ5kvN2ceKIp0teNbF+SW51GW9Zz57lCMfKqKCaPyixm6HaoMln0lao/9Kzps7hWViQJod5K5FvkFUzaNf3qssuW+/3tvWPGIohTs3PtafwuOrWRe3wEqfe7Vnzb3sakf8K9MWblwwtlk49Uc0OjebIVZjeWscsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EqlwfWxdWcLsgrqgIbRCsRjouDXXq+3buYkODgy0l4=;
 b=ANUBbILAWGhr7Ct8G5HVet/aUBtOnoPPPYHKi57L814nI6QjbBUdw36yoLiYd5EK1oLoKmNXW+X2d5kTVLiX1eRHkWaAVLU3kOfjnzKHR1ljeLvKeH4Rs92e+onfAcYfoy5Z4rxOX3j8x+8g45VwE+JCV9cTYQcLEzfb3owrRAdzLOz5Tbl67NNlrk0YR9Q49fvdt84M8K8Mq71FxE4VfcbkngET61oDgkDA1yxczhEmtz6tm50q5ZCTJXBxzO2c7whQKUn6kNn1VewjfvJ4aCcUjA3+s82ut9p1bL7oNS1UBUQYRbOVisIXpyGpiu8VK3RWlTw5SkI2PihpRGB9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EqlwfWxdWcLsgrqgIbRCsRjouDXXq+3buYkODgy0l4=;
 b=Zs6vWHlQHmCIM+Qax0tuSONN9VYKG8JRPtny/yMdC3ydnDq3QQwIHTN+Lv3u6RpyjzVM3BCkQHiyDTpgx4Bn1iESx2yYnuYGB7nKJBr+HDQnCsfU6cU5PUKT5uPwIC7hhMxTWqycRapfY9ISGqHkAvXpswI12T9E+tBa3YtzZUs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BN0PR10MB5174.namprd10.prod.outlook.com (2603:10b6:408:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10; Fri, 27 Jan
 2023 13:40:23 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 13:40:23 +0000
Date:   Fri, 27 Jan 2023 07:40:17 -0600
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
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.4 fix build id for arm64 with CONFIG_MODVERSIONS 0/6]
Message-ID: <20230127134017.6uifyex23p54etld@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
 <Y9MyFyifBDCrwMuq@sashalap>
 <Y9N9B5e7HZhFN7nl@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9N9B5e7HZhFN7nl@kroah.com>
X-ClientProxiedBy: SN1PR12CA0094.namprd12.prod.outlook.com
 (2603:10b6:802:21::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|BN0PR10MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 7edf6690-0d22-4388-88ae-08db006c09fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCNdgelU+Jrn20bUjwOBeMwzN9r07jEz/R1Un2vGdQrtmPumbDSx8YDxVfTprScGFlojhI78anCcUM70sIZAsWE697E7TciQ6nZw9bQJD7W4Odvl8zZeYBQjW8EAH7rSCkMawC4M0F5rQa8YKZxhIKHTf0Uhr9mGoG4rxVwBOSG+KVsnys1eTtKk8Af4HAr2S3f27wUQlNHCPmIkiJMLRRgpiWuJpoKul2nmbIp7WajzbM541Vm2n+MeckPfe9aOu94fkQI0ljjGODEsGzzC6Ll3df3B8YU9H6HkuXAP2FA3zOyWRPVXFBN1lCu9O1roUJ8qPXIJl4pb9aUfLvzCMtVyLeK82JfsDCXRE/n5L4FjVXN1UDyVUgUKU9CUuzKbBqRFI/n2Hf7vqXMpIDc50XcGpxLeOCtEAsxU2suC90AP6WAkQbUGwkkEuDN9mi9M+7cDAujm9T7S+ETAAoCaYjpOWUg3+83Dkddu7DK/rCl/8/fvf9KUpgob9zV7S4fJxb/ZGL/TdFT14qJ2/HJWINvaWeBLr1kkPvdbI5R9VY0rEDdvveiLGi53Z2X6KP9ucYsZTftnnw576t5PhJvaIjoSfQbKqDJCar4zwUDHds5i7RGAlIKhfUdYTQWjRKr2Txfop1DJmbkK5yxlh965DgRyTNepriNDh4mQI6ZObtLr1KZ578l3lSYCoTx82YUEpphDhYazk7Kt+tkVVjduMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(36756003)(38100700002)(316002)(54906003)(7416002)(5660300002)(2616005)(86362001)(186003)(6512007)(6666004)(478600001)(6486002)(966005)(26005)(2906002)(8936002)(6916009)(66476007)(8676002)(66946007)(44832011)(4326008)(66556008)(41300700001)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmJFK3owdGxHNnVOUnhLaS9wL0pZM3krcVRiSXR3N3M4cHFhQmYrNzB0UVhN?=
 =?utf-8?B?QmkxU0crckxLNFJpTFVQSzNXTUdyRURvZUNiUG0yNXlybFB3dWZMU2pUcm5E?=
 =?utf-8?B?d1dSUWVqOEJQS2xDZDVXMDhkbDR5cStSRDU3OHRjNmlIdS85NVVuSnJ4ME5V?=
 =?utf-8?B?NCt0ZG9wS09SZmdST1daa1Vxc2hJNFVST3RlSm9NeDEwa1YvSXhUQm5YZzh3?=
 =?utf-8?B?RTZud2l4UTNBMldJZmNDY055KzZrOTVuL1RoYXNGTU5HUjg0c3hTMldWT2lZ?=
 =?utf-8?B?eFNtM1c0OHdmZmRGL3EvTXpNUnF5Qk5QY245UzlFMVlPQlhSaG9oWGhocmM4?=
 =?utf-8?B?ZmdvWlBLMGFvYjY5Q3pyQ0trUytCZjZMNDNQM1RXcFFEOXEwVUxUY08xUy8z?=
 =?utf-8?B?OTRTUmpNU0ZYTDdhTC80WXJCRnpLbGRSVGwvQzBraThGQ05uQytQaG80dXpy?=
 =?utf-8?B?VTgzbkFpUUNLUUZ1TU5FNU9GbkZJdHM2TkhMYXdwY2R0TUI0R2wwS0Vqam0r?=
 =?utf-8?B?SkxJWTNBR0VWRzVudExuVWoydmVRY09jM216K1dWVVBWVG1KYTVUL3g4RkFx?=
 =?utf-8?B?SXdsZzNGSWwrdGFKRDF5TGhMb1BjWGhjY1RZOTkydzlHNGlNb0NuNTR1c3Ur?=
 =?utf-8?B?NXUrZzFUcEhqNm54eGNIOGszUWhCZ1k5ZDhKZE1KUENIcTFjSnhBQUhvcTdD?=
 =?utf-8?B?bmJTVXBUS05GbGh3L0V2TTZJTTBtNVowWVlkZ0QwOFU4VmlPbmd6ZmMrMjZi?=
 =?utf-8?B?R0QraDU2OHZLRmgxV0xJTGwwaEdQeVZZMURZaTFjeWtoL0dxb0ZCYWplRjlW?=
 =?utf-8?B?VXBZZ1hWK2tsVE1Hd25CV0ZsNnZoVFRpb0xGeE5sZzBuc2xTU2JGeG1NYlY4?=
 =?utf-8?B?cCtkSmV3KzQ5MXR1cVI4Qlo2L3lXbUxJeEl2OHM0c2VnOGx2Q3RwdDBtc2Za?=
 =?utf-8?B?YWZ6OUpZWlQ3UFQweFZpSVMzeDJGeEFxb3pldUhVejlzOG9NQmpJMlo1MHpJ?=
 =?utf-8?B?MmtGOXlIL0E2Y3VFQXhtNG5HN0l3OVZlM0pHYlExazNIL2FvQjJ3ZDBsS1ly?=
 =?utf-8?B?OUl2VkdwdWRlZGphNkQ5K3NSekJBd2o1YkVYMTBNR3I4TE9iWVRTaDZWSGt5?=
 =?utf-8?B?K2tlOW1MZ2JUbmlOSEVYL2FCYkhPSFdWSE9NMkVKbG1CbTJKWWptb2luL0gr?=
 =?utf-8?B?dmNrenArUUZoSG93L1Z4K2NqcW4wTFpLWlIrbUNzaEN4THIvektjU3g2c0VN?=
 =?utf-8?B?bjdaSVF2OGVac0pNOFFIcVl0ZmdRUVhLdHlrV3k3NHBqd0RwSENaa3ArYnp5?=
 =?utf-8?B?Ymt2eVlQS3AyWWhidkVBdG5ZOUVPUCtRYUJyMTcwN0V0SHVTem1KWXZyck1J?=
 =?utf-8?B?KytWL3hJTGJBanBSVFJvMGhjeC9qeXpiNTFML3BRNktiZEFPbHY2VHkxeU5F?=
 =?utf-8?B?cmt0dlVVVnJiTUN0c2VwdHpxQUh2UXBISWFZMnUvVDUwaUYzQ3RzTG9iY0Ji?=
 =?utf-8?B?RnFQM3J3bzBIMExVaHIyUktTL3ZiVElnM09UYURXNnRhbWQ4RDc5VEpuMEVa?=
 =?utf-8?B?VWdVTDdyUkpJNHEyVTE2M2hQdHNYY2l1Qm1kdlByRGVtcGxld3NTMGFZeEJ0?=
 =?utf-8?B?QlR2M1lOaFJVSjBZK2ErT1VHOEUyaGZqelF0dWZrbklkTzRPdTN1cHJpZ3RZ?=
 =?utf-8?B?Ly81ZGd3Wlp1VDFnS2w5QlNFZnFzNkcrYzA0QURqY0t6TDVFS3pLY3QrOHFC?=
 =?utf-8?B?N1JVL3AvQXRYY3dsc3ZXcVZ2aDBRTTFobE9jMkhnbFZySzR2NjVXTFRESlpx?=
 =?utf-8?B?KytobFZVcmUvM1dNV0R4OVd2QW93djFSdHBnd3czcTdjSVpyMWk3TlhLSEFD?=
 =?utf-8?B?Nm5aYkJhMkxwcDZXUDhkejJXdEJGUkZlazVyUW83SFVaS1ZGVzkvb05DWUxu?=
 =?utf-8?B?MWY1cXFpMm5YTlI0MkdzRVJOOHd2bmg3ZlMxVzhkZGs1UExXTERXYlYrTzVW?=
 =?utf-8?B?V0F0WmU0emloU1NCRVJ1aytpcUFpalhwNUhiK0t3VGZkYWN0a3ZKKzdkYWF3?=
 =?utf-8?B?NWtWTTRtZFBTUVdwcEVKeHlKSEtPSWt3MHpJMjNMOUJjN2hvUWFSWjVweHZJ?=
 =?utf-8?Q?UXroxWatSjdjJ401EmeMx1aoX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Ui9KRC9RV3MwNkdDaUt4OEJLL2VJbDVjczdPUlQ0UFI3NjA1eklEYjVGaXQy?=
 =?utf-8?B?ekpLY2llNktYTmtGQ3g2b2xWclNQbUtvTnhSRHZaODliN1FHVm5KblZhY1dP?=
 =?utf-8?B?b0RYS0NXelJ3dDFONUpQR3doczY1cFM5YzdsMmk0blV2TXJsbHdEa2NLN2Ux?=
 =?utf-8?B?VUxUN1UxWmtpcE4zN2plc3gxVlZQeEJmUjJXZGp1d3BqdGtpeGpxTDhWNHZa?=
 =?utf-8?B?ak01c05RSmh3Mko3cUYyQzdQWWZESWUyL25aTXZUZ2lRNUdiLzNCUVdLeU4z?=
 =?utf-8?B?TTZQdzVrYVJjMU94a3cweDVMWHJ1aW5qTXVSUjRsOCt3NUxBcjhKTjFxQURT?=
 =?utf-8?B?b2IrMzRDNUNsckNCdERtazlwYlB1QTM4Ny83YU5KZFFMZjlPandqamhUVHFp?=
 =?utf-8?B?VDN4WmhtQ0tOS3lTR0lHTzJnRVlrUEV6bUh4OVZhU3pRNkxBcHhyS25WSjMr?=
 =?utf-8?B?S2Y2Y01hMVF1ZlZmVTBTclFjZGF5cDFmNkpUMm5sNGFxSEIzV3piNFlGTHRt?=
 =?utf-8?B?WW91MGhPSlVXcFNObys3bUUrcEF1aWR2U3FKVG9JL1REYkVXMktjODRIV0RH?=
 =?utf-8?B?NWZKVzZOL3JYQ1g3QU5LcXkrYldQMXBObjdPZkduUlAyRlNaT1R0Q2draHlV?=
 =?utf-8?B?U0NYS0UwMlJXKzlTRS9DS002UDMzcnNNalJNcGhHREpxMUkxVCtjcjZNMVNk?=
 =?utf-8?B?Y1VOcllUYlNheHFpdGxrWFJta0ovYXNEaTg2aTdDRTVwM0VRSmpQT2tVME5o?=
 =?utf-8?B?SFJrMU9sNzZLdGoyRkUxSU52cS9vQ2VpWTgycDI3bmlUb0NDT1EyN2Z3aEs2?=
 =?utf-8?B?dG0ySUlqbUppZkV0cFljcTE2MzRKN1RzZ1ZzalRsM3V0RWFPWGlLRjdwWmlN?=
 =?utf-8?B?eENYTFRiVWU4aTBtZERvMGo3ajNJTVNIUktHNkJFUkpoNmdQMUxCMXc1WnpL?=
 =?utf-8?B?T2YzTmRxNStkNVZFdjZjcWllU3VIcjFkQ3dxUjBlWDJmS2Q4RUUrV01VeXFZ?=
 =?utf-8?B?eHBTWDBRQlFTcjFtR2R0dVVaQm5mbmVLZFFWQ0JuTVpqUUJJS05wbVVjandT?=
 =?utf-8?B?RnN5MDNTOFcvL0QzVzY0blhyWUV2Z242czdLaStoUEhEck0zTlA5OVlsVFV1?=
 =?utf-8?B?YW5DQWM2bThtcnhhK09Fam1xTnhZdGtvNGNjQzRmZERxd2VSVGZlMDlScFJG?=
 =?utf-8?B?YXB3L00wOTVxZVliMnQvVnNoZUhXMmFhSDdvTkZ6emRLOUowbEhNS3pUaUVI?=
 =?utf-8?B?aEZPbmliRHJoN1E2N1ZqNnJaZDVoRFlYUzBFcXNnNml4VGM5dlVFdTRQS25S?=
 =?utf-8?B?UlNkUlRZdjJUdE5yekhwNWpTSFlCSTNwbGRTUzgzSld2L0lXcitwNzVBRS96?=
 =?utf-8?B?WGZiZFNBTEVza3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edf6690-0d22-4388-88ae-08db006c09fb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 13:40:22.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+ecYYx8ivmA4iK3cJDUfeY4/+eWocUSll9RUJ/eNEosTeXYNEYC8VkZ+gDxAcBkufjD8fzqS/J7utmO3PssGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5174
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270129
X-Proofpoint-GUID: rh0eXSBrYIfRPK925MEV3yau_st4z8rb
X-Proofpoint-ORIG-GUID: rh0eXSBrYIfRPK925MEV3yau_st4z8rb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 08:28:07AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 26, 2023 at 09:08:23PM -0500, Sasha Levin wrote:
> > On Tue, Jan 24, 2023 at 02:14:17PM -0700, Tom Saeger wrote:
> > > Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
> > > on 5.4, 5.10, and 5.15
> > > 
> > > Discussed:
> > > https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
> > > https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> > 
> > Queued up, hopefully it makes it this time :) Thanks!
> 
> Dropped from the 5.4 queue as it is not in any newer kernel tree yet,
> sorry.  We can't have a fix that is in only 5.4 but not in a newer
> release, that would mean it would be a regression if someone moves to a
> newer release.
> 
> Tom, please submit patches for _all_ branches, and we will be glad to
> consider them, not just for one old one.
> 
> thanks,
> 
> greg k-h


I was sort of hoping 6/6 would have landed upstream before 
sending v5.10 and v5.15.

I'll send those now.

--Tom
