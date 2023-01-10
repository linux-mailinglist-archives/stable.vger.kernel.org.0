Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B49663AA5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjAJIMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbjAJIL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:11:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3019DF8
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:11:57 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30A7GMmR023905;
        Tue, 10 Jan 2023 08:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=MLTWxadZsZJpSN81ZQ+cf0j+/U7RcF4h4mgtBm7UTX4=;
 b=noWNWJ10I1W2y5brKftoBt31nTQiBi0UqHHysEzUZIwu3+eeZPsuKfNyhIDQf9lOynPy
 3X5NZN3csIsHs/Uz3xxcL+Z9ePUYPIXW7tb2uMNgqpeOOgRaeSCjntOJmp5E5+wiyBSh
 JY2CJhM1salucMHoXaHlPlKWGB2pMb8vWT+fZXDHt7v9R6XrxGqjKZ0JFyw3wcToFFi0
 Y2Ar05k74/n0X9ZUxV7gDK5kqRjIF2IeVvosWC0MNsP5EEfBaTukWMoXY75w7XGoo2cE
 53ywnNXPfMjgKJsbCep88rqZHKRVuNVtKj2D4iMEemfnnJnxU6LpZn5QjCS28bxrdewJ 1Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n0uc8gqse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 08:11:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30A6dFr8023914;
        Tue, 10 Jan 2023 08:11:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n118hdvbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 08:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQbAuvWTBi/2CmoqzYiZ36sc18/3DtTSE9do0wicjVRJeqkuPpPtaPyKRhphd9vn/lmHuX8jvlt6Ak0/UF4FO4wZTUQh0Jgf6imoJJGvW5Jn9rLrvVAtvE6A3BaEXW6IYKi2wZ8e/cPURSEcMRKvTBK7jAb7iV6rvcnZ/yRb2FDOIqMW82xJM6lRarFiU5jrCSDXTML0Ie/MqDp8xV2/ONY6ODE55RQWHdQTEqB+ll5u/x4Le2MCearlUF5Z3YKhWyLd5nXSpisrcyJoa7I0OHmeHhralBQoiPf9nwMsbNK0cap6XDh8NSQjThMnKUYBvEr4QmCah99LLvuc7cdHlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MLTWxadZsZJpSN81ZQ+cf0j+/U7RcF4h4mgtBm7UTX4=;
 b=N+dtROZVscKhX983LzCtTvorltbroCBk/vTUX0HllhRThTgt43mrYApbAT1kpx40SAj1DX4Ze2+RKB8fjt4Vni6DJXrQAR8+0VeyEbkVi7qZisp3SOJlqBc96sGyTahm4wGO9cr8M0/MZIUS5OZ1Glr4Yt7I6YK4eZ+wRzzjCYf02EcYjjw3lWEY+euAunsqMSCrgHVSEkwv0m6YD94SPYIzXVlLRitUg/wA9jbEciNj8iRNAaRGeeg2WtzwxpVB1KLsS+zUIJYGOSCudgiUbQSyJPowMAD7wXcaLQmSUkhssg/yC5MushfP1iNPdF+FkAZFAiYUJXux1p+vK46Y6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLTWxadZsZJpSN81ZQ+cf0j+/U7RcF4h4mgtBm7UTX4=;
 b=clIBlNDBA1tXCNPIumkWJmrvy529bpK4rzNQt30O+TO85997SloIkAkHZIcZB2liHX5ULW16adD6xgSekSMKegXEDC7Z1QPWRSdD7XJlkwCdmWWnk5hlRL5dICs8nuFE912k4xLJ52f7nEbuuO4LzPGSs1IZeJ7xJfj65N5lu5k=
