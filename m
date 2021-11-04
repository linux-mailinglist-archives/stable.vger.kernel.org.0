Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F077C445453
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhKDN6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:58:41 -0400
Received: from mail-bn7nam10on2124.outbound.protection.outlook.com ([40.107.92.124]:14433
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhKDN6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 09:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgFU8nMm0fxdKJtP6IoTIHVvXKKIeszSP1FYrvSXUjzeSSC1PBj7e6/mXFU1cv/24WmDc77OeLbDGh32b6dmLTzZkS1j8qNs8OwJV4zAOTicaBEq07Wq+qUL8qkQdG/1jSYWhq/c/4CbLn/sLrL0gcRbZMqZUytp2XMabMLaOHeyWOlssR7/zKF858s4QL40B4hEg49TBHEcGtAyu2iH/lO/LkexPqIRwkLom18Od4h4TaWJGjmoj3s4Zvy9YjswTndAvXSCUPZKw9i1KeXF+fa/gIIHy0oPb2nboOZNXXqpauNqIRM9mGCBpRL9rSEJWVkvEmic0pT4Y47tTsuehA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHX2ZhbVIYvTxMdLap9nOduTqhNMGKRypYylWwtXjgg=;
 b=IL2zSeQkHersfgoYUJPmah/FkaC78Y5hHGUXf2OhrjuKn/a/YLDuH1Q7KYbrDJN7zFDzQSOvyvWo2NKyY0f5zXWB91N2J3B1c2Ll7r8eigkTiqkfYG5lU17cLcnxlmpKFfiSP57TGirEDeu2rgEjfcINdmuyyKGN5GKy85u1PYD8byyTdD2xKYVgWQROgNaP4h+s2cg9mFxbYnMbbdkKDLoGyQfmxIGSZ9bJdqQ8MN2jL3xC2pVMnmHr4MWHEhwdOJuRzfryesDnuyg5exszO90uTA/X5cHDNBg8hvu/yEVCZzaTdz/XRYTf0AOPtQiRgg3LRV+e/Au6WrkJ3T1Dcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHX2ZhbVIYvTxMdLap9nOduTqhNMGKRypYylWwtXjgg=;
 b=HflB8CmqLX0exj5N4IhK6KHm5YJUtKKgt5363qVCxJTxrRRX5Vm8uMC3b2H2RNiqlxFCcR0NribYqWla0oeAwTa9SGIHSs7I5DvvkKQUpYovpl7+0dfpyvrCKMyFWXLmrcYpfYbN5DDG3nJp/dXe9ST+1NUnVRRcYCT31PtrbiQ5IykuI6MgaBDCf0Z4tBp1a0dHO/8hiFPWlVsXe76tIREtGM6/jAXH6b2RuGtBPNZxEzcfhr57sqhK3GpQ6XiF/wI8Eh7KsYvrc/tF3IzTf8ltYd8esf7GTAupGy99Yl86ENlE6JhRU6M14Y9Aij56g/J9Yf0OhpHRzAOPoeYQ4w==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB5765.prod.exchangelabs.com (2603:10b6:610:42::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Thu, 4 Nov 2021 13:55:59 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 13:55:59 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 4.14-stable 0/2] Port upstream patch
Date:   Thu,  4 Nov 2021 09:55:43 -0400
Message-Id: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:208:23e::24) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR14CA0019.namprd14.prod.outlook.com (2603:10b6:208:23e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 13:55:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e14a6dab-bd3d-473b-d5f8-08d99f9ad4b6
X-MS-TrafficTypeDiagnostic: CH2PR01MB5765:
X-Microsoft-Antispam-PRVS: <CH2PR01MB5765F8D64099BDC64DD8FE2FF28D9@CH2PR01MB5765.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:165;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IKEv5zfU5xQkkwdqorynnNTR/WasiqHL6NNfKYidTYy9nEf1//uAEcVKZBWxUYXCpZ6eOX9frI530vYj167445LrlFOoRSPPHu4QCXbm3TqDLQZOwF8939lyji1wwgmmEkYIY0LsKhVC+Ddn5vvss7ZHoVWTRnbPG32QPpwR4JnsXrtJjz0VRhJ9iq9mPe2+bNRPrkjPPoyvA5HxD8CtgXZnLLCDHjuvqj9LNpB+QixzGOHmlnYivtNdmYjPc/+jyeoq6n3lHMf+gXWjx8pl08b/4kqsked7JI/NF17GDX/cg+DNuabpU/a82MR6/qfGxbO7B52KpkTqAUWN5KwxCPoO8ur1ay6fMFfjxBXbaQWIgeTeIBHiQDXJrHE7Tb5nUwJwFADEMqqnCU2qB0y48CKn04ReJ/dIr39D8SKrPJbS3RTyi5aRhbH/JSCk6rx9J7vaLonspc146n1DJKilMFdaZRDAO9jAx8j8RLTIUFrRM8juNGYAWCYFgajCnBWb0Henr+IFXWfJgHs58Ik6gk4IPv/pC2K1SjJC1F3+y7nn20nCMTRK7/NO8Aj4ms/pe7RaC5O6ywE2W1ESAwxztYzyYFpg6T1hjGFzAn9tYDgdw9MXrs6GZw3QeKJGXHdyZ+xt+fHFq8MsStYb2LBBl3VeNv1wTJQdM2/USe13OqQM8AxWTTKaT/zK1DZQXGY6afE4pJDBJKGkO8Mnd8bwTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(2906002)(4326008)(26005)(6486002)(186003)(8936002)(9686003)(86362001)(6666004)(36756003)(83380400001)(450100002)(508600001)(5660300002)(66946007)(66556008)(316002)(66476007)(38100700002)(6916009)(8676002)(4744005)(107886003)(956004)(38350700002)(2616005)(7696005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QqV4hebzajQClbetdn6B+2vsCgCWCS49dbhp20ZaitvqoZk2/ED7+sc8ueV?=
 =?us-ascii?Q?UqROzk0bas7uQfn4kRcwEF+Ad2Riz+A/7Tfcsw8BClHlcEczTVx5yeEzlPJH?=
 =?us-ascii?Q?eNQtRqPAIacvWO8R0WM3cQkELDdPTy+jLwJLjdMyt6m0d+TOjrNdNya7YuvV?=
 =?us-ascii?Q?Lb+8L5fjUCeWwEmEDa3DiIJABrZM4juYCNUBsT9trQwbfRl6Dwx/zqFLXHFi?=
 =?us-ascii?Q?JJnndti9pAISQQcdW5yYMCo8bjJfWbv/1imXCVl7LhyjFGQ5wtMDgBEX28OU?=
 =?us-ascii?Q?/86rYAwQFruPaYdvMa1NqlwEx0AfEhl7kMrur+y/tCKVXBEUVtYYulWFpjpM?=
 =?us-ascii?Q?N65Jm5JABPEnvBGNRUbMt8vS3A6hJ0DMVOEuqlXHbcV7w6X6I4SmAcmV44Ro?=
 =?us-ascii?Q?RZAnoc4Z3tIMVKBR00OhJjaqBD4PqHcj66ODfcqul6hjC0mzFC6tYRRWEFnp?=
 =?us-ascii?Q?v6u+Z0kN4o+oBpztMW7FM7bq/M5dBA8NuMLz7fyZtT1ju1DLx7ySiHQ/UCW4?=
 =?us-ascii?Q?OkMy/fC9DWwzfhEgxjzah/3tzkYzwHmCqVClZJLxkgp0kzBVJw4IoWhUkA+M?=
 =?us-ascii?Q?GEt5EhrLdjSosWZAkXZEhwdOYVDQHFW8xgpRptnKJ+tGly5psrRYZOFkZS1k?=
 =?us-ascii?Q?Kbep1UnCJ4HyzichLP0EBJDv7NAY7BuIpT1nGxWt+QIjFJg++Yy/L52HRrZN?=
 =?us-ascii?Q?FnoDwstmI7pkGw7nU1oPMnVujfQx+JnOsC6ID+12Lv5LDW//Nhde7I1AmkqF?=
 =?us-ascii?Q?Ar4oye+0cWhQKxexDmtgtJtROyDm3vp6fG10EJnxeVtYJ9BZH6bRrvkn5bG2?=
 =?us-ascii?Q?fJbpLGEEAa6usuC6ccrFEAL77YEShz/rZJ2a1tPFLZHj/a9ua3lAPML3cMZ0?=
 =?us-ascii?Q?Rs8NlcseMy1mt2PhWYZndPusrie76uYfRpV6CB4FCSBDihNlS9yoisCJlu7i?=
 =?us-ascii?Q?qOYw9MDcXCPyQVBLHYDqd9IJMHWnnHjhVgGPYibjfZp88tgWOrOACOAl+FT8?=
 =?us-ascii?Q?vfVBVuZ1ANrbiUvnwmdjLFkc5IdFSI4xfUKs5A0PvX7HVQgEwhoZkOsH/nWd?=
 =?us-ascii?Q?1QrmZEbEZDEQKQlF/IigwBTvBcEkmVA8CvkrKULUP+yUhZdCkXzmMecU8Mv6?=
 =?us-ascii?Q?+mLRCeprw2VJQU1D8YA5Altb+OeVKJf6WUf50nKmVCmvyk2mfTbnUJCmNLiq?=
 =?us-ascii?Q?/1tdeH/PTRX097apbJqCpCdF7v4vwqP5tMfuXgqOi/GtZJOdQc/fc6xmpzSw?=
 =?us-ascii?Q?Tk3fLbOtjmrcrHmTSgu7SUBcmcK37KI+ToS1okgNQDd8S1Anw7BAFeBwuXza?=
 =?us-ascii?Q?I2NaJUQ9TviL37ZXCoToULOqc/0nnWTa1BXFoox60IDgTpcOSPzVoDHkVaZI?=
 =?us-ascii?Q?eY3GaIGXHHY52b6SJZBwIO05yOX0RitgOYj4neHeVP2zdbWexOgo5/cc8jPr?=
 =?us-ascii?Q?KzNz7KoNUPHuiyeenst2UTZkN2maXQb7hgYQGKlNMGo01nCE+hHJpftVtqXo?=
 =?us-ascii?Q?5s4BFaeFsZpXgGOchQYDxTRYy/xNpiq63iZTEqdkkYNb6F2BB6FPscpJcjPJ?=
 =?us-ascii?Q?RAhsQnEGGdJRxRGsjwCUIg48q3MhRtUQnlXI2RmuITJHCtW4wQteZG+e1jh0?=
 =?us-ascii?Q?/1Q4OpaNtg+/Be1oqrqegPRr9dhKuhhz2yZXABw4XjNMlfmDi6EqU/rX+kh9?=
 =?us-ascii?Q?ZII29TIFPyzlEagCfDi8bx1uAFxwsVWaehMAbLvjkQYHuAhsv5pl4YSenLAj?=
 =?us-ascii?Q?2aLw0c3S5Q=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14a6dab-bd3d-473b-d5f8-08d99f9ad4b6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:55:59.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JT0AvUtJxjF5V6UqFAXkWVNqKsR2eqdjz4qHehPj4y7uHkNzLvcLC1xAw1OeCPkkwSTgg3tFDy1cf9jHxS/GQcv9O65zR73M5jYvXQ/9Ns72WnvXzae++bFIwMBI17ki
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5765
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

This series ports upstream commit:

d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")

Gustavo A. R. Silva (1):
  IB/qib: Use struct_size() helper

Mike Marciniszyn (1):
  IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
    fields

 drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)
