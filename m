Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D4743F826
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhJ2HxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 03:53:25 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:42158 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232243AbhJ2HxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 03:53:25 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T7d6kX009489;
        Fri, 29 Oct 2021 00:50:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Gqg8FFqmsFbjTbgxzKaSJcr8ijaumuSTEhq6OoTYYxE=;
 b=MMhTDi6g7NRJcy3WhRRk7fbKNQlDE2A5aT2zlwlu/qaWTyDpqHy8/DfeGfMgxSjStC6Q
 VeLDrC5mXuLdKLVqIpu+1bKJssYsavjxhwRy6TPe6lCYgSdxzNvSjWrc2nUy0l7WCsaI
 oVTeNlFc1lVLLqCduGCcy4852MwpU8vNAm91tY0i/g/g2pbaTwRXuYrYGZosy6WAwI1v
 Hq35tXf6RRdV4DXJr1EMwDEIq39tYBL3Su57oUSDOr+1w6AuG9ZzynB98RdoCBLEeQ7V
 b8MbxvWB0BQPfaHIyf8SZMVmi13HlEYZ80dPdKE8sww1uorQ4Gz21KO6jKpr5CNEDVwL wg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bycjw9gn5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 00:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4Qg9ICJqlic2FHZGDz6doufDikZKNxB/hge3GJzlXpJTT1CbBuBU0MHiAz5hgVYGs9/r3Pc+/af3l+kz5Zver9U2m5oP0zOsIYXkUrWPIrnlp9Wv9EDQdj4DcTjYuE1Qr4LsORlhawFiLo6YOZth/3hmHRrZehjrMq/HO5jqLZKm9mPWa162Su/pE7MQlTUpHHNlgwFXmdWFnZO72KRQXDrEtZfIAWOMhj+xu15OJv6EG321VSCDUjrLX78bDaH3jHrYjTLMRsOh+fB0zebQXglPU+J75iph/fGiHaWYIqLPCdnTAZ8nAKVXbea7XvRef3c5aLUka8Zvprcce4Vig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gqg8FFqmsFbjTbgxzKaSJcr8ijaumuSTEhq6OoTYYxE=;
 b=GyAU/mnrUzdCmEt1uhJBny8gjrNt7yzUcBIETMTB9SrzIOigHsksvikMb4xJjsLf8Bvq+HO9zKYzvrUPah7k/ax664m8+lSgpAz29FLBeXTNBh9+1CmmlQMvKPbbaPJVypkLR/u/VX2NfTtylyQMCExPRWVhpQCPlICsGam5c9nuBDQsASh1gbhkydTq8KS6lIHF/lkIyFUDzC5cfU5S7Hfg62OoTA72Z0g1Uj1QtJcfZ1uPhDVm7GTOumqyN4JaPpayQh7Sd814lmHuOq4KmEXWqV3BzWNwC18FW75UJXhNLcQpJCYQXuIEa1vEmf1UNmAdMNI5lQO0BQzWQl5/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN6PR11MB2035.namprd11.prod.outlook.com (2603:10b6:404:3c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 07:50:52 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 07:50:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 4.19 0/3] ipv4/ipv6: backport fixes for CVE-2021-20322
