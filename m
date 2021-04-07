Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A671357712
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 23:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhDGVoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 17:44:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbhDGVop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 17:44:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137LhiLV133867;
        Wed, 7 Apr 2021 21:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZZ+rXfjgDEQcFGGboBe359cL++lrH7SACD7Zoxz1DrY=;
 b=Uc2AM26KQKM0MPzD2/58nw6ThwPVT3NrLK65igeYxLecdbl9hKwS03WnXACW1xLzOyAT
 VAzAvfmnnqHcIcXJBJWfhYv8BW89CWTJL6KrOkwU3q+OSPqm1QgOZlllJ1vH/wplyXPT
 vqiNy3WgtVxptOJkW6KxXHAQ/VqZVGAibMb09IfFnqrnIy7Ftk5rIvAghdbQ05sz6RDg
 twL0Z5bOlJKuZJaHqvjCxRg1VuSN5MXMgr99neKpX9DRSIkTVxMaxkFNi4dC9TX5JiMW
 pVdeRtaJLvy8fvJ8dr9DuCsBmjRNXTfYNPQqbHG0CBgvjPCTarUefDP5ZGQr2SAw3BvS qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37rva641r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 21:44:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137LQ0AX008995;
        Wed, 7 Apr 2021 21:44:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3030.oracle.com with ESMTP id 37rvbew6sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 21:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNGMaiOKcu0FAaUYAhXojfD1qBi8A1crpvHXZofLpG9G3ZXSsYPXkX0XBH4pFP7b0raBcP6wQxzf876lLcU21SC34EWvy2zBsr+HhxcwWu2rFU005014zqdpF81dY5/tTjuhM2K6/9V7G007FmGTgOa0w9E3AhEY2ggeD2MTx/ZGCh1zkg1oVccz39uUS3AAmIgahv8sbC2S0osMHuoyGktsPIIlUdLdKR9xIHlgim3fsdwrpSySmDH0mbtKM5HZAm6HKWE5DzLtLHh72ByaGd5wBNAI8UfyVkWLq0UfoEmmIkcFQQYDLSrwgPqdOXBeTCCIayx1sV+9k6fXhXAB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZ+rXfjgDEQcFGGboBe359cL++lrH7SACD7Zoxz1DrY=;
 b=UW4Gb4rQoXaf8U5JTNJ0SBNlP/M11Iy4YYOwC0kNHPt1JZRu+MYL8ES/Vg/apUVsARoBY+QEWiTTCM1pvHCR/6WldTrtw49By00ZcltxjQ3tnXFpFUwQJCjOp/HN0LB+WqZ+lYroyWtoQ8i0dLhMmT6ISZw+jiISwGQdS1WIcowRU8K+UyJ8XU0dhK+HtS9osE0BWbUOw+MvD4oNPk7PbVDK7B81DyH2NYty9x2peiy+0nnR/F6DVPBJlaMaUJebOZ0HHyecAIoufjJoqr8K8mvitbd2MsFY2eC9jQL6iVawl94sWGtJxkv8aAUqRArDLW/p4A0BlUYhKRQUMWJhOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZ+rXfjgDEQcFGGboBe359cL++lrH7SACD7Zoxz1DrY=;
 b=AErZYthPWxofsRktFocWYK3xoWn7Bjl+PDQuCIUnJHL8IK7ujSxmL6ixEJTGufs/fo8oLty3XU9/i8JO2nwTHmhQfUwITDsNPlFHcZj5+PSja6jkRIu+O5UMNSMJcG9hLlBi8BR9fERjCp9pXYvkyb0e08eoTNsuICBr3up3l8k=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21)
 by SJ0PR10MB4543.namprd10.prod.outlook.com (2603:10b6:a03:2d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Wed, 7 Apr
 2021 21:44:01 +0000
Received: from BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721]) by BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721%7]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 21:44:01 +0000
Subject: Re: [PATCH] xen/evtchn: Change irq_info lock to raw_spinlock_t
To:     Luca Fancellu <luca.fancellu@arm.com>, sstabellini@kernel.org,
        jgross@suse.com, jgrall@amazon.com
Cc:     tglx@linutronix.de, wei.liu@kernel.org, jbeulich@suse.com,
        yyankovskyi@gmail.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        bertrand.marquis@arm.com
