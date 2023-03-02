Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FFE6A8765
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 17:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCBQwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 11:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCBQwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 11:52:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DF54C16
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 08:52:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322FCWp2005696;
        Thu, 2 Mar 2023 16:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=teOUqXPH7J1tO2Kazo8iIqIohQy2xzD7FTkJeOoQqLg=;
 b=2Qu71vkzIe8/a6cJEV8aq+gHwux5ZJu6m320a8GE0JlD9LGscVTRzjF3KBN6XeY8PM2N
 G2+BYHv+N8DzD5ZnWvP1cghFFQxC6wD8cRJ8NVzPk8itaYMWL0s81lNhaNrEAdcv/p2J
 3jiTq/KjWGFZLc6sfC1dQMMgwTTk5Gno4KFjixBaRC+6ANjHoLxOsjYbWPdGrdI/P4Gg
 TE97AlN9HUqYs+i3I0JcjLZTKXoaNqRtX2Zg6+XhpVrrkCyGGVlg8YGVi0z97w+LW3qG
 N2a+M4+FfLy29Mz+mcOnzraxCR10i32JuIqhxI9+5tfiCjJYGbUzFg3OjwNVPvIl4D8b sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb9amdrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 16:52:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 322FTxEv002280;
        Thu, 2 Mar 2023 16:52:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sa24jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 16:52:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNR1jGttoUl+tQi14gPyzq1Oh96ab8dcW3fI5oNDnkzU3qZ3XOdYBWC7xWeWty+jvghx6NEUXmCQqQLCFU0oT8j0ZP8WU2Psx2uKq8YHDaizKczrJS1KO6DJDusVMAIjmZXiMPCNT01JqZRxXzzWEhRodGtbWPtkvqkD6aXILSbfVIi6g6D+KGjvxcMqEQdhbTheuIzq13Zl4SP2awyWV7Yp0vdso4ARmqeRkm/VomWgoWeV8j7GUAlqYFBQ5MaJ06WchbLGO9o4qzNJjv2V5DjiMd98bqWxam4OWrH3rvaqDf00q1YfDSCFeG/9daY3JRLpZOE3+HYx67joca0JFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teOUqXPH7J1tO2Kazo8iIqIohQy2xzD7FTkJeOoQqLg=;
 b=V6+5NgdoY9fT4Z0+lN45pRGthRyNi851oV7fDjDfSDvyNCiKq1Zq4jITx9YBNycyo989C2SP36+Vpg+Dm1VYDqnqfIoZ1VFi8Ydaqz6Gydlm/JIQIe7F2KEGmpFRM4Ul57eEa+oJZjAWC0cu1RJiaZ1gSPWAEfoYE2XbRvmgf+WiDeMUBdaQIhFi8kSRXzC6gYB8DkwubUUw443APQt2frIo9Btz4mLlp/0r4KJ3jgUhDx7t92lcyH7lbPK58ctJFvUeBWB4clSCL65HLwGX40z6zwJ6Ym67KAG1zcVtbbiFxLHAApbvUnqPnxk2AXz+kpyXmG/TF4SoYbAwnWm2yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teOUqXPH7J1tO2Kazo8iIqIohQy2xzD7FTkJeOoQqLg=;
 b=uqvbruFt82KFKh4IpR/+084le1o+AmJpbx68VTngC5PDYo9y56BmuTLlwgTOs6O6TFLYd93TgksSj+fnnjXuZqLS7SvoQx/Ms5ua2DeW1wPfwW9xpO9P4ftkSL1fRJbkfoQtwXq13wNVfmQoxYjFWhoOaxVK0wJs1iPtveJt5iM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6159.namprd10.prod.outlook.com (2603:10b6:8:ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.16; Thu, 2 Mar
 2023 16:52:22 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%6]) with mapi id 15.20.6156.019; Thu, 2 Mar 2023
 16:52:22 +0000
