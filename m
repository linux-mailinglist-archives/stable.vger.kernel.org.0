Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9795B6C1E0A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjCTRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjCTRc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:32:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410AA10F1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:28:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KHE2sL013784;
        Mon, 20 Mar 2023 17:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=RgphKe8K4Fim9KHveFxN2eNZ3ZTkoLPyz3TxrYZxb88=;
 b=IW8Ix82fxaEdEmXjgWngSqhswXSChOyQXO055HJTOWKVHffFQPqzbB0HCoK3r43zNRYC
 3SIOR3xvJPIyLBgM/HNx5JLzmhPaQVn0RrOlhLYH6Nc1E+9Wz17vtUAMHhrx9VXsCQAn
 ybZGSNAggYudEeIwYxrBAeOjicecmv45n4TsZnBRUvKAKF44B/4F8SRmSvbRlfRNi//H
 f4TnOCf9BCc0bl0VMv+DqmmsgZdZl55inLEOS704SDWGM5iW1HinlhS4J44IwQ3XQk7O
 7Ex/ozcakyGW4++DsEEzBOzPE5lkt24Gucoz1bLthHYiurxeLBt6bzwA/boVscEVeCt4 zQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433m425-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 17:27:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KGtZj3036692;
        Mon, 20 Mar 2023 17:27:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3peg5nm6yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 17:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUF3g7lrWlbP6UEMUIxtZwCJkLEyE41cA2Eahbc9Opfh3hKktGF8TH3Wv1Z1STMeVozHPy4KqJqXQA432KM4f9O/TEHwAiSZ1EFcqk1S9W0HvgC2Y/vtTNTbD4bE6uZKm/SDoDTe/D61JDuwh40YrJ8GP+QJ6pOrwDHRGXgFj1eNNn22W/6lXG/eHz7MTO5e8zkx8VBCV1IFXCLVheB/VHbev/+IaAMuhhAPRHL63Lnby+dc2bCdheIRpaPnSQual3iBr8PQ+zn/Q+OAkaNmqurjGLmXkgugjbLVWVG1Y4Qmwx8EravZw2nK4Sb9sIopZnC+O9VA483zXhzZdDMKZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgphKe8K4Fim9KHveFxN2eNZ3ZTkoLPyz3TxrYZxb88=;
 b=hp/HDGvP0zTq8dnq6zw5el4HynXQsWkYE3GnmgIdykPRd6KV2JStu/OGUJ9+z8lLcpsrV5BvrtwtJStpIwnmfk8s/kUXqd/hvXM6jS8INF41E4gMvLbqJntV0K3oZSaLL9F8m+v/E79TF6L7NYnggEjhHE8wnEpS4h9Fcr9wIy7fKjk7xBfuQ9Q/faxewm+EYYRGa6+jKP+LXDEKjPF8tUPg+5Obn5qYJoIyZ1SU1O3TwjvmEOmZHy7GE2BWIaADnbanaHORrJUFIF031YC3/0HBAX8Rgs4iuxEg4GmvP/lpSayzcAYXnrr4zeXzaFweDvCMbo0bv9ziSwmrt7UTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgphKe8K4Fim9KHveFxN2eNZ3ZTkoLPyz3TxrYZxb88=;
 b=VwVuLhX2faax4whZmVzxCemI5k7fFLw+CgUJoNjWSwn3bCBiSWzE2qzfUsLNo6WDVy+sLbH1Vjb5Nxc5KGdMwNWObG+u5ETo9ozclb5s5Yt2NNsxVFq2xxKK69lNh7ofFLYVXP1DuR0DLaQoJyEv2uWoZP6dAT+iwESZugJTDUM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM4PR10MB6815.namprd10.prod.outlook.com (2603:10b6:8:109::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:27:10 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:27:14 +0000
Date:   Mon, 20 Mar 2023 11:27:10 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 084/357] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20230320172710.mx7hsqs6tgmcpxjd@oracle.com>
References: <20230310133733.973883071@linuxfoundation.org>
 <20230310133737.692796889@linuxfoundation.org>
 <20230317182806.owvwdor6qpzp6tve@oracle.com>
 <ZBhek48t2C6QBUrp@kroah.com>
 <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