Date:   Fri, 29 Oct 2021 10:50:24 +0300
Message-Id: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0093.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::19) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0093.eurprd08.prod.outlook.com (2603:10a6:800:d3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 07:50:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07da2df0-b4d5-4408-a528-08d99ab0d4b4
X-MS-TrafficTypeDiagnostic: BN6PR11MB2035:
X-Microsoft-Antispam-PRVS: <BN6PR11MB203570D69F7C60EBF4CBE2FDFE879@BN6PR11MB2035.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwbKLPjZcIdRJmu74Ye0aFQd7PZGgmpDbxqk6FJ8NgzsCNv/i5grCrVuMU67K4ZZEnx5uOlqoxcRXnY7ndqcovp5PcaFBDjSOiqAbcSKYYB2M3NDs9ujx4e6eWNHNIYCpoE7OxS9wf+7dbIV1eWpXYDOuYlHxp7TXCfzspo51882Ua9H9uS5msksg4Oc/ja2gXIg/VCGG63ed3Lp1yPsyKaNdjNFkp3pAbxmZXKYxrz471uGljgUuu8LUMcxfLjYJ/CkFMa8+g5j7Lp33abnnQDc0GIe3HFl7kzvQmX+uLHmSZON5XAk7/WjnGRK2CYSmawlRRiooK59s3cl7cPSnTwGrbSVeMaPrBAC3wdhXfl5AJPwbgBA3xmBTG7t6TaSUT9Eao4VNXAtjde5+JNIMmHBBwdHaV8E4K1nWhocl0H2Iys3JJbXvr2ACSeSXds3w3ttfdIW6P24JHptOW+f0r2zewWN6IMw4HLby4CcN0oLRFFlL6FdXA+Wi9bVeYc+p75YKex8rSSDckk1zzeTnYU4ySAqch1/HckDe5bxULSXOvn8CxwVIJOeLZ7ewJNnh5MsdbRWObCdT1vDFP80j5ipKbIRJIT9SxZEod2o3R4eYYfX4gtejwn52u9OunYQ3I0S8agfdaeL+hNIUyBt4wiaMzp7lpUMixbn1q8Dy+SJPdm1EYUdUH/LJKHBKnxH/n3i790H0nQWyWh99WRqJ9ZAznOnVyw8ERNEtegAABTPnBBGUztmbfiA6BhseaJ6WyHPhx7h5GTZtVm1qNMo3Yji42ujGFPyzW2DnprUeKkEYBQCtjjmg1hgIsSxfjuH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8936002)(186003)(38350700002)(2906002)(6666004)(38100700002)(4326008)(2616005)(44832011)(956004)(6512007)(966005)(6916009)(4744005)(52116002)(1076003)(508600001)(86362001)(316002)(6506007)(66946007)(36756003)(66476007)(26005)(66556008)(5660300002)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fmak56pldFk90FFh/j30tkPoW3uARUZOlZab9z//O7in6jnWngAHMFyYms1l?=
 =?us-ascii?Q?/cwkccEMu/G0vtzrMO6njEO07Edwn7XriPudglIdFio1KKqW8I1U1lfeGdHg?=
 =?us-ascii?Q?Ig2xpQUBtrWkkB9g8sF7DkHQG2Dz1WRYMk5YELns+Lhh9J0/lE1en2sUm7QR?=
 =?us-ascii?Q?pXhr9k9XbJX03QPNcloJgQKNOVJI8mdp+gkrWE/f7HyW8GRBZp0BevoMH/M4?=
 =?us-ascii?Q?bLUMP2Ae3O5NhkbJxu44E0FB4l5gECP+Yo+MDmfqxNrZX8R8JENTGD4Dw2Be?=
 =?us-ascii?Q?HtoIjAODPuQ+duX4esbWZ4NJnBuBWtZhq+61fu+kyOVnzu+G0WnUnjLrGFyb?=
 =?us-ascii?Q?jmH8kuvBNN5lsmet6UNrU8DD96TfVMPki3tcBGAhitkjmQJBjymD1N11Meie?=
 =?us-ascii?Q?2kWRh4byASsD+12uSVxxz8Ew6unAwUEH/NpeXfHc+72Aa602MV2/IcaC64Er?=
 =?us-ascii?Q?K7Xs1eqojFjkTtqvIatpRvVdpIh5C4AZNaWn0A1eKKHnoolxTRUIJffbTPMc?=
 =?us-ascii?Q?4RIHdA2E8HE+WBBUW2uKWjOtlztBL4nLTFOQNIHJ2HPxoAyBF1WnNMNej3YJ?=
 =?us-ascii?Q?KXLyWAzyLjRFOYsfkYYV3TFNoifCMRx8o5Qyi0ULYVNvC+1FohYbOKe6aT5y?=
 =?us-ascii?Q?Q2n8AgAtgkw7Rt8gNCtv5RT6vPsXX+ABMQWQ4DjdGcu1bmAbVwd8RTp3O9hi?=
 =?us-ascii?Q?mDKv0BsBTVrA2V3eUTHZYKPwXiTQQjQtjm9YCV6znXz3qeaZcusKt19Yiv03?=
 =?us-ascii?Q?UY2jhD4+WdY3YZHTv0BZ3Lnk/bzOQErz5YSafZE+NBpkS0HisJzmOk7vgCRB?=
 =?us-ascii?Q?ITvWQvg47IUsGoIZtvLt6K0eDonohWpNKcuLHTyTM2wq2YCsy8pqMt0j4Kt7?=
 =?us-ascii?Q?cvvas5qq8IpR4j8eTSZtvUDJ93TZQJICiQEZXF9gle5jpKY1qf+DOjJ+Rm4W?=
 =?us-ascii?Q?/uIp4GQpkGWfM9Avy0u2jEmRH28Uy6spEQ9eIg0aUunpHeVPtcEMDa7mL8Fv?=
 =?us-ascii?Q?ipTKSqAqJ/+9yetgJXc8+CPQUFCydnDaLDO103GoqzYIQF3hIXHZN+hBruOS?=
 =?us-ascii?Q?FiUDKAea3Gdq6Sroql9n0T5XFMR31Nr4pi5NdFyQ2pSt0nf62vufgcMN4GVy?=
 =?us-ascii?Q?qmB5PWzpntjYDtIFEqN/o+tuhRvmRHg/yrjdkY+BO66ZD8KT4h9HWI3yK0Wc?=
 =?us-ascii?Q?i71oFGKikCrM2tfaukksCL6jgb3PioS6SWWrRt0PEGWyc6Ikzx7YVcUqxCZY?=
 =?us-ascii?Q?mwFDUP6H3ckzW42lRG4bnA27m9a01aXNutBSj2wA7s8i9Lugpb2YgQBX+7Tg?=
 =?us-ascii?Q?+zM1jYfiiyu/75kJmZlCza6Z/4UB4+YSfcYNt8J5c1rOkPuZ3QOCqG8x0+Mh?=
 =?us-ascii?Q?E3HMgPYRI5KCkUNqCzpiVpKfkE7A4Rk3COE8tIzi4KAdZhUaohzfBwPiIFy7?=
 =?us-ascii?Q?Ju9id7rCjBcN+hxlWPR4snLXVvxYNbIIekn1pgUcuIqSzVI1nJTBPKxkzlUf?=
 =?us-ascii?Q?nyE6IybnS8NQkOf9lgFrkmslH1cBUGnCEHcwXyLXXhKU/n6na1vs3wgidRVy?=
 =?us-ascii?Q?Br5VqZmA4eCW9yB4L76qqMAB6DKs4lNwK7MAn4bALohXc285PD00hQkUIHei?=
 =?us-ascii?Q?3vSR1kdK6tnI7PLsEyUDhDWdOAo0naMmF7+b1CS4DUiPnMBVvI+SPH2bd6Sq?=
 =?us-ascii?Q?KHO4UA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07da2df0-b4d5-4408-a528-08d99ab0d4b4
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 07:50:52.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBZNja5UV+Pqspkd1C87oMlUQSVN/B8QvTA6WHb5vhYm5GaxxW645MK1SgXmhR8dMOuqWatNIG33Z5thz+9shC2DaSmahoVsJScgsfp6UcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2035
X-Proofpoint-ORIG-GUID: 5maVbbe2lSmmdk3oP1JcN4SQYG_dUdU0
X-Proofpoint-GUID: 5maVbbe2lSmmdk3oP1JcN4SQYG_dUdU0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=518 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290044
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commits are needed to fix CVE-2021-20322:
ipv4:
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e

ipv6:
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43

Commit [2] is already present in 4.19 stable, so backport the
remaining three fixes with minor context adjustments.

Eric Dumazet (3):
  ipv4: use siphash instead of Jenkins in fnhe_hashfun()
  ipv6: use siphash in rt6_exception_hash()
  ipv6: make exception cache less predictible

 net/ipv4/route.c | 12 ++++++------
 net/ipv6/route.c | 25 ++++++++++++++++++-------
 2 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.25.1