Message-ID: <78b78fd7-899c-aee8-4f82-f7e7dbc2f4c9@oracle.com>
Date:   Thu, 2 Mar 2023 22:22:11 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.10 16/19] drm/virtio: Correct
 drm_gem_shmem_get_sg_table() error handling
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Emil Velikov <emil.l.velikov@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Dan Carpenter <error27@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20230301180652.316428563@linuxfoundation.org>
 <20230301180652.989746215@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230301180652.989746215@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ee769f-6930-43da-5caa-08db1b3e7dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGdhBF8LjhwbHqCjDs8RaUS/BWPIFvvPoH8X8ow0Cmg47Ak0kvsn1aXG42QCyvmqkRij8sCx3nqkIqf/UjV91ieJRKbCGC09EIEXisX9CDlUazBHe+5EDNML3qW5NhbsmnhfN0NiDRepo9UAd2F1rfZilc4ab3nMK1C+zjKUo4z2Ap92u9Z3m9TDbHXclbaY9hgeeS6RcHdKUoSnO0cgNEFt5ii9jMoa12Rcknk/EjHRG8fA8wbCzdcvY80fzl1+hpKN1K0fKDqekyZbhqA+S9+9aQ3gtebcHZh8T6Ri8E3lCO5kbtdQakRMRFZXpcTpGTHUN1sPipDjaVt1lhIuZuaMkkQZK2YuKtsi/tveEaeFcCB5Ma3PD/V4HX53MgGPc3tEwYvtAc3wPgjc2dSnksRdcM10RE1arxUVvbm1iCKoBYXuhbZF3VgH0Osn/YJeS2rL5vv5DoXLXU7isTHEwb2rWi9ogo6EG0LCo0/a+zHH5kgS90VioXijmAcVQldObGWZQhsMq4K4b2DHov7C63FCl0iF2EjC3YZ8ZFRg4naTkt+7WtPguN+SzhLvb4Q8MLxaNApUJfhFAjdrIEingH+S8p6zQxhWWoLXkkZH7Li16R5/zFv7uEWoGhFu3YVGaTruK0L3bbmUSH9bn7enBgXh4/QyJ3xJFS0o4rk8NWTCXB2mPmqKmqLZGyZPrZrG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199018)(2906002)(5660300002)(38100700002)(2616005)(8936002)(36756003)(86362001)(31696002)(966005)(478600001)(6486002)(26005)(6512007)(186003)(41300700001)(6666004)(66946007)(107886003)(53546011)(6506007)(31686004)(316002)(54906003)(8676002)(66556008)(4326008)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEhTVlNNMThIT3RmVThEYWpXZ0JwUXg3cWQxcGtxcHVPOTd3ZlJ6MmZCVDJZ?=
 =?utf-8?B?YUlBWFF5NFQ5Tm1VMThkc0E0N0g1azE5UTcrdE1CRFZyN2Z3WitXQU1IVE5w?=
 =?utf-8?B?NXZuQWFoSzhQNkRzQmV6enoxMlB0RmxSeHNQbUs4Y21TNFUrMjhyeXFsbFRO?=
 =?utf-8?B?L1IvK3Q0bDM4aVRYT3FkSTdBdnNYc1FaM3EwdGYxS25WZGYzQnBwQUMybGM2?=
 =?utf-8?B?dWRCUXdHVjRlUDRtRFVkQ0g3SjU3ZU9KK1hkSm5yTENzcnl6bmJSRTVKbHRT?=
 =?utf-8?B?Qzd0eWxLZjRCN2x3YjI2OW12cWU1clM2dzBuNmpNbHNNd0dCRVAwbFIzWUpD?=
 =?utf-8?B?OWJyb0FjVm5VTytKZ1hUUnBrd01YQWVuUDFNa3hTVWRXVnVGdS9saTI3TjRF?=
 =?utf-8?B?OWFtWTZDOGIxMnNyZHdzaEIzN1JsZWlHdnBtRGtnY3o3TVhSdkNQeW91WUhF?=
 =?utf-8?B?aUZ0NEV5c2xTZkxUM0ZZNlRxTkpFU3Vib2JpT2l3c0owOGNhbzkzNDE3bGlx?=
 =?utf-8?B?WkNQMXdHdzZJQzBJalhIMHdnS0p4dE9KRC9UejVrakZsOGRHa09GOXpwYVdx?=
 =?utf-8?B?d0xBem5aZG5Dc0NRMWtvcXZkN3p0dGF6cTQxSFlmSUJTMDNtaXZGZGlEOUtM?=
 =?utf-8?B?cGE1WVNlNHhtUU11cURsTURpd3I5aU1UeXQ5dzI5eXVhYXJEWjVWcGthV2Ny?=
 =?utf-8?B?Sk5XSVI0Vm5oSW90bEp4ODZyVXVaT0NOcVhkM0t0SHpDU1UxdlhGWmdDNm9S?=
 =?utf-8?B?TFdHdWgwa0lQdGRuemthWGpIYXJoMmtySlBxVjFsZGN3MXo1WDVQTjk1cHFx?=
 =?utf-8?B?aGVqOXVsT01kK2JUcitHcDRaQmplbFQwOGY5RC9sSVZrUlJHWmU1eHorQVJF?=
 =?utf-8?B?VndRQWl3YkpLNFR3UWkvay9ueGpQdVFpNzBHNUhibTZNMjVRakpDOWZ4V1Jr?=
 =?utf-8?B?aFNCbmlWejR0cC9xbFVQSEFwcE5sbDhsWTFoNXgzQiswZldQOXhIN0JwanAw?=
 =?utf-8?B?b2JEWlNtM2IybUg3QjIwMVVVK0FMeGMyNUJTT081NktJbnd3SFlQK1VXTjY5?=
 =?utf-8?B?ZmpUSklNeWNPNExhWGRHQ1pHNHdZL1BOY2pmWEozOHZ1RFMyemNjU3JDeThY?=
 =?utf-8?B?NEpkZjV5cmE0MytGZ1NadERhMlc3d1Uya3JsbVVJdGk0MXdMZUZZaGo3ampo?=
 =?utf-8?B?T202a2RJTXJqOGpHd3pYTW93NnlLZXNiYmg4cmRWN25tUlZrblRoZjlncU0v?=
 =?utf-8?B?Q3dOTU1GcDN2ZERROVFxNWJHV0Zoemcra1k1TUxZK3JKUU9GVzVkbTloNENu?=
 =?utf-8?B?amV4OEZrVVNvanhMYnU3c2dOUVdLa2NFY1BqWk9QZmt2c0MrSDdhcjh0cTBS?=
 =?utf-8?B?a3NVR0ZUZ0FiZkhxY3RaRmE0VWtaSUtNamRTbFRYdTNZKzIzRDdaWUNMR2gw?=
 =?utf-8?B?bzhHTG1seGtBYVFPQzV3eENJa1hRaXFGMFpBRkp2ZU84L0w1UDB5MDVPQVZo?=
 =?utf-8?B?ZUlsYVdYdmsraGtsUkMvd3R5RkJoVjRMMU12ekVPUENmVVh4SDFyUjd5RjVz?=
 =?utf-8?B?OStmbk9KZ3g1VVFxMFl4d1BrSy9FaFVUeEJ0MjAxRGpRVktUMDNFYTNxWGxC?=
 =?utf-8?B?VWF3eEhubzlEWEZka01zb3hjUThqRVBiZEQvSEtaRStaV0Q1VTRmUy9WUFRO?=
 =?utf-8?B?UTRvWUdybVp1Yi9TUUVrbmRaM3NkSHFQb1RzK3F6ck5aMnlJb1pnanlaQjJG?=
 =?utf-8?B?V2UzZHpsazhvM21oME5JOHJBUlNsS3h1N1o4UlgzV0FKZ0x0cFg1cGNGbWFx?=
 =?utf-8?B?VUI0bDZ3Q0NwUEZFZngzb004R2RwSkR3a3BzNlo2dnQwQTFIbllrNTN3Y3VD?=
 =?utf-8?B?YUx2U3F1T3hRK3d6ak1HWWdxY2IySjlQbWgvOHRSZ2p4eGd5aHJLYkNkSnYx?=
 =?utf-8?B?b0R4djZsdUE0R2JTeGRjeWYwaGgweFM0cXpyeFZRWWJJR2ZmcXJwUnV5Uk5I?=
 =?utf-8?B?RWxIUjkzTzVZVnlaVnAvQVhVQkZ4bzR2QmxpSEIzdVFhbHI4NEl3bVRadEVV?=
 =?utf-8?B?MnlNL2svTHRXODk1UEt0dlFFYWU1OG1qRk5PQkQzTWtjemsvdWVsZjh6NFEy?=
 =?utf-8?B?aHg0aXdtT0JCVzkwRkM0NHZoYkk5eHJaaW1Vc0hQYjJlV1Q0NENGZXhkd2h4?=
 =?utf-8?Q?3J+eoDkADKFVQ9eHBppqb7o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MlVCOCtCbW1rUytMNnNYa0d5eXYrSms4Y3FGT1MzVVJrd0VkNEVnWkxNZTBa?=
 =?utf-8?B?aTRad0NqTVhsQlZ2QVRVMXlRaEd5MnJDUko4OXR0SnFzdVJYeTk2RisyOWZU?=
 =?utf-8?B?SDE4alllTGsyRTI2Z092WFNTZ2lwTjk2d2t5Nm5SanlyM0pBZDQxTUNKeE1r?=
 =?utf-8?B?QTRhYTJyM2ltR1FRVzRCeHllVnNMSUFKYkJMTStESHZRem0xQnA0YUxpbkFG?=
 =?utf-8?B?dnIzR0k3aWpjSnlqdVdGL3Foc1lELzdJaFhlQUZlOUJtZXlZTFdZQzEwNHpn?=
 =?utf-8?B?V29sRXdXSVNEOW5UZ2wwb2QxSnc3Z0s3K1ZSb2s4Vk5GczFRQXJvbkwxR2th?=
 =?utf-8?B?M0JCQU05elBPZzl4OVlGTk94VXZDdkliQmVvVlZjeHZ3L0V2NjErYlV0RjJZ?=
 =?utf-8?B?T2hzVU4xMUMvV1gyMTlNS0hBdW1WNHN1cDV1MWZhK2IxVmVTVW9zQzNWN2Rn?=
 =?utf-8?B?aVF6UUhXdWhCTlpkem9JNmJ1bHJ1WDgxSHRGUm5ncFRyMFpEcFRVRjN4d1Bs?=
 =?utf-8?B?a1B3bTdDVFdZR2ZWWVo4ZXVWQ2dWTzB3Skg5cm5XSENiS2xRVWhFTnQvbk5s?=
 =?utf-8?B?azZVNVh0bktrSWtNZzFCMC9xRU83SnloM0JPYVBRR0xIbE5kdGJzYW1JYVdn?=
 =?utf-8?B?THNBMnhSZHBlYzZpZFpnd1hZU2ZDNHlDN1FhaWJ1OHU0OTc2SnU0MVZqSTNl?=
 =?utf-8?B?YUN1SDVsLzZHSUtuR0gvSmJod21SNVFFZnQrckxrdlN5L1V4NkduQzBCdGRt?=
 =?utf-8?B?eWxOa2hIamp0Y1RHS3lrQVZsUm80NW1rWVpDQmt1elFSWGxlZ0Rwa0g5ZnEv?=
 =?utf-8?B?RjdQajJLNkNxaGFsZVRGSDBSajNYS3p1WFNTeHNCRFg3WmNjdlFGZ1lhN2Y0?=
 =?utf-8?B?azR0NHFKc09kOWtDODJVQ0N0VjhzOXBRN05TQVo2bXRKd0duOVlZNXVJNFdx?=
 =?utf-8?B?T0NGNkFtQThuY2ZFNHBBZFhkazJpZktRZ2tmTFJhY2F6dUJzRzJLWDQwWVB1?=
 =?utf-8?B?VGdIMFZETjZ5VEtLUG9iTTBuNmowUDI0akRTYkxmbFlQa29LZG84bHdVcmZW?=
 =?utf-8?B?Z3NjTXJJcHZFeGxXUTRKMnNLN3lPaS92RnBaSjZJTGI3YjNYQ1FVaXJQdVV1?=
 =?utf-8?B?L0lUNEVjM1JQMHduM2toelBCZTllNjJjZTZJbDZkSGxXRjRtT05KejFiaEVM?=
 =?utf-8?B?d3d6OXJYMW1rM2hQek9uL0JvTlVORW1YZHRsM1ZZQmhlMUovMGVtR3oyK3Nl?=
 =?utf-8?B?My9ENmMxNUxvM1RsUE1rVVNxV1NWRDhDbi9iYmRyZ01yYlBBSWViYURhQTM2?=
 =?utf-8?Q?IMIEVSxyaj268=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ee769f-6930-43da-5caa-08db1b3e7dfb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 16:52:22.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cb18rRpR3zwwvxlT43L4NdAZrJgL3MJnIjV5PRl9s9cooxK5mygWdvcNmlpp690mIIhy1CrlImKG6DqqrwSLQuF24Zrdj0GQPhaqN0zMSk6L950fh1a0TPmY6S+tQ2L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_10,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020146
