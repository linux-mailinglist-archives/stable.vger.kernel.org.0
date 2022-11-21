Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE236632983
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 17:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKUQce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 11:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKUQcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 11:32:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57886C6D00;
        Mon, 21 Nov 2022 08:32:24 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALGMgoF022907;
        Mon, 21 Nov 2022 16:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LegyJzcNBdkvEkyIqXtPcDubKxu9jz1nfJSXrOlLjCs=;
 b=F11gbAjTC8ppmzpgq+fStUfYpkRp4zSByOnPQwFlwPs55l9IibF7wdleM7FKS4ShrJ7C
 TMvMFlsF8+wNBSK0lZJrT4gNXUjcUHFDsHbkHXCUWzjxkWXwSigMOBsvcD4R7xUpNSp6
 jNyUtuWXxseWJR3+9jFdsPwRO2MFiPMA3FmwNAJbgGSX9wBbDUBq4SdJ/UdXo32Y6/m3
 jb7/gBMXgN15c+tINzw0EYi0i7qsD8x+tHJmdqjU69qLVTfbPtMxosQIbOKpOAwhpe9T
 biKTR49ADrEb9S+SYvki34VHyR9B3OCMxwhTGvAAhnTmUwjzhYUJ8g0+ZWhEOTTok192 Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0ct1g14r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:32:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALFfkUj008246;
        Mon, 21 Nov 2022 16:32:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk3euxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:32:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7wq57HuGI7vKRU/qejk2D6KnzY/NSVciS+0BLKHXQXfc8AgqiUblM3vAyl2bdOAGImr0OpYTJl6naWwuPXyDeKjomKAvUJUV9VBU2jAARs29cbeo+jh1e+tIoA8fF6e2nPhJ7CdbsSdr46LVf4+UQwPgzA08MdQCgrJ0Y8MhzIGopQ0FgVPg57CdLYno42OLtWdVnZ57Zbm4oyvC486gNBUhd1OlGfmOU0eB+8wArsGbg1x0W2z0hkhHEGaoDXdTEtAkijD5CoK3JtTzTvXv/+D2YsDcdQQipc8mIGKpEf5wzEsiEzuqACiGvsypvfHoHZ0TSCPNXQMhFxFHzmBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LegyJzcNBdkvEkyIqXtPcDubKxu9jz1nfJSXrOlLjCs=;
 b=lCyOn/B3DM93P6PtI9n/oNtHS7oLttxSBQEPDr125UDPXIUehx2qg48AeMhrEJwPVuePThkycDe0zPen/75yn/FlqUrIL0vtsigNZ4f0pROrKPEqV4+KWnVq9DyKSK6mrB+PWdyg/QbvF3Bxyr58PQna3MXmgkbco6atJxsJx9ZaiRlLj9SDihN9dqlbGB+x2VZ2HcAsrH4YaTHUnaUkhzy2bZZRBnrRNr7wXd0BK7JheLinM7VO4n/m35RElhZTGfBZ75Pmtoq+fDwaIQcS6WvPxu7UbEfbFYwmstriiaLDq7czgbmKOC+VCb7h4cD7jLyVCa1VkYMArPNTQDlktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LegyJzcNBdkvEkyIqXtPcDubKxu9jz1nfJSXrOlLjCs=;
 b=gZslKZ7pFQ9w8uKzy+BZT/2s7fwx0XAgdymQxocc4Xz3HxLCBXVqG2vne4suUsxqhPeH8jxPNi/ArW+4QaOaTBDnPbDZY6Br41KT4sBViZfKf8SDZhrgsxwqnO6Z5w+fk2+gUPq7TC7PFyJcYUCOR8dDa/f7h0F5lJVg5Q1WKwA=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH0PR10MB5779.namprd10.prod.outlook.com (2603:10b6:510:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 21 Nov
 2022 16:32:02 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:32:02 +0000
Message-ID: <d908d6f4-bf73-27d0-e062-19eeee874f3b@oracle.com>
Date:   Mon, 21 Nov 2022 16:31:55 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
From:   Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 4/9] KVM: x86: forcibly leave nested mode on vCPU reset
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
 <20221103141351.50662-5-mlevitsk@redhat.com>
