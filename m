Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B78532D92
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiEXPdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiEXPdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:33:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8D957144;
        Tue, 24 May 2022 08:33:40 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24O83mwJ016140;
        Tue, 24 May 2022 08:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=BpQKWo7BDMHV++6ZWFMQoAovmTzti5noicly5we7CPw=;
 b=TM4vuLxDJdwIblnVdXH3l3mfA2hPn/j/IvwX+KugNsRzk9bIjq4iHj88piDy7Hz7VeAQ
 7yH0u9zal9SCujDKU2sIGpkBULZ/hOf0ughRf1crzpn6rMT6tlBTOn2o3h/MnzNYSx2x
 tHbyccvNXifENpdd5OFBw4zd6m4MNGt2dxM= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g6urw1c75-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 08:33:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIcCGMvZKlWwMU56BT8U8Q4xDU+DNgogxR60EJ6TNkqO8aCcJLg/zrxlyLodI1PSpPGjy5RupCPLPOJKmfsonuXpYJt8joBAPZO1k0TyXzTMP77zpE6I4ySHvlJYyKcAp+E5pwxH/KAriVPk03DIBUqxKR2KESE/Jv1v2QiaSoCZAfz6Jzx0Rt/8qk4RIZjJNAgjAl22AA3ZwtFciHuhVx0XPxqL1sOKN2zv3Vjj4UfpD2PFDlRCOARVaRxTThzAl8oJiEUbI+sgzghx3LznuxOXkyIQqJNTWZvB4FcsvEHVzwNV5OnIv8I/vqpszZq6+zMS7+at7+c7JjaDTStYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpQKWo7BDMHV++6ZWFMQoAovmTzti5noicly5we7CPw=;
 b=brvrHczHgg9Tz4TTiX4z+P0VwAC5UKKr7ISz674m0XtzkCG4KdASxYy3XXDvo0MOu6vlgGfcOekb97psfZ01LnN5SRf0uihnEva64464pB30uVFXlLgfyrlSDNxnKvsfl1APIg5X1/HtRGIrQZp/leREBCDAApD/LSkqjGiqTAWzh4ZH3CJ+77Q9w6ejo3Bz+peqmRa0D/pquEBMtx2/t/xSXlSB7fXi+3ZI9YrSOtPmkZkFnoucO0Vyzeous/WUtlXJcSL9rx1t7kmZeIFuFdmHQCTsha2Qu1m3cGUfzFN5wzsyGyP1lUqz41Y9JALyFVo7YsUWUxWq9/xeUU4E7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5262.namprd15.prod.outlook.com (2603:10b6:510:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 15:33:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 15:33:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ftrace: clean up hash direct_functions on register
 failures
Thread-Topic: [PATCH] ftrace: clean up hash direct_functions on register
 failures
Thread-Index: AQHYZkzTQS9IyBnykEesMdoF6vW2Ga0uLTaAgAANc4A=
Date:   Tue, 24 May 2022 15:33:36 +0000
Message-ID: <5992B5A2-090D-49AB-8CF1-B9B2A6B15350@fb.com>
References: <20220512220808.766832-1-song@kernel.org>
 <20220524104527.3a07878d@gandalf.local.home>
In-Reply-To: <20220524104527.3a07878d@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7787bca-3007-4a36-a275-08da3d9ac53f
x-ms-traffictypediagnostic: PH0PR15MB5262:EE_
x-microsoft-antispam-prvs: <PH0PR15MB5262A6DA5EEBE02CA65D8897B3D79@PH0PR15MB5262.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2JPfqcS96q80ZWrDO/C6X7f7Sp228PvemIdiFlpg+jAEr3OQsnebL3Jw+EBAuPq9pwQYlW9GTHd9hAWM2AOCeqGU0vt1A8TKpRtAlBQXE1vyMkMQD1SAhE6B7JPltCEk4k/uvyBvVo34En31tKrvOrGPzh1sfCHKAccoJ0pyBrBdfWpUYlEX04zVrTWrCTK3PN4qV1OoB5cxGBe/tBDVLuAFHgIgv/aYNmkIXaws89M44PoaHIeniBCB2nk6iLUrmdnvpEO6k/V+hge2nMdHVCzdfhuMIzQW2NuCbBRTuxNdkWMGZ3+CGKFhlptKqhKttrDWYm10KSx0XDnCQYKF+46sS8qB1ykaHWQ3KJHw3ZWTqeyeVFzJOFPdZ937iGFDuCZ41nR9BI9IdosJ/di9JF/hpOp/nhZ+q6FtUkKinUh7sS+Th9mT3v4Ie+wkcpLr/rfvAl7WY1Elgyhu9Z7HMMBl0wxyBOTheb0xwGO55JW9VG9fmPkD2EwNhIhf00G+hmeYyMYTTS8AjxTaVPUKPAUx1nPDJ+pxc5rjSUssJng27gLtgm/4fkn0mWaHg2FULWbRyjXy3qKflC6qWac01Oa/5SownOaXOh1FGhiuaHYRn6YBSF+XNq1mENufYcaDIDUMb4fPY0QBWaWgLtsQomYDQYmdulqd0fyhnawSEulJ0+NGe+UqiNO2fqhchxzXqaCIcuSt+dV9IUeggtflheQgvE+FStE3pz3WeTSdWIHATDL19We15roef7AfKxpA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(2616005)(53546011)(186003)(6512007)(316002)(36756003)(83380400001)(38100700002)(6486002)(508600001)(86362001)(38070700005)(66556008)(122000001)(2906002)(71200400001)(66476007)(4326008)(8676002)(66446008)(5660300002)(8936002)(91956017)(64756008)(76116006)(66946007)(54906003)(6916009)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0D+M9lz8ekyvK4l4bmO/Xo2I7Gtepa3/XnDrrb6ZPb3OT3CsWixvuqMDXxLc?=
 =?us-ascii?Q?yACEdOu2nIhnd5z8wMOHXLea3nvu3JPxpBXKtuCklkJnPHbfo1C6OdYfeWls?=
 =?us-ascii?Q?fTZ+g+sZTSO8nxmOxdm0IIbIrys90U6YSrgwdzExNGIF6ffDCv0tXx4ar0Hr?=
 =?us-ascii?Q?gsD8nfhe/vsLFZr9TSVlSmysC0i+IeAOLxSsNEFxlg4cDGjv71MMJUrNdb9X?=
 =?us-ascii?Q?QgSfczYxi4enmmAKQhLsmISKuOUJnrQbJrKxfE2kO7+VnDNHB8RQD5MURA1f?=
 =?us-ascii?Q?ZmdB8Z/z4CA2ZWyNOztr92NiHytgVZBpLK+zWdWbYGxtSU12hbsPEj5BHBBL?=
 =?us-ascii?Q?1o6gXlgQFZXq6oz+yu3H+F6YNLXeyeHVtGM+7pEMMZ/rm/67Wf6durg7mbaq?=
 =?us-ascii?Q?+13PryETcSrrbXwn6S0ycb7qzwdu9VcnSRoTr7kwQxfFCOwGTVUnsngH2WKo?=
 =?us-ascii?Q?ODRQKz8S/AJ9FFBzQAXw84EmkG0OMeYeXfmXq3kGV8q4ILDiNxaJVSqymZtv?=
 =?us-ascii?Q?czGjc8amIvXvOhEDOv9KMIKANdWE8pmfcTzuu288V1C+ZnZdATiNbGvjC2HE?=
 =?us-ascii?Q?HKLy+FhP/EV4GNrV0vsyvm8LdMs2uou88RVXBNIC22Rz8g2UHbEOU91keSh4?=
 =?us-ascii?Q?3jjgiRnrU0ADIjK3CrORNtwSan/pKKOTm3tV7DVFtCqwbaHjqRl2gew4otxA?=
 =?us-ascii?Q?fDKzrs2UxhXTaBw6n4m/81SAbmHlxxO6MLvwCzGyTyhq+my/PD7hjL666NMN?=
 =?us-ascii?Q?8pDGS/8pp5ad5g1Lh8F70cX9+TQRsSuZZ5TNfEOC9Uh0gHeKM3KEt9yZUuBm?=
 =?us-ascii?Q?P/St64pfNRjSSBsrKwf/NrIbTo6na7GEdOk7AOsC6j62PzP0gR9w0BN4Thfi?=
 =?us-ascii?Q?en5L61gFsepxLVowL2VNdD5eL0H/eJq56TC2GZPxfFS+s7VuJ4NKlsdulKFx?=
 =?us-ascii?Q?BOgoFV2+ZMDH3IMT+8uN2dIp9psVpC3PQOtmsB16qkF0M5WxfWpGcJGVHYwn?=
 =?us-ascii?Q?q6gDA24yZ6W/xaoRJuGsHQaBp7ZYxyTHGHD2hwE9IeXT/a8IkJMe4b5j1WDw?=
 =?us-ascii?Q?NUYGP2ZwbaWWhTjTM65URgWnZiPNeSx9bY/dmRSDOsAZkqqIhUU9dUuuX6Jx?=
 =?us-ascii?Q?OPIan4sJOtJIKyA99zYwsBPsQCSTHtcAphBMchLuc68qSJnYEtn7N64lNA/1?=
 =?us-ascii?Q?OLi2Okc1czK+DbLYUiqCix2T7iPO/FuJQNhEU1AWAe7YhkRkOR/3LUIArVKC?=
 =?us-ascii?Q?SC6tq8dxhwKCVs/Plj5YQ3qqQLXU/23Dio4534exLSfWtvf1nrKUoX9wXlzQ?=
 =?us-ascii?Q?nW+pOkMnKu80SmX70pqTSMAIfYSNT0XQcux4apiBEn1rfeXdES5GlUP2Xb9N?=
 =?us-ascii?Q?6z1Lhqn3XU6XJ8HRoXSUoyeBSXvZAFKesCnjNnYeNXQjlUwyiqD8hXjfISl7?=
 =?us-ascii?Q?8FfYI+VaUQeNUxk2c+3kDCgxR9GySb397CUrwISr5nRS6JsAz/3sufL7nISK?=
 =?us-ascii?Q?tuuOMaXq21uHpccrU6pUEOUjpdziDcAH47/BxgO/rqm1/J8d3sfmoTo3+syR?=
 =?us-ascii?Q?aSishmcxEnFFczOhpmXWjGmMHbEkG3Bvhzneo1GEYspc4rs4O0ZYqJRsLKDN?=
 =?us-ascii?Q?n4UGPq/L6u5uZxDdyWrAeMTaIuVH+1TphlE+YNhakltWJSpBJfz1spsgMSay?=
 =?us-ascii?Q?Y12fltOOtlIoyMiKgcyKC1Bu85sLhTLJzzebJ/90r0N+EbbU/TvUiQSQsmXd?=
 =?us-ascii?Q?7wnfUwgEVh814JXQC12SbELISM9Bn4E8hRixyGm0CCdx24HBi60Y?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BF86E0E24825240A7A80550F246C159@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7787bca-3007-4a36-a275-08da3d9ac53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 15:33:36.9261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AN8uHyKIRLlzAFBwq6JxKQLyHcoKlFBlUfM2KbCogvPzDFOq9CX4a3hej0204b1allV5ogL0DAiXMwzMlynlww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5262
X-Proofpoint-GUID: V8d8Pnc0MGGjieE6XO-i95PSqa7r7VcB
X-Proofpoint-ORIG-GUID: V8d8Pnc0MGGjieE6XO-i95PSqa7r7VcB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 24, 2022, at 7:45 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 12 May 2022 15:08:08 -0700
> Song Liu <song@kernel.org> wrote:
> 
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -4465,7 +4465,7 @@ int ftrace_func_mapper_add_ip(struct ftrace_func_mapper *mapper,
>>  * @ip: The instruction pointer address to remove the data from
>>  *
>>  * Returns the data if it is found, otherwise NULL.
>> - * Note, if the data pointer is used as the data itself, (see 
>> + * Note, if the data pointer is used as the data itself, (see
>>  * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
>>  * if the data pointer was set to zero.
>>  */
>> @@ -5200,8 +5200,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
>> 
>> 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
>> 		ret = register_ftrace_function(&direct_ops);
>> -		if (ret)
>> +		if (ret) {
>> 			ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
>> +			remove_hash_entry(direct_functions, entry);
>> +		}
>> 	}
>> 
>> 	if (ret) {
> 
> Perhaps something like this is more robust?

Yeah, this does look better. Do I need to send v2 with this version?

Thanks,
Song

> 
> -- Steve
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4f1d2f5e7263..cd38ad490174 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5195,8 +5195,6 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
> 		goto out_unlock;
> 
> 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
> -	if (ret)
> -		remove_hash_entry(direct_functions, entry);
> 
> 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
> 		ret = register_ftrace_function(&direct_ops);
> @@ -5205,6 +5203,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
> 	}
> 
> 	if (ret) {
> +		remove_hash_entry(direct_functions, entry);
> 		kfree(entry);
> 		if (!direct->count) {
> 			list_del_rcu(&direct->next);
> 

