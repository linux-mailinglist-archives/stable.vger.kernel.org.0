Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD846329A9
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKUQg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 11:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUQg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 11:36:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50042BF5AE;
        Mon, 21 Nov 2022 08:36:09 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALFpAUx029557;
        Mon, 21 Nov 2022 16:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=w7/k3P5BQ4jeM2BxAKyxHl6RdjHF5pCv1N6y52ghkO8=;
 b=hxR6fGCeJP9n9zYb6hUMK8onfJMyXAeV5Shu4nzB8TYdC4Kd3YNeyidmtqd7PGNF5T37
 NFT8QxJcvlUJgunaUi4fY1Ho/hhqaIOXLB725dhQHLB1k3VvxHdElwMqjhDOWHBLjmw0
 K4NDS+cdR66wwoXJ90I9C04E/p+Sfw44wI2J2igolX9zU4z0BwAldoEQBm2AHBm93kRx
 ozktfuM8Mk1+ycGPjelfnO/3OQ+ihIizA3n1Y5Y68FE/BJrA6NrKqwiJRLcKjretdOvv
 /ljhDFBEB29F9I27mADhHc30W3gHPoH/f5ae+nalGFMu9bTYHL633/hrGst9a5ugr25g 4g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxs57n9ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:34:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALFg9Ke007448;
        Mon, 21 Nov 2022 16:34:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk473qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:34:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fr/DE12xDY8xkD+1DADVD47vZvY8jJHP8qlM3h/iUHECFPUp+Ll1s9bgj34T/vsw+G/Ar2x3StoLl2gT/Lde/CE6R2cjUSCWGGQYNznhThlQn9HvgoEv02iC5KqETdWdyJWJAGBCaRk+gZEfDMHRCwunKsQcBVNK76/Wa5pLSq83/Hy2Scznt3MxZkKbdtTZlUTPl9QYhpNaIgeNQrWUVTOtL4pZZc1MokB3m3tu1aoUBX+zSita+cMHhTDQbxKQvMrEqOqTyGpoEOjBdtK3WfY36hc2tbq3bYenIbbtxKyp7XKnH0T/YMJimohVn6sl8Scf0DWNvzmWe+zcN7mLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7/k3P5BQ4jeM2BxAKyxHl6RdjHF5pCv1N6y52ghkO8=;
 b=NSjSRZ2nahXakw7Jz9YGHe7oeOptIeDfavteIAvGmNM/Jhh8u2LdHiqEQjKHpoBfcVDPncRzJXKUwPQ0XD4JhHB/fG9vh0+0DAJ+5yhu98APQrRPG6I0r0RNqQAVoggdLakUSBZ3Cbxde3nBgweaDZxFbALoi9oz4lDuPiaCTGrlNgpAFuWRnpYSuzB1qyS7rIgIWIx1ZEJ+mBsKuvvtx54ddxM55dn1HWbIb79wx/7DYRxVOafh0+y6lT7GmNobxkCQSVXG21Hbowiyifq38TX+Jt0sgun/j5TbXgWtjg2DQqnofp85lEHGEvoRiWrpl+DnN3nXaj8lYFLSXu+x9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7/k3P5BQ4jeM2BxAKyxHl6RdjHF5pCv1N6y52ghkO8=;
 b=GiaWL7AOUJisk15ZUaFV3Hxe+hlFER1QAJvPhzvbDWKJ7sk2dr94z848+vWMb0JN6cIqjjdyB3+f6YBL6F3L147T8x0g7T0x7HXKrea33MzKH3FdESK3dYBQfTNnx/3ys83pImsjyqWbY7jCe85fCmmjynAwkonQ72crj9+/pm0=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by BLAPR10MB4836.namprd10.prod.outlook.com (2603:10b6:208:326::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 16:34:54 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:34:54 +0000
Message-ID: <99cea0ba-9791-45dc-8c78-04d724a11cf4@oracle.com>
Date:   Mon, 21 Nov 2022 16:34:47 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2 9/9] KVM: x86: remove exit_int_info warning in
 svm_handle_exit
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Liam Merwick <liam.merwick@oracle.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
 <20221103141351.50662-10-mlevitsk@redhat.com>
 <3d25a0b4-6957-d070-db11-69ec9e0132ba@oracle.com>
 <30b8e07970f2cfbba0ebee82aa3b46a047a0f43b.camel@redhat.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <30b8e07970f2cfbba0ebee82aa3b46a047a0f43b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0489.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::14) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|BLAPR10MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: 69885b4e-3155-4703-180f-08dacbde51f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVih5rTohNBHGcSEdVaTMFqQzxHUxnBR6qM8bqtg+aQQz+f0o1KQpL7d+6cXEnHmHwgpMSYuaqnvbBi3cPGmr+s+WletxLwghg3WW/uAL/G6jhw16x1y7uM5rR9NSk9L+dW6xQjeIxf0Y2bWiS0FMtKCbRgy1SJTvofc1H8PYVvcUip1KH46bLhAiDI8wBUa/GqCBJuaV0bDZ+RVc2RCtHWns5X/deeg3oeLDGb5RmUZ4ZjY2UlwInwEhhSGPYO9V/oqi5xMnmwD9Ossj6FOqCLBur9TcPSQHlhIo/XtlbcxPj5ui/BugvCRvpkzWrrFgJWjfEaq/R015xusNnO2ZqtuVoIIZuRZTTyBQ2aHdt++UHOmQZRYeGydT5+rNvaHBsdYCrY9QGX5JfbNzmr9dLYqzHLO4FfmZtxrwDDte504gG4UN0VyBrW3m5oPP5Ltx018Hgnr7TaoVDc2RGzatMnZlvVDLPtV8wvxcShWmTMmo6/k6cl3w6EmMjc293QCGSuwUpsFv4No3z3z59zOWXaGdw++vmObHxo8SbUpqlVDuUm29D9nYSubjVGFvZbNh1sInSCw4aV4YlZfvgNYG77CanQvd99tTNy8N1+mZxsowVOguKVOQmQb6iLgzCHaKVDK7lhpBNeIUHVvhjSxF41EvIPszSCM6Tbogv/eSchjKOQ2VxsHFepkbs4qdqgjhdBzlxwFKN2jiXzS9Wqt8m9xw2jD5buwzgqZPtv4Z5w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(36756003)(31686004)(86362001)(31696002)(26005)(44832011)(5660300002)(2906002)(7416002)(53546011)(2616005)(6512007)(38100700002)(186003)(83380400001)(6486002)(107886003)(54906003)(66946007)(41300700001)(8936002)(478600001)(66556008)(316002)(66476007)(6666004)(4326008)(8676002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qi9JbUZFTjFvSHVUcktkRDJhekQwTGdhclhHMEl2eTQwLzhNMlV4VzNpeDIy?=
 =?utf-8?B?Nmk0ZUJrS2tPK3JRWmRINEJTUWlwQTF3NjNGU1RzZTBNaG5kQmlHZEVFM3hJ?=
 =?utf-8?B?dDM0OW14U1ZHYllES0MrOXNVdk0wazhxQWlaR1VLTVJaTkJib1NlM09GVWhv?=
 =?utf-8?B?UDNjS0I1QWc3Q3pGQ2NRNGh2VVlOVmtFMDArc0VvWVg0ZXgzK2RQdnFDMnNv?=
 =?utf-8?B?Y0p1RmF2VnZIdlJjMG9OV0tCN1VVQlNZOXBZSUlOME0wU01IejBKQmxhN054?=
 =?utf-8?B?dnBwQ2ROdUZTVEFGdzM5bTluK2dzM2V1RExEVU0xUktOdnRPRG52UUI5SUdW?=
 =?utf-8?B?MU1sOUxEeWhObVQyUEtoQkk5TmhHTnI1RzBjQ2d0UHcwbFpPQzlQT1dxWURw?=
 =?utf-8?B?WTZudlpxY1hQYjJiTVVGOUhzVlpINzZkVXlZb3k5RUtXd3dHM1FoVjQ5ait0?=
 =?utf-8?B?MmxORDBwS1B5ZGpaNjNTSUtFU1B6aEZ1dy9md3hsSVdrNXZ0U1B5NFFIWjh6?=
 =?utf-8?B?ckt1M0dOQ2tmVnp3aXFOcDB2S3BSaXZyK3BmOFZiZ0E3ek5KV3BIcGZ6U1d1?=
 =?utf-8?B?aW9ZQUNBRlkxOVgza0M2TEpNSFVJUStnTXV5MzJpZEcvekVqUHN4OHVEWTVq?=
 =?utf-8?B?bWh0YjA5NnBBZzEyTDVIM3VycnRjYlhJaFZpdUZDL3cxYmh4QmFVRnY3T0RR?=
 =?utf-8?B?bGlidFBNLzJjWVZDaDV0TmZzOXA5cDZjd0NKVWh1S05sSDZDWkRQdXE2VzJa?=
 =?utf-8?B?YTd4UEZhR2l4bzRIb0xHN0tIS0JtQ3dZcWI4Z3dORjNmdEdxcHJVUHJKUnY4?=
 =?utf-8?B?YkEwdXZBeGQ5aWMxRmdONkpSYUJXUFFyMWtKMEVvR2RjZUtOUlg0c3pRRjc3?=
 =?utf-8?B?N0lHbFdkdmxYb2xzQU9XNmM3TmJ4emNDbTFZUjBTSXBoWEhhbTZHdVdOLy9k?=
 =?utf-8?B?UTNDSndDRk9qV3NjQlZKUWpEViszKzBvUDNuQkZ3S3c3S2VwazRVWVhOSTgz?=
 =?utf-8?B?TGliMVZqWnZONUxjOGJ5ekhpWmNUbzhUYkJhdms5dzdYNHVKVjdkQ0RSUlZZ?=
 =?utf-8?B?cDRsL1BNSXdOM29uYWJsTnFoOHdxSkVxK281VXhqRDNsODZJa3FjKzZieXpp?=
 =?utf-8?B?dUtkcDMzdGlJMlBRNmRZOGJmVDVNWitQSENJQWxTcy9JZ095Z1Q5ditzTVZH?=
 =?utf-8?B?ZEE3VFU1QS9hNWxXZzZrSFRYU0xGaFNnVTZBSTMvQmtMcEdMK2FjRXhOOWRL?=
 =?utf-8?B?b2RVMWRkeXFnUFhqOHZnb0VuYmpxMFV4MDNWRld3YVJlRExUN3ExSDd0cUhp?=
 =?utf-8?B?UGxTTVh3YnViZ0ZoMnZiK1FQTy9hbXVkc1Z0dTBWdmpPR3hGaVpOSmtaK0JE?=
 =?utf-8?B?K0hJV3ZGZjdxYUhMU2YrS2locVNmWVU2Z2owOW9NcUozSk0rOHdkT1BUVXRk?=
 =?utf-8?B?SUxSMENtMXFnODlHSlJnc2hwazN2d1Z3Y1VKUWVRK3MvZmVjMHRSVW4zR2ts?=
 =?utf-8?B?dEpsbE1nNlJOR2lJWHJteVRGUk1UbytQMDh3cHN4cmRaTDNhcnNEYmx4c0Uz?=
 =?utf-8?B?bVR4d1JRN0dYZjNwRDB2bG90K0pIUFpJdzJaUlZxc1BwbmJMZm45NnozNUtN?=
 =?utf-8?B?Z2l3NkxBdGM3UHhzNG0yVUxFdHBmbm43WDlPa0ZGRi9VdVpzeTNkUEhYdDc2?=
 =?utf-8?B?U3ZoSzJoTTdwelVDMjlPMWE1Y3BsOG9IOVBPQlhaRnMwL2VDNkJRNEYvR1dH?=
 =?utf-8?B?cnVuRndFcTN4SHVZcTRqS3Z4djVPZFphdXJMVnpKYXBoTHl2Sks2aGlLdEhR?=
 =?utf-8?B?VHY2eFIzUW1DU2wvbnkzdDY4cm0weC9pZTd2TUVIRzd2SFc3LzRZS0FPWjhL?=
 =?utf-8?B?TWVjdFBXbnB3dkhKdmNnbGErUXlrOXlrNkJGaXhBaUZNRzJrTlB4MSt0Zzda?=
 =?utf-8?B?M0xFTG5IbHpHdnFOWGtrQ0xaek82NWh6WTJsaWZLVGJsZXlYYkRsc2Irb29z?=
 =?utf-8?B?YndzMmI5T21IVUlDTk8vQmxWTXVVUXBjMWpvSWM0T2FTWjhqNVpUeDVNam56?=
 =?utf-8?B?THJzSWl4ckFIS3ovb1RKSDRkeUJyWGE0UlZKUHZYRmo5dUF2UGtrdmprZ2dY?=
 =?utf-8?Q?CRJZouxbgX+Y/3mXAdZHspzsI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L1hrOExzM0Y3TDFVNHBxcHJFS21uT3VLNXQyaTZNOVZuQVdaZ0NHYmtwZXdj?=
 =?utf-8?B?T0VCQWk4Q214cUhpTVBSYTRnRkFSN3hlbTJKK01FVCtOVzY5OUpzUXpicGYw?=
 =?utf-8?B?alNsZWgwNEJGdVJBWERXNTNvZDg2bTJ4Tis1ZjJBSFpzWWV0TjU1NEhnRW16?=
 =?utf-8?B?MHFKbUJpUEltQ05QbklQNzJlV1I3NytBd0JnT1JSVUNINS9sc1JueGxRaXpE?=
 =?utf-8?B?dTBZcFZCMGYwYVd5Vm1vYnQ1UGUyaFZrZGFRRVJiV1MxV1hyamR6WWdVN1pk?=
 =?utf-8?B?MmNuOW9tejRVaXZjZkFTMFVIZS9qeUZVdGlhWUhNcTU5SkhUYitLUyt2ak9D?=
 =?utf-8?B?SGpHZ01zOHUxZmJzTFFqQXBUdUNHK0tGVm5RMEJtWnB0NW9FOUZPbTRrdWtq?=
 =?utf-8?B?ZlpuTzFVcjJHR2h4WldMckIrWVQ2dVluR1E1Z2VOdllENUIzOFJUU3F6VkF3?=
 =?utf-8?B?eUZJMHp3a1p0SVFhcDJ3WGJLcXM3NG9yZUtlbDI1akFkQ3AzazJUcFdEZzZp?=
 =?utf-8?B?cUFPeUwwZ3ZKRDQvTnIwUDMwcm9GcnRUVmVVam5lWmpseVArZVlsRlBLM05H?=
 =?utf-8?B?QUhDUDNXTW9PcFZOMUxyVFdrNXpuTjBISThCeEVyNzd5VEJFZHNqTXBNbGRm?=
 =?utf-8?B?cEcxMVlKZnlzUXkyZ04waUFSazBpNEdkaGNMZVpCc0M0NjZmeWJCMm5MUmlK?=
 =?utf-8?B?bVA2d2VTSDJReFhNYU40YmlSS3kyMWc1TnpqZjA2R1lnUy94b1l3UUJVN2ZZ?=
 =?utf-8?B?SkVuRWEzRjNpOTJkVVM2UkRnb29XL2FNMTA4YVZWbEFqSHMyNVFuamVJK0oy?=
 =?utf-8?B?dHAxN0VUTnQyWkUzZ083ODZDN0N6aFBhTkducjd0a0V3UnlHOWRlNmVmRGdD?=
 =?utf-8?B?SFU4K1BQVFFLRndHSFdBMzhKVkI2WTN1WGwrM0FSaS9taG8xMnppSWxYZ1A3?=
 =?utf-8?B?dlV0MzN6azI1QWF2dW4vMTh1dml1N1dadGtURFQ5ckYzMktyRjduUzZsdGFL?=
 =?utf-8?B?WEtjdGc5SFJIL2Q2UWVOalBZTExjS0JnYW1Lb2o5alErTm9NR29WU1RrOEY4?=
 =?utf-8?B?WElKaTB0anFVVUZDWER3Z2FBbzVwcGNKdWNaU1V0RzN3aExiTFgwVVkxa1J2?=
 =?utf-8?B?aVdsTHlqUnFrMEtzeDlhWWZmd1QxeEhHa0VMS0I5VzIwRStOaGdQcWJpdDZB?=
 =?utf-8?B?QmFYc1lNSlcyc2JrdVNjdVZSVGw5c29ZaGh2c04raytBbi82UHcxWitVV1B6?=
 =?utf-8?B?MEZmVFFZS21zTFJqanpvZHF0UGFZaURYTklMajNqdkhYaHJJa3orOE5zWU5j?=
 =?utf-8?B?VWpnamt2Vm5RSkFMYUFzSEpzU21WYWZZUGlDR3VsU3VsbFQxa0d3ZjFxTk5R?=
 =?utf-8?B?WWlNSUxGRE1UZERPd0xORHJYTjZFd0l3eHhkSXplRUQwT1hlZ0tQbXNZVWls?=
 =?utf-8?B?NUFnUVEvUHFmVUpTeHhWNE5mdGM4dkdiSXErelNNNFlNUFZ5anA4aTJKNW1F?=
 =?utf-8?B?OVV4bzV4UkZuZFphZ2ZlOFNOUC9QcFEzaEU2VDFtczU1cHZpd2V0alNqd1kr?=
 =?utf-8?B?Ylh0MWE1Qlc2dGZPYU0xME5XSDFHVmVzTzNCb1ZKNVV2M1drNEsrSk02US93?=
 =?utf-8?B?MndFTC8yODRzQWdXejlNVDhhVHZnM2p6TVdwbnNFdjQ1TGdyOVYwMDVnMEx0?=
 =?utf-8?B?RHVDSFMyeXdJc25JbngwTGNucDFmU2FibEpFbFNLclVReUo0eUhKVkx0OVor?=
 =?utf-8?B?UGdJa25hT1F2bUJIYjk2cldPUDRLQUlmc2pGYm95U3BHTU05OVZMMTk3ekRT?=
 =?utf-8?B?RDU4dEdTL1UxRXJCamh4TzNvQkZWVVJJK2xvMWFJTTJZaGpLWTdibWpUOTZ4?=
 =?utf-8?B?M3JOOUUvcFFRTkhJdVkzRGpRait4TVFneWdUSkF0UCthN1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69885b4e-3155-4703-180f-08dacbde51f7
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:34:54.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcw2dSiK2160UJP1+TvcWqAxIWmZqzsglHIYBmwccnfiK8rF7+L16QGmhX4lF1P7iwoHgDwbG8rnk0w91Eo2jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210128
X-Proofpoint-ORIG-GUID: ihsB0pvMBsKFXAfiDf_jar8nwUTFMbAD
X-Proofpoint-GUID: ihsB0pvMBsKFXAfiDf_jar8nwUTFMbAD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/11/2022 09:15, Maxim Levitsky wrote:
> On Sun, 2022-11-06 at 15:53 +0000, Liam Merwick wrote:
>> On 03/11/2022 14:13, Maxim Levitsky wrote:
>>> It is valid to receive external interrupt and have broken IDT entry,
>>> which will lead to #GP with exit_int_into that will contain the index of
>>> the IDT entry (e.g any value).
>>>
>>> Other exceptions can happen as well, like #NP or #SS
>>> (if stack switch fails).
>>>
>>> Thus this warning can be user triggred and has very little value.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>>    arch/x86/kvm/svm/svm.c | 9 ---------
>>>    1 file changed, 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index e9cec1b692051c..36f651ce842174 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3428,15 +3428,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>>>                  return 0;
>>>          }
>>>    
>>> -       if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
>>> -           exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
>>> -           exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
>>> -           exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
>>> -               printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
>>> -                      "exit_code 0x%x\n",
>>> -                      __func__, svm->vmcb->control.exit_int_info,
>>> -                      exit_code);
>>> -
>>>          if (exit_fastpath != EXIT_FASTPATH_NONE)
>>>                  return 1;
>>>    
>>
>> This was the only caller of is_external_interrupt() - should the
>> definition be removed also to avoid a 'defined but not used' warning?
> 
> I hate to say it but I have seen a warning about an unused function,
> but I really didn't expect that to come from this patch.
> I somehow thought that its some leftover in kvm/queue.
> 
> I'll remove the unused function in a next version.
> 

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>



