Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE92631DDB
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 11:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKUKLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 05:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiKUKL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 05:11:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242CC10FC9;
        Mon, 21 Nov 2022 02:11:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL9Sb8t018331;
        Mon, 21 Nov 2022 10:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ej9KsU1cNgTCgVer3pL388Yxc7BAliEM7HdaQS1QRjs=;
 b=HcI3frEy2KrMxROHxscDgqNJKhRywInTHbRQjWQbswwN7HZqhh5YihMlH6EG8YoHg3Fo
 iIQXuuGXuZAR3QjV8LgZjAALMHhOpVoSBmjtrlQeVuLKCabYsQqSKgMHsBWh3G7mcUgO
 zBttUcEVG/dcx3PWUwTDqViVQ4hg5lZzjpNHKZQSdh77eogsY8zM1/Q2GH5UYrWMhh7p
 /5VcH3OGHt+805HERlpsbe4s3SgAu1wWRkXriYgPFDCg4h8CNaqrRm0pHkKWmtxbkeQ3
 lD8HsuIol9WSN7lhgS3FTI1lNIfMgJerO5fM6Mdw80XsY6vqbzoUGdsUmHOtKP1NScII tA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxujubdt5-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 10:11:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AL87BOn016869;
        Mon, 21 Nov 2022 09:55:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk9rpg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 09:55:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lN2vt+X9yeXc3i9l5l7blRCjS21F4oSBdePa2exsZkFGU170UnuTAs6+bNOn309traashOwf4uUNaHiawyMEPuV2JukLuNfYiodk5w3a1+iBOkXkD0vjZoQyGM2qiV5XEphKsqfVTN7ylrkCD7oYUp3gliLh1vIdSNPJfJjQytF48tIgAE7Fn+Bkcgf/I12JugFZfou1W0NCDjH0wdieDDuaAS/QnYBDUtYYetf0/yji/TDWiXLvpNuoyP0UWSZfYuYj/pKKOnctmBGu4vXCXsOqmMTbTyn+Mjaq8pd3EnfhN/dEObW5jr812KkAgHrsWjIIfQxnhtgM/p2JS9vAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ej9KsU1cNgTCgVer3pL388Yxc7BAliEM7HdaQS1QRjs=;
 b=hZtROehv1bCOXjAfi0y+h0fHcbEYsnagFEWcmbE7MAejvoWfklfwCqdLawXSbF3bOQyAcApDzynyHrzjvUMqltscLDAR+n9mcp1pug8R3RLh7f8p1D4eAXQjr0pI7g+gJFOFPpwH+npJb9e9tVyhvqylWKSzboc3N4Zgj/M2FyhOUC4Psr1GiTrob8HVxUGNYJO02jafgY3yUPs13AEuREDJWMtpKiTpjCtojTIAnzu0XAvfeyxL/Le49WG7LDStsn7WWYuw0EroW21hqmuU20emryG5cKoJ82VqMeRQzsgCUJa+oR8TmPCcEKKhUnofllQsSj1AUQGU0OR/KfzOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej9KsU1cNgTCgVer3pL388Yxc7BAliEM7HdaQS1QRjs=;
 b=t470xn51rNPR6sxnBFv0PbhIHctLj4Px/K6x3zIub3AKmcMIneYmpNc9GLjXkR7Q6q2eEflZcRWCf6OsSTMgoPuz+6W/8VSJA5Y6KY2nenpsxP6pirOFZl7VVxQ5GPNZO3o1ETAbRUlfF0SmnsrtfA6STzqD3IPyfo903ntjk4I=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BN0PR10MB5014.namprd10.prod.outlook.com (2603:10b6:408:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 09:55:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:55:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2] xfs: redesign the reflink remap loop to fix blkres depletion crash