Content-Language: en-US
In-Reply-To: <20221103141351.50662-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0027.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::19) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|PH0PR10MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 261af29f-d4da-4ac5-9094-08dacbddeb38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOQtM60MlZJe/2dl2c7AKKZjvYPqsmhI8whaXekIRi92/1olSHFAWvBtdBBD+74HMNyJzMJRzhGgKTr5eAHvkIz0DKSVpx+2WO4kJo1AYh3qpZwn/pMMFiRKOWppLuCSoF+PlJLI0Wf4GUgijL0g6iCnnPb/zgUlSREO/TIt0/OgxuOf6iTslgQIpT2XBR8GgXv8ZgtXVQdXsLQE4Kl3lki8yVB9ANS6rm6NxNF01/g+cip1h+tChgFEaRwUPxhSExln/zQ+utp1L5UCg3fTpit/FCbXREpAp3je7jAWRqIUzp0nCwlP4nmBw0Hu9Y65x0dPfYWeSGKknAKJM9Y9zVMsEC1fWRqEu93Ll3k9cHJ/gByg6W+k+nVosgFkdBWA8cWJ+2nnI7HHZRCIZ0kv12s9zFfpjBqHhJubMP3WESzXRl42Gax3pniqa8d59nMe7c0ktGYYDc5R95F/pp5jeQ0NBBwUyA7mdAPpCCxNDmW5/I1wL+Irevyqqpzz1+tI7byvrjl4ax+sONZjMeDqV7yIAPFU0PgSUw+0RiZxN+Pt1tF9Qh86i43zf3d1iso2pCLoj/c8m02E9Dk2PFVxk+JkBaeNmb3QwUigoALV9Ks8yxwyqeXKAo6bp5/AtgAtguWQWe5SQamAAqb3q1rJEpigrzYL87sUOW2zXAuVuSaauRVTgTunTnUiAOvpkNNyX4Pj/NHBHTekwWYjmCAFP8WOhcGnoIBe1V59+Vq9FTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199015)(36756003)(86362001)(31686004)(31696002)(44832011)(26005)(5660300002)(53546011)(6512007)(2906002)(7416002)(83380400001)(186003)(2616005)(8936002)(38100700002)(107886003)(54906003)(6486002)(41300700001)(6666004)(6506007)(478600001)(4326008)(66556008)(8676002)(66946007)(66476007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alY0YVhvSnJuYUhCd2c4eTZMNlJhYm92NmdGZEZRQU1DWkJKVHNhRzNPTXMy?=
 =?utf-8?B?aDJ2MVo2RkxPSkxnUHZhUHNrQ3l4dGIrbENYT0k4Mk9QM1o2K1lIRmpBQ1Mr?=
 =?utf-8?B?MlRyWmloNWpDVFZvZHlvM3BFMU5ZdXRkQU1zRHJmM0xvbC9PMlJLWjRNOHA4?=
 =?utf-8?B?eWZMdDJnVXpPQnpOejhPSDU3d3Q2VFpmUzhjbGxBWUtZOXBlcDZTdU5sRnRx?=
 =?utf-8?B?K29kclM3bHhlRzVXTzM4THRmakNpdlA0R2lRSC85Tkp6a25SMEFub0RlSzZ5?=
 =?utf-8?B?aGkvcFJlOThBdWJjV2R0YkZOQUZNK01NVFM3MWFOalFBK0tWTTQ4OWkyUkpq?=
 =?utf-8?B?dHFiWDF6MkhTM2lNeldBWXU3dm9mRTV0WVpsa0RmODV2RDZoSUNncjZ4a2Nl?=
 =?utf-8?B?czdUZVRYdjNJeFg5T1ByelZyUzRacVY1RVUvVzVVNWhHRHZ2WW82UjhSdDhl?=
 =?utf-8?B?Sm4yem5OVjhGUUtGRWVnc1gwdUI0N2tOT1FOS05iSjhsMWQxTFRHcTRGOU9C?=
 =?utf-8?B?VE0wVWxDeHpGQ3dTSGk2a3ZTcVFUYngxbDFqZHowTUhHR091S2ZXREVLdk85?=
 =?utf-8?B?ay9qKzNabkErWnM5UVdvbFp0OWY4U0Nia1g1YXhIbDhDRTMyMlZOcHNudVpP?=
 =?utf-8?B?SCs3NUd5Ukd0aExwdUE4NjhlM245WHZpWFNCdU5NY2NoNnZvZ1NPMzA1RVB5?=
 =?utf-8?B?LytCUVNyMDUxWXBOV3JKKyswaGV4cXVYWmRtVE1yZVpESzlPdG9ZdnAwaG4y?=
 =?utf-8?B?NGlUWUVLZnBvVElqT1FVazM4WlhGekd5S1JCUU8yUWN5aFBHa0RjNUE1eGtG?=
 =?utf-8?B?YWczaDdMSm5VU09STWRIeFptUkxBNHRWVm1COHRuL0hZa3dwREowalB5SVRH?=
 =?utf-8?B?S2ZQMkhyOWs4TGdNdE45KzhLQWlnY2RqZHY3RTFGMW1hZnFWSGFuT08xOVZX?=
 =?utf-8?B?Y3M0M2dYU20xd3RPMGdnMnYxSnRESU9xSE9jTU56L3czeDZJa0lQQlFML0RY?=
 =?utf-8?B?NzlpU1J6K3paWU5pRFJqWlg3YkRQeUxvYm12Vlk2Um9na0srdUlscW82ODgy?=
 =?utf-8?B?aldWZ1JqcUo4aGh5bFNLc080ZVBoM1JvSW11REpQMlJqa3ZnWDcrL1pMWmFJ?=
 =?utf-8?B?TmV3dzZCSi9pbG44SnN3bWh2OUd4ZUt5bDdvZnoyc1Z1blVEVkQrZnJCZldH?=
 =?utf-8?B?eGU5ekVDNFJDZmlTWk5iZGNhMks3Y004U3FwZWhtaThiUHZMeVk1ODlaUS9O?=
 =?utf-8?B?b1RCTlNzOE5UZWZyRkcyN2h6cTk2YmlYczJaeUN4LytKdmloa1pPaHZkSS9V?=
 =?utf-8?B?SHpzb3dpbWUwMGJEeGRTWmFFTjFuRVJEN3Y3K3NaLzJFeVJNT2VNQW94czVP?=
 =?utf-8?B?OXRERUpEampPcXpsMGtxMkJlcXJud29mRTdoL21ZSHFuZlBodThDT0dLVnNn?=
 =?utf-8?B?Ty9YN0xBQStwMGZFdngzdEZhU0hMVTBiR2crV1M0N2xFTVZrRDVzdGk5Ullv?=
 =?utf-8?B?Ym5CZmVvbHVDNDNEZ1F6dmtUYXNMNERSdU9CQWc3Z245ZTZBMlhVa2NrVk54?=
 =?utf-8?B?Ny9ZSFhHUUNKcU8zcmRvbEtER1dtNkZpbGIyRlpaMU1RUTZsNHg1Mm9qZjJp?=
 =?utf-8?B?MUtIc1BGNk1MZGJEOFFSTjhoZWtET0NyQUhnWFVOS3hBMDlTQ3hKWTZ4Ni9j?=
 =?utf-8?B?clZiWVhZTGZkcm1uK3dwVkRiMmMrM3oyUzZpTWRBd0VCNDdob09nWk40Tkc0?=
 =?utf-8?B?a1J6MGdnVTBZMEw4d21YeGJWdlFYeENJY2FXbWJKSGVBSWZKNDYzeWxjS1hO?=
 =?utf-8?B?Tk81N2NtUm8yazJuNDd2ejdkd0hvVGxrNE1CeEh6cHlKK0hVa1FROXBCbDFy?=
 =?utf-8?B?ZFJBR3A2OVFsMU1PZzhKbTZaWnhzUWptdXQyUENQREJzNGZuV3dqWUcrTU5V?=
 =?utf-8?B?bG1qT25XdnpRZmVHOHRlYlpMcCsxWGh1ZWlwSkY2WVdpeldvbEUyb2FxU3Qv?=
 =?utf-8?B?blA3SkszN3NTZWxxTk1FcWNPWlZDUkRLRHQ4aGtEV0t3Zmg1cWg3OTVlQTA5?=
 =?utf-8?B?c3JvUVdqNUk2VjZPanlycDRGSnpvMllVNmFiNUM1Y2k3cHdHZFI3U1JlTEk2?=
 =?utf-8?Q?qH/9HOYQqvhCmbnM8penoeYFs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TWZFTDlHanNIMlI5dW5ybHM0RDdSdkY0QjFOLys4dFdjR0N6cThoakVsQWxL?=
 =?utf-8?B?a29kQWpwT2ZDbkYvTDVYNkJPamdWck5wM3psV1F2ZGVVeHVkZ1RwaEpuWHVV?=
 =?utf-8?B?RVh4RU5vb1MyV3BpN0FkOVVsaHBVU2tCSUtKWlAweGh2WHl1UXZsM0lRUE0x?=
 =?utf-8?B?SFRKNklGTHpwRGlwM3VrcHZJcTlqaFlsb3VDeDc3N1VIek0xczRYR2NCY3pk?=
 =?utf-8?B?cUtDK1NtSVNTTm0xTGpVNHRiZzF6Z1NOSnZyV1UvMmRJenMzemMxSWVta29n?=
 =?utf-8?B?TVM1TlBUUkx1TnpUYUo1cWhpTE5BejE0emUvdlRVWkthVERua3J0UndUT2Nh?=
 =?utf-8?B?clVqdDQzaStlai8yaG1rZ01qTGpwOVA3eEN1NFNPWFBkUVY3OHdmQnc5WWps?=
 =?utf-8?B?WG5lWFpoMjNyRHVKR0x3VFozZFgwREZnR2t3b3pLLzFzMjYxOXQ5KyttYnNN?=
 =?utf-8?B?N1BzVTk0blJuUjVLYmhIS1Q1TzJTS1ZLTHNERzN5UTFNcUIvWC80eXkzRldF?=
 =?utf-8?B?aUFrT3c1RVNKZHRhbWwwaXA0eEx5L0wyMG1OR3JUL3VNckR3UXFDR1dKYlZF?=
 =?utf-8?B?NzQ3VG50bzJ1RFpXYjljUlJYSzRoSlNNV2p2Tm1kbXpWbGVqMWpKNjQ1aXdO?=
 =?utf-8?B?cjk0a0VqdWVNT0w0RlVycll3a3V2ZTV6clJRRjI3U0Z1SHNVQWV4OVBMaXRM?=
 =?utf-8?B?Y3ZXd09XVVBLSG9mWTc2VGFudU9jS1ZVRHpvcFVmcEo3cksvS3k4OEQyTUts?=
 =?utf-8?B?ODc4djZIRFRLWGpvRHptWHBlMzR0NVV1ZEpVRSs0eXpkVHJjVWNaVmFyWmE4?=
 =?utf-8?B?R2JZS2w3SU92SEZLSEhpN2UvQVJRdWpWQ2dkWmgvcDA1Unc5UUF0RFBrWWsz?=
 =?utf-8?B?RzdTRUtwQjhLSndYM241eFZCM2hqUnB6QmM5a3F2SXNWdUhDdVFJNnd0Skp5?=
 =?utf-8?B?am9SU1dXZHBqQkVRTGVYNmxiMGswY0tIVXdMMVZSMXJ0SnhvSmRXKzhGNUI4?=
 =?utf-8?B?MDBETTU3bUs0dUlObVB6VTZmUkQ4MndkeUgxSkxkb29iaTNuZFZNSFBJRVdU?=
 =?utf-8?B?OG1rOGpNOXA4YkZiYkI2WFp4azBqdzF6Y01tTHIwQlpyQkZYKzFqYTlzS1Uw?=
 =?utf-8?B?WWorUzgwdi9XKzVIcFVIZDhzYkNodzBSSkVsRnhCWURwM29PL2J3YjB1NHJM?=
 =?utf-8?B?TFI3Y1dCdVZvYmxSeitTNVVtV1FDQ2ZsaVZndGpWdkpHaTdXZFhQYklod2hV?=
 =?utf-8?B?eTc0Njg0ZEJCSnJIRTQ0d0hqTlo1ZG9xa1J4SnBnejdDdklBWENHTW9EV0FT?=
 =?utf-8?B?a1c4eHI0NWc4dUZkYjNSaFlWbEtpMmQvUXBybmZBVlJwdThCNTJKWGhxYVp4?=
 =?utf-8?B?bHV6RVhmbDcycWVrMXRnTTBBWEdScEYvRjhVd2x1RlV4cysyRFAzV05Pb1M5?=
 =?utf-8?B?SG9lamxVOXA0OUtPSFAwN1d4c0xMdno2aWJ5eHdxMjlmQzNVamM2QnVNbzBT?=
 =?utf-8?B?czR1Rm4yelpsbTdCUlpVQ3NjR054aE5oWkdVNmppRldrWnRLYWZocUw1Yk8x?=
 =?utf-8?B?UjJuUklKbUEyRU81MGViU1F3M01VMkVxaExjd3gvV05VZ1AwMkJXQVZMQ2xQ?=
 =?utf-8?B?RFpLUE1FWUs5KzA0MFFLSFBVWnR2M2hUSnBzb2ZSUjRFNlk5UlFqSGpCMnIy?=
 =?utf-8?B?djdoZE9uaks0bHpXcE5teU5NVU14RUF1K1U2S25nekQwZE5vb0dEZFdxcG9Q?=
 =?utf-8?B?TnhFRlR4bm9UMW5LRHJFRmJJQkozRHdIdTdGbllXRUNDcjdTL1E4SWJLemNn?=
 =?utf-8?B?WDQ0Z3lSa2I4ZGJwQURGYUZJWXBUcHIxamJ0Zm9WNEcrcnk2RngrK2xTUHRj?=
 =?utf-8?B?cXNTZzFnREF1U1pITVdHSk4vRktaRWExS21PbEZ4a0JsOVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261af29f-d4da-4ac5-9094-08dacbddeb38
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:32:02.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hUO7l74rGi6D6eNL1/Yc0rO0Xqs09YJTMWZ8WzPUKVjmmvNcEcAr3u1p6LMLtkFBWpN4ck0SyCg4aO1ENRwBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210127
X-Proofpoint-GUID: 9xvU4R91r98NOD7CM6WY31BAsd4NDCnI
X-Proofpoint-ORIG-GUID: 9xvU4R91r98NOD7CM6WY31BAsd4NDCnI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/11/2022 14:13, Maxim Levitsky wrote:
> While not obivous, kvm_vcpu_reset() leaves the nested mode by clearing
> 'vcpu->arch.hflags' but it does so without all the required housekeeping.
> 
> On SVM,	it is possible to have a vCPU reset while in guest mode because
> unlike VMX, on SVM, INIT's are not latched in SVM non root mode and in
> addition to that L1 doesn't have to intercept triple fault, which should
> also trigger L1's reset if happens in L2 while L1 didn't intercept it.
> 
> If one of the above conditions happen, KVM will	continue to use vmcb02
> while not having in the guest mode.

"having" is the wrong word here - maybe "not having in the" -> "not 
being in" ?

> 
> Later the IA32_EFER will be cleared which will lead to freeing of the
> nested guest state which will (correctly) free the vmcb02, but since
> KVM still uses it (incorrectly) this will lead to a use after free
> and kernel crash.
> 
> This issue is assigned CVE-2022-3344
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/x86.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 316ab1d5317f92..3fd900504e683b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11694,8 +11694,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	WARN_ON_ONCE(!init_event &&
>   		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
>   
> +	/*
> +	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
> +	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
> +	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
> +	 * bits), i.e. virtualization is disabled.
> +	 */
> +	if (is_guest_mode(vcpu))
> +		kvm_leave_nested(vcpu);
> +
>   	kvm_lapic_reset(vcpu, init_event);
>   
> +	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
>   	vcpu->arch.hflags = 0;
>   
>   	vcpu->arch.smi_pending = 0;

