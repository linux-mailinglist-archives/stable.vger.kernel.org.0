Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF846C1FFF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCTSgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCTSgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:36:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C6949F2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:28:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KFx4oO024099;
        Mon, 20 Mar 2023 16:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=IMnxgEBjy+RV1vfOAI7NmvDCy0itVd4+mDl4j1SOVXg=;
 b=kQnEiQL0pRwK/BTxC4GWKh+AmPeaYxpWFCWpedqmlUhh8m/SHwPp0hkQGVxKmnRxrh7K
 496+3i3yIG5qAVjkNkwdDKsW9ZE1wJXIObfWkPDrJqHGjtOePXcH7tu9lVVK5ImhKSox
 Jlm8eOSlWQe5JF9C+eqmeJjnrJbq1NfhVepWggW7k4bIAqVHTNqVg+dCHO1OfQ6jM+I+
 X/96BMXxPVvREea0MRz76FnY41LyCP/OebZzL77449tjpdT9/OrCX+Bs0wyU0/AQPIK7
 U3QIO5M5DYBGEMxQ1HeTQSo7NBP4586YA36Mb0sAe/QZLNWkiTbI3k7g+nTU1lD7sNCO Dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3wgc1dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 16:48:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KFFdLv038628;
        Mon, 20 Mar 2023 16:48:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rc1hbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 16:48:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHYB8tbywrAB53Swz6lveyMzrcPZIqNKXP2Od9SylHumzFboODTAB3P2X/pQ0BuD1yyJhS9Ub+6BlQ27qeAgjtZZHw1wRREePvytql/KrGQ5Gc6tmNCFFX5cmcXwTxOlbrKCTEOidYy1KNIq4iOkVKYpmYbOAB3E1Co7P2gcq4WNvyE1J+vJjrM9RHRJdXX2Up/O/OO6dMPRgko9txdWYuzdMqtRFoE/D9cDm/tSblFbg2DZBUCHa/E02uiB4AjuH+ndmIo0iN+ulaXmtRJ0ddOVEr8qgwUFElQ3/xwLB3NvvCbDVL3nHUdJ8GZGgc8Y60hz0zlMrdG1Zs/xJpDoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMnxgEBjy+RV1vfOAI7NmvDCy0itVd4+mDl4j1SOVXg=;
 b=YRtK+LH9drTkBsZjtAE1II/3erDcZ9m7e/rw0z0fw4hn2MJDzMPmnyiiQ+5DfEZh7QdJVozDQr5LeZTVofrsF7grx3MGt2MbWg241IheHr0G5vfW0vA1haG43PVJqspZl1bcSXyNKcgVrQGquZBXBkm/wfXMnUlzq262JQ71Wrl3FGraJ8L46BS1Jt6/jnWGJqWPOfie0MvY98D5QCbkPhNeP0vmABG3IztsNfn9LomQJeBuLeaxHIG6Wy26un4np8F4nRGkvWxr8hi/jIHzFYA7iONcHz83X5wa3D4H+nmuJ8TN1Ep3cRG7jvb7HH0OKMdSaDpXz/9GZtTjTarx0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMnxgEBjy+RV1vfOAI7NmvDCy0itVd4+mDl4j1SOVXg=;
 b=ICo4PqfRtB7ZFit1+J64vqKgmnH1BOehIFstid3BGYSelvXxP8uT5W9A7Ma+w7xHqxkonOSiwN+jpOIHRFyzK4aqGaAV8J31UKJY+Wv/u9g1wdThCaRVHHJStu1Rrp28ZZ5uJ0ZnHFSCOYf1VgFoGkJU8KoGBRw+iNqQPPpR2fg=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH0PR10MB5594.namprd10.prod.outlook.com (2603:10b6:510:f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:48:02 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:48:02 +0000
Date:   Mon, 20 Mar 2023 11:48:00 -0500
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 084/357] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
References: <20230310133733.973883071@linuxfoundation.org>
 <20230310133737.692796889@linuxfoundation.org>
 <20230317182806.owvwdor6qpzp6tve@oracle.com>
 <ZBhek48t2C6QBUrp@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBhek48t2C6QBUrp@kroah.com>
