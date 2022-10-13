Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F35FD557
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 09:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJMHF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 03:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJMHFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 03:05:55 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2036.outbound.protection.outlook.com [40.92.53.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C13E52F3;
        Thu, 13 Oct 2022 00:05:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtnLO1VDQHw0rqhJNTPFjZxIw31JwIm2FnVff3+j4PPJLIMi+xpiWDMwjENXBuUQWspltS5Nya6QBS5BY1R4zCuQATCAzKulPKuJQ5zNfwLd1pZno2zJ8Y24eV09LR5KQeOb6ykxecASo0Yl6mbWY3XlDm5Aj+yH/voA6fHmHjkJ1Ka4zqOPCsjyA+TaOg6EL+R2atEvpb4PmwWUpK20DOEb7H6QUi6NOpLBRTuGlA031hyDuZzy87OrYGKST558i9BJsqfQ3z3Cdmnngs9WsTFyd7OxbDJHaT2eQhHrTUGviG8wnoKZF7uJRDj+UvvEQqqqoF1w4LVH3N6wSBRWEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uK43Mltxo0N70mTV3WMzjeTK++dfecnPSlrdCSY6dkA=;
 b=JeK7ehrQigAR/bynqP1A7/mp68q7muBXD6872Bm4dXcnpNrt7Mt5p+2nUYYEdN93V6IHIMqEprBnKeq2jZhrqV9Y0Fruq/Eput9MVGvBX1PnqPycXK6fz8J0RypuoZyNk1SYriJEMrO2QmaFl+8jVjN6ZGI58+fCrmmHayyeFeMjR2s+ealBgPp7Swl+eMli1T1UpN39faJI4KhTKGlSh/uwyXQnUyghghFcu2ZQb+gOeFUrPK1Qg6en4uzAyvmBJ+uh7+A53bhb6HfwsLMGDXu7KlqEMS3+1lnhDxffyYYHdoLk/xb1j39aLe0Dyv4aSvO4Nxmlvp5waIeTfa8E+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uK43Mltxo0N70mTV3WMzjeTK++dfecnPSlrdCSY6dkA=;
 b=UfoWE4Q+Xq7S5qEQkMM99CiyxCC+B9Vw+eqnVUHqJPIajm1LKmLhNROPYXQmiYXP0FCH8MMiqYJbybdYL0MddLd/Q1Qq3NURLU0kSQqbJjnfBkGZCM8QfvIvumCulZnuf725EFV2/UrzTOJYgprEl5pjGdKWzRton5TpKYgWIU4bdEbX4KeoZKOpzHIlM7Cem9R1MHE2g2FbAeXKtiKnRtRQEKGopu7RUHuVSIgmR3TJDTwyJzs45rQa4FZzhUAihM8L4PIZgL/Cv4ljOkSjUXJhdwW923gKIVmjl6qgjvKkG7KWvCddzGZa3XiV6CNy+NOuKwxQb6gAiX8Q9p0YLw==
Received: from KL1PR01MB3510.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1a::18) by KL1PR01MB3857.apcprd01.prod.exchangelabs.com
 (2603:1096:820:36::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 07:05:50 +0000
Received: from KL1PR01MB3510.apcprd01.prod.exchangelabs.com
 ([fe80::62b8:242d:a21b:94a0]) by KL1PR01MB3510.apcprd01.prod.exchangelabs.com
 ([fe80::62b8:242d:a21b:94a0%3]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 07:05:50 +0000
Message-ID: <KL1PR01MB3510AD021B2258CB789466E3D5259@KL1PR01MB3510.apcprd01.prod.exchangelabs.com>
Date:   Thu, 13 Oct 2022 15:05:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     cristian.marussi@arm.com
Cc:     iambestgod@qq.com, james.quinlan@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sudeep.holla@arm.com,
        tianyaxiong@kylinos.cn
References: <Y0V6Q7ZJ3GjBwWub@e120937-lin>
Subject: Re: [PATCH -next 1/1] firmware: arm_scmi: Fix possible deadlock in
 shmem_tx_prepare()
Content-Language: en-US
From:   YaxiongTian <iambestgod@outlook.com>
In-Reply-To: <Y0V6Q7ZJ3GjBwWub@e120937-lin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [z6gmYfpYA91tFuH7Oofbh8YRK5CS06DhKo2EfI6IwARw0QCSr7d+PnsQCeDhHGF4]
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To KL1PR01MB3510.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1a::18)
X-Microsoft-Original-Message-ID: <68025117-6b32-9326-0fad-08c2775bcecb@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB3510:EE_|KL1PR01MB3857:EE_
X-MS-Office365-Filtering-Correlation-Id: 706970e2-675c-448d-028e-08daace95bfd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KeVSgoK82dFSPCQ0AGU8sJzk7DIhkYebCbybmQUN2PKP+TYAm5N/Uk3JUdYc0Gl5i/wiISPIFfoIGSh8447RJya7kcckodzc8y6NLpGQK9VhRQEQztODOZix+ooXtBIxfAT+cKFgCKlgY1cbkaRCUPwTKOddU87PoQhuB+y5puqzWcybyDcBUQaS5cT+Aq36zqdt/gh6M+c4KTBudUPdk5p/T2CtPXW19ijJi2SeFpjwau2MAg4b2rhCkIhii98TAT2jnvLKEaCcVBKLxumpLxaUynMc9UpQ5xa1Le8CAvq8fPeDTn31UZ53S4iEP7L2XJB9nR2KRAiLEIxf+WIfjLhsursnHLTpsgYcxJtVxxJBs78ttRe2JPKZUQO2CazvSE02xGQho5nzm3ZHKUBJ/OIIUPsyv6BfeBck0T1qoqM75JvAqBWfK8lvbGH8MkLasKXXIwZ67dXxm4inn7/Qt3xtZ0px1sGqx7gDWXkr5xUep/O0gsQn0CP8ZHm2eZHt1vTMTO1OT9MHiokdq+6r0vjkzTdQkp7gxdMzt5UWY8nJTHdR0mEcXi3ROwzjbtP0Dsmu5nEVIypQGnC6YFVAHGQwsuoRX4dWniSdVSCOszCugSrrHM2QtoSXCcl9Gbi5xwA02/PCgZy8G3wTzETN70ChM+sVcdIEBCLJcAOFfgMLL6BprPgJwfk/J5YR9pTY
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b280VEN1WlcvclcrMk9YWnpFWktPTi9qVzV0U3dQMlE4cDAvUzlrT0RoNDd3?=
 =?utf-8?B?MWdDOWlRanF0Z3Y1dHdHUGF3eGx2dk85alRTRy91RjI2bVp0RW16VTRRMDdH?=
 =?utf-8?B?VUtvNnBqcTh0R2d3QkM5YU9zZG9UQkZJb2s3M0RHRVBYVHNCVWpKMXhTL01Q?=
 =?utf-8?B?Vkg2cGxEV2g4OHQ0d1JwQlBURlBoUTZhdEV3dEZQU2lQVENZVDdRbXdxQlly?=
 =?utf-8?B?aCtpVkVNbHdTY0ZsREQ4RnBpb2FHeGljYVYwY0E4MjUzeFJyRnNFOWxzaCtE?=
 =?utf-8?B?SUJBZHhySzBOS0wzQ3VPdU1kMEVDVW80elZ6OFdrSVhKVGh5S3N2U2JCdjQ0?=
 =?utf-8?B?c0xzZ3ArTk5GREl4UUQ3eWRCK0ptQUZHbmROSDVrNE1Xb0FMcUppUTk3ZXdk?=
 =?utf-8?B?UE1JemE4Ky8zZjhHazFHQ0NUUUx1Wm5Ga0IzNm1LT0tiQXJhd0MrSGdzSlJU?=
 =?utf-8?B?OHo0eUVYNGx6TUpqRHJ2YVo0UW9hR2lCVUlwZDJoMGx5U3p0VXVQdjZpeTYw?=
 =?utf-8?B?TVcvcXR4MXBXQlZjRzRZZS9UNTBrWXJTRTVsZ0dlQ3RpS0RSYmo1WkZvbUlv?=
 =?utf-8?B?QStmRUIvVXY3cVFPK015RVY1dWhvK0dabWZEWVhXeElhVGJRdWdUd1NUSFo1?=
 =?utf-8?B?dGJzc2JnbHFlMzVOc0FxZDdFNm5scDVaeWRXaklyVGd0RHNTeU9lMjZqc0tF?=
 =?utf-8?B?RUtPV1V3Z1B4cm5QbGFrdDdKZXdHYm5uM3lZMklpT3IwNkZqSEdUK1E5RjJs?=
 =?utf-8?B?VXUwc3Rxc25lQWNpNk5YZlVZaFRZS0xldlhQR0R1TER1bko3anRtT3JmNk5i?=
 =?utf-8?B?cUNMQ1B3b2ViZTdsSnlrTVVteVhteXpudFdTZGNDTFRtR2JObFRhTDRzUTJQ?=
 =?utf-8?B?c1JyTkhOSnBHN3I2eisvbFBVejZWZUtFbTdIcVR2d3lUUTJCSGkxMExjaXgx?=
 =?utf-8?B?dGpsVXlaWTVYYTZMRE5ZU2Y3S2JzbjJ3ck5mNnRiaTVxS1V0U1dhQ1FlR1Fa?=
 =?utf-8?B?bmdJV2YxK25FTVhpejlPMFptd01BVm0zMnU0ZmVRK3NidGV6MzJvNDEwYU9O?=
 =?utf-8?B?cmpwK3pCOC9QeUpGa2lmU3pMRmZuWmRtRkM3NmkwWHNGOGVWUE5uUEpOM2lS?=
 =?utf-8?B?QWoremExUDJuY3g0cEdjbWY3MlhsaDduMlhwZ0tlYjU5My9uZ0hYbUh4Mk14?=
 =?utf-8?B?QVpBd3dYMGxIcnVDUVZ2NlhsNmc5c3d3NjViVE1SNHZpWkp6bTV6cWhwN3d2?=
 =?utf-8?B?bWMxWFhHY2dXL251blluK2Eyc2JXTkNKTC9BRCtud29YTTNENVJRT0I1R3A4?=
 =?utf-8?B?UmkyYWNBNExBRG0xRktjS0NRR0RiNEdicW5iYnlpV1dLNHRrS2toVWswbGpS?=
 =?utf-8?B?VHZNcmY2SUtPdHZ0Q0lqQ3pkdEM2Qnc0Q0VBU09aZVZ4U1h0SlZUWGJJa1Nu?=
 =?utf-8?B?azVwM0xQRnUyVjhHb1I1VXpSdHl4T1J1OWErNXlaNzFDd3FPSVk1U3pwNVF0?=
 =?utf-8?B?cC8vQ1NJa0VCc2hpZUtYelFYTndUWllZaHl5SDArWlQzQ3h0ajVROW9YL1RP?=
 =?utf-8?B?QkFZZk1Wb0pNSzIrSm82M3VCbUtrOExBQ096Y2xucTE4SzloZTZXSi83Yk9y?=
 =?utf-8?B?cDZxQlNjbmM2Wm9EbWZMSEYwTHNpanNWMDAvUlhZcERIRWI2TEpxQ1hvY3Bl?=
 =?utf-8?B?L2NnNElrbCtBQ2JpbjMwUmI3czJnUmNYcWdnbGMyTE9MekJ4RzNnZ1ZMQW13?=
 =?utf-8?B?WmdaY3NTejRXYk5pVjZJOGhEWldVZWdCZmtKdFExdFJzdEN6RXkyNHRCdkZo?=
 =?utf-8?B?Sk1rZEs2elBOLzg4QnV3dz09?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706970e2-675c-448d-028e-08daace95bfd
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB3510.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 07:05:50.0761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR01MB3857
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cristian

    There may be a problem with my qq email client,   I don't see my 
mail in the

communityI had to switch outlook email.Forgive me if you've received 
multiple emails.

 >Problem is anyway, as you said, you'll have to pick this timeout from the
 >related transport scmi_desc (even if as of now the max_rx_timeout for
 >all existent shared mem transport is the same..) and this means anyway
 >adding more complexity to the chain of calls to just to print a warn of
 >some kind in a rare error-situation from which you cannot recover anyway.

   Yes,it has add more complexity about Monitorring this time.For system
stability,the safest thing to do is to abort the transmission.But this will
lose performance due to more complexity in such unusual situation.

 >Due to other unrelated discussions, I was starting to think about
 >exposing some debug-only (Kconfig dependent) SCMI stats like timeouts, 
errors,
 >unpexpected/OoO/late_replies in order to ease the debug and monitoring
 >of the health of a running SCMI stack: maybe this could be a place where
 >to flag this FW issues without changing the spinloop above (or
 >to add the kind of timeout you mentioned but only when some sort of
 >CONFIG_SCMI_DEBUG is enabled...)...still to fully think it through, 
though.

   I think it should active report warn or err rather than user queries the
information manually.(i.e fs_debug way).Becasue in system startup\S1\S3\S4,
user can not queries this flag in Fw,they need get stuck message 
immediately.


Thanks,
Tian