Content-Type: multipart/mixed; boundary="rciby2deb44uvyjv"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
X-ClientProxiedBy: SA1P222CA0160.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::6) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM4PR10MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: dd49d3ba-c3f8-4132-b660-08db29685871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PNu5QsTfuyTpMsxvBc2aDMg+GD8/qGWS52kc7jbZ3sk1tfpu4kkCpzxa/Mout07U7GR5B/ItZnFik8vma9q3tiFk/RuuxT2HV022w+Ztpujr1r28t8GLtLNVUBYB+YEDlpk2wOWrGeQifJEbKFttXoB6R0xHNZMFtWc/Na51Ep4X3ALdIKJgxWG5uotaMi5h6NrfIBGfKKiyzO31VaZdZm9xl5VSXSuACFKsx/XkZcZQAi6I6ehfaKSnW3zPCIqWGF/sU9sfwkS0Xzn1Ue/voyne0uBp6dnlgoILvr4ThF+0KswUkwBYIdEkVYFVRc+ELTcgiTxPl5cnMmeuXs9Po2oZ5RAAeQsE3ntJtOam0GjnXpuqSfpn8lGmB8Y/jWfZwHhbI5qx5EUZ/KdWy0Ic7uzNA9oM3W2WBQ4OKb/GhV/QMjxpiRgqT9ID1oiw3SVSpKXmVLhtPsFzlO0mvoRuzKvYksQsNKjqvIN0eXcfD1P6eO6vLevyqOai2Ub5WWMyU5hGNbQyQO62ta+01rWNOGr1n3v7Om7NZGvPV7yuh8d0yCD9m4DVa6Ko9hZuuE6fLfB5BhG+5+O1yVNinINi4mW8CD3cqTjrf2Jey+B36Ga2oTHX9kC9dLX3yE/M1izZP70xWcEOZNw4X8qZQonM60O8uTXafKeprOpWA6utx5aglnX2HX4DcWFfH42pbjE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199018)(2616005)(6666004)(6486002)(966005)(33964004)(6512007)(186003)(21490400003)(44144004)(6506007)(26005)(1076003)(38100700002)(478600001)(2906002)(86362001)(83380400001)(66946007)(316002)(54906003)(44832011)(8676002)(5660300002)(4326008)(6916009)(8936002)(235185007)(41300700001)(66476007)(36756003)(66556008)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0IzQXJ5M1JoOGpuSE80TXRtVWIyazlBZHZJb1JIUzNlR3QrUnNWSXdxMUNF?=
 =?utf-8?B?WW9RalliRUt6TDc3ZzVPMzA5MnVJYlJaQkZHMndCVHpQNm5iYmtxNVF3MzIw?=
 =?utf-8?B?RU5HLzlFdTVOdDZqaElWODRtWS9qTXdRaVc4cmFHOFFkR0MrelR1N0VJbGVj?=
 =?utf-8?B?VWdJd1p3R200VTU5RWRYb2dXa2tDbWhkdWdPUnJXN2RNRlo2UmpMckY2TVJu?=
 =?utf-8?B?N3dpUCt1c2NJTDdrZ1JIdjJCcnNZVDdUb2YvSzJRYU9wRjBpM0JETktkd1RC?=
 =?utf-8?B?K2pmZTd2WVpadVEzM3Y2N2MzWEprL29WeWpoVnJTd1FUZlhISjlPT25abzEr?=
 =?utf-8?B?SUNCMDNCQ2JUS3pQSC9lSTdRYW92dWwxUFdxS1ZWZ3kzRVdYZGxhNXE5cFZD?=
 =?utf-8?B?Znk1UmpKcng1MmdrcjNUdTdYUWtLSVcxQldWeURTTndCWk5iNXo2bVhmMUdy?=
 =?utf-8?B?V29aTmM2elJxcnJjbFhtaTJNcy9kemVPN2hNaWwzY0RTK3ZsUVJzK3o5Q2J3?=
 =?utf-8?B?b2NKeW54MUxHdmEzQ2pkcVZzZ0k2SWVlTDNjVURYanRYQmpOWGQxZkhEWVB4?=
 =?utf-8?B?NmkraVo1dWtCQ05sVDd0NzUxVnBRSGFDTVBJOENaR3RpMUFTd0xxcExMa3VX?=
 =?utf-8?B?ejhNbUI2ejhxREYxWU9zTE53amQ3VVFTczlBWkt6dStMazNaV1BsMjRsNGIv?=
 =?utf-8?B?aVNNL09hSlZQQlVVTTJ6eCtkUEZNVVhsRHhxQ3ZBL1FQcSsxM2ZBdjVIV1dz?=
 =?utf-8?B?MWpPUjQ4NWhKdlJDWU9HNERibEt0cnNQdTJmdW1rT0VvT3hibStEeks2ZUdL?=
 =?utf-8?B?N3ZHN1BuS2grdU5kaTNqNEdRbDNHSHJNVit3dzB5YVo5RzNxejNRbWtLdkZ5?=
 =?utf-8?B?R2hiRkhkNXViY1RyNHpsKzRyZC9pNEFKY05Jb0U2YTh6Zit0M2pzTDBHQ0c3?=
 =?utf-8?B?OFFpNnArei9wcWNpYytCRHgyeE80NENoOEdISmxsMjN1bTRqQkhsSkp4cldn?=
 =?utf-8?B?ZmhkVTZlL08vdE9oRXVCWElYZjVHMlBsdnpENm9XTDQ3N2ZmaG9iYnc2cm81?=
 =?utf-8?B?QTFsYVBrVEVodldyS2VEUnNDZmNWNm53bGVmU0pDQTE0UHU2SXltcHZpRFFs?=
 =?utf-8?B?WHg1eTIzdmg0MGhuL2pxTlZwdjU2SmlCSFZkNWdwWk8xU09XUjFHUTBvMlNC?=
 =?utf-8?B?U0FZenlobHZmU21Udi96VWVZQkxDSWFpVnR2RmVGTDFNTmttbnlvNXpZdDlI?=
 =?utf-8?B?dEFsNFFPZjgxc2oxUjgwOGhxeSsrWlErTGhPd2dFcXowTUFJN2RTZXMrakUy?=
 =?utf-8?B?aStZSFA0a2dnSUI5dXU4Nlg1R2gvclVEK1R1T0VMRVZxZzdHVE55VDVpa1pm?=
 =?utf-8?B?RlVaSHZIcGVXM1lKeHVWeTdHeXBUUFBmZFdrZXp4ZG55ampYODNXOTlmSWFm?=
 =?utf-8?B?eldpMjJ3ejV5bEd1bFNFWU51WWdRalNIcjF0cXZLeFlkRXAxU3JHUE1mV3Rq?=
 =?utf-8?B?R05Zam80UmVPSVIwNGU2bnZKZmlid1VzbnIvbzlUbThDeUZrTzNFTDZVWTkz?=
 =?utf-8?B?eml0YlVWdWUyb1l4TXhVNUVTazZSQktTQldwdnc1cTc2OEZEbzRTQVdmbWlD?=
 =?utf-8?B?MDlrUTZKanZHZ1kyOFZ5QURYODByWGw1VUhRTW01SStRNjhiSDZ6TVNtR3B1?=
 =?utf-8?B?cjJYQmtnQnNRb2Fsczg3eU1TV2NXQUxUQ1UxL3daQTh1KzJPc2NCcUFMbTQ4?=
 =?utf-8?B?eDhlTGNzaHkwQTFLSU1YdzhlS1Y5VTQxZHQyeGQ4RHovZ0syOVRTV0ZMeGdk?=
 =?utf-8?B?OU91Tm5TWW5UZkc5YnkvT2tGaWdzSjBTZmkydG04NlpOLzRyV0VsVDFVTHlk?=
 =?utf-8?B?cWkyTUJPS2gvREFtQTlvTUU3MTRGT3pCTCtIQWFlUy9yQjFnOTBXelNOSzVh?=
 =?utf-8?B?QlRDTkRnSEhnUGJIQzhiTDNLaE1pMUFDVGJkTlRLaTdmZlN6WS9GdkdpZXU2?=
 =?utf-8?B?amxYc1NvUTBhSnJmdG5UbkVHUnZPdGxrWmY4blRKbTBtdDBiV21ISFBtVUlo?=
 =?utf-8?B?aEtxYS9LWE8veVBJaHVxeldXakl0ZE81NWpxVEl0L3E1Y0MvcjVrU0JiV25x?=
 =?utf-8?Q?4AM7E10AoL9S8jr0IoboVeICH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NzN4UzRZTzVoeFc5bFFTQUxwN2RSOXhXMkwrMmtwenplTDlJcXFFV1poQmVw?=
 =?utf-8?B?YTJ2ZHFVQTVQMnoyNkFKL0NZcGoyTUlzR0ZoRTRwR2drT281enMrTmtDT2xh?=
 =?utf-8?B?OEZjOTd5Q1BCK04vTnIzeEFvd3JvdzJETFZvWXpla2lCSFNhM3p3cjErK1Jw?=
 =?utf-8?B?d25uSXI3SzlXTzJpTEZFQ1lRbmxHVm56eVlWNW5YaWZMUUFFUUJvWityQWd3?=
 =?utf-8?B?RlhKZEdBU1RBV1ZISy9Ydko2ZjcxR25qWVpZd0grYW9Nc3dBK2xoVXRzeEFh?=
 =?utf-8?B?RUsyZERubWFVS1kzcVJuZlJRMWk4R2FPd2NtVGJZV3E0M2prUzRLNlFaK25v?=
 =?utf-8?B?OEgzOGdLRXlhYWJvTnJXSFpIUk1VS01JSkRORmcyOGVvVDEwWHlJeTRmNHhk?=
 =?utf-8?B?WWNFZTNWTWtHSy92WkpEc0FSWXhWOWpURXNRMDIyU2NNdG9MbTJLOHpQeFFC?=
 =?utf-8?B?c003M0JKUVd2dXFCQ2ovUXJObDZmVFR1RkNCM3UrWktJNXlubXR0MS9sSTlJ?=
 =?utf-8?B?b2JTeXorUFZYUWs4UlRCNDkxVnNCZDRtRldPbldDQ2lBckZ1OVlYYmRNWVJT?=
 =?utf-8?B?UVp4b1JHSVJJZ1VtSXFGSk1KTEFLMlJULzJBcVdCdC9xd293d1VyZ0dtbFNi?=
 =?utf-8?B?cERXWWNuckNaUjVaaVhIODl1WVpqbUE2R2NMaFcyMGQrT0FyWEZZVHJEN28w?=
 =?utf-8?B?cHdISWZKeHV3ZzRzMkVnbmFFbG1jb0ZHYlIxalRJRk4yUGUwRVJhSDZ3a1lh?=
 =?utf-8?B?S1BzSXBvMUtpRlc0clpPdXVMTmVHR0hJdWxabnlqZW1oT3h5aE1JTWR2ajVT?=
 =?utf-8?B?Mk9BRTVUcFphTG5rRHNzZGQrL3ZIOWlJakdnQzlZZk9NZ2hGNlc4OThnZHN0?=
 =?utf-8?B?QWNaNTBkRWxxWGdZNFVhaS9zWmVwNVllbGk3NTl3cTJ1a0V6VmN4eGhtTUVU?=
 =?utf-8?B?ME94Qmt3MThUWUNQcC8rbCs4MFhYZWZDZVNwaGRUYjNKM09RajhnTlBKaVIz?=
 =?utf-8?B?SmtVSVpUYlVuMGdTZEFrbUlXbkZpRWVLbHRsOFlCMDRrYlBuRm1QWTFPWExk?=
 =?utf-8?B?TUZ1ci9mSXoybENTWWY1bmhnMW0vTzVpQzJYWmpOMjlhaHVCeWRDSHdzbnYx?=
 =?utf-8?B?dzYyY3B0QndLMm9ma3d1MXJodnVYK1NyQXMrUGtORmxBZ0d0VGdFeFBObnNk?=
 =?utf-8?B?U1k4N0pCRG44V0xsMlVVMEYvb3FjU2xjODYyQS9wUVlYQWhwNnhjSGFaYnVL?=
 =?utf-8?B?cHFnQUd3QkRZWWZzNVg2bDNmc0ZOdzBycWtJa0o0QXpWYWVTQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd49d3ba-c3f8-4132-b660-08db29685871
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:27:14.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXRNrQyrC3zcaiQBatxea0qbOmR5z2tzvnc7d2L3Fr9kh0BR5RVwA11RhC9iVelOrluYACcLgbsrejtl14fOTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6815
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_15,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=678 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200147
X-Proofpoint-ORIG-GUID: VTAZqWXOfjPebQtN_LLxbXkFHbrS4d4y
X-Proofpoint-GUID: VTAZqWXOfjPebQtN_LLxbXkFHbrS4d4y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--rciby2deb44uvyjv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Mar 20, 2023 at 11:48:02AM -0500, Tom Saeger wrote:
> On Mon, Mar 20, 2023 at 02:24:35PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Mar 17, 2023 at 12:28:06PM -0600, Tom Saeger wrote:
> > > On Fri, Mar 10, 2023 at 02:36:13PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Kees Cook <keescook@chromium.org>
> > > > 
> > > > [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
> > > > 
> > > > This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> > > > macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> > > > tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> > > > data argument, it has been removed here as well.
> > > > 
> > > > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Acked-by: Thomas Gleixner <tglx@linutronix.de>
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > 
> > > I noticed kernelci.org bot (5.4) reports:
> > > 
> > >     Build Failures Detected:
> > > 
> > >     mips:
> > >         ip27_defconfig: (gcc-10) FAIL
> > >         ip28_defconfig: (gcc-10) FAIL
> > >         lasat_defconfig: (gcc-10) FAIL
> > > 
> > >     Errors summary:
> > > 
> > >     1    arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared (first use in this function)
> > >     1    arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
> > >     1    arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used [-Werror=unused-function]
> > > 
> > > Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/
> > > 
> > > Here's what I found...
> > > this backport to 5.4.y of:
> > > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > > changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
> > > except one, in arch/mips/lasat/pcivue_proc.c.
> > > 
> > > This is due to:
> > > 10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
> > > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > > upstream and the former not being present in 5.4.y.
> > > 
> > > I rolled a revert/re-apply with fixes in the attached mbox,
> > > however maybe just a revert makes more sense?  Up to you.
> > > 
> > > I have yet to try building this on mips, just did this by inspection.
> > 
> > I've taken your patches, let's see how that works...
> > 
> 
> Ugh, It didn't go well.  I now see a problem.  The change to DECLARE_TASKLET_OLD also
> removed the last parameter.  I missed that.  I'll spin-up a mips build.
> 

I've now confirmed locally with gcc-10 mips build of lasat_defconfig


fixup patch should be:


diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c
index 8126f15b8e09..6b019915b0c8 100644
--- a/arch/mips/lasat/picvue_proc.c
+++ b/arch/mips/lasat/picvue_proc.c
@@ -39,7 +39,7 @@ static void pvc_display(unsigned long data)
 		pvc_write_string(pvc_lines[i], 0, i);
 }
 