X-ClientProxiedBy: BYAPR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:74::46) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH0PR10MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c896a71-1d08-4fa0-edac-08db2962decd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZObJXWiANRmkRcHmke8iqmWcICAhGegBvtOIN355nwgl1m2EzSpvM46DE/L2edWjpI+bfrRuK7x9kX52Wbt0XttrAp/9RTSwWOqVSmhfIubsaHmCasghLjic4gJyu0PRwQYTZvPejlB4A4/gmzdBwtwSip2Wde9pPNfMtU2ML1b6y/0dgsGLAh/kT1mcj64xN3aricBR1rBS6htG6KdUyeaX0Gc+qBFVb0MaKhfcduefew0fV0okbfkQnsAIPpZjOMv92KGgm5WnqrvycHmkeZGf7qq2unspuJ649T+K236tDSEN4kJf2Dj6+BAi18XSWY12o6PDNeTZWw03EO+/iOL8MtuLu2DGZKdfO/qmiPtB6AgDi2SWetcDOI/JwdwlvLAXF5FD/kbVP8Ql3S3p0eP4B/9ssQEjfwCnEh5by6holc8yHV8ROvtKsYfSomyNAUHHySPZCkFaaRIRVR0ZHoQG72/ffNS4hHDAqh6APguLiM3AV5xY1b9Y0c8Vkr5zZoaBJ/bD5xKyM9D43ZYG/WBQCCaF3wPGPq1+nhx8JE7BN+YH0aF3DDdZHjoHuO54EJz4mOOheQHZPZDOyLsedKlHHuKBmNWXqNLP2BsbQ95LkC+Fx8vrw9Uh8H9YsYD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199018)(316002)(83380400001)(2616005)(38100700002)(86362001)(66946007)(6916009)(8676002)(41300700001)(36756003)(66476007)(2906002)(44832011)(66556008)(8936002)(4326008)(186003)(5660300002)(26005)(1076003)(478600001)(966005)(6512007)(6486002)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjhOZURCbXNaaXJ6VHA1T0RBeGlRdkNYWnNVSEVMSWJEMnZCLzYyRzliaVlz?=
 =?utf-8?B?aEhXRzJ6ZldGTUUwN1VuUTE0MUNzanVPbVIxUm1jVGprUVBNb0h2djFHYUxV?=
 =?utf-8?B?Z0ZSaVpKclI1dVAwVTlSWEc2M3ZpVERiSExycXdWSTkvbUtlaE1GdWlKWEFX?=
 =?utf-8?B?R0pObVQwektWSlhlbjR2RVNMVmIxNFBQZEJjSG1YbEszZmlUaUsxQXFsNDdE?=
 =?utf-8?B?NHRnUUF3OExXWG40ZGhpNGM1dmFzbTAzUWZlUzRmMy96TlA4SksxVlUrT0dN?=
 =?utf-8?B?UUkvRW9uYlV1NmFSa2ZJN21ZVTJCcjByb3c3aG56VVUzZHM2eGNtUzhieC9I?=
 =?utf-8?B?NUdsbVNsOFV0UWJlZlZ1cjN3MVMvVWJmZTQzQVM4MllESFJ2T09QajdzSW9s?=
 =?utf-8?B?bTdubmQyL1hqRTJYTEtHbCtUWE1ucG9lRnpFTVk4VjNZUFpGc0tuYmF0RUZD?=
 =?utf-8?B?Z2dRWFRMbFhOQmV2alJUR2J4Z0xBSjNVelFWYXFPK0pTdFV5RU53bkZ5eGhs?=
 =?utf-8?B?aC9NSjR0cENrbzBmSFBSeVBjRXBJZVNRVVI5anhCczlsMzNCcmh0eUpENEx4?=
 =?utf-8?B?UHFsRVpHeE85aEZkdW5hUlZFQ2d2S0tOUG15eVlIR0hxWjdvZnJocmEvZmRH?=
 =?utf-8?B?Rmhsa0JGTGE1RngzOW5Hb29TUFRkUGwySHhIczEyRVZKOFRZdjAwTTZxMnYv?=
 =?utf-8?B?UlFYb0tPaENKZmt3eThkSzNqczlzMk1zdmJKdTZSRlZ1MGxVaVUxNmdneXpL?=
 =?utf-8?B?T2Nhb3dCcHNQaEo3SDFqb21hdkdpbkJHU01vbkt1SDA2MGxFRjJnQU00NU1s?=
 =?utf-8?B?YWJmczNXa0dEcXhOc0xSR0kwdnJXZWN3TmlWMHpDMG5yQVNIUXlXKzU0dDJo?=
 =?utf-8?B?SFdsSVY1SUI3WXlraGhnRjBmaXlES2xHV3prNEtNSlNkZHRXQ24vN24xRldm?=
 =?utf-8?B?bTVVWmF0SzZOTVZhckNuUXRPSVBwU1V4c3J5dFAyOE94eFY3MXV4V3lzN3dv?=
 =?utf-8?B?eW0wY2hkd1A3eVVHR2lOTkI2YlI0cXZZNGZzQmxIMjdsSnhidDgxb21EY29a?=
 =?utf-8?B?ZHlEY1RKTnFjZ2dxazN5dW5Vd1hrSjZ1dmVlanMwSjByaUdVeFdIZENIemNB?=
 =?utf-8?B?amh3M3AvdVJ4ZlNvcldac2tETzFTL1Z5S1lnWnB0S0s3WWl6V1JOMHJ1c25t?=
 =?utf-8?B?VDB6NGNxSTlFUVJuMnJmQXVxN1RpM3FQemJDd1I0cGRaMTlRR3AzNnZDUDNu?=
 =?utf-8?B?Vnk4YVVqalhWU3M3blJBbU1TN3FjYW81TmYyKzJuNDRwU1dYdWJLZDRzMmIr?=
 =?utf-8?B?T2o0VlpXR2U3VGNnRXFPSThKd1kxRVAvcTFJSHROUUx2Q2pwbUJoV3Y2RUk1?=
 =?utf-8?B?bFFNK3BpcU1yYkZ0SVpSRmNkTUViRjVhaFhRaE1xeDUvYjM5ZnlJdUhaYXRr?=
 =?utf-8?B?MnpzT3o2Q0JtVkRyVm0zZHBQTUNiUWVVaUhqNXVCaXp2TzNwdGxkYkhKV1Rj?=
 =?utf-8?B?TzVMVW1DR2djNGFNSVBhRkxTWDVxRVh2cHVHcnYwTXF5ZXlVcXpGKzdtdCtJ?=
 =?utf-8?B?V0FFbWU4U2NYQWRKak1QRElkQklpK25YZEU5YmRKZ0Z0eGZONFBYbHZoUkt1?=
 =?utf-8?B?aEtsU0kyWWpKbkxORGFvR1J5QmdkY1B0VTUvSSttZm5YVGk2T1Ixa0wydGV5?=
 =?utf-8?B?ejZIK2lUT1ZQcjVZN0hLcXU1YXl6dlQyWjBmNUhxTzc3eDRIcUZPVGlLeXVM?=
 =?utf-8?B?N1J6b2lmZ1Z0MFFtS3VNWnhLWnVDdmk2Z1FnSjQ3ai9EemI5VC9FVVo3TjQx?=
 =?utf-8?B?RFhYWldVMmhXRTlZbGo2Ymp3L21acHhCVUZEb0xxNUM3Y3RETCtIOFNHcEM3?=
 =?utf-8?B?UEc0emdiUUkwUHJWekhtTGpJVUJrSTFSRzlRUDJZT0JmZVhINEFEdmNJellL?=
 =?utf-8?B?dDF4VzhMZ0FEZ2FGZXFTUldDUE0rVHh0RmdGNGFDUVRZazVyalJCWE9valdy?=
 =?utf-8?B?bDZPdlB5eTdmWlZNdkJPS2tjbExJQVdudU5wVHdsU2dqQ0s3a2J0RldKNDU5?=
 =?utf-8?B?QjJEaHdjVTR6dW9qMUVQNEh5YTRFVDE3bFRIVUNhM2tUTGZjQk9jSE55TmV1?=
 =?utf-8?Q?KZmEcI1NHVV1ySL0cQT0gm8d8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SkI3dGpGQ0F2bVFWSVZKQTQ4by82MlhrYlNRVjhxZHR0dUlzZXBqNXVPUnNT?=
 =?utf-8?B?MGhjSVVKUXVxZFlVTlJVb1l0YUllMkZQLzVIVnlBbXBXc2NnYXNDN1VTVXNa?=
 =?utf-8?B?bUp4cUd4b3ZHK1YzY3laaWxDampTamE5cGQxU3htRDdSZEt2dmRJZnU3NnQv?=
 =?utf-8?B?dUlod0JIanZYNTM0K2YzK0xzYkNNM2ZrMkVnbUkxWnR5UUk4RW5KYWNkcHRJ?=
 =?utf-8?B?bDdSQ2QvM2JlM1l1aGtzMnhKeHZrMmszeWFsSWVZN3d3TFhKUVJ3WEtqNmhr?=
 =?utf-8?B?bjN4dkdJc29USVkzR3k0WUtFblpvUFQ1dXJJOTNHalJmb2wxaGpSNTRUdUNH?=
 =?utf-8?B?OHRicTNEOUlLOXVKSjZTaXlzSmx0K0VKclRlV0RaSGFWNmRidGF4VzhGY25w?=
 =?utf-8?B?RjZSQktxVTNRbTdmUmVna3owdks3T1pac2JWK1lNK2pkK2YyVUNZaUNMVldT?=
 =?utf-8?B?UEJUS004QngxMFg3dlhJVWVBak9GWk5UWE1BeXZLSW1ibzFMS1l2R3RIWDA0?=
 =?utf-8?B?SGxhaSs0RzFFK3BNUzlQdWNDSHUzY1ZHdytKQ1lJY01WNVlvekxXNElCUEtu?=
 =?utf-8?B?UzFBWGR0aE9weDhPQTJ2TXJSdTdUOEJNTkJ0L3BVSnNZdEpsM1FXRjQwYzFN?=
 =?utf-8?B?SldJcWtNL3RobnNBV1diV2N3VUs3eUFGNWRlUlMrQmtyelZ0VnowdTFxcmwr?=
 =?utf-8?B?SEtCRXB5NXM1bGE4dlhXeWFvbEVmSk40UmZMRjRuZW9Sb0VZTTFJWWNYbFBh?=
 =?utf-8?B?RjVSZjNEcTlSRDhWNTlpSEhLbnIzcUhvMHNmd3orY2tIRnJyc0ZHbE1PckZY?=
 =?utf-8?B?NlZLSEgzaFZ3dGltbW5aMDlFNjVjVU9sMmJYYTE4MkFTbCtNb2ROSjNlbHBF?=
 =?utf-8?B?Wlp0RXlWdmlOampjQS9vdnR1NTVvUkp3QU9IdkpiUDJFazRUYmtNR3hQbjlv?=
 =?utf-8?B?TmE2NG4zWnp2SFdNcGtvQmpidXNBUkpub3phYTh5SVVodjF4S2VaK0FFRDAw?=
 =?utf-8?B?RXRmczlEUmtLUUhpNkN2R2hQamdUalJEcXFteHpRZUtsRFBLN2xueDVjbmR3?=
 =?utf-8?B?eE1WTE9hdWpEZ2c4NlR3b3JiMHRibGNyeVV2eUlsdTJIcjJ5MitmQUlpaHpB?=
 =?utf-8?B?ODRHYi84WTNWSExjOXdranNZakYzSElvemwxYy9aZnUxWDNCU2dPek9OZ0Jy?=
 =?utf-8?B?eGx5ZEtQeGJpRDEraURjR29Ia0xGZE9ITkFOUlRuMDFDaUcwK25jQm8waFNF?=
 =?utf-8?B?YjVlUmYwSExVejEzQ3dNSkJkVDlid253K09uSmVoRDhORnllUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c896a71-1d08-4fa0-edac-08db2962decd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:48:02.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MC5ic292zr7naa0CWFtFDx1uJ9c7v/pFNtaqTfLBhQoa8mU/ThD8ot7RMD6b+NgFpDFL9kw1s1a0Rp2CtX+pCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_14,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=642 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200143
