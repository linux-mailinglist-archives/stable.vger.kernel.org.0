Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED66E7DAD
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjDSPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 11:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjDSPKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 11:10:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE2344BE;
        Wed, 19 Apr 2023 08:10:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JETUSj010036;
        Wed, 19 Apr 2023 15:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-03-30;
 bh=F+kS+kxTC0EramMDfQGcPm+yRCATd1Nx7IBbzqTnll8=;
 b=gaUQWzidOZXdNcSMJDmTonK9yw3zN9Kxs8AmPKdmeuClFsKK7QSsMq4aAmpGTexbMCse
 FkKWhvtyt9aIWbrJAZ9RArQodGOGA7mkRHraEAEWtpono1syX3AbJMaI14UK181mS81R
 CfktcAQyNiqhXpGAgyTulzCdpMRPKN84WbkkVC0TYZca+tv7/pl2txwX+V3bd3MkTvJd
 QsvyOQp5LoHFTBwrceqoo6RW3hOo7BeCVmF/9ivLMRnJVrWShSygGFpDMDEH2ghtkqYW
 RAwzCqfkILezmtXUldxyOsBoLKMc+732bsDQr/mfMefRZVryvfz0C9rbNSWPURQwgZ28 Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjh1rmu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 15:09:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JDqteW037106;
        Wed, 19 Apr 2023 15:09:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcd36f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 15:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqZvn9GGLTOPPLmjvQ0ePrprVES33go4mF9Kwk0p7+ZNPiNavnrMU3JOdabr7qWDtH04ieqfC0x0cYrnVJipE1lOSDFUtIMziwvNN0dmbQteEObsPgfpCqXP7EMQ5srnWuOqA41UMSyQjdo+CKEkzrzneq1GB80hvK+uackbTVGewBO2GMNlJGCqbyjDViF+sjiphMYuGKDEXrd0pFIj6pR5tD1gaXiWfjCgVAOToHcqIlSvu6iWFdyxWUNhXCDgYGiuhrhJZTSK7Kth/OCfVoidNA3uKGqDFgsO86LLlDokkiZ4mETN7UoQ6gHccUqBhZM5WfJIiRkvN3viIRK3eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+kS+kxTC0EramMDfQGcPm+yRCATd1Nx7IBbzqTnll8=;
 b=OEcurNtAqTEK27GbJLfkhQaWQYBnVK9ngl/LCrofqufuFowYutbbt3Z8I8rbOeFhbk4dqqWvp0VUQWmxoY56tSaux/aNrSL0LriWzr+/jqnqbUatGa89u4xZBGp0nfo8o3sqK4QJS/UmAapZLqb3x9snyq6IWoeU6BTxPJj+2Br5gYICV2E5FC/OmKb1CkiGo5paYehIwklJDBbRYwZ33dVxz5qsWaGSjdqmGHLwIVfwnfn6hIXMgiM+tLfEEgX/WLHEgEiygoKhJwq1yM4osJTCcG/UNh3UiSQu1jUsrA6XnXDH08l0oP37c85iXwfKIZmocR9uJsWdynhMYIcqlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+kS+kxTC0EramMDfQGcPm+yRCATd1Nx7IBbzqTnll8=;
 b=hucHBN3/zjuBczG6ULOCweP67iH28RuOI8n1eEWEmGTROb2Q7Cm2wiLJKo4HaBgusLyo4dUYiaIYuHzFOYjX//O7wf2YzlvEiXBnLI4okLAhi3b1dnhh2e1d7sWBjQDyF/jCOad/HU+hWk+G41QGbVdLl8XwDR41hkg59pLKBnU=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 15:09:30 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837%6]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:09:30 +0000
Date:   Wed, 19 Apr 2023 09:09:23 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
        Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <20230419150923.s5vbpsjqq3hlcl7k@oracle.com>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
 <20230418165105.q5s77yew2imkamsb@oracle.com>
 <ZD9rfsteIrXIwezR@debian.me>
 <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