Date:   Mon, 21 Nov 2022 15:25:06 +0530
Message-Id: <20221121095506.1190043-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-4-chandan.babu@oracle.com>
References: <20221111041025.87704-4-chandan.babu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BN0PR10MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c9dad9-88d3-492a-5346-08dacba67bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dh5mMrABc4uipkwPqk3bHGhsn4Hwgcp+eeWTErF9t4NYvxSy+tlAoOxMwgZ+9PQYh59sp0eeJeylEGfHWndRi+xSFRtb+H4J02MUjy7G4UPK4niPpnDtcqkPHecHcsFExKJz5/SXJVN2ZhNTY1M/67g8unzaAphlvcJ5f8dWRCqJ2EKFP2Y6Kzws8/JcGSyLH4n53hoBy+rOhF2/KBOi/3T0nozPiNTEDDL5dCbbIYYCyuItW3Qc+MPEXe9oJIxMW+seJiHgPXLYwmHBS5rbSl1qI+qOw9eWIgNEf6WEUjQl6T60THDZfWSKquOqdputAKNLsBAIMHNUExSTD7EIGTLrWlxJcfwmLQIl8rB9o6P57CjQ7wZehiL/Jt3iixwf99f+NtE30pa23KYtuUt/lw78xNEe+M7IQNzU3VxAzQIIlGU+gblQU5CoB4dmPqpB65W/YF+3VBpdwSaZoo26v/B7sYvKYiQqs0tPvUeWmDasdQYGt3t5bgU3JdJ8Ts3FFL0UbdzW9FE0QEDbE5Pllv4FGuD8X7S0dpqbvNHSleFB85GCh9Bs5vRmbm82rNd/Zuu7BJN0lqQhyJ5onWiomB44NmNl5OX5M73XEJfawtKZnirKokjeDrh/gyx2/fwzEUAKnPlVvzC+Ng+5dpYwLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199015)(83380400001)(66899015)(30864003)(8936002)(86362001)(36756003)(2616005)(1076003)(66574015)(186003)(38100700002)(6512007)(316002)(6506007)(26005)(6666004)(2906002)(66556008)(66476007)(41300700001)(4326008)(66946007)(8676002)(6916009)(5660300002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2xrczBlSUVMZFp5UUZpalZKek0rS3RqeEh1eW00ZUN1RW44aGxnWGFxK3Ix?=
 =?utf-8?B?WkZnZGtqaEhYSjZ5Y3ZvUmF1a3M3UU81WDg0R0dETkdJOXBJbERXMUhNUWI3?=
 =?utf-8?B?Yk1MbGUwbk1pZlpiaFlWMU9qU0pMUUt6YnRXWitxeDJ0UzlaWmhJVldXOXJ3?=
 =?utf-8?B?aTFQN3E4eW1LcVorS2dKVGpWOWVnL2xMZlN4N3ZyT2xiZHdnb0RqZE5kQ3l2?=
 =?utf-8?B?MGRnN21PNEFVTkhFS29Ib1BBemRXUFlZakpVYTlubDRoU2oyT2w0ZjRFcUZs?=
 =?utf-8?B?N2F1eVozVW02Mkt4SlN0djBYM2l3VFdkVUpKdGFpb1NBYlBtcE00TEIzSXc1?=
 =?utf-8?B?ZGYxWWg4MzBwa0FqbFJUK3RuQUFuT0k1VTh6dE1EOWNyYVVIcGxJcTFlWGNp?=
 =?utf-8?B?QW1wZm5BSzVwTWpEOVcyV0JLRzZTOUNTRkpzY1hIbDdLejN0MkhtRkRXUk5q?=
 =?utf-8?B?NmZHVk1zTmRwbld1cDRYR0MyNjRIMzVPV2xDNGE1NkpZUTBaWEJRQlAvYkI2?=
 =?utf-8?B?NTNWbFQxajNsUldCMGxUV2xtVWVUNG1pYXNzOG5UYVArNlNBTFRuZ2tIcnU1?=
 =?utf-8?B?bi91aUFvSVl3ZTJ1U0ltcjBGNXh1WDl0cHFmcDBrR1lrdVJZY2xEN2JQYldy?=
 =?utf-8?B?WW1JY2hHUzRyWUJzbWJjTUpNNHNNam8rZm5ISDEzVXRjQyt5MWdnc0ZxOHI4?=
 =?utf-8?B?b05neGU1WE5OV0FaV3JwUVlzN2tmYm41Q0hEMkJxVHo4dEo4UmdLMFYrR041?=
 =?utf-8?B?REo2MXZvYnNFYVdFbVJmY0J5eTljdC9FQWg0OGdISUx5VG9mRWw1cEZBYU9h?=
 =?utf-8?B?alVNcllpS1BMZFFiOXRzQ0hpYXZkY3g3Yys1ZHlORVN0KzdyazMxNWdKRG93?=
 =?utf-8?B?QmJPeXJoQXBmdFFUSG9FM2czRzVrQ3Z0azBPbWJabUdSRlp4WDNVYTg2cHl3?=
 =?utf-8?B?Smw4YkFVS0s5a2RaRWtlb21odUdoeHF5aTVwWTlzUENQUEo3YjN2L0doRjJi?=
 =?utf-8?B?dGV2MmM3SHc1dE8raWJwTEprWnRUKzljazlOS1BtL0YrVFEyTmQxbTBiVVdN?=
 =?utf-8?B?Skl5Z2JqZU4ydGs4djU3d24vdnV0dlU0SFhCWlI0Q3ZZaVdHZGlJT0dwQmRu?=
 =?utf-8?B?cEsrcHBVbHpsbW9lREE5bzJXdXBpbzZnV1ZrbHBPVnNWLzFhekFYQ0JYNEl2?=
 =?utf-8?B?bTlDUUlSWUM4ZXdhS0V2K21JNHBtSXBWYmdHVEhSaVRZY2RXWW1mQWtXYU9y?=
 =?utf-8?B?cjZBclpBMStqeG9OZFIxekFCWEZxSzdkOWlKRXdMeGYyWjJGLytMSTZ1aUUv?=
 =?utf-8?B?M0FsMnRwS2xPT01VSndHNU80N2FhZVJnRVBmTkNjaHFWWlluZzZVdC9XVkdu?=
 =?utf-8?B?SlF6ZEhIMHNmYnJZanZCdEVTL0lRcjlxZ25aT1BaU3Y0NDdRMnRpeDkrSGUw?=
 =?utf-8?B?YkhXZVp0NUlrR2FUTkZUNTJCMUFLZVVGSEN1aVhUVkdXS04wMzJhL1ZlSUY0?=
 =?utf-8?B?ZklyZDAyM2RjQllKUjdDczFFL0ZOWEVpSjJ6SW9RbDJIOHd3Y0tHS3RYQk5w?=
 =?utf-8?B?YXp0dlZreTArK1pVVUF3WVZpbUw4UXVDSDZKd3JwdU1lWFhQaFVPbDJ6bWpG?=
 =?utf-8?B?MVQza1FhZytQRHZtM3dnbnhLWDJ6YkQ2Y2l3aVhnWlVPZ0wvT2ZseE9Jamdn?=
 =?utf-8?B?YWlpaGVXRzhDay9xd2c3NHcva1ZFcWdGYnVnNHJRUEVTVlNPZmZBMllDQ3Qy?=
 =?utf-8?B?c29QbTEzaHNLMnJEUWVzc2tJU0xsUkdCOEplS0QrVG4vN1d0clgrYlFWeisz?=
 =?utf-8?B?VmhaNEZUU202UHJyOXAwL1RtR0ZmNmsyc09NZUZHdkd5dm9ySTVVdEFuTC9o?=
 =?utf-8?B?R1pFV1d6TDFFWlhjQUN6RkdjY2t4NnM4b0o0Z2U1SVpERTBVOFZZTERoQjFm?=
 =?utf-8?B?dmkrY2x1WEw2ZUR4aDNuZk9jZUNVdlVVaDBiOEZzVzEvaS85UmUyU2pudjJn?=
 =?utf-8?B?ZU1nRExiSm85KzFVVis4MUhrZmFxT2RSaGVFbUZBY1VZZ0hLaW8wbDR5YUhT?=
 =?utf-8?B?dzhId05SckkrRDdDZlZEcElWYjAwRFJWbXFiME8wQVEwakFoR044a3F3VWYr?=
 =?utf-8?Q?eFyfTuygFj/foQZyE1/rI7mbj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?U2VuMlg5UXJ4a0dWZllIU2ZNR2xmcWJSbFMzRXhaOGdOMmY3cmFXWmRkazcz?=
 =?utf-8?B?bFc1MTk4Z1RpSnBwSWVKYzRsV01jSXNZNkYvVFoxQlBwSmVGUXBpc2xHMVBU?=
 =?utf-8?B?TWRPcllUejV3VmlEMlFrQytnOGdxNURrMlBmTmdKMU5VNnBPUG5hTjRwMkZw?=
 =?utf-8?B?S3k4UkI5NEVLam1OY1g0OUZhaUNxbFQ5WS9KV2ZQb05zakNYMGltSlY3cXk3?=
 =?utf-8?B?ZmU1UWhnZlpMRWFwU29qQzVadWRJRXYwKzYyaUdWRU9uUlplZVBiTXRxOVBL?=
 =?utf-8?B?L2R5ckNNNEtWeFE0YVRnV3RMUzlxSllBYXM3SHZZb29QS2J4anJEcU5DVTZk?=
 =?utf-8?B?Rm1tSUs1alBwcUZZM0dWZys1a0JHZlp0bEJaQ0cvaVExM0MrK3dNTGFaeGFt?=
 =?utf-8?B?b25Ob2NvUDlhQitST3hDUkhpVnNybzVwN3pnajE3N09VSUxUOXNjbEdxNkF1?=
 =?utf-8?B?Z2gwVnM1bVdNbjlRS2JMaEhMT08rbElsUG1zdmJic0lsMkpleml0cUpjN2xO?=
 =?utf-8?B?QlFZdm9lU2J0NUV4UUNSbDR1TzJXR0NKUmczUUllUkZSL2gvcnFBTFFlTTlj?=
 =?utf-8?B?aWtzMk5IWklrRUpTa2pHQ2xLcVNvdE0rNGhQSnNVVFF0cEE2OEtwdm4vSWoz?=
 =?utf-8?B?ajVHd1NxVG5Ld2RHeWkwNDlyY2d1QXhWaForVjFwaU1vUmlYR3RkNlY1M3Rm?=
 =?utf-8?B?djRXS3NmS0RteW9FbFJnMG9nejlFNU1RY1l6eVg4T01hWnhPVFBiN0R5dWlH?=
 =?utf-8?B?ODhMMnd5Y0VGRm9kcmhiZ1ZDVmhOblhrYXYvaDM0b2p3NUpCZldqeWxHS1JR?=
 =?utf-8?B?VVhRcHNjTmNzWnNTVy9tSk5vRFBicWpRSzBSdnNFK3VBMFJIWXRpb0ZhNVRG?=
 =?utf-8?B?bk14U0s1VXZEY0RaUTk5OTd5eTloS3hZa2VGaTlwMlBMS2dIMG1FdkVxUkdr?=
 =?utf-8?B?aGsrTDkybEtMZkZweUNLZU84VlY3WjByVm9Zd3NubUJuQytPMmk1SGpkNHhX?=
 =?utf-8?B?bTd1QjNUQzRYZm9XNmJHelgxYldYSmlNbDFJRUFQWmJRaGlSd1dqblB2ZVdp?=
 =?utf-8?B?ZUV5c1VpMlFNVGNRVUUzQ2hwWlNmUHVKUTFHTU0ybkdHK1VLbXVjQ3ZOMGFo?=
 =?utf-8?B?OGdOdHQycnlTR3ZLdHUvRmpSMjlPTXlpU05xNHE2WXRWWHJoNnFBY2djcjlm?=
 =?utf-8?B?aXkzQlozMHpTZHVsbU9YL3lmc2FpUHRlaTVrVGN4bnNReDJNNXJVeTNlcVlR?=
 =?utf-8?B?NTlsdFp1QnBCMTdHa0tWMjlVVjdGeFlmTXp2bU4yem1hM1dnS1BUeC9ZN01i?=
 =?utf-8?Q?EqR1Xwh3ZjpUIsVAFu0oOOduYnJBWuJWNo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c9dad9-88d3-492a-5346-08dacba67bb9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 09:55:14.1952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/dtzrliiaS8BySVNiMCB+fdy5/hzVUyYK39b+aqbKVH3dP4ph56VD1JBnxM+guekKPmWy5RCCquVbEqqWjC4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210078
X-Proofpoint-GUID: bYQqws1q_I6mzYmnkmVutNkp_iQGGajM
X-Proofpoint-ORIG-GUID: bYQqws1q_I6mzYmnkmVutNkp_iQGGajM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 00fd1d56dd08a8ceaa9e4ee1a41fefd9f6c6bc7d upstream.

The existing reflink remapping loop has some structural problems that
need addressing:

The biggest problem is that we create one transaction for each extent in
the source file without accounting for the number of mappings there are
for the same range in the destination file.  In other words, we don't
know the number of remap operations that will be necessary and we
therefore cannot guess the block reservation required.  On highly
fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
run out of block reservation, and fail.

The second problem is that we don't actually use the bmap intents to
their full potential -- instead of calling bunmapi directly and having
to deal with its backwards operation, we could call the deferred ops
xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
makes the frontend loop much simpler.

Solve all of these problems by refactoring the remapping loops so that
we only perform one remapping operation per transaction, and each
operation only tries to remap a single extent from source to dest.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reported-by: Edwin Török <edwin@etorok.net>
Tested-by: Edwin Török <edwin@etorok.net>
[backported to 5.4.y - Tested-by above does not refer to the backport]
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
Changelog:
V1 -> V2:
   1. Add a note in the commit message to indicate that the Tested-by
      tag from the original commit is not applicable to the backport.

 fs/xfs/libxfs/xfs_bmap.h |  13 ++-
 fs/xfs/xfs_reflink.c     | 238 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |  52 +--------
 3 files changed, 141 insertions(+), 162 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b5363c6c88af..a51c2b13a51a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
 	{ BMAP_ATTRFORK,	"ATTR" }, \
 	{ BMAP_COWFORK,		"COW" }
 
+/* Return true if the extent is an allocated extent, written or not. */
+static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+{
+	return irec->br_startblock != HOLESTARTBLOCK &&
+		irec->br_startblock != DELAYSTARTBLOCK &&
+		!isnullstartblock(irec->br_startblock);
+}
 
 /*
  * Return true if the extent is a real, allocated extent, or false if it is  a
@@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  */
 static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
-	return irec->br_state != XFS_EXT_UNWRITTEN &&
-		irec->br_startblock != HOLESTARTBLOCK &&
-		irec->br_startblock != DELAYSTARTBLOCK &&
-		!isnullstartblock(irec->br_startblock);
+	return xfs_bmap_is_real_extent(irec) &&
+	       irec->br_state != XFS_EXT_UNWRITTEN;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 77b7ace04ffd..01191ff46647 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -986,41 +986,28 @@ xfs_reflink_ag_has_free_space(
 }
 
 /*
- * Unmap a range of blocks from a file, then map other blocks into the hole.
- * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
- * The extent irec is mapped into dest at irec->br_startoff.
+ * Remap the given extent into the file.  The dmap blockcount will be set to
+ * the number of blocks that were actually remapped.
  */
 STATIC int
 xfs_reflink_remap_extent(
 	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*irec,
-	xfs_fileoff_t		destoff,
+	struct xfs_bmbt_irec	*dmap,
 	xfs_off_t		new_isize)
 {
+	struct xfs_bmbt_irec	smap;
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
-	unsigned int		resblks;
-	struct xfs_bmbt_irec	uirec;
-	xfs_filblks_t		rlen;
-	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
-	int64_t			qres;
+	int64_t			qres, qdelta;
+	unsigned int		resblks;
+	bool			smap_real;
+	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	int			nimaps;
 	int			error;
 
-	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
-	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
-
-	/* No reflinking if we're low on space */
-	if (real_extent) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-		if (error)
-			goto out;
-	}
-
 	/* Start a rolling transaction to switch the mappings */
-	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -1029,92 +1016,121 @@ xfs_reflink_remap_extent(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Reserve quota for this operation.  We don't know if the first unmap
-	 * in the dest file will cause a bmap btree split, so we always reserve
-	 * at least enough blocks for that split.  If the extent being mapped
-	 * in is written, we need to reserve quota for that too.
+	 * Read what's currently mapped in the destination file into smap.
+	 * If smap isn't a hole, we will have to remove it before we can add
+	 * dmap to the destination file.
 	 */
-	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (real_extent)
-		qres += irec->br_blockcount;
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, dmap->br_startoff, dmap->br_blockcount,
+			&smap, &nimaps, 0);
 	if (error)
 		goto out_cancel;
+	ASSERT(nimaps == 1 && smap.br_startoff == dmap->br_startoff);
+	smap_real = xfs_bmap_is_real_extent(&smap);
 
-	trace_xfs_reflink_remap(ip, irec->br_startoff,
-				irec->br_blockcount, irec->br_startblock);
+	/*
+	 * We can only remap as many blocks as the smaller of the two extent
+	 * maps, because we can only remap one extent at a time.
+	 */
+	dmap->br_blockcount = min(dmap->br_blockcount, smap.br_blockcount);
+	ASSERT(dmap->br_blockcount == smap.br_blockcount);
 
-	/* Unmap the old blocks in the data fork. */
-	rlen = unmap_len;
-	while (rlen) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
+	trace_xfs_reflink_remap_extent_dest(ip, &smap);
+
+	/* No reflinking if the AG of the dest mapping is low on space. */
+	if (dmap_written) {
+		error = xfs_reflink_ag_has_free_space(mp,
+				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
 		if (error)
 			goto out_cancel;
+	}
 
+	/*
+	 * Compute quota reservation if we think the quota block counter for
+	 * this file could increase.
+	 *
+	 * We start by reserving enough blocks to handle a bmbt split.
+	 *
+	 * If we are mapping a written extent into the file, we need to have
+	 * enough quota block count reservation to handle the blocks in that
+	 * extent.
+	 *
+	 * Note that if we're replacing a delalloc reservation with a written
+	 * extent, we have to take the full quota reservation because removing
+	 * the delalloc reservation gives the block count back to the quota
+	 * count.  This is suboptimal, but the VFS flushed the dest range
+	 * before we started.  That should have removed all the delalloc
+	 * reservations, but we code defensively.
+	 */
+	qdelta = 0;
+	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (dmap_written)
+		qres += dmap->br_blockcount;
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
+
+	if (smap_real) {
 		/*
-		 * Trim the extent to whatever got unmapped.
-		 * Remember, bunmapi works backwards.
+		 * If the extent we're unmapping is backed by storage (written
+		 * or not), unmap the extent and drop its refcount.
 		 */
-		uirec.br_startblock = irec->br_startblock + rlen;
-		uirec.br_startoff = irec->br_startoff + rlen;
-		uirec.br_blockcount = unmap_len - rlen;
-		uirec.br_state = irec->br_state;
-		unmap_len = rlen;
-
-		/* If this isn't a real mapping, we're done. */
-		if (!real_extent || uirec.br_blockcount == 0)
-			goto next_extent;
-
-		trace_xfs_reflink_remap(ip, uirec.br_startoff,
-				uirec.br_blockcount, uirec.br_startblock);
+		xfs_bmap_unmap_extent(tp, ip, &smap);
+		xfs_refcount_decrease_extent(tp, &smap);
+		qdelta -= smap.br_blockcount;
+	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
+		xfs_filblks_t	len = smap.br_blockcount;
 
-		/* Update the refcount tree */
-		xfs_refcount_increase_extent(tp, &uirec);
-
-		/* Map the new blocks into the data fork. */
-		xfs_bmap_map_extent(tp, ip, &uirec);
+		/*
+		 * If the extent we're unmapping is a delalloc reservation,
+		 * we can use the regular bunmapi function to release the
+		 * incore state.  Dropping the delalloc reservation takes care
+		 * of the quota reservation for us.
+		 */
+		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
+		if (error)
+			goto out_cancel;
+		ASSERT(len == 0);
+	}
 
-		/* Update quota accounting. */
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				uirec.br_blockcount);
+	/*
+	 * If the extent we're sharing is backed by written storage, increase
+	 * its refcount and map it into the file.
+	 */
+	if (dmap_written) {
+		xfs_refcount_increase_extent(tp, dmap);
+		xfs_bmap_map_extent(tp, ip, dmap);
+		qdelta += dmap->br_blockcount;
+	}
 
-		/* Update dest isize if needed. */
-		newlen = XFS_FSB_TO_B(mp,
-				uirec.br_startoff + uirec.br_blockcount);
-		newlen = min_t(xfs_off_t, newlen, new_isize);
-		if (newlen > i_size_read(VFS_I(ip))) {
-			trace_xfs_reflink_update_inode_size(ip, newlen);
-			i_size_write(VFS_I(ip), newlen);
-			ip->i_d.di_size = newlen;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
 
-next_extent:
-		/* Process all the deferred stuff. */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out_cancel;
+	/* Update dest isize if needed. */
+	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);
+	newlen = min_t(xfs_off_t, newlen, new_isize);
+	if (newlen > i_size_read(VFS_I(ip))) {
+		trace_xfs_reflink_update_inode_size(ip, newlen);
+		i_size_write(VFS_I(ip), newlen);
+		ip->i_d.di_size = newlen;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	}
 
+	/* Commit everything and unlock. */
 	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		goto out;
-	return 0;
+	goto out_unlock;
 
 out_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
-	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
+	if (error)
+		trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
 	return error;
 }
 