X-Proofpoint-ORIG-GUID: FW-pKxxPFJ5ATjj9BSdqotCaK9Kf62C7
X-Proofpoint-GUID: FW-pKxxPFJ5ATjj9BSdqotCaK9Kf62C7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 02:24:35PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 17, 2023 at 12:28:06PM -0600, Tom Saeger wrote:
> > On Fri, Mar 10, 2023 at 02:36:13PM +0100, Greg Kroah-Hartman wrote:
> > > From: Kees Cook <keescook@chromium.org>
> > > 
> > > [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
> > > 
> > > This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> > > macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> > > tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> > > data argument, it has been removed here as well.
> > > 
> > > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Acked-by: Thomas Gleixner <tglx@linutronix.de>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > 
> > I noticed kernelci.org bot (5.4) reports:
> > 
> >     Build Failures Detected:
> > 
> >     mips:
> >         ip27_defconfig: (gcc-10) FAIL
> >         ip28_defconfig: (gcc-10) FAIL
> >         lasat_defconfig: (gcc-10) FAIL
> > 
> >     Errors summary:
> > 
> >     1    arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared (first use in this function)
> >     1    arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
> >     1    arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used [-Werror=unused-function]
> > 
> > Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/
> > 
> > Here's what I found...
> > this backport to 5.4.y of:
> > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
> > except one, in arch/mips/lasat/pcivue_proc.c.
> > 
> > This is due to:
> > 10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
> > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > upstream and the former not being present in 5.4.y.
> > 
> > I rolled a revert/re-apply with fixes in the attached mbox,
> > however maybe just a revert makes more sense?  Up to you.
> > 
> > I have yet to try building this on mips, just did this by inspection.
> 
> I've taken your patches, let's see how that works...
> 

Ugh, It didn't go well.  I now see a problem.  The change to DECLARE_TASKLET_OLD also
removed the last parameter.  I missed that.  I'll spin-up a mips build.

--Tom
