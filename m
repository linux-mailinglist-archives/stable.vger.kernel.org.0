Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38346252EB5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgHZMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:31:48 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40808 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729308AbgHZMbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 08:31:46 -0400
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DBE04C07A8;
        Wed, 26 Aug 2020 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1598445105; bh=QPHkCJ3Om0DAlINmhzkHzqRGtpayNcOSpYTs3RGGkBo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JzOuoCtOBtCc6RkttyOXh4xqi1yE/7XnX6e1n7/f6F7HGxN83d44jgvMEeyx+51Pr
         rAHZk9ZAUMw0co+LV1v7xj+/KHUsB5vF+n674n0GHs2t8Z7NvId5g5AKpx92wKhaAB
         mDHFRjH+P/g8/hx2KzBRAYXmPKPEzLbiaqKW2TTVzVEmNycj8Azzy9caOUJodr5+9w
         BfPX13vI9jngh3gI6CxioGmXfpQvZSe6nBgTz1RGiTKzBTDNClSheRy+gne4NRnQGK
         6mBkXuFPpI1R0E/GTWXid2q/1UXjt4QiszV2DoPS1GLUUlS3vZtDgKnwatlUA5QxNT
         zYytXLHPvDWYg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 393A2A005C;
        Wed, 26 Aug 2020 12:31:44 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 7E108800CD;
        Wed, 26 Aug 2020 12:31:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=gustavo@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="tsbpkFme";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzSwO34DUUmKAl8Xn1/k0r7vd6iKfm4XziRwR7d9bR9ydDMqY/4pGZaFT+Rkws1LGVDwYozmBDy+qIQ+MSrrVUDjo1zBgtYyEpJWRVmPjV5ZXDIEBfU3p5fR+d3Ts0+hE5NpEcgS3zDq5Qgx8ZYYoQShlfPVL/WXrDMw/2X0wdTIEcR2Vy+vnE7usp3Vgg5jvDCiN9elb+24XRBkMx2l/RhxuKmTqqhxTF0j31F7rm0rSpcNYHq1JtR4KbjScBf7RFiVRnPU/qXrwcaKukvQyI/XGsTetxKaNwhjRoVt62e352D/5CI4teyXjVmDoDBJ7mxcEohBxO8yeRav8meyQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn4+dMv4srTONSHdy6jTEJNnFaZnQT7iFbvJZrNVYfc=;
 b=T2a3+fdG/BJ/kPcuVTkD/pN357F8T7gJfo0v/zTosMUm1Uh/ENFxF9iMDu1mzwMiz8FU1+6wGSYA7/VYgPsrWNie2LVXIztgaW0OgYaQByJJhJpb7Zbci482hVilbEaXlLmXjioIm4GQT4pnodPgUgmhNzmLBH5y6vXgQADANdNCP3Z5aoO0k4pXJPQDcBZVDrHrGIKOIMmkaWwu1R6ozo1SmkOZ7/vVsbcwmwqjlDj4DPvoOII+GQmkup2X6fBVsGdRMbLmNUKzEk8QnhX2WtKoSHcWAhYHI7r+DkotTbQazLXf1W7t57AWXSLjaTUDAtrn1aGO1MRJbelQdjmsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn4+dMv4srTONSHdy6jTEJNnFaZnQT7iFbvJZrNVYfc=;
 b=tsbpkFmed9YCCRTFvhpbu56ohmyyTGQepr16KdO6JnhVde3O1U04hTqpzqhKQKn+XGH3G0VcSSKLigy8RgQ6oXe18t7s1eeSfX8rDBx/G5xP3/r9ME1PVivmGwVNr1CFYpRVWI1MhnuJqjDJ2VZpvLGtKPL75hmK0ZX/PHnnJvY=
