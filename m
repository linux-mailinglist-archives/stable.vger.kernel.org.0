Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5624C1F54
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 00:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243307AbiBWXHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 18:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiBWXHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 18:07:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAD33614F
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 15:06:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5gsBnnGUaDDOchf/oLHx8BKmrQr2fOeDkGf0StsQT2WQcUDeKfLrL0grwDWdP603KvH9STXnF8rjDuMWzplJ4PQP4PsEbNlZ8dQVdGMp5vXEMwfXPr9un6FMWP2xec25fztSA6F/xgAAprSyDRv8xSWZ0560gS1K9kocVE2O5QPSxG+1r08LArebREni/1v08GoWPK+8RrTFX193v7TJwC4486rr5ij36VE/Y7GXagdOLJ16MXXi5i+aFYNmALg6HUb9omCuIK5PNpmDGugH2sYBQwLyL5+PYHzu4EUqooFwJApks6yiZuvnk1G9uKW0fWVSO2u0BbLexyueeuxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7RjfO7FAG1syzywT1RsdDSKrrs1UJ/Q0tB4tmu+jKM=;
 b=OnI+kIsJOZdIBV3IWqSswj2EhAP0as9FMLrZX2O1PZ7IK8YqgJx6gvV6ZMm4sqUmafmazgU2yplebxjG+gaAq9U3udeuNCgAUt+PEGLLbcAVatUJH44uddn7BvwPG1LJvR9RLYxOSJzjQhLWep1UiZCIPmudoGdr1lK3V8wNYQrTY/RbZX4BoxeMd/5xMcNPs1ZOe5MC58Tm+/0cNMeejHTOqt+4f4H7weejJhcaCMsmdKB4rO19jh6YTiFTTniZpPdOpWvebft+OW2ydn9qnrqJ9aNcpGYD/+VbXzBhJ7Y7F2CRVrwAQwqll3uFGsgSjnvBXTd+LNBTGRfb14Cmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7RjfO7FAG1syzywT1RsdDSKrrs1UJ/Q0tB4tmu+jKM=;
 b=UYI1OMcZ/dwj3UIUOEMNAHCcDMDdxCtvBH6u62dCYlZ3CMZEnHpXNHtWuk5JX1QBuiYHTYZOQOvnh8XgGNopYWSZ0kZZ9xilYwIUrIx0vLWXjEd7lL7hp/7u5jiiNaWHBNI25uc0JX/uFUq1DpnfdQIBHWUjkPgLgCC5Nkn9NB8=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BN9PR12MB5033.namprd12.prod.outlook.com (2603:10b6:408:132::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 23:06:47 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 23:06:47 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Messaging verbosity backport
Thread-Topic: Messaging verbosity backport
Thread-Index: AdgpCbf8l7Z4rDscRRehamZpyAtlRA==
Date:   Wed, 23 Feb 2022 23:06:47 +0000
Message-ID: <BL1PR12MB51572C542F61E7C087C729D5E23C9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-02-23T23:04:24Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=cb4d16bf-f9f3-4a75-9eda-2becbd1dcd11;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-02-23T23:06:46Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 4773f93b-9631-45f2-8173-90bb4cfba8c5
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 651093e4-81a7-4aef-15f1-08d9f7212b0a
x-ms-traffictypediagnostic: BN9PR12MB5033:EE_
x-microsoft-antispam-prvs: <BN9PR12MB503347DB351D7627930CE99FE23C9@BN9PR12MB5033.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W522btsf3Qz2ufZytX7CH4uD75kCpZIn5ztofxIr+WAk54/hB3t67yNSLoVHFuJFOcNYftIPSzTCDcrNNGGV+h5f1mIlN+8N21VxtayCPFKe7+Llk6rKQA4zYxBnyY28qJHRAEEo8Hu4Yx95smqoms50GqlgukcRWGjw3Ki+Nu2Ea7BnkxAT0QFSFM9dbwRmQEzzOJld7fxTLs7xQPyY5xQWK+bBtUWvMwQ8g3ELRbGqH6rInFTr1yUvjzS1OzLh3Ns0k2C+eLePWZdcXyju+0rjKWwBmde+gknXTXMvEbb09bWNE7fNMmvWEjfHBQQjsHQ4AXhBg78B9uVkBdllXI04O/UGpXcH1fB39WztYMgZKBcs6RpwmIkianoEtZ7cT16D8stCfi4sBfoF58qps7X5bdD8IERR9LkSBIBzmXoPLZl9phi9oRPuoLbkUGgF0QAP9pZLWbgNt4NVISlW8pLgFvZZjyoB1BJLBduj1AaRlJwzqeZzrO4Uya+ch3zfrNh5L6AnHf2U03+5nPDgVEbySL6ZiBEh8Z+uiVsjBcyOf8m4TPK7QBdNxrulylIPcJg58eFPAYaYLilWjyZhdoZcPWSDNeE2yFvYKvc62frQ7N2yjXG4vgJrzscHyEnt6GhIOorOb47DBI4Xyo5Ql+sA5KaUYmiyToiLPGV50m7oqRl5Nism5YZK8HRmxo2/0OIZ7dmqflLWQuGpK5mEMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(7696005)(52536014)(3480700007)(8936002)(5660300002)(4744005)(9686003)(71200400001)(508600001)(7116003)(6506007)(66446008)(38100700002)(76116006)(316002)(186003)(66476007)(122000001)(38070700005)(26005)(86362001)(64756008)(55016003)(33656002)(66946007)(8676002)(2906002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LO7JAbfJU0z/PPCfDUHB3HzRbMmdHkhMw7eTdIzBOHWKv5VyF3fprvHWacUL?=
 =?us-ascii?Q?f6xaXaKvEdNLQbevItcD/TKzJctENj9HMsGeFz8kp6GlRqC1L2AjcF1fcV1J?=
 =?us-ascii?Q?Vj2ZZGXZ+jLg5407DmgR1RkpDhqrnhjNjp9ohFzXEuIJQwu8Z2LM/oN60pN2?=
 =?us-ascii?Q?ZkZJzbaJizThXA5fJ4WISwnEg+dKXKE2VmDwrqAVyTX72L2Nuw213T6Js4lu?=
 =?us-ascii?Q?Eb5RlJYGqAZRzNqUmnIv81eyZWAZbBBYY7bFbQ2uuOad/wm7TkBDRGolQiLh?=
 =?us-ascii?Q?EgJqNJVxYQLqY1wLT0nRg4JqnYceQ7t/E3/oC5FmN5h1t2CRUFFjx6C5+YiV?=
 =?us-ascii?Q?JIt03o4xJA//yc4ULmbsaD1kXD6zWbboY5NHAExlidaYOUhs+iC/PhDW7z2I?=
 =?us-ascii?Q?Z+FXudSMDtkz8Y8g1JIO0kV/dUNaPFXtSiXOtBINqMyk7jJxRxcMHQ5ndzQB?=
 =?us-ascii?Q?arU7KqVG0eiO/joiT7PCxpvrwB10yKMkPbw9nh5qcpUchzhSowfcf5rcyfjB?=
 =?us-ascii?Q?p9CEVPcU7fTMvOcpso2sR4MUeiztGh8AZniSATITZeFN1bRb1TbhKAIKZz3T?=
 =?us-ascii?Q?1/QyI8zPVG9VQJOkVPA0PtbgEQuQ+I0IRmWuPMLnd1TDuO3xFDn99ccjEYAH?=
 =?us-ascii?Q?1yHClY8MYNLu2Wrio/f5urrTalOPCKoa0WRhwlaGSydAmMN/+1uEL/Y1VFAr?=
 =?us-ascii?Q?wGxZL7wue67scQ5XkpURRpHQt5EIeed6O17vk5YvCqssZFXoBis+AdSruvBQ?=
 =?us-ascii?Q?WWhXa2DmJyfv/7aM/8HP/iY7ixCL08lyO87XNS1GPAwtIQjyfa30OqB1bay/?=
 =?us-ascii?Q?x2XNR9JWk1moDmnTd36gXreg73zWSTS0OfF0hw/Oi9K4OblvnEbqZpJSNRSL?=
 =?us-ascii?Q?ADArdn90k75KdUaiiw+c7Yw4GwFl1ETqG6tGeUYbXobDxPlV7WDa0zO6lnsg?=
 =?us-ascii?Q?EapdJyS6T8fvDhkghR1V8okf8v4uG25ISwXhc9MCzcDhntQhnBUD0KjTlI1f?=
 =?us-ascii?Q?hj/TvprgNV6nuwp/rggn2gi9fvXWy7e3yKFrvtehFvlLO0qDZp7bKg+DiL0j?=
 =?us-ascii?Q?GX6BI0WjsdlJmY4ABqmS1OR/0aYE4hJqrxWQeFe05ZaDUSf+S7TgeE0bSsbs?=
 =?us-ascii?Q?xof78aJMfKYkUVOQK+wtVca/Cfjnl7HCvgPXaLRS9+tkZRx5JTYjNyD0Q+sD?=
 =?us-ascii?Q?BPAvQvaSS7q+lHLuDG9AVl8T7YFxs6tSBmfkobhkDZor8HB1ZCc6o1k8egFf?=
 =?us-ascii?Q?CEeSO8wGYD6g1T2sNqOr8yPhVwjwbIiS7HBgpnchusctIpBr0Ys0Knw2+hBq?=
 =?us-ascii?Q?Q6t9m/3dYtov2P9A9fV3Q4eP0JDm79wNEz2SjmMqnvjZ+uklyJzE74JW5jms?=
 =?us-ascii?Q?aLT0eF3kWtEsawbWHR/3iszIO2aZIROkY1o2VgXWCXDTLZP+ewru8P8DKCiC?=
 =?us-ascii?Q?uxJIHRIe7RXsnaWekCBYuRnBwbWmr+JgfrB4qudHAnZCQCCy0PmIEwYvtLyZ?=
 =?us-ascii?Q?2yKhX5lduwk6MmkloOPTcgGv2D6VMrS3+02iY7C1CtTvaiX3MJ/wHngzkKOJ?=
 =?us-ascii?Q?bHTzTZ8GG5UZ263D5i4RXdO9gWRsrWOvRVJxh+rLqplyWrH7jgwVIvGr+iNa?=
 =?us-ascii?Q?ril0bESzKMvuNt4vDQE6H/w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651093e4-81a7-4aef-15f1-08d9f7212b0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 23:06:47.6917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blK+1RDKXXldPm0RRaT0/hKHe9WflPoaJA1YWuXzw7QE8uYRl//MkjQysrTQOS3HhHF2OM2iSgAEMA5hjgm/9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5033
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

By default some laptops show this on every boot.  It's not useful and was d=
egraded to debug in a future kernel.

[drm:dp_retrieve_lttpr_cap [amdgpu]] *ERROR* dp_retrieve_lttpr_cap: Read LT=
TPR caps data failed.

Please backport

commit 1d925758ba1a5d2716a847903e2fd04efcbd9862 ("drm/amd/display: Reduce d=
mesg error to a debug print") to decrease verbosity.

Thanks,=