Received: from BLAPR10MB5380.namprd10.prod.outlook.com (2603:10b6:208:333::14)
 by MN6PR10MB7518.namprd10.prod.outlook.com (2603:10b6:208:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 10 Jan
 2023 08:11:13 +0000
Received: from BLAPR10MB5380.namprd10.prod.outlook.com
 ([fe80::8dc1:cc82:6d27:71e5]) by BLAPR10MB5380.namprd10.prod.outlook.com
 ([fe80::8dc1:cc82:6d27:71e5%4]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 08:11:13 +0000
Message-ID: <47d19f5f-8bb8-397b-dc0e-6027551539cf@oracle.com>
Date:   Tue, 10 Jan 2023 13:40:59 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v5.10.y] ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        butterflyhuangxx@gmail.com, groeck@chromium.org,
        harshit.m.mogalapalli@oracle.com
References: <20221006173127.2895108-1-zsm@google.com>
 <Yz/L47ZUgnBdpCoG@kroah.com>
From:   rhythm.m.mahajan@oracle.com
In-Reply-To: <Yz/L47ZUgnBdpCoG@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0240.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::17) To BLAPR10MB5380.namprd10.prod.outlook.com
 (2603:10b6:208:333::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5380:EE_|MN6PR10MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d97ab49-c3a6-4fef-3b61-08daf2e23d1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VD3dfp4R3lUVgzroV1oDuBJ38ynHHf1G5LrLRUt8RndWaxZ9OGO6Y6mD1wCthS7LPeUMlf2BDK0xSXuEz38RyWvfwr8YTg7NX4o+uvC6QjGd+9zcSOrJE7zXnmakZwi4Tp2ycAmu9N++UbucyJCfbzkHqFEscbnR/mcAQS/VUpFzEf8nL+kzgKVUNjtVN89lFWwpMHa8OC+StOC+ZK+FFEmWgJ2Gh10gKXvrJ4HmzGuyxLNjLtFidJjiW0KKpPP9kaivNSSTKUeZzf8I+jvW33yJSc8LoMoHW2DCdWfWZfzt9hp8PWQ/cdbbj7DGrx/mRNkba6HgOwLY3Qr10m6pAmHZbBqwtXKJ2rM+9fsL92/ylTVIJ7LVlt2PjuKTZqWZHGRWe+dpKhUl0r/j1p9F8ZZkM7lySyJ+Ijbiq0SEfEv1GXd+rheGX/14DVU90374eWL3GxuzZh1B8AUXBcHOSadUxlw644nGJrZf9COggZl+gfzMa4AgZl+nK08pv3zTDf0lFl8iO8OTJog8VVYlokqyRfr+zcyPiLtIw+xp+bEIYMVe/ID5HOFHN5/SIz2FrPW/6lwhXzj7jduM17nzRF4Qzrf48oQRO6Z/434cxFbIkvBZ1h237BiCDjaec91THPtd9FK1ZCGvA9Y8GHtyOmKLlNeOfUvUPoA63EcFLlEyjWXsUJIdXqch/FRm5a3npfb+rZcHupIJUL0bNDbe+jVQxc6nYeRpUSfrI1nj2AhbQ7bRqry3960Yy4/N00GhR0rHc6nooy4morpRrkdTUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(36756003)(86362001)(31696002)(8936002)(5660300002)(966005)(6486002)(83380400001)(6506007)(53546011)(6666004)(107886003)(478600001)(2616005)(26005)(186003)(6512007)(9686003)(38100700002)(41300700001)(4326008)(66946007)(66556008)(66476007)(8676002)(316002)(110136005)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU9Ucmp0dGM0RWdxRi9iWjc2TkJxUVBCK3FpOE5EbTJGaS9ILy9tWDlZbGgv?=
 =?utf-8?B?TVBkcGIzaTlqdlVBUlM0ZklMc25jbzBrUEUwSWJXYVJYM3pleW01ZVdBejY5?=
 =?utf-8?B?aGkwOGhSL3cwU3g3emw4RDhZU1l3QXdFeC82ZVJVQ1VHdmJuWENKS1JtR2to?=
 =?utf-8?B?a0JCVXFYSDFQM3dOamp4MnBGTHc5Qmo4K1ZzSUpIV2c4bHZvUmFEZXVNbHVE?=
 =?utf-8?B?N2JKdlRDZUVlcFNaRTQ5a0tyOTlKeHRicEh4OXRlT2hpeTYwNFB6aWpjSUU3?=
 =?utf-8?B?ejdhenVvL1FYN0RmNWNRN0hJQyt5TnVTb21zMjZLZUljY1VXbUlpcU1WTUgv?=
 =?utf-8?B?Mk84K3grS1Z0Y0VNMGtrYUo1dmtSVXFHblN0M0Y0T0pvTkJ0QWVaQzZYMlRT?=
 =?utf-8?B?UGJRbEVEd05obFFXeTRONkdXZk91UWI1dkhVYU5aMXFDUDZGSHZ3L0Ewb3RL?=
 =?utf-8?B?QTkwY1AvQzIxT2JSRXFZTmlQS0hya1J4QW1Cc0hMNWNzN0J5OXBmZGF4eWZC?=
 =?utf-8?B?VW9VblhlcGtwY1pSYWZxZ2R1VW1nOFRTTm95eU5hRlBzem1Ga3h0bmJzTDR0?=
 =?utf-8?B?SFJsUDZWT0VsdUhJbmpUcnlZQnRQNkp4bngxbGVqUVcyOWpCNjVOdnB6K0cv?=
 =?utf-8?B?WHBTQi9ma2hCWFFhUGdYT0Q1R3FmR3FtTW4vSHFWcmV5TDFpME5rbG9oUHVS?=
 =?utf-8?B?dm1oM0lwUDFqWUs4MWRzbFpFUjRVWStxSzFMRHh5RldjaWdlTjFwQmRkN1Jl?=
 =?utf-8?B?YWd6RWNFWG9oenFJRitFT2o4b2hlZFhrRTZPS3htVzNVakRFYnlSQUhVT2Fk?=
 =?utf-8?B?Q0hWdjh3Z05BR25FYmhTRHAwTUwvSHdSWHFwMlBHT0tkWnY1dVRCbUphZWZU?=
 =?utf-8?B?RGlJUnVkZFEyNkl5VTgwT2ltNllEVzBWamNtOTFHdVlCQlhWQXNvM0dkVFha?=
 =?utf-8?B?bHpUMms2Rk5Bd0VFMTZKNTY0SGFlOTBuaEE2R1pRbWdQNEkxbmFXNDE1WHdU?=
 =?utf-8?B?clhBc0V3S1NCbWRCMTJrMkp0Y0RDU0F6cU9KUWRiaTk0N3dQVjFIUm9ZYzVN?=
 =?utf-8?B?WThIa0VKYldzTXlkV0wwVFdpcmRDdHhLaHVTWWFTOFQrK1hBMkttZjdDNHhh?=
 =?utf-8?B?YTJkcTQ5bllrWjRJaTh1aTVNZFFyOWh0NkFQYm1QZGZCZGpUT1BDR0xlc01u?=
 =?utf-8?B?RkM2WTg5Q3JSVU81MmJDZGZzNDFsYUVXVFdDMnVWM3hDVndLSmhxWE44T2cz?=
 =?utf-8?B?M1p5bEU4eklXYTBuTjNJVldMZUhpQ0RHWm9pT2hCc0JNN3RGdG4rQ3BUclFa?=
 =?utf-8?B?TnI2WDRWWndGZHVoYnorU3pnU2hnRDRadWoyU0dQcFFKRUc0TU1wZmVzSWox?=
 =?utf-8?B?M1lxSXhFYmFvUUR0VnQ0SWQ4ajJDWTZXSXRCT3VRYS9EZWhlMkFzRFVJTStF?=
 =?utf-8?B?UFdIbkI5bWpabFVBampobndlcDlOdm9MOVZSRzVLZldVQ3daK2RZMTg4bUVN?=
 =?utf-8?B?eHdUbjY0WVQ3dWJya0pVYzdlSVJ3ZnUwK3NKUU41VVlYQTRZeWhGRUxmZC9Y?=
 =?utf-8?B?dkZ2ZHVIZTFPNXNLcmN2SWZEajZnYVkwMlFaNmdoa3JMK1Z5RFlLeFViemlJ?=
 =?utf-8?B?RGlMQUlSWmVGZzU4OE1TSDRUVmVKdGQ5NlhSSzJnZjlPa0RRZVliYnBWVmo0?=
 =?utf-8?B?c1R0Zk9Teko5L0RtV0ZObGs0ODJqZnNxNy9XRjN5ekhCbVVaeWVSaURscURF?=
 =?utf-8?B?MGZ2RkZhYVdzZFZNTlF4SHNva1JXVFdZUUU4SERsUktDUEg2Z0FzR01xSlRk?=
 =?utf-8?B?ejRTQjUvUUVRdmxRUkdvbEVsZ0Z6WTJ0aHowM2pJMWduNTRaZkdiMjd4SWlZ?=
 =?utf-8?B?M1Y2K2tOQmVtMDhnTlRBbGVVOGN4VVBOVmZNSW01TGlIek5TeW9wV09wcGVB?=
 =?utf-8?B?bG5KQkNxSGFHM3VEVk5jM2p3d1pldUxGUmZGR0hEaHcxemNzNHo0TDY5M3Y3?=
 =?utf-8?B?VVVxYU4rUnJVSnB3UWNOM21BMklDVTlNM2VqQVN6Nk5CaE9qMkEwbk5nbEVw?=
 =?utf-8?B?ckRVVjhBT3FqTk1PZlR4TkJLSVdNYjNJK0k1TDAxL1Y0QkRvUFdaaFFibTdh?=
 =?utf-8?B?OUkwTUVuNmk1YmFlMUtRbzRaUkVEUHY3OFlaL3pCb3NCazZTdmtsaFpqcGxQ?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: L5TRBNO1lXhqeU29yglCpHFC9U3KDk0qAf2zvjl8R0qMOeWjutZWhMk5Ue5VDp93byKOwSKBbwDzhKeZboJ4g9G54YDB9yJ5tCcoIX7jHotwiKPG6ieaUnskiDseOxNrTmfHLuBcNAITwZBAqbjJa2p42/HshbBKWPkqenGLKQ6La0Bcf7zn5qGGqCQPlIJx4azzlRq9k7j9pwcn9b59NMMilipq/Z6bp7XA9szxhDrBusAT5V6Gu+NXWQ9xvwWXeRM8fSYlwV0JgShoYPFm6OSAmXqsqCJjdyNFt+LFayfw5imMz5elH2mGw4K3saCMiBMjT158ppdqB3PVdckIIXr6750CM3lFhAHzlBhjhyBpzS4hsThS0WZ2gTS5k4KDjhaMnQ0b5J/WOts1knIdWrUROV3FFN6UhaJqMHBdQM9mM/rH9rqlUsMTwKNyWyZy42Y6Ey2wu8jLkyy/K/3ClKk9zq+dyGvzomq5MvJMLTZipWcwAOgQ8/vq43jnFtZtkB4MwHRLZYagwiCjqO/IzXLbFfAj0TITsApgW8oU+K1EzjGvfOFxdp1bXl2YiBvGx/3AU9Xx8fmMHZ3EQvmnsDpx6LDZDsdDA6zqU2CyKBQ0C3cCNTCco27+Q9VT7Tjuj7gujksUPfgh6WHgG9OLCiFBlNKcfW3FyJBDgPSnoHk4dbx2A+9N53e/SnGXfwN1x/6rojqXvqXYq2DGlXFzzMxM/E/m1YpESvEGwBly6BbDdujkCRLUC2x172hbTLbx3mRkYbCwVLL8v4W6Xv758MuPkHcDOk9e8tEE1T58mSNPvp3sbLXsLWGiIZRPY+QyeoloRlUOuJvPKD5l3ox95DrevTOfhvvSdKBjIKKE7gNmktQXb3FvkZby836wQw2EwI6HPWas5UqKwRrvhQDarPtR0q9bMVkUzEcD2UngSZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d97ab49-c3a6-4fef-3b61-08daf2e23d1e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:11:13.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNby4KTqvSpyMBVqxnxBWdKQ+4XHd4qoEtCU2NfY04todM6d5epAcBCHvTfAPYbiTo8IsCry+gWXm66xu/n3fZvvjgeoVq7vUcPk1b3b59c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_02,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100050
X-Proofpoint-ORIG-GUID: S4aCXjQxQUfoYBRvISjF9Ny6o2988dVO
X-Proofpoint-GUID: S4aCXjQxQUfoYBRvISjF9Ny6o2988dVO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 07/10/22 12:19 pm, Greg KH wrote:
> On Thu, Oct 06, 2022 at 10:31:27AM -0700, Zubin Mithra wrote:
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> commit 8423f0b6d513b259fdab9c9bf4aaa6188d054c2d upstream.
>>
>> There is a small race window at snd_pcm_oss_sync() that is called from
>> OSS PCM SNDCTL_DSP_SYNC ioctl; namely the function calls
>> snd_pcm_oss_make_ready() at first, then takes the params_lock mutex
>> for the rest.  When the stream is set up again by another thread
>> between them, it leads to inconsistency, and may result in unexpected
>> results such as NULL dereference of OSS buffer as a fuzzer spotted
>> recently.
>>
>> The fix is simply to cover snd_pcm_oss_make_ready() call into the same
>> params_lock mutex with snd_pcm_oss_make_ready_locked() variant.
>>
>> Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
>> Reviewed-by: Jaroslav Kysela <perex@perex.cz>
>> Cc: <stable@vger.kernel.org>
>> Link: https://lore.kernel.org/r/CAFcO6XN7JDM4xSXGhtusQfS2mSBcx50VJKwQpCq=WeLt57aaZA@mail.gmail.com
>> Link: https://lore.kernel.org/r/20220905060714.22549-1-tiwai@suse.de
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Zubin Mithra <zsm@google.com>
>> ---
>> Note:
>> * 8423f0b6d513 is present in linux-5.15.y and linux-5.4.y; missing in
>> linux-5.10.y.
>> * Backport addresses conflict due to surrounding context.
>> * Tests run: build and boot.
> 
> Now queued up, thanks.
> 
> greg k-h

This patch applies cleanly on 4.14 LTS as well. Can we have this patch 
in 4.14? I have tested for build and boot.
Thanks