X-ClientProxiedBy: SN6PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:805:ca::38) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e3fa802-ed72-4e99-3eb0-08db40e81290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +mb/KZuGT3ftF+CoX8CeQjN3ayM+DuEET5gNmtAvIEmklIzHwKnLbWyQLsD/cxe4oY+d1u8k4clDCc8FZKY/hCePf70AbXRMjkjkQVJvxMKCe+9MjfdQK5YvgHXaCJHHbpXz5F5v81JAyk9mcT18igANpkPGBUW2DiWQAlfWA5FbKcuEnVGsHfH14cbhpDojJuswIBlIUcWoP9d03hB9LtQpTZPg2JiNpsXTg+12JkxrYthQBHpvrOFwafoY70rYcGZk1xAzby3APDoaMtXGmeQyGVWPri9J7P0g0ukLZoG1ZOeorXSxMo/cEgwdhxNtfP7tgR0GghLM5I974VNjezia5xdb5wJLeDd2RVRqkEncgD7+y/ffquLTONXxvQmM+w/XjddoDcQrwwUPN3yojGgAPwWQYDc4Ogvpd6PU/fFeD99OdezvcrY9RlP0FXM9Bbd6PI586ji5gLB1jOyCzlRDeaC2UBCEa+3J1wxM4UjZYgfta9HzhhvPlq9pr2dq0tYUI45Z88CGBx9BJnqRQjAe0pR/iONJPIB2EhMi+wQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(2906002)(8936002)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(107886003)(6512007)(6506007)(1076003)(26005)(966005)(54906003)(478600001)(2616005)(83380400001)(53546011)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVA0Q0tjYkUrN2FKY1dMdnk0VDlsellsOG5vd0ZidXhiZ0h2RkZKS0hiQys5?=
 =?utf-8?B?OE8vQTNXRHNCYi8xUnNSVFFWU0dNdkUwTXBaYWtZSTdjWDJmZFpnRkxoeCt6?=
 =?utf-8?B?VEMvL2pFU0NlS0pRUjJJRmNpalI3ZUFUUU5CYmxLMGlPdzRWVm9tZTMvZ0w5?=
 =?utf-8?B?YittT0RVOHU0RnordDFnUDViV0RrZzVKSDhIQW5sd2FmazBlWUdqUkJLSlMr?=
 =?utf-8?B?bnF3eTB3dXdjU3Q3ZXp4N3VmbjVpNDhPSnNVb0Y1MHFvaXlMazZXVXo0SHBQ?=
 =?utf-8?B?OVdwZVBtL0szZ09vT2xvWDgrQ1dmMUczSHNnaFJLUDRkeVZ0djgyWnFRVWd6?=
 =?utf-8?B?RmwxaGRHZ2NJRVpPSzc5dDd5SUNjbGE4NWZQelBqTkJsb3BrSGV2c2NFV1ln?=
 =?utf-8?B?K1RwS2IrRThRbmJTeG9aVGIwUWtkMGpPQWNwdDJnV1R5eU9KWURxS3BlOWw1?=
 =?utf-8?B?K2JQdXE3WDJKU2hZdWliZWtFU3ovSjhkblRKMGNzNHNBTXRFVUhSM3lEbGdD?=
 =?utf-8?B?bnYzNlVTaGJLdjRDUmNBUU9VY2tkbit1VStEL3ZidDJQYS9iOFdPa1QwWWo4?=
 =?utf-8?B?NG13WkZ1RUt0UkFIWHg5c0ZrZkRCcjFicS9YaFlCeDR3NXkvVVpUWWEzZXJR?=
 =?utf-8?B?cHVHbDZmRk1ydXExSXFnRkU5YUFmaTJtOUpYd0xYRFNCQkVGOUVndXZGeStj?=
 =?utf-8?B?a0JBVmpLZUtaL1FSNXhzdFJjTkpKR2w4eTZwNnJrdHl3NFRuN0U4V045RE44?=
 =?utf-8?B?bHhOeVVsRHFkNGdnbkZzZk9uKzVMandNNEZHbk5BR1hIbG5VeitEczBkYklP?=
 =?utf-8?B?b2hlL0RKcVAxNkZnNTJ5REFaTCt4Nkd5elppVkNoRUJhQ3RETUhOT29Odk9D?=
 =?utf-8?B?M2JRcFFVUkNTMVAzc1ZwUDJlU2pXODN4Z3dzNUxFS3UzSnc0SGtYMDRIUmw2?=
 =?utf-8?B?SXRFVEdFZ0Y5cFA1enY3UEhXYjFUQkVLVVVuRVBuWjFNODQzbzg2TzFNdmw5?=
 =?utf-8?B?aTdZTVlzNDhQVTZES1hEcGIyR1FnNTNiK2pobWEyM3czVy9NTDZPQkwzSDJk?=
 =?utf-8?B?RDF5YmVBWnJTM1ZtalJtU3ZiWkw4Y0hHZmR0aU5jRUgzYnJibUNwVWlIVGRO?=
 =?utf-8?B?WUt4dVNYbVVpcGFOb1ppN1V5VnM5cG9jY2xVM3ZwN1dKcFkybjBhZTJ3QWhN?=
 =?utf-8?B?YkxLQTVmZ3JEb3R6elJtVzZQdGRUWE1kZnBzS3NzV3hnUmxUU21iMWo5Slhi?=
 =?utf-8?B?T2FGZkMrSTB1TWRaODRNSEpMYWhYam9oYzVzQi9PYmR2L09nU2w4WUpMNDBu?=
 =?utf-8?B?VWxMVnRlWGx2WVJPYWVrZTVodXJaZ2Q4TTZxS1FObGVkbWRveGxPV3k3VUpv?=
 =?utf-8?B?MGI3SFNoUWVTeStTdWx5Qis0SjdWTnlQbzcwbExLenY0RmRmREFqS0dtWm5p?=
 =?utf-8?B?MjFNMHJ5QUZ0VlZGNHJheGJUZnB4eFdMa3FJb2ZzR1dIOEI2RWtGNVJocm01?=
 =?utf-8?B?ZEQwcE0zZ1lwUGI4U3RWNS9yU0RQR2tFVUpQaWpwYnNQcStxbXVuMWxDUDVF?=
 =?utf-8?B?eUNNeEk2V3JqMUVhUUhCOWFrUnhnWW1CZGpoRHliL2NiTEIrODZCazZOWVpi?=
 =?utf-8?B?QUdnNTgvQU9HcE9vTDJlTTNQWDk1bEljRDBmT2RRMzM1NEtRMkdhVTNsVElC?=
 =?utf-8?B?cDd1WWlXcklFQW0vRWJzbGVyMytHR1hlY3RpV3hDbkRWempha2Jybi9Da0VW?=
 =?utf-8?B?d0pudkRaanplRHd2eC93TzVBSTA0WTJsdXV4NDluU1BRTGRzVU9yQUJZZXlR?=
 =?utf-8?B?bnJnRzJtQjg1M0d5bW9RZW1IS0RDZzZ2T05vT2R4Rit5RGw2RWdoOGZpRVNL?=
 =?utf-8?B?QlJnT2hnZGxLR2ZJOFZDMHhvbWJEUXNCcGlhdEcrN3BxUURzTDlOTTl6SFJ6?=
 =?utf-8?B?V3VqUEZFdDljdXRLVUx0U1h0L2ZsbkJydWszL2k5SzFhZ2xmczl4N0ppY25j?=
 =?utf-8?B?ODlvWXI2ODhqVkFkZm81VTc1WW5BRWFpVmgvNFVWeU0xRHZ4T2VBczlaRnVS?=
 =?utf-8?B?ekxXTlVyZXZVMEJESmpBcWx0bFZzMkR5UVBtdXNlVjErYXd2Y1ZKR2NlL0Uy?=
 =?utf-8?Q?eaM4RWy54BBrNdIvDw0GqzOMS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WTJGeGc3eGtrREl3d2diTmxtVmlxRWhObWRxSmkreEdFdjhJaStJY1hSbDFZ?=
 =?utf-8?B?NFowRTM1ZGpuVTRYRWRNNlhzeCsvOE9vN0J1TnBoOXozcE4ydDArSHUvd2Zl?=
 =?utf-8?B?WU5XdzJMRGZQLzZaR09iUW5HNTQ4a01lbTNNcmNnaE0wVUtMOFU3MTZIaEZi?=
 =?utf-8?B?OGVqbDhnZDNjV0IzYk05Q1pBV01VZXFDSjJWNXo0UWpyMC9RMkRnclUzb3lG?=
 =?utf-8?B?WFREN1NBMENFc1JqbmFrY3lPcG5JT2cwVkhSazJZZ0syMFh5MnFFYldQL1VE?=
 =?utf-8?B?ZkNIc29KNEUveFZPdi9zUlpWcXNReXVPMXNDN1F1cExpVDE3MGs5UC8vMGph?=
 =?utf-8?B?VDZoeXQrYVBuaWgvZnBvU3Vad2Q0NHQxN2twK1VUWEI0djltZHFYcXdYbEQv?=
 =?utf-8?B?b2FSRk1MNVo2WEM2cHFPQVRSbEJJMlhNU2tkcldGckNndkw0VXdpZGVqOURo?=
 =?utf-8?B?eWRXS3V4aWNtUGFJY0dGMVNBZzdYRUZINGY2a3lzem55b2d1U0JhL2djYWZu?=
 =?utf-8?B?VU41dHJaa09URllaZTVYUjVqUE1rVGpUd3JpdUxLVDAzb2EzZS93dFRCZWFs?=
 =?utf-8?B?bmlrbUpJSGFrVnBWbDFVVXlRZmJ3QXZXeGNhYzROYmF4MVBHWTBkb0xYbE9Q?=
 =?utf-8?B?d0dvQ285KzV4aExzamhNZWNWaElMY1ZaV3FDTjZLcnlwQ3d2TnlJUmw2MWxV?=
 =?utf-8?B?WHplTkdOMkFZS3dJRS9iS2tvWEt0Ny80WENrZStLZmpSaUNJUEJ6MDBrODNV?=
 =?utf-8?B?NlZ0RUVGdlc3RWxabVdMbGRyYm42S0ZFRDVMcjN6OEVESzM3UWVDWStjNDhL?=
 =?utf-8?B?NFlYZXZMR2xEVk9ldkNEM3BZZWw5RVdHZUd2aDhZTFRFS3RDKzgzalorT0JY?=
 =?utf-8?B?NlBWb1BneFZNQTR1ay9tNTRRU2tmcGdtOUF5eStab3ZjYm9vSW1CNHRYcFFp?=
 =?utf-8?B?REZoODNqa3NmRTBUNnVXY2F0WFJnMHJ4SVhKS1R2TmNKVThnY1I4WUFvejZw?=
 =?utf-8?B?YThMa0FNT0RHSXEvb2czbTlFRUZxQ0lmM2NKTm5abDZOOUJqNUE4eFR3ZGtD?=
 =?utf-8?B?Z0JXSTJlKy9qSGFTeFNkM0g3Z3BlcjBicEFmVFEzNnMzcS9wOHZLbGx6a1Ra?=
 =?utf-8?B?SWExLzgzS0V0VzNVTGtZQXRGcnRKSEwzeStUbWhNRmRrUXVlWFBaRmhoeDRC?=
 =?utf-8?B?T3RWdVJ1Uy9FWmNYWCtiSThOSmhyVTExbnVuZHF0YnRmQzV3dlRIRUNReFdw?=
 =?utf-8?B?MVgyYzJKT1lTd0lZZEF2c3NRS0VGTVR3WnNTNzZyRUFvV0xuT0doMENzUlZM?=
 =?utf-8?B?MlFOdTh0THRMcUVHdUNaVURQc29iOWxrSWNybEhRQWd1Z1FxZ09DMXc1OGJS?=
 =?utf-8?B?ZFgvYXpaNGwwYlRDVnNCS0haOTZidGloYzNXcmdTWVR3ZHRtNVpGVnRteVZE?=
 =?utf-8?B?NTIrdVExOWlCY3ZBVkl5UFNJdE1tV3JPT2lEaEdBeFZsR2l0QjFuc2JRM2tn?=
 =?utf-8?B?ZkVTUFlzLzkxU3Jmc05xRi84M3lSd05nd25iNmVNZ3RReXZobVZkc3JQbW1p?=
 =?utf-8?B?MWR6TERNdFB6Vnd6TlNLa3Jlcng2M1BESW84MVFERCtEY3RzUjVZM3lTTUFR?=
 =?utf-8?B?QWxCSUUrdmhjS1Z2LzdIdHpHTllSVHVveVRjWmRIR0c2amNWM1dJNlVFR2V1?=
 =?utf-8?B?K01CMVM5cXN3bndweW1kakVMRGZjSUk4ZTEzcjZVT0xLUmMveWdqL0wxbm9k?=
 =?utf-8?Q?D+dG6+HwiE/Y2iTUoc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3fa802-ed72-4e99-3eb0-08db40e81290
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:09:30.5851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55h8mZxHOI5yPH/ADdduWApRPKsET2dY08l/6n+2C1/tjg99JEaKBAKuWQrnHyz5oJCRXH+x2ikFtka1u8ieAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_10,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190137
X-Proofpoint-GUID: 6JCrVCzl3_W5lV6C5ku_zDT0IWuQvzi5
X-Proofpoint-ORIG-GUID: 6JCrVCzl3_W5lV6C5ku_zDT0IWuQvzi5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 10:56:22PM -0600, Yu Zhao wrote:
> On Tue, Apr 18, 2023 at 10:18 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> >
> > On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > > > Tom Saeger identified that the below commit moves it out of ifdef.
> > > >
> > > > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > > > Author: Yu Zhao <yuzhao@google.com>
> > > > Date:   Sun Sep 18 02:00:07 2022 -0600
> > > >
> > > >     mm: multi-gen LRU: kill switch
> > > >
> > > FWIW - partially backporting (location of cgroup_mutex extern) from:
> > > 354ed5974429 ("mm: multi-gen LRU: kill switch")
> > >
> > > fixes x86_64 build for me.
> > >
> > > Regards,
> > >
> > > --Tom
> > >
> > > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> 
> ...
> 
> > Yu, would you like to provide formal backport?

Nah - an easier fix was suggested by Waiman (remove the lockdep_assert_held line) and confirmed here:

https://lore.kernel.org/stable/20230418192807.n3hggjak25tnat7i@oracle.com/

> 
> Are you suggesting backporting the entire MGLRU patchset (>30 patches)?
> 
> I do have the backport ready for 5.15 and multiple distros have taken
> it.

However, I am interested in testing 5.15 backport of MGLRU.
Where might I find that?

--Tom