-/*
- * Iteratively remap one file's extents (and holes) to another's.
- */
+/* Remap a range of one file to the other. */
 int
 xfs_reflink_remap_blocks(
 	struct xfs_inode	*src,
@@ -1125,25 +1141,22 @@ xfs_reflink_remap_blocks(
 	loff_t			*remapped)
 {
 	struct xfs_bmbt_irec	imap;
-	xfs_fileoff_t		srcoff;
-	xfs_fileoff_t		destoff;
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		srcoff = XFS_B_TO_FSBT(mp, pos_in);
+	xfs_fileoff_t		destoff = XFS_B_TO_FSBT(mp, pos_out);
 	xfs_filblks_t		len;
-	xfs_filblks_t		range_len;
 	xfs_filblks_t		remapped_len = 0;
 	xfs_off_t		new_isize = pos_out + remap_len;
 	int			nimaps;
 	int			error = 0;
 
-	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
-	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
-	len = XFS_B_TO_FSB(src->i_mount, remap_len);
+	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
+			XFS_MAX_FILEOFF);
 
-	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
-	while (len) {
-		uint		lock_mode;
+	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
-		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
-				dest, destoff);
+	while (len > 0) {
+		unsigned int	lock_mode;
 
 		/* Read extent from the source file */
 		nimaps = 1;
@@ -1152,18 +1165,25 @@ xfs_reflink_remap_blocks(
 		xfs_iunlock(src, lock_mode);
 		if (error)
 			break;
-		ASSERT(nimaps == 1);
-
-		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
-				&imap);
+		/*
+		 * The caller supposedly flushed all dirty pages in the source
+		 * file range, which means that writeback should have allocated
+		 * or deleted all delalloc reservations in that range.  If we
+		 * find one, that's a good sign that something is seriously
+		 * wrong here.
+		 */
+		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
+		if (imap.br_startblock == DELAYSTARTBLOCK) {
+			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+			error = -EFSCORRUPTED;
+			break;
+		}
 
-		/* Translate imap into the destination file. */
-		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
-		imap.br_startoff += destoff - srcoff;
+		trace_xfs_reflink_remap_extent_src(src, &imap);
 
-		/* Clear dest from destoff to the end of imap and map it in. */
-		error = xfs_reflink_remap_extent(dest, &imap, destoff,
-				new_isize);
+		/* Remap into the destination file at the given offset. */
+		imap.br_startoff = destoff;
+		error = xfs_reflink_remap_extent(dest, &imap, new_isize);
 		if (error)
 			break;
 
@@ -1173,10 +1193,10 @@ xfs_reflink_remap_blocks(
 		}
 
 		/* Advance drange/srange */
-		srcoff += range_len;
-		destoff += range_len;
-		len -= range_len;
-		remapped_len += range_len;
+		srcoff += imap.br_blockcount;
+		destoff += imap.br_blockcount;
+		len -= imap.br_blockcount;
+		remapped_len += imap.br_blockcount;
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b5d4ca60145a..f94908125e8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3078,8 +3078,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
 DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
 DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
 DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
-DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
-TRACE_EVENT(xfs_reflink_remap_blocks_loop,
+TRACE_EVENT(xfs_reflink_remap_blocks,
 	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
 		 xfs_filblks_t len, struct xfs_inode *dest,
 		 xfs_fileoff_t doffset),
@@ -3110,59 +3109,14 @@ TRACE_EVENT(xfs_reflink_remap_blocks_loop,
 		  __entry->dest_ino,
 		  __entry->dest_lblk)
 );
-TRACE_EVENT(xfs_reflink_punch_range,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len),
-	TP_ARGS(ip, lblk, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len)
-);
-TRACE_EVENT(xfs_reflink_remap,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
-	TP_ARGS(ip, lblk, len, new_pblk),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-		__field(xfs_fsblock_t, new_pblk)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-		__entry->new_pblk = new_pblk;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len,
-		  __entry->new_pblk)
-);
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
-- 
2.35.1