-static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
+static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display);
 
 static int pvc_line_proc_show(struct seq_file *m, void *v)
 {


Attached is a reflow of these two patches.

--Tom

--rciby2deb44uvyjv
Content-Type: application/mbox
Content-Disposition: attachment; filename="mips_declare_tasklet2.mbox"
Content-Transfer-Encoding: quoted-printable

From 0b1ed2eab2fd9d748523d951bef0acfa533fd838 Mon Sep 17 00:00:00 2001=0A=
From: Tom Saeger <tom.saeger@oracle.com>=0A=
Date: Fri, 17 Mar 2023 08:25:30 -0600=0A=
Subject: [PATCH 1/2] Revert "treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()"=0A=
MIME-Version: 1.0=0A=
Content-Type: text/plain; charset=3DUTF-8=0A=
Content-Transfer-Encoding: 8bit=0A=
=0A=
This reverts commit 5de7a4254eb2d501cbb59918a152665b29c02109 which=0A=
caused mips build failures.=0A=
=0A=
kernelci.org bot reports:=0A=
=0A=
arch/mips/lasat/picvue_proc.c:87:20: error: =E2=80=98pvc_display_tasklet=E2=
=80=99 undeclared=0A=
(first use in this function)=0A=
arch/mips/lasat/picvue_proc.c:42:44: error: expected =E2=80=98)=E2=80=99 be=
fore =E2=80=98&=E2=80=99 token=0A=
arch/mips/lasat/picvue_proc.c:33:13: error: =E2=80=98pvc_display=E2=80=99 d=
efined but not used=0A=
[-Werror=3Dunused-function]=0A=
=0A=
Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google=
.com/=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
---=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 +++++----------=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 16 files changed, 21 insertions(+), 26 deletions(-)=0A=
=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index dbe836c7ff47..5fe7a5633e33 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
+static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index d36e89d6fc54..4c039e4125d9 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
+static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index 6ac6a649d4c2..a2527351f8a7 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
-static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index fb1de363fb28..5256e3ce84e5 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
+static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 774abedad987..64c979155a49 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
+static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index 100b235b5688..fe6e1ae73460 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
+static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 0da9e0ab045b..68643f61f6f9 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
+DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index e76f1a50b0fc..afdd28f332ce 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 5c423f240a1f..3235d5307403 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
+DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 30e92536c78c..89fc59dab57d 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,17 +598,12 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(0),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
+#define DECLARE_TASKLET(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
+=0A=
+#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
 =0A=
