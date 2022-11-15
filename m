Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343E2628F4B
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 02:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiKOBbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 20:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiKOBbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 20:31:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982E8616C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 17:30:55 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AELEaJX003977;
        Tue, 15 Nov 2022 01:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=nOqWF+08RYyX+C5I1eryYI3URKwp92+CBDgK6Hwn4LM=;
 b=HTzfT/EG58HzqtvFsxDQfht+Q6SrNfjBiExocB/55eiSTt3ysqL3WNyEvFukGvoh23fT
 L2FW04hqWSSzOZ0UDVkimXFFF7DoMnhhe70T+iPEl1hWAuT1YgCFSc0Q4mVtryTMgMWM
 tGRgBe2quzNPmXqH2ozB48wjdpjjIULamVQINsaWdLVZcgK2Gzc+X5JwGz4XdH5r1PLk
 JT4/oUqZn5I2AGuw8CmcKKrPPnrlFt2hnHhRT0i/H5gdfvYZGSRxF6lcN4s/KgBnzMpX
 4d2LJtMvb3KfrAx5/bzvEdkVRhRg6qY2oLTSajWo8zateMuTi5Rgn+HHwf9qe9Nqll7A Cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2f94b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 01:30:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AF12J18031792;
        Tue, 15 Nov 2022 01:30:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xb1n64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 01:30:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STUy0uTaKRZno8oIrsADvbOuU7yUSpx6BRHij6OcHo94yWkCN10uRnYPw4dCtPj/IbaA0e03CXzgrKbquKlo8CbGGX2RQg9K2HlSyV1FKa5KhVMfP9L1Hss/w1ofUSPeOsls/FXc+9Ue2kqy/9xMDAiTEQHLyWDFaXsvX5VG3E7bz6oo1dgar3VrnhMadDYqzIi/vog7CPVg/zq8GWUanEc+6RlwqpCoI4ZxbOU60eTcCh533A8vZsihgrJVcFC+HvlrOQ2LndkyWVp1yoODsjjjMuuU9/c/PsOZeVJybN88yoR/6Jwidyw4zdBwNewKXQpE4hbpWLqzQjsFKksdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOqWF+08RYyX+C5I1eryYI3URKwp92+CBDgK6Hwn4LM=;
 b=TBjBwGsT+34OB3OtTohVn7J2bSiI4en/7owyJkHqqePcMVkOIwf6kWhjNEPa3aJY9N0jd/xPwVBoagEquHN8BSj/d6p4Zx2/yn5tJx9QxBSnjwn8jLVD68eaBz53EIddRm74TadRHRZTMWf3bu1RyXViNAT1f9Qd4UOAufOFwa/ElTR1LgNyei98pgWhKkUO947G2NyCedLRuehwvZX4+1jLhIa3I4ho67pi1u5xwaQycF7CS5ebCk4YW0VeV7dGDdgKNx/s4bJug3VRh0wX4q3KO6X7YZw5jcx7ndIFLGPqLKvaZxSQWdU7U42q90DKsikO90MjFvlrdpSZ5xp+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOqWF+08RYyX+C5I1eryYI3URKwp92+CBDgK6Hwn4LM=;
 b=M0RwoCCwHs4FlIm7wn88URbpazgA/hOfsuvAyTymHsDFn4d/OoKzLOGtNkghrNrTf8pVycNjb1zeU92FC6WN+jHpIAcHHHJHYy5jZQc380wo26XlhJQHoL5BHumK9KtWlpWGbFQQRoEIeB1LOgn7VKw5nvMtHhPmGP7UkMcVjnQ=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH0PR10MB5356.namprd10.prod.outlook.com (2603:10b6:610:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 01:30:32 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 01:30:32 +0000
Date:   Mon, 14 Nov 2022 17:30:29 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+j44CA55u05LmfKQ==?= 
        <naoya.horiguchi@nec.com>
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y3LrtTmLdBU7atso@monkey>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
X-ClientProxiedBy: MW3PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:303:2a::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH0PR10MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c929cd1-e353-404f-df7e-08dac6a8fca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uyt9LQl5+LcbQJem3j22v290vy5GUbZWlUQHQERfLYUFVL9bJrvjDI07XJHQ64FtrcU4tzXUE+6w075/j+Ssri2xW0kk3j46v8ieKbDbaail2acAWiMe1uO4zFzD6YVW4y+yWmGqW1i7En764xUjLLviBqG1xIx2K5hHUJQxJvGU982v2O17wLXd/y5oqMsSwrjEGzkJmZyWkMtHCtF7/f4wZeQk0VAYYVIZjzCErIR7s+BnZLX2B+Z1lUUgGv/2TMM6zEXy2sUm/vPMUnOHYj88R6F1ByQYcPe+LpKPgAgBPw3C7KClzbBd56wOp781z/5QAQEmik2zHgDLLX6M3G8Sq3Ll6NVBgtaf/Y5z9AFzq2uitGM4K2EYTg0/BUrGheFW9k+2FaXOo24PogXugQc2vVb52EIdip5djlDY9Lt7RfjJGsEK4au40ZU987QmQR7FRLKx2ofYVUkyJ9Ucb4JIC9HTcmmI6CwYD3ErbdXQBa73LQq5YNjq8yalbt0C6dt7gXAqdZ3g/PE+RbQIoSFDD8ssYRaDj8AmS4cuFA8VriBLtIr6PS6Ktd82DHXFQvigIjuzKkdiBvPMbagGmJgBJ1kRs5DsivFSQlJforQl9uNUE2cM0qw46tTMByrqI0wu+vmqCTW+l7MmWBHUTRDOVajNgqTwamU5faHSfSbyNtODj7SBfD2vID7hlWzg6ju5ULlaBCNz5d5mLsgY9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199015)(53546011)(316002)(4326008)(54906003)(8936002)(44832011)(6916009)(6506007)(41300700001)(5660300002)(26005)(83380400001)(186003)(2906002)(66946007)(33716001)(6512007)(66476007)(66556008)(8676002)(9686003)(86362001)(6486002)(478600001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmdVSU50WGhyM1QzMDNQYmJOdzZCWkNyNXVHRDZmQzhvdkZZOFRTOG43OWV2?=
 =?utf-8?B?UFNMcE9xUGJzZTZqaVgrWjJyMjM3d3VZQkZtTVBvVnlaeXk3ZHBQSE5ZWnRt?=
 =?utf-8?B?NEdBV2tJL2dTL3R1d1UweithWW5ZaHZ3RVlpdVF0RStzRG9HNTVzdmhrNjlD?=
 =?utf-8?B?SWg4QnNLMXRIS2xvaDl0Nm1GeEZTT29SVm1qUjU5d1grZStlcFk0eGZSYW9J?=
 =?utf-8?B?MUJEdExZQTc1aGdKMGV5dGJYcmE2bFNMeFBJRVRiT3A0YzlnTWZrSmY0eTli?=
 =?utf-8?B?cDZ6VW5WSkhNcDJGVkFndWQzZjl0cTNoQ3dVVm5RNHJ2OGV6OXpXR2x5VkFD?=
 =?utf-8?B?cnFzRC9yaXdZQUZWZVhEeDR1RXJKcFFJNDdZUFk3OXVKSVNBRitWeDBmUUJ4?=
 =?utf-8?B?YS9zNVlVa3J5czBoRHZRWWIwUGhuTlIvNTMvTEVGVXZCVFNNQVJsQThTVGhq?=
 =?utf-8?B?VWNWSkZPVmh4dzZnUDNIMGIyQ3J3QmlRY1RTbWpkRkkzRktDMllYNGkvWEI3?=
 =?utf-8?B?OWZyRG5BS240a0RQLys2d1R1WVRyWlVtQnM4eCtXZnRPOTlXQ3BhRnUrejFn?=
 =?utf-8?B?R0dJb2gyeTZEZkxjRDhaZHNPb0ZGS3VoeldoWFFDcDRkMlgyNDdHYXcrRkgz?=
 =?utf-8?B?SDVHWnlaOHRWY0FJY2lXWlJWM0ZNSGRzZFhTTk4vNHNnN3ZUc09QVHI4VGVu?=
 =?utf-8?B?NTZXMDEvcXZYZ28vODNxcG96ZEJtbnBRZjd0V05SZnBkMU9VWlhla0p1MlFS?=
 =?utf-8?B?Q016SDU0bGtuMjRzNFZZNGpOUVE0Q0IvWU5GeFFCcFNTMmY2WGxkRk5NR0JQ?=
 =?utf-8?B?YXc2TnJRT0M1UW5pV1JHSSt2MEZxeG5zeFZjem5OQ3hEc05QbGwzby82cDhD?=
 =?utf-8?B?TVllalRCTWtzbWxsTE50Z05DTGtRcnVSRE1GSVVlN2plMmU4T0lHSCs3Y1Y4?=
 =?utf-8?B?U092R2FYYzhTN1h3Y1BWb05WZS9QMW0wc2JRMnUrNmtSakM0d1kwMGFiN3B0?=
 =?utf-8?B?ckZGNW5mbFpxK2Q0WS9BUXpXTk9EZ3hSdXlWa3YwZEE2SHRNdXMvK1FTY0Rx?=
 =?utf-8?B?YjUxeXh4c252MXVzT2I2Um9hc1FTbXQybHpWV0FWUk9udnJWeExzRGF1OWtz?=
 =?utf-8?B?QmRBOFVBMUhHTGRxRVBYaTVXazBqdzNmWU9HOFM3VmtjclRXNlFjVVBob2Za?=
 =?utf-8?B?NHN1aGN5UXI2V0VnSUNJMFMyVnBwYWwvRFlMbDlDSUVhOHdxcFVRNkZ5V1Bn?=
 =?utf-8?B?SzJKM0J1Z2xmREZoaEx6WE5RYmJZNFgyT2RVNUMwcExOblhDaURzN0g2MDZp?=
 =?utf-8?B?RTZXR2szT3cxVzB5YTNYL1RoUzY2SnFyTXN4bm9CbDlaaEJvN1ZmOU5VdTJX?=
 =?utf-8?B?ZGZTczk0Ny9RQjB4bkZNNFROLytld2VjTUlJM0NiODBLZlF4SzFwS1F2eTho?=
 =?utf-8?B?L0dOcWc2QXNXbHBlazN4NExoZkVTMXo3MzNJUDl2U3pqczkzQ3RpTTk1UHQv?=
 =?utf-8?B?OVBBTFg2S08vdXl1L2p6bjJ4bk90OE10VFg4YzlGU1F1b2dDODlOMXJyT21C?=
 =?utf-8?B?WmRwN3JkNjBEcVhvZGw4Yi9wWnRQVnBIcURGM2xhTnJEMDVFeFlVNmdMeW1l?=
 =?utf-8?B?dGRVc1Y0bEhaVFJyV1RCMXhvYlhWRXBweUpRL0tETHVlY1RCQy9EVUh3QnpB?=
 =?utf-8?B?YzdaS1YxNzA5YUt2cFRDOCtnS00rZWpHcmxHa0NpTmxWdjFDc2kwVDFyZ2g2?=
 =?utf-8?B?ZkxGdWhXUEovQnRxMTNpMFloWi9lcUZBdC9VVXNDTHgramZEeXZvNHdKVDQ4?=
 =?utf-8?B?VHdxRE9wcHhFb3lXWHMzRlkyc1FGZ1ovYUFudk9pSzc2SS9aVVNiNHRPc1Bu?=
 =?utf-8?B?cmhVcHlOMm5BckdHa0JpTlVMUTUwWHhCd0kxK0k3NVJGVHFFTml0cmNlSjhS?=
 =?utf-8?B?SmJZWTRJNGU5Z2ZXN1BuS0lTSis1bDJDZ2VVSUx0WHhJL1FUdnlLdWJXcUZS?=
 =?utf-8?B?TEU0ZEJHU0UycmQ0NzJyRDE5c25XZHhhVnhpQW0wZjFieGpaK1RuL2xXcXUx?=
 =?utf-8?B?MUtaKzNvSHRqR2tzREZERlBESERwK3BLTlJaSGdiaWt0RDNpOE40ei9CZVVW?=
 =?utf-8?B?cEQyWXNocG1TQkpCVGFPeFNKVHNVa0p1N0I2ZGw1dXZrbmxOZTZHVmo4UGln?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OXdKWnpGTWdZK3F4b2o4VU9HNnAzWC91R2RvalF5YjF1UXN0cWp1dEExd0hi?=
 =?utf-8?B?WkJXMzV1Tkh2RVU3VERrejBpWHNMbzl3cWJLYzh3TWVKZjBQamNaUmY3Ukhp?=
 =?utf-8?B?ZzhlWWpwOE1BVDJaUlhIdDdFSDVZMWhneVE1VmZGY0VzTTVjcFQvUW1LNjNo?=
 =?utf-8?B?SktBT1NtL0tvMWEyRC95TzlETjNXMUFTNzlpaW1aMEtDNXVVV2Z4MkNWVHc3?=
 =?utf-8?B?MWppWnVMVklMdE1JTGhqZGdHUUxHbCtncVVtc1VDMUw0ZWpTZXYzYkV2YmxZ?=
 =?utf-8?B?RCtUUFpWeUM1UWljNHhVQmdvZ2dFNnZJMTMxbFYxWDdVMUlSa3oySGdlZ1Bw?=
 =?utf-8?B?OWxwN3VtbXNYMnRONk1rUFNmenp2TmF0MlB0ZFByZEV0QWdXZG5TNW5NRmVq?=
 =?utf-8?B?Mm1DcXluMDBqd1VsRFNHN21WUnUwVEVsakxpd3ZDdVl4ejNwWGZGNDRCakRW?=
 =?utf-8?B?YWZaTk9FcjJLWVV2Y0NuZW83ektucEdsNkJTZE5rYUYyY29YN0hkaThMSC82?=
 =?utf-8?B?WDhYNVhSQ2ppdlUvOTZFbGpscGRuL1JraXFlRXdsZUdhQWMvMGNqNms5UHA3?=
 =?utf-8?B?SVFmTDVqeExKWHdYbkpIendIQ1ptQ1lhVTFwd3hEajZXL1pDOGg2Q1p3UWZO?=
 =?utf-8?B?bENPUFlFWlM2MGh1VVRsajRrcDBFZW5uVmxNR29hL3ptWEF6MitFNlVrWEdP?=
 =?utf-8?B?ZmJTVGlERDNjSTAxVFZkc3VZbjExV0dnNmtXTmtaclBWNTdDdkNmbzU2WnR1?=
 =?utf-8?B?bmZIK2l0RVplOVhpWXRMcldpUm5USFFpb2t0Q0VGT1c1RHl1L0hOeVZWczg3?=
 =?utf-8?B?Z0VpQzF3SklTZkxId1dmSkZTNjJDSmxlS1BxM3hTeXhHWmNvTmsyYjBKYUpG?=
 =?utf-8?B?MUtHZE45cU5GdkQrUFY2ZGtqMllxYXVGRzdKaDBJbnBYaGlQRm04MkZLM21h?=
 =?utf-8?B?TjhGbkRJcnBiWVNSMDN6NjBha0tTUUYyK2U2ZytrM2FQeEgzaFdubXRXbnFl?=
 =?utf-8?B?QjNJMmNPdGFVVFFVME82NGlPWklqcURJWElIcElFbkltSW5iTE1BZWdPSFN3?=
 =?utf-8?B?RlJzblkyalpzaDhPaXVXeG1CcVp1cjdkcmpXV0NBMkVxdzRYa3loYndhNWYv?=
 =?utf-8?B?ZjhIVUhTMnJFODNPMi90TmVCWE9vMTZUMi95bktVMjRid3JTRHRGczY2RXov?=
 =?utf-8?B?WXBKd1RQT0IxcHJaWEgyck1NZWNqSFN0dUFGNEYxWW1ESkZXS0tyczJLd0xv?=
 =?utf-8?B?dGVGbktFUzVTd0VNdmM4TFZKVzdqQ2k5UlUxU3hLTWVQZDBrU2xqWjRrQzhY?=
 =?utf-8?B?WG9FdEduSW1iaDZKdFkxTUh3YWwxajB5ZCtwMGl6akRaQ2tvSEljRkk1SlBE?=
 =?utf-8?Q?7nFbOx8ujtLZ4xdf57d+R+5yv2LYFQ48=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c929cd1-e353-404f-df7e-08dac6a8fca8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:30:32.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxRiKZdEUMs5j6XuwoXSjBSZhbVyCtJyim3eQaWi8nYWvZlEIQjm347GNTeZ7P7/UUlEzz7+HVnn8gjAIp0v1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=892 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150008
X-Proofpoint-ORIG-GUID: RN_6K-KnHvpFRUszmOXe8EPivfxwe47y
X-Proofpoint-GUID: RN_6K-KnHvpFRUszmOXe8EPivfxwe47y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > Hi,
> > > > > 
> > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > 
> > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > 
> > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > but that's revisited recently.
> > > > 
> > > > And have you tested that these all apply properly (and in which order?)
> > > 
> > > Yes, I've checked that these cleanly apply (without any change) on
> > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > then a76054).
> > > 
> > > > and work correctly?
> > > 
> > > Yes, I ran related testcases in my test suite, and their status changed
> > > FAIL to PASS with these patches.
> > 
> > Hi Naoya,
> > 
> > Just curious if you have plans to do backports for earlier releases?
> 
> I didn't have a clear plan.  I just thought that we should backport to
> earlier kernels if someone want and the patches are applicable easily
> enough and well-tested.
> 
> > 
> > If not, I can start that effort.  We have seen data loss/corruption because of
> > this on a 4.14 based release.   So, I would go at least that far back.
> 
> Thank you for raising hand, that's really helpful.
> 
> Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> pagecbache") should be considered to backport together, because it's
> the similar issue and reported (a while ago) to fail to backport.

Since dd0f230a0a80 was marked for backports, Greg's automation flags it as
FAILED due to conflicts in earlier releases.  I am not sure if James has
a plan to do backports for dd0f230a0a80.  Again, this is also something I
would help with due to real customer issues.
-- 
Mike Kravetz

> dd0f230a0a80 does not apply cleanly on top of 5.15.78 + the above 3 patches.
> So I need check more and will update my current proposal for 5.15.y.
> 
> Thanks,
> Naoya Horiguchi