References: <20210406105105.10141-1-luca.fancellu@arm.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <c31042a2-fb32-fcf0-7b81-13c53473e9ea@oracle.com>
Date:   Wed, 7 Apr 2021 17:43:55 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210406105105.10141-1-luca.fancellu@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.201.61]
X-ClientProxiedBy: SN7PR04CA0037.namprd04.prod.outlook.com
 (2603:10b6:806:120::12) To BYAPR10MB3288.namprd10.prod.outlook.com
 (2603:10b6:a03:156::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.100.253] (138.3.201.61) by SN7PR04CA0037.namprd04.prod.outlook.com (2603:10b6:806:120::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 21:43:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df0646c3-6d67-42aa-8c36-08d8fa0e41e1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4543:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45434FEDF8BE0CE8D24DEF458A759@SJ0PR10MB4543.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RxHXln+iHigEXBJ+zqEaZu9yDOhVOBsuYZPgPZpi1m0HbM1y63o6Af0+XI+PfQYRPkDV26eX5s4JEMkbj6BxVyyL7CsKtWrx6cLVfVsyb/PJQttuXvZGomCrKmzoB+isbJJFK8bevebEMggxGQOd16UxFJZSS5CInkDKTT2MF9dVlVOObHZ1yE8RtMdwXO3iO7XGmzkb0sMYSDvTTOiBoF1BdxD3PzUlYniM34vSzkGs64E5FRCp2UEW1yaifv6Z2435ugda2Q0rLn+JSD5FJ4ipGJFdbEt1L9ZW3176DxIuZa0OXYIMWJxbdBwYJ3UtTDsF5E24xDkk6qAE+FXEjDNs/ujcewhDdT42WP0I6d76tzlp/pIA3XDfMHdWfVaPCmEl3BLKuF7EmGzb75khgNqNAQSAHWnHkLcXtCUynD2byr/IcmBbR/YqEIHzRP8HUgBUka4GbaeCSFZxx8i5t6IYtXo3JXXinhYQE+VntxveasE24BO4AJBIC/Xpal7NTyMzsXQdD8dhBYNz0rs5QONxGNc2MrmfjFBq3HbixLnFurAeE8CuZX4Ipg4IKifo8nUPeiKPDbMb1HnWAZv5tbqkHzJmVKoKRCClOKgk/+vRug761F97VEnXilJwscaVuYHLIF9cOXLL7LjCaY4ADHaZIN8d/4iUq0N6/DGHM4LaAUqwjN5XG7QpOQDRZ/XT21IPS3HZjWxSdD0K9bHc7wfzid2YEfTugBsEuf4N2xc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3288.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(366004)(39860400002)(2906002)(316002)(7416002)(16576012)(53546011)(31696002)(36756003)(86362001)(4326008)(5660300002)(956004)(2616005)(66476007)(66556008)(6666004)(6486002)(31686004)(44832011)(4744005)(38100700001)(16526019)(186003)(83380400001)(26005)(8936002)(478600001)(66946007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0t6eXdnc2pHTXU4Z09YcnU1bGVYaXVEVXEzM09VUVkwb2cybG5icmlaT2x4?=
 =?utf-8?B?bkxDZVhQeTZubldxWm9US1NKZlI5bHFEZ2ZrOUt1N0xuZ0V6TWdjY1loUVlO?=
 =?utf-8?B?M0Z2MzRpRjltOHRkOEw4WEkrbnlEWGM3N3VyK2x1M3JIVHBEKy9remcxeFlC?=
 =?utf-8?B?amVGUXRiSG5RaTRPRnJRQVQ0S1pyK0M1ZThRNm5Kd3EzSDlaalZ2K0U1VmpL?=
 =?utf-8?B?ZTlmMjl0eTZNYmFQZEpYdUZML2FnMlJJSi9QdzUwdW9mM0xBQXRwcVdMN2F6?=
 =?utf-8?B?ZzdiNjhlaWpmVW56SWV3dGJWdTcrcDM1ZFdZTkVYamtUWE04ZGpYWjN0ajZh?=
 =?utf-8?B?TVhYVlpwZVQ0bXRscWtDeCs1dk1lZEZCdGNDQldyak9kbHJzWjBsUlpUQjB4?=
 =?utf-8?B?eWVxc0dkK1BWMDh6MlhxdlJVU0plTlk1Y2lZV3lMVzMweWJZV1Zvam9RRWFp?=
 =?utf-8?B?ZjRLNkZKRFMwVzFaRWM0RVZuLzZFd1AyaVZpZTNJS2JZYURhaXRYMkQ5WklM?=
 =?utf-8?B?Z3AwSjBLRWNNeGlGRllHanp3NktIanhWeExUWGhZWm9RQ3pFd0d6S1o2Wlpa?=
 =?utf-8?B?K0pSR0VDb1dHWFB3OGdyTW8weUk5M21QWCtjTDlPMjJ1aU5kOEtZMWFCTHM5?=
 =?utf-8?B?VTdKdFpGQTNYWEFKcnE0TEVxTzg1Z2w1UHd6Vnlkb1BiQmkveGhlUFJBMzQr?=
 =?utf-8?B?L1N5UHFVNVNMV0MxVU9lZzJiWm4xTHoxczlQVGVsRDJjUWZYdHI2YVF4QlFl?=
 =?utf-8?B?V2Q1NkJKUUFRdWRPT3NxRDNIZUVCTTYzVHNrZEZCLzlPeWZHcFh5MU8wK3Ny?=
 =?utf-8?B?RmYrS05YY2tNRXRPSGdMNklWczlZek9HZm1lMVY5cC8yblZEQi9vZXF4ZE95?=
 =?utf-8?B?RXNTTkg0YU0vS0RYdmM2dnQzTUtGYzZDZlFyeXplTG5IU1pzb2QrS213OHpi?=
 =?utf-8?B?RTNzMlB5aHpncnR2ZXMzSm1vT3crM1NMdFBkRHVBWkdVbWJPQ0o0ZGk2Qjcr?=
 =?utf-8?B?ZnllSXlrYTFzZ3lkbVFkam5xVm5CWlZrM3AzcjhmdWxndHpRZjhxTldvWEpC?=
 =?utf-8?B?ODY2dkhtZjZsTmthVW1Zd1NFWlFyeCtzWHpZZnkrQi8rT2hucHJqQk9LdTRM?=
 =?utf-8?B?OHM0bnEvQU1PcHAyUlUvbEp6VVNYTlFXTXl2QThSek12Nkh4c2lrMFNtSDRO?=
 =?utf-8?B?RkdGcFYxZWtHRWFEUjU0Y1JMenV3T1dFNjVvNitwc3U5LzRQWjZ6SGdtYnpO?=
 =?utf-8?B?alFxK2liZitwelFhYlk5akU3bUY2cWFob2Jrb1kyQ0tEQW9ITEFEMExxY1g0?=
 =?utf-8?B?Q1JLL0xoekliZWhCdGZXQ3VtQnE1YXB3ZFBDVURQU05WT3gzTDRWZHF2MHFh?=
 =?utf-8?B?Z3I1amE5TmdFRHlhazY5NE0ybCtITXBtdCtaSlJvVFZrcUJoQ3RmY1kvY09M?=
 =?utf-8?B?cGk2VnNWV3BWQzM0THVKVGdQOEpZY2l2am9OdXAybDRmckprT01tNG03T2dx?=
 =?utf-8?B?VFpyUDN3WjdzQkVRWi92N3pySkhDeVJaN044Sm9kd1k5amRaWG5KS0pwOFJI?=
 =?utf-8?B?bnFGUm8yQU1OeFhGclNnL0MwazJhZ0hqeFZGcFJYVjA2SzFjanRGakhtYXZI?=
 =?utf-8?B?bGpvVnhHNWZmZ0srS2ViRmh0Y3k3eE8zT2FZV3Jub0s2THNIaVpiOWRNNFRZ?=
 =?utf-8?B?aXpqYnE2bS9ya3N6Qm5kQ05rb1YwRXlVb1llbldZQThvNDU4ZGVyWjhjYmNX?=
 =?utf-8?Q?21WRWFTEG/QMJxxbfCaqI5b06MkMlXgd4918Khv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0646c3-6d67-42aa-8c36-08d8fa0e41e1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3288.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 21:44:01.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tW+uVxnNY8FeZdF8c9OTtnh4U7NSOxAXrO0w7VzSuiZzZQxQBbQx/9txGY76rFZSEAMNulCLEkTYvNhWaeZmP8iZWGAgZXlp1+UhGud8mMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4543
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070151
X-Proofpoint-GUID: ZnOEBukdJS-F1O7NhVdPcBTBg4Vr7QLm
X-Proofpoint-ORIG-GUID: ZnOEBukdJS-F1O7NhVdPcBTBg4Vr7QLm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/6/21 6:51 AM, Luca Fancellu wrote:
> Unmask operation must be called with interrupt disabled,
> on preempt_rt spin_lock_irqsave/spin_unlock_irqrestore
> don't disable/enable interrupts, so use raw_* implementation
> and change lock variable in struct irq_info from spinlock_t
> to raw_spinlock_t
>
> Cc: stable@vger.kernel.org
> Fixes: 25da4618af24 ("xen/events: don't unmask an event channel
> when an eoi is pending")
>
> Signed-off-by: Luca Fancellu <luca.fancellu@arm.com>



Applied to for-linus-5.12b


-boris