-#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(1),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index 370217dd7e39..a2a97fa3071b 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index f88611fadb19..565987557ad8 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index b7af39e36341..98c04ca5fa43 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
+static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 579b66da1d95..45d8e1d5d033 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
+	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index 392f8ddf9719..46ba86b8df28 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
+static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index ce5bab7425d5..8f0f05bbc081 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
+static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=
=0A=
From 11fb97c7ec4af4f962125246e0230812707fea06 Mon Sep 17 00:00:00 2001=0A=
From: Kees Cook <keescook@chromium.org>=0A=
Date: Mon, 13 Jul 2020 15:01:26 -0700=0A=
Subject: [PATCH 2/2] treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()=0A=
=0A=
[ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]=0A=
=0A=
This converts all the existing DECLARE_TASKLET() (and ...DISABLED)=0A=
macros with DECLARE_TASKLET_OLD() in preparation for refactoring the=0A=
tasklet callback type. All existing DECLARE_TASKLET() users had a "0"=0A=
data argument, it has been removed here as well.=0A=
=0A=
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Acked-by: Thomas Gleixner <tglx@linutronix.de>=0A=
Signed-off-by: Kees Cook <keescook@chromium.org>=0A=
Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_s=
inglethread_workqueue")=0A=
Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
[Tom: fix backport to 5.4.y]=0A=
=0A=
AUTOSEL backport to 5.4.y of:=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,=0A=
except one, in arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
This is due to:=0A=
10760dde9be3 ("MIPS: Remove support for LASAT") preceeding=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
upstream and the former not being present in 5.4.y.=0A=
=0A=
Fix this by changing DECLARE_TASKLET to DECLARE_TASKLET_OLD in=0A=
arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
Fixes: 5de7a4254eb2 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASK=
LET_OLD()")=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
---=0A=
 arch/mips/lasat/picvue_proc.c          |  2 +-=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 ++++++++++-----=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 17 files changed, 27 insertions(+), 22 deletions(-)=0A=