X-Proofpoint-GUID: AfqeVsqC_1RjlNq-YEk52HMC0LpCDNLf
X-Proofpoint-ORIG-GUID: AfqeVsqC_1RjlNq-YEk52HMC0LpCDNLf
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 01/03/23 11:38 pm, Greg Kroah-Hartman wrote:
> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> 
> commit 64b88afbd92fbf434759d1896a7cf705e1c00e79 upstream.
> 
> Previous commit fixed checking of the ERR_PTR value returned by
> drm_gem_shmem_get_sg_table(), but it missed to zero out the shmem->pages,
> which will crash virtio_gpu_cleanup_object(). Add the missing zeroing of
> the shmem->pages.
> 
> Fixes: c24968734abf ("drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init")
> Reviewed-by: Emil Velikov <emil.l.velikov@gmail.com>
> Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> Link: https://urldefense.com/v3/__http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-2-dmitry.osipenko@collabora.com__;!!ACWV5N9M2RV99hQ!KAxF_UJ7x6SleCxrpYd8Huyt4Zj4e08fd9IUL6fl1Wneipk6_LKBnYuqQ2LK0bnvWHC6dxungVXptuvz5-4QQ2zjcq_JT1ub$
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   drivers/gpu/drm/virtio/virtgpu_object.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> @@ -159,6 +159,7 @@ static int virtio_gpu_object_shmem_init(
>   	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
>   	if (IS_ERR(shmem->pages)) {
>   		drm_gem_shmem_unpin(&bo->base.base);
> +		shmem->pages = NULL;
>   		return PTR_ERR(shmem->pages);
>   	}

While doing static analysis with smatch on LTS-rc series I found this bug.

PTR_ERR(NULL) is 1/success, so we are returning success in this case, 
which looks wrong.

Only 5.10.y and 5.15.y are effected. Upstream commit b5c9ed70d1a9 
("drm/virtio: Improve DMA API usage for shmem BOs")
deleted this code, is present in linux-6.1.y and
linux-6.2.y, so this problem is not in 6.1.y and 6.2.y stable releases.

I have prepared a patch for fixing this, will send it out.

Thanks,
Harshit


>   
> 
> 