Received: from DM5PR12MB1276.namprd12.prod.outlook.com (2603:10b6:3:79::18) by
 DM6PR12MB3676.namprd12.prod.outlook.com (2603:10b6:5:1c7::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 26 Aug 2020 12:31:39 +0000
Received: from DM5PR12MB1276.namprd12.prod.outlook.com
 ([fe80::2d6d:2aab:cbcb:258c]) by DM5PR12MB1276.namprd12.prod.outlook.com
 ([fe80::2d6d:2aab:cbcb:258c%10]) with mapi id 15.20.3305.032; Wed, 26 Aug
 2020 12:31:39 +0000
X-SNPS-Relay: synopsys.com
From:   Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
To:     Vinod Koul <vkoul@kernel.org>
CC:     "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] dmaengine: dw-edma: Fix linked list physical address
 calculation on non-64 bits architectures
Thread-Topic: [PATCH] dmaengine: dw-edma: Fix linked list physical address
 calculation on non-64 bits architectures
Thread-Index: AQHWcXv97q/9AycNOUCVf6O7ldeDEKlIvXiAgACsBSA=
Date:   Wed, 26 Aug 2020 12:31:39 +0000
Message-ID: <DM5PR12MB127696E920BD51BA1788CDE0DA540@DM5PR12MB1276.namprd12.prod.outlook.com>
References: <9d92b3c0f9304e3f2892833a70c726b911b29fd8.1597327637.git.gustavo.pimentel@synopsys.com>
 <20200825110937.GI2639@vkoul-mobl>
In-Reply-To: <20200825110937.GI2639@vkoul-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZ3VzdGF2b1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTE1MDE2NjExLWU3OTgtMTFlYS05OGNiLWY4OTRj?=
 =?us-ascii?Q?MjczODA0MlxhbWUtdGVzdFwxNTAxNjYxMi1lNzk4LTExZWEtOThjYi1mODk0?=
 =?us-ascii?Q?YzI3MzgwNDJib2R5LnR4dCIgc3o9IjM2NDUiIHQ9IjEzMjQyOTE4Njk3NjQ4?=
 =?us-ascii?Q?OTY0MSIgaD0ibWk3UjFGdVFwUERwRzJsMzRpVTZnT0U3eDNBPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBQlFKQUFD?=
 =?us-ascii?Q?cG9LRFhwSHZXQWZKNEVPMXlDWi9SOG5nUTdYSUpuOUVPQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQ2tDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFOclNWM2dBQUFBQUFBQUFBQUFBQUFKNEFBQUJtQUdrQWJn?=
 =?us-ascii?Q?QmhBRzRBWXdCbEFGOEFjQUJzQUdFQWJnQnVBR2tBYmdCbkFGOEFkd0JoQUhR?=
 =?us-ascii?Q?QVpRQnlBRzBBWVFCeUFHc0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtBWHdC?=
 =?us-ascii?Q?d0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCbkFHWUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFiZ0Js?=
 =?us-ascii?Q?QUhJQWN3QmZBSE1BWVFCdEFITUFkUUJ1QUdjQVh3QmpBRzhBYmdCbUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1BRzhB?=
 =?us-ascii?Q?ZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWN3QmhB?=
 =?us-ascii?Q?RzBBY3dCMUFHNEFad0JmQUhJQVpRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFIa0FY?=
 =?us-ascii?Q?d0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0J6QUcwQWFRQmpBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFaZ0J2QUhVQWJnQmtBSElBZVFCZkFIQUFZUUJ5QUhRQWJn?=
 =?us-ascii?Q?QmxBSElBY3dCZkFITUFkQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCbUFH?=
 =?us-ascii?Q?OEFkUUJ1QUdRQWNnQjVBRjhBY0FCaEFISUFkQUJ1QUdVQWNnQnpBRjhBZEFC?=
 =?us-ascii?Q?ekFHMEFZd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhr?=
 =?us-ascii?Q?QVh3QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3QjFBRzBBWXdBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVp3QjBBSE1BWHdCd0FISUFid0JrQUhVQVl3QjBBRjhB?=
 =?us-ascii?Q?ZEFCeUFHRUFhUUJ1QUdrQWJnQm5BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ6?=
 =?us-ascii?Q?QUdFQWJBQmxBSE1BWHdCaEFHTUFZd0J2QUhVQWJnQjBBRjhBY0FCc0FHRUFi?=
 =?us-ascii?Q?Z0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFITUFZUUJzQUdVQWN3QmZB?=
 =?us-ascii?Q?SEVBZFFCdkFIUUFaUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFB?=
 =?us-ascii?Q?QUFDQUFBQUFBQ2VBQUFBY3dCdUFIQUFjd0JmQUd3QWFRQmpBR1VBYmdCekFH?=
 =?us-ascii?Q?VUFYd0IwQUdVQWNnQnRBRjhBTVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFB?=
 =?us-ascii?Q?QnpBRzRBY0FCekFGOEFiQUJwQUdNQVpRQnVBSE1BWlFCZkFIUUFaUUJ5QUcw?=
 =?us-ascii?Q?QVh3QnpBSFFBZFFCa0FHVUFiZ0IwQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUhZQVp3QmZBR3NBWlFC?=
 =?us-ascii?Q?NUFIY0Fid0J5QUdRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFB?=
 =?us-ascii?Q?QUFBQUNBQUFBQUFBPSIvPjwvbWV0YT4=3D?=
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [89.155.7.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04672cf4-6fc2-4c13-d3de-08d849bbfb3f
x-ms-traffictypediagnostic: DM6PR12MB3676:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3676B19793C4A14929BFFE5CDA540@DM6PR12MB3676.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VwVEDRreWhEELRBQEPkqyYtkF938V+Ypi/qimIRtJMa6bxq85adjxMAqzBauL8VTxFjI4MhQGMeNF+rtGg9Zz+nHFZR3tpOSigTLJrNhcjLGX9HqsmYDiO54Qx+XYdLA3w4Xisjuc3jWYZoVpOxc4afGtKDurNVUb+YwBN81n7yu2Oi5Ia9IGR/2C1+O0DIe44zphTIdJT/IQBPNcXC0E5p7hIZzLSsyKaxXNsBIYV2WRh54fJk6wswHGWZTv8TdTjGtcYKk+mGhBglkhSYmBerTmD2tps4LifLAMfvkqn0oOGIEZAbt7ir6TDWAGZ0SkaJxyHSa5ca4QglBkzZ0zQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1276.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(52536014)(7696005)(71200400001)(33656002)(26005)(186003)(53546011)(6506007)(83380400001)(2906002)(478600001)(86362001)(66446008)(8936002)(5660300002)(66556008)(4326008)(6916009)(8676002)(76116006)(54906003)(66946007)(55016002)(64756008)(66476007)(9686003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: efTDDzuOnnZYS+TP0F+z+hCrfTJEEmO74oKKBgrNnchTMwNxcDiw0hKkPyxmrodrpbxIcYQsAqf4DlMfBLOQrenI/lBhVtUvo4eDs0AygMdBg73cJDi+a/6sEX/fo4RC7poeXM32tMfo9K+sSYcyuw8rWMgOiuYPwCarbdS8DKJQb2uZIJzE6yzyEt6JpPMZq9zMcmJlfAnwoSeb7Tf6KfnNU5ri2xwVs5D1arvxtIbSMHmZxHJ3QJrTnC0ski153ZiKz2IXY9n3nB1fGKgJsnOAeKOBdAknhDKNcMik0GdRxyZvx9iBTIF8GDFzKjwZsce8L2KcrAdKOk9eiVB8AK4D0/ChEkwLXV3pF9TFMwsJY7wjIuXK7pdjdzZAXK9/KLWqxIv9pzxY2TGPeyOhr07a2pzrHxxDS76bamGNj94JmgiTR6B3ThmtrsaMGeuAYySbrJPxuNLn4IJZrtDnbO+3RF/VLK15mR2robe1BNNcwQOLHFMDjGDqI+rOCmWGu/F2QY0AjAHrCpmD8rmkq3UL72A1aEMQODsYDF+u2be8h2CI8JTTFN60mVkXsi0U8pgsu1LqeyVhsD0b5+V1DIzi+TIUFlDroiAWr/mGJds5KWnyj1+VCW68Al8llNp9VcF5AahvGMbQutpIuJOCmg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1276.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04672cf4-6fc2-4c13-d3de-08d849bbfb3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 12:31:39.3892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBODUvr1aGwEe9jiFtRSnzd0Cr5j0DBlfh6p9gPHd5LGX+M00Vbz0ycCrunZ/oDGRiHD6E65bW4F97WX9HV3Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3676
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 12:9:37, Vinod Koul <vkoul@kernel.org> wrote:

> On 13-08-20, 16:13, Gustavo Pimentel wrote:
> > Fix linked list physical address calculation on non-64 bits architectur=
es.
> >=20
> > The paddr variable is phys_addr_t type, which can assume a different
> > type (u64 or u32) depending on the conditional compilation flag
> > CONFIG_PHYS_ADDR_T_64BIT.
> >=20
> > Since this variable is used in with upper_32 bits() macro to get the
> > value from 32 to 63 bits, on a non-64 bits architecture this variable
> > will assume a u32 type, it can cause a compilation warning.
> >=20
> > This issue was reported by a Coverity analysis.
> >=20
> > Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support=
")
> >=20
> > Cc: Joao Pinto <jpinto@synopsys.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
> > ---
> >  drivers/dma/dw-edma/dw-edma-v0-core.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edm=
a/dw-edma-v0-core.c
> > index 692de47..cfabbf5 100644
> > --- a/drivers/dma/dw-edma/dw-edma-v0-core.c
> > +++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
> > @@ -229,8 +229,13 @@ static void dw_edma_v0_core_write_chunk(struct dw_=
edma_chunk *chunk)
> >  	/* Channel control */
> >  	SET_LL(&llp->control, control);
> >  	/* Linked list  - low, high */
> > -	SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> > -	SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> > +	#ifdef CONFIG_PHYS_ADDR_T_64BIT
> > +		SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> > +		SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> > +	#else /* CONFIG_PHYS_ADDR_T_64BIT */
> > +		SET_LL(&llp->llp_low, chunk->ll_region.paddr);
> > +		SET_LL(&llp->llp_high, 0x0);
>=20
> Shouldn't upper_32_bits(chunk->ll_region.paddr) return zero for non
> 64bit archs?

At the time when I made this patch, I got a compiler warning about the=20
u32 vs u64 type mixing (phys_addr_t) and the macro usage upper_32 bits()=20
on non-64 bits architectures. That's why I made this patch, but now I=20
don't see this warning anymore.

Vinod, please disregard this patch.

-Gustavo

>=20
> > +	#endif /* CONFIG_PHYS_ADDR_T_64BIT */
> >  }
> > =20
> >  void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
> > @@ -257,10 +262,16 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *=
chunk, bool first)
> >  		SET_CH(dw, chan->dir, chan->id, ch_control1,
> >  		       (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));
> >  		/* Linked list - low, high */
> > -		SET_CH(dw, chan->dir, chan->id, llp_low,
> > -		       lower_32_bits(chunk->ll_region.paddr));
> > -		SET_CH(dw, chan->dir, chan->id, llp_high,
> > -		       upper_32_bits(chunk->ll_region.paddr));
> > +		#ifdef CONFIG_PHYS_ADDR_T_64BIT
> > +			SET_CH(dw, chan->dir, chan->id, llp_low,
> > +			       lower_32_bits(chunk->ll_region.paddr));
> > +			SET_CH(dw, chan->dir, chan->id, llp_high,
> > +			       upper_32_bits(chunk->ll_region.paddr));
> > +		#else /* CONFIG_PHYS_ADDR_T_64BIT */
> > +			SET_CH(dw, chan->dir, chan->id, llp_low,
> > +			       chunk->ll_region.paddr);
> > +			SET_CH(dw, chan->dir, chan->id, llp_high, 0x0);
> > +		#endif /* CONFIG_PHYS_ADDR_T_64BIT*/
> >  	}
> >  	/* Doorbell */
> >  	SET_RW(dw, chan->dir, doorbell,
> > --=20
> > 2.7.4
>=20
> --=20
> ~Vinod