=0A=
diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c=
=0A=
index 8126f15b8e09..6b019915b0c8 100644=0A=
--- a/arch/mips/lasat/picvue_proc.c=0A=
+++ b/arch/mips/lasat/picvue_proc.c=0A=
@@ -39,7 +39,7 @@ static void pvc_display(unsigned long data)=0A=
 		pvc_write_string(pvc_lines[i], 0, i);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);=0A=
+static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display);=0A=
 =0A=
 static int pvc_line_proc_show(struct seq_file *m, void *v)=0A=
 {=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index 5fe7a5633e33..dbe836c7ff47 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index 4c039e4125d9..d36e89d6fc54 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index a2527351f8a7..6ac6a649d4c2 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
+static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
+static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index 5256e3ce84e5..fb1de363fb28 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 64c979155a49..774abedad987 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index fe6e1ae73460..100b235b5688 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
+static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 68643f61f6f9..0da9e0ab045b 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
+DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index afdd28f332ce..e76f1a50b0fc 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
+static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 3235d5307403..5c423f240a1f 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
+DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 89fc59dab57d..30e92536c78c 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,12 +598,17 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
-=0A=
-#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
+#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(0),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
+#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(1),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index a2a97fa3071b..370217dd7e39 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
+static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index 565987557ad8..f88611fadb19 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
+static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index 98c04ca5fa43..b7af39e36341 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
+static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 45d8e1d5d033..579b66da1d95 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
+	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index 46ba86b8df28..392f8ddf9719 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
+static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index 8f0f05bbc081..ce5bab7425d5 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
+static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=

--rciby2deb44uvyjv--
