Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90E755F084
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 23:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiF1VtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiF1VtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 17:49:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E739E1DA66;
        Tue, 28 Jun 2022 14:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656452956; x=1687988956;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qlEu8iNpoCaY6jSMSOqJ+J1kMIdKGdUl7IR76OCY8+0=;
  b=cOzZFJxRmpry8rbp+A5vY42JrMF5eeH7pk+z3yOsw1EWEXigPb+T7/KN
   ev37sY2Eok/Sc+OUAnlButs0CYvUEZD4t8sgsTM8gQyFICeFj/So9x0rj
   nUkBupeyCNFq8trZTCcwtsIsttM7LPJIP+J2TCDUNnkYrfHfIyhDo6SX4
   VGClDI0NBP7UhnNJTgE+nbBvG3XVJLsJeCalbWV578V/Zi2buDGlapZhl
   SxGZUtJndqEZ+fVWgjq1LQK0KcLQ4wjpz3X5PhQ5s7cbFbIDfendI8u7d
   EeF8MHtfTLS6oRw+nCRpAosajE43UXxOOKgGQX/Erkd6hN+hm5/1I4tEn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282950221"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282950221"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="732915920"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2022 14:49:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 14:49:15 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 14:49:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 14:49:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 14:49:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zn1oIxICmwtiW6qXUUPzIsUwDE0TM7gqcjAS8rFpjUhb5VkZOwfPT/wE/4ZWxNX6UMeD4YzZk7F7VHPMjy/YCWKPSrPe3toDJm0dNevrg3HJA7CN7em7rVBooKohpRdicQqJgHDJzTWPAAftXuM5OJAbjBxcuXhYk6NIs6frDMP5WCpDwkOqdXI+Fg7VlEavPcDEme+OCm01WG4ie72nzMORtOaCasxoy6CSc7rHAEW0WHboHzz5ALc/uX3TPlEqUGuwoiahk/vWxXl3n7QoqefQxJ3gzNjus6KIgAatN9x0comJz0OIWgX6pDM0yRK4nZWTukqeHGDykaEQbPMTwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlEu8iNpoCaY6jSMSOqJ+J1kMIdKGdUl7IR76OCY8+0=;
 b=jFXy2idU+5hh2oA/A4lYMgHVTbfcnd0QUYXiXYsjlyv3y1G0/oUOIoM/2CNZrlxEY5agdfxktg18IcZWnpm/GIHF0q8Puf1DB/Y0L+72xgDYH9ehYhZita7MAENthPj6H7aPtkBjpJDT3dn+SRUi1qKmpCDGYg/M9hVdDLHzB2rdWf+faH4j/xCdcCqa/qK2jUQ5T2d+Z+mPYKeT6U08wJkaQSTivEMzmMJIZWriZJWEn7bQ9dI3DpXXc+eNaIhpSHg4KYcKvtZ33MKrz4dT6Fd2vOkSyUxEwLhSBdrmM2xjU9sNRNAGjkqyDV9d7vHY5gf4KMhzrmYGpqDZ0IgOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SN6PR11MB2608.namprd11.prod.outlook.com
 (2603:10b6:805:57::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 21:49:11 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 21:49:11 +0000
Date:   Tue, 28 Jun 2022 14:49:08 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Vishal Verma <vishal.l.verma@intel.com>,
        <linux-cxl@vger.kernel.org>
CC:     Vishal Verma <vishal.l.verma@intel.com>,
        Abhi Cs <abhi.cs@intel.com>, <stable@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alison Schofield <alison.schofield@intel.com>
Subject: RE: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd
 size validation
Message-ID: <62bb77547fb2f_1ab19729496@dwillia2-xfh.notmuch>
References: <20220628200427.601714-1-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220628200427.601714-1-vishal.l.verma@intel.com>
X-ClientProxiedBy: MWHPR19CA0084.namprd19.prod.outlook.com
 (2603:10b6:320:1f::22) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd36e90c-7d22-46f0-2297-08da595008ed
X-MS-TrafficTypeDiagnostic: SN6PR11MB2608:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kq53C6u8bF3XJknv/MEqH9ejAOR3bx2txb7pFLt2YEA6hVj4eD0RO8A5SrW3oflz6OpD6kfK8hMx0O/p+wQlNCC1vLxeCZKd1EaCGcf4lGA9NdXETi1TYBctKNzabnJhiIeK8zPqdC5vdqzEhEypOebvG1tjDB2ZbQvwtmMypiKFuzihKgOtWPjb/Vw2eTMq2LhUIivu9Yvt4QLoJlqAnCeJ1rBY2deM2+Ibl8iLqqGWnd/ZwpdYq0xKyftgHTxSarFVx5daI8a1ma16d69P40DMhYC6aI78Mb2zcem8kokJ0WHO4xWOA56cYbl5DClG/WSt8n/9g0XGunE35T8/HS+Vym9AAXw5aWEJ6f7gIVeMGBT39rQ4yzjiwf/OEVhrW0K2/zTqZiNuEbCWeopwv67eP52QdHl7rfIKQTWPJA04FMyfIHfhmhvdV/vRumlzgqzBn6PPwo5z70K34XoV3gLmv4LNlHccD++vfG+UJEzp3S9JlYlmmfLVXiL4R2hb8mI2t7f5rpt2vt9lRBG122hQgQ7re0wY8/Wbfot1JmFB/Tn1nuCeS+EbvK634yeMYzxMkIWdgHOHvqJ7TdKRkvVeQP2htXUepfwPPBSZ7qHnuloTgCnQDvkIWULhLsqvRbswmt6nTczNly8EAWe/1JtlyiiLhTxukjI+DFXYEE7sto6KOLJx0a6RipZfbpb3TUZuOI33Gc5aVuTrp89fB4CEXA6ABmoEZxn7gCxAKw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(366004)(346002)(396003)(5660300002)(38100700002)(107886003)(2906002)(41300700001)(82960400001)(186003)(54906003)(316002)(6666004)(8676002)(26005)(86362001)(4326008)(66946007)(6506007)(9686003)(4744005)(8936002)(450100002)(478600001)(66556008)(66476007)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ULAo6ZTq7WHKeZ8JO1vIxW8WEMOT1Emkw2m/VubwoOcr5gX7yq6afx+J2jAF?=
 =?us-ascii?Q?uskQGCOj6KV61OPPWY6A+vVPNJKarLUDweiIAN6SaZjzyqRleA0pfXyKseXx?=
 =?us-ascii?Q?U83eZ+I6pwEr2mfulmZDjAcygo5NaHJCUfETRDuEpwWQ4rBp5D13zsyalVSp?=
 =?us-ascii?Q?5eyrpRf1ccv871PAm0tggDpPEofZW8zn0FQihQNAQ316iXZ1agIylKy13Moe?=
 =?us-ascii?Q?4QIp4XLOZ7cuG90o1wNeCRxlLGgPodaoYJlZJyTESqf4Kl0pMtIVzWqplzzn?=
 =?us-ascii?Q?Z8UFE5xwqvB3Axr/faRUmyevy6x2FT5Dx/lKmoCZv0jSWQ+OA6kuVXntxsDA?=
 =?us-ascii?Q?Aaa53h4v/GiQD9uBZEkE6q08wwateN0x3WS6bJsAcTdbYM+SqDivposcVASO?=
 =?us-ascii?Q?/uEaS8L1ex9WXN00cA/Lj7GHDpZrBRdrqp6cG1yZa/ZK79BILVwIzO7jBYN+?=
 =?us-ascii?Q?cK0BIUwaguKMPZxxucGia2SxlDiIp243RRFlAhPkpwPxa2uYOtGWu0hFjUkG?=
 =?us-ascii?Q?TXGMI4IgxXuOiUAcuCVTTeez0K01sSDNx4OwGZpgOg12VLbzHRHAedUXn+AN?=
 =?us-ascii?Q?zENZnxb8u+zOw2qJMsD7xN0mF5vbZZxLUkm/rMXyNB1rxMOsHqfaOuSSPD+J?=
 =?us-ascii?Q?AGfOMKAALtsC+Ur9BKTeFff9bVV05zuYWVf2EnttKMYRxPSJ4gcCm6JsJhtQ?=
 =?us-ascii?Q?oLKoxdsp7J1DH+cN2OqAvMCLTVzVaKoTtdGC6mFEDHONihGcLbd4pvy2FPTm?=
 =?us-ascii?Q?3wz6NJdQOBum5PtljzQpgCZJhvr8YtqdUR6er/hP2k/frxTiGgCn5o9E9cq6?=
 =?us-ascii?Q?EJ5Hpg+iYiLm4CoyVyiQ21d8VmxT6H+DtENW5h9IDd/nXYb7KGM8koYbvQiG?=
 =?us-ascii?Q?PHTJi+jhpRe9zLjo+fpFSJ6YWphZMfAzLRK+2zBhpBUFKAyVomDoWD6Q9BEG?=
 =?us-ascii?Q?Q9fF/4xitYdyNSEKpCMAQA7UR/UdJ3CxtRF1EfWRoa6Jqzh7FxQjz5Izq8ci?=
 =?us-ascii?Q?I8GqU1uZxtWgA8NkyVyggateQYIReLZSUg5ISvqIHApB4UsavsPV4CQC0Z9E?=
 =?us-ascii?Q?OSbHRGXfCloWHix2itE8dYsNs/MAMVQlpWJrfjqWShUk1IvYDkkP/LtqO828?=
 =?us-ascii?Q?Xx89GYcUmlZJgbA9HlQgxMe+v4U3xvipwJ3eEBNlOqcOMXttNd24+TNfcbTN?=
 =?us-ascii?Q?WKafB5kmeRQT+1YIb5PYJ5Ng/FM9i+qn1D44VDhjPfKaYaiF5oMj6b7QA5LP?=
 =?us-ascii?Q?HTypi1gZYqoHvSC+xKEZlNYPfzyFfoC0ri2Td2rKePx6EIs+fj3t5hOnBwHe?=
 =?us-ascii?Q?auNkeMQnDslw98G+zjpCqV/TSTXFmMJpDg0bABzLtWCV/0OAU0HFOQmbpT81?=
 =?us-ascii?Q?c5wVIK8pETJtJihmoeQFZ0YNPHzFzjfmMeqUgJm/eXhwHQ0vuyfcATK7YdGh?=
 =?us-ascii?Q?vSKFVXqHu8sk2I1VMSm5Z8FgR7FH4FT5H3w/EnJ5UyUDfQ+zxkoa/M32UjZs?=
 =?us-ascii?Q?xLO0ujNcGDEBB9OgQ11qU4sH3cDDRPbbcUmkzqwnoURO20ZNMm+jeJ0Xdozc?=
 =?us-ascii?Q?AfZiU/Ryr7N/OU6bR4uNeSbOWylkZbCCzoZfmO0QL32P3q+2yQ6nu2MYMpL9?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd36e90c-7d22-46f0-2297-08da595008ed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 21:49:10.9298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTUASErGYVdIbU0J7xZTsiUlFhucdDYiUMLcKorNxkzF/o8RdnkVtRpwpJnh19A86/xhVkuf1bTVMTMNwOYcNYtwh+K/8YpbRYbTgURF+Dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vishal Verma wrote:
> The conversion of command sizes to unsigned missed a couple of checks
> against variable size payloads during command validation, which made all
> variable payload commands unconditionally fail. Add the checks back using
> the new CXL_VARIABLE_PAYLOAD scheme.

Ah, looks good. Need to get label read/write regression test into
cxl-cli post-haste.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
